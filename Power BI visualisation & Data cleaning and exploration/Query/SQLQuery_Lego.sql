SELECT *
FROM LegoSets.dbo.Inventories;

SELECT *
FROM LegoSets.dbo.Inventory_minifigs;

SELECT *
FROM LegoSets.dbo.Minifigs;

SELECT *
FROM LegoSets.dbo.Sets
ORDER BY year;

---DATA CLEANING

--Deleting all of the rows where theme_id is not equal to 158

DELETE FROM LegoSets.dbo.Sets
WHERE theme_id <> 158;

--Deleting all empty rows

DELETE FROM LegoSets.dbo.Sets
WHERE set_num IS NULL;

--Deleting all sets from Inventories that are not in Sets

DELETE FROM LegoSets.dbo.Inventories
WHERE NOT EXISTS (
	SELECT 1
	FROM LegoSets.dbo.Sets
	WHERE Sets.set_num = Inventories.set_num
);

--Removing all of duplicates from Inventories

SELECT set_num, COUNT(set_num)
FROM LegoSets.dbo.Inventories
GROUP BY set_num
HAVING COUNT(set_num) > 1;

WITH DuplicatesCTE AS (
	SELECT set_num,
		ROW_NUMBER() OVER (PARTITION BY set_num ORDER BY (SELECT NULL)) as row_num
	FROM LegoSets.dbo.Inventories
	)
DELETE FROM DuplicatesCTE WHERE row_num > 1;

--Deleting all rows from Inventory_minifg where inventory_id is not in Inventories

DELETE FROM LegoSets.dbo.Inventory_minifigs
WHERE NOT EXISTS (
	SELECT 1
	FROM LegoSets.dbo.Inventories
	WHERE Inventories.id = Inventory_minifigs.inventory_id
);

--Deleting all rows from Minifigs where fig_num is not in Inventory_minifigs

DELETE FROM LegoSets.dbo.Minifigs
WHERE NOT EXISTS (
	SELECT 1
	FROM LegoSets.dbo.Inventory_minifigs
	WHERE Inventory_minifigs.fig_num = Minifigs.fig_num
	);


--Removing img_url column from Sets and Minifigs

ALTER TABLE LegoSets.dbo.Sets
DROP COLUMN img_url;

ALTER TABLE LegoSets.dbo.Minifigs
DROP COLUMN img_url;

----DATA EXPLORATION

--Finding the sets with the larger amount of minifigures

SELECT
	s.set_num,
	s.name,
	SUM(imf.quantity) AS minifigs_num
FROM LegoSets.dbo.Sets s
JOIN
	LegoSets.dbo.Inventories i ON s.set_num = i.set_num
JOIN
	LegoSets.dbo.Inventory_minifigs imf ON i.id = imf.inventory_id
GROUP BY s.set_num, s.name
ORDER BY minifigs_num DESC;

--Finding sets with the largest number of parts

SELECT *
FROM LegoSets.dbo.Sets
WHERE num_parts = (SELECT MAX(num_parts) FROM LegoSets.dbo.Sets) AND year = 2013;

SELECT *
FROM LegoSets.dbo.Sets
ORDER BY num_parts DESC;
	
--Finding minifgure which has appeared in the largest amount of the sets

SELECT
	m.fig_num,
	m.name,
	COUNT(i.id) AS Appearance_num
FROM LegoSets.dbo.Minifigs m
JOIN
	LegoSets.dbo.Inventory_minifigs imf ON m.fig_num = imf.fig_num
JOIN
	LegoSets.dbo.Inventories i ON imf.inventory_id = i.id
GROUP BY m.fig_num, m.name
ORDER BY Appearance_num DESC;

--Finding the largest set from each year

WITH LargestSetCTE AS(
SELECT
	set_num,
	name,
	year,
	ROW_NUMBER() OVER (PARTITION BY year ORDER BY num_parts DESC) AS row_num
FROM LegoSets.dbo.Sets
)

SELECT
	set_num,
	name,
	year
FROM LargestSetCTE
WHERE row_num = 1;

