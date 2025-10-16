CREATE TABLE sues AS
  PIVOT (
    WITH lines AS (
      SELECT unnest(string_split(content, chr(10))) AS line 
      FROM read_text('day16.in')
    ),
    parts AS (
      SELECT
        regexp_extract(line, 'Sue (\d+):', 1) AS sue_number,
        regexp_extract(line, ': (.+)$', 1) AS items_str
      FROM lines
    ),
    items AS (
      SELECT
        sue_number,
        unnest(string_split(items_str, ', ')) AS item_pair
      FROM parts
  )
  SELECT
    sue_number,
    split_part(item_pair, ': ', 1) as item_name,
    TRY_CAST(split_part(item_pair, ': ', 2) AS INT) as item_value,
  FROM items)
  ON item_name
  USING sum(item_value);

SELECT sue_number AS p1 FROM sues 
WHERE
  (children = 3 OR children IS null)
  AND (cats = 7 OR cats IS null)
  AND (samoyeds = 2 OR samoyeds IS null)
  AND (pomeranians = 2 OR pomeranians IS null)
  AND (akitas = 0 OR akitas IS null)
  AND (vizslas = 0 OR vizslas IS null)
  AND (goldfish = 5 OR goldfish IS null)
  AND (trees = 3 OR trees IS null)
  AND (cars = 2 OR cars IS null)
  AND (perfumes = 1 OR perfumes IS null)