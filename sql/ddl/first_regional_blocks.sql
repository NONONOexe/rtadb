-- create table of the first regional blocks
CREATE TABLE
  first_regional_blocks
  (
    first_regional_block_id   smallint  NOT NULL PRIMARY KEY
  , first_regional_block_name text      NOT NULL
  , geometry                  geometry  NOT NULL
  )
;

-- set the logical name of the table
COMMENT ON TABLE first_regional_blocks IS '第１次地域ブロック';

-- set the logical name of the columns
COMMENT ON COLUMN first_regional_blocks.first_regional_block_id
  IS '第１次地域ブロックＩＤ';
COMMENT ON COLUMN first_regional_blocks.first_regional_block_name
  IS '第１次地域ブロック名';
COMMENT ON COLUMN first_regional_blocks.geometry
  IS '第１次地域ブロックの領域';
