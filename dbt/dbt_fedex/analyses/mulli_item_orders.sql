with multi_item_orders AS (
    SELECT
    orderId
    , count(distinct sku) as n_sku
    FROM [master].[dbo].[raw_data]
    GROUP BY orderId
    HAVING count(distinct sku) >1
)
SELECT src.orderId, src.sku, src.*, m.n_sku FROM [master].[dbo].[raw_data] src 
INNER JOIN multi_item_orders m ON m.orderId = src.orderId
ORDER BY m.n_sku desc, src.orderId, src.sku