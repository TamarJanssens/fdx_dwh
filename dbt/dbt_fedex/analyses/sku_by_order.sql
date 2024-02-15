SELECT
orderId
, count(distinct sku) as n_sku
FROM [master].[dbo].[raw_data]
GROUP BY orderId
order by n_sku desc