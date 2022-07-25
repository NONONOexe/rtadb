-- create table of the land use categoris
CREATE TABLE
  land_use
  (
    land_use_id       smallint  NOT NULL PRIMARY KEY
  , land_use_category text      NOT NULL
  , geometry          geometry  NOT NULL
  )
;

-- set the logical name of the table
COMMENT ON TABLE land_use IS '土地利用';

-- set the logical name of the columns
COMMENT ON COLUMN land_use.land_use_id
  IS '土地利用区分ＩＤ';
COMMENT ON COLUMN land_use.land_use_category
  IS '土地利用区分';
COMMENT ON COLUMN land_use.geometry
  IS '土地利用区分の領域';
