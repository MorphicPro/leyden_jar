-- Set of sessions based on wh in desending order
SELECT distinct cast(jp.body #>>'{wh}' as INTEGER) AS wh
FROM jar_posts jp order by wh DESC;