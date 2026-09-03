-- Creating Tables--

CREATE TABLE website_sessions (
    website_session_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP,
    user_id INTEGER,
    is_repeat_session INTEGER,
    utm_source VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_content VARCHAR(100),
    device_type VARCHAR(50),
    http_referer TEXT
);

CREATE TABLE website_pageviews (
    website_pageview_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP,
    website_session_id INTEGER,
    pageview_url TEXT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP,
    website_session_id INTEGER,
    user_id INTEGER,
    primary_product_id INTEGER,
    items_purchased INTEGER,
    price_usd NUMERIC(10,2),
    cogs_usd NUMERIC(10,2)
);

-- Verifying if all the data has been loaded correctly --
SELECT COUNT(*) FROM website_sessions;

SELECT COUNT(*) FROM website_pageviews;

SELECT COUNT(*) FROM orders;

-- Basic Data Validation --
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT website_session_id) AS unique_sessions
FROM website_sessions;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT website_pageview_id) AS unique_pageviews
FROM website_pageviews;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

-- Checking missing values in website_sessions table --
SELECT
    COUNT(*) AS total_rows,
    COUNT(website_session_id) AS session_id,
    COUNT(created_at) AS created_at,
    COUNT(user_id) AS user_id,
    COUNT(utm_source) AS utm_source,
    COUNT(utm_campaign) AS utm_campaign,
    COUNT(device_type) AS device_type
FROM website_sessions;

-- Checking missing values in website_pageviews table --
SELECT
    COUNT(*) AS total_rows,
    COUNT(website_pageview_id) AS pageview_id,
    COUNT(created_at) AS created_at,
    COUNT(website_session_id) AS session_id,
    COUNT(pageview_url) AS pageview_url
FROM website_pageviews;

-- Checking missing values in orders table --
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id,
    COUNT(created_at) AS created_at,
    COUNT(website_session_id) AS session_id,
    COUNT(user_id) AS user_id,
    COUNT(items_purchased) AS items_purchased,
    COUNT(price_usd) AS price_usd,
    COUNT(cogs_usd) AS cogs_usd
FROM orders;

-- checking date ranges --
SELECT 
    'website_sessions' AS table_name,
    MIN(created_at) AS start_date,
    MAX(created_at) AS end_date
FROM website_sessions

UNION ALL

SELECT 
    'website_pageviews',
    MIN(created_at),
    MAX(created_at)
FROM website_pageviews

UNION ALL

SELECT 
    'orders',
    MIN(created_at),
    MAX(created_at)
FROM orders;

-- Getting an idea of our traffic --
SELECT
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(DISTINCT DATE(created_at)) AS active_days
FROM website_sessions;

SELECT
    device_type,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY device_type
ORDER BY sessions DESC;

SELECT
    utm_source,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY sessions DESC;

-- Conversion metric --
SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS session_to_order_conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id;

-- Conversion by device --
SELECT
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.device_type
ORDER BY conversion_rate DESC;

-- Conversion by Traffic Source --
SELECT
    COALESCE(utm_source, 'Unattributed') AS traffic_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY COALESCE(utm_source, 'Unattributed')
ORDER BY conversion_rate DESC;

-- Calculating Engagement --
SELECT
    ROUND(
        COUNT(*)::NUMERIC
        / COUNT(DISTINCT website_session_id),
        2
    ) AS avg_pages_per_session
FROM website_pageviews;

SELECT
    website_session_id,
    COUNT(*) AS pageviews
FROM website_pageviews
GROUP BY website_session_id
ORDER BY pageviews DESC
LIMIT 10;

-- Monthly Conversion trend --
SELECT
    DATE_TRUNC('month', ws.created_at)::DATE AS month,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY DATE_TRUNC('month', ws.created_at)
ORDER BY month;

-- Landing Page Analysis --
WITH first_page AS (
    SELECT
        website_session_id,
        pageview_url,
        ROW_NUMBER() OVER (
            PARTITION BY website_session_id
            ORDER BY created_at
        ) AS page_number
    FROM website_pageviews
)

SELECT
    pageview_url AS landing_page,
    COUNT(*) AS sessions
FROM first_page
WHERE page_number = 1
GROUP BY pageview_url
ORDER BY sessions DESC;

-- Landing page Conversion --

WITH first_page AS (
    SELECT
        website_session_id,
        pageview_url AS landing_page,
        ROW_NUMBER() OVER (
            PARTITION BY website_session_id
            ORDER BY created_at
        ) AS page_number
    FROM website_pageviews
)

SELECT
    fp.landing_page,
    COUNT(DISTINCT fp.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / COUNT(DISTINCT fp.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM first_page fp
LEFT JOIN orders o
    ON fp.website_session_id = o.website_session_id
WHERE fp.page_number = 1
GROUP BY fp.landing_page
ORDER BY conversion_rate DESC;

-- New vs Repeat Sessions --
SELECT
    CASE
        WHEN ws.is_repeat_session = 1 THEN 'Repeat'
        ELSE 'New'
    END AS session_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id)::NUMERIC
        / COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    CASE
        WHEN ws.is_repeat_session = 1 THEN 'Repeat'
        ELSE 'New'
    END
ORDER BY conversion_rate DESC;

-- Revenue and AOV --
SELECT
    ROUND(SUM(price_usd), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(price_usd) / COUNT(DISTINCT order_id),
        2
    ) AS avg_order_value,
    ROUND(
        SUM(price_usd - cogs_usd),
        2
    ) AS total_profit
FROM orders;

CREATE VIEW landing_page_analysis AS
SELECT
    website_session_id,
    pageview_url AS landing_page
FROM (
    SELECT
        website_session_id,
        pageview_url,
        ROW_NUMBER() OVER (
            PARTITION BY website_session_id
            ORDER BY created_at
        ) AS rn
    FROM website_pageviews
) t
WHERE rn = 1;

SELECT *
FROM landing_page_analysis
LIMIT 10;