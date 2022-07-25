-- create table of the second regional blocks
CREATE TABLE
  second_regional_blocks
  (
    second_regional_block_id   smallint  NOT NULL PRIMARY KEY
  , first_regional_block_id    smallint  NOT NULL
  , second_regional_block_name text      NOT NULL
  , geometry                   geometry  NOT NULL
  , FOREIGN KEY (first_regional_block_id)
      REFERENCES first_regional_blocks (first_regional_block_id)
  )
;

-- set the logical name of the table
COMMENT ON TABLE second_regional_blocks IS '第２次地域ブロック';

-- set the logical name of the columns
COMMENT ON COLUMN second_regional_blocks.second_regional_block_id
  IS '第２次地域ブロックＩＤ';
COMMENT ON COLUMN second_regional_blocks.first_regional_block_id
  IS '第１次地域ブロックＩＤ';
COMMENT ON COLUMN second_regional_blocks.second_regional_block_name
  IS '第２次地域ブロック名';
COMMENT ON COLUMN second_regional_blocks.geometry
  IS '第２次地域ブロックの領域';
