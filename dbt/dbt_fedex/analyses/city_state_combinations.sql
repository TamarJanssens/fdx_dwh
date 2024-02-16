with cityState AS (
SELECT DISTINCT
      [shipCity]
      ,[shipState]
  FROM [master].[dbo].[raw_data]
)
SELECT *, COUNT(shipCity) as n_obs from cityState
GROUP BY [shipCity], [shipState]
HAVING COUNT(shipCity) >1