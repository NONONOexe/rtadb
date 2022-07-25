-- create table of the cities
CREATE TABLE
  cities
  (
    city_code                char(5)   NOT NULL PRIMARY KEY
  , second_regional_block_id smallint  NOT NULL
  , city_name                text      NOT NULL
  , city_kana                text      NOT NULL
  , geometry                 geometry  NOT NULL
  , FOREIGN KEY (second_regional_block_id)
      REFERENCES second_regional_blocks (second_regional_block_id)
  )
;

-- set the logical name of the table
COMMENT ON TABLE cities IS '市町村';

-- set the logical name of the columns
COMMENT ON COLUMN cities.city_code
  IS '市町村コード';
COMMENT ON COLUMN cities.second_regional_block_id
  IS '第２次地域ブロックＩＤ';
COMMENT ON COLUMN cities.city_name
  IS '市町村名';
COMMENT ON COLUMN cities.city_kana
  IS '市町村名の読み';
COMMENT ON COLUMN cities.geometry
  IS '市町村の領域';
