USE ERPAPP;
CREATE TABLE colors(id INT,colors TEXT);
INSERT INTO colors VALUES (1, 'Red,Green,Blue'), (2, 'Orangered,Periwinkle');

WITH RECURSIVE
  unwound AS (
    SELECT *
      FROM colors
    UNION ALL
    SELECT id, regexp_replace(colors, '^[^,]*,', '') colors
      FROM unwound
      WHERE colors LIKE '%,%'
  )
  SELECT id, regexp_replace(colors, ',.*', '') colors, colors
    FROM unwound
    ORDER BY id
;


SELECT GROUP_CONCAT(colors order by id) as colors FROM colors;