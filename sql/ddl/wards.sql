-- create table of the wards
CREATE TABLE
  wards
  (
    ward_code char(5)   NOT NULL PRIMARY KEY
  , city_code char(5)   NOT NULL
  , ward_name text      NOT NULL
  , ward_kana text      NOT NULL
  , geometry  geometry  NOT NULL
  , FOREIGN KEY (city_code) REFERENCES cities (city_code)
  )
;

-- set the logical name of the table
COMMENT ON TABLE wards IS '区';

-- set the logical name of the columns
COMMENT ON COLUMN wards.ward_code IS '区コード';
COMMENT ON COLUMN wards.city_code IS '市町村コード';
COMMENT ON COLUMN wards.ward_name IS '区名';
COMMENT ON COLUMN wards.ward_kana IS '区名の読み';
COMMENT ON COLUMN wards.geometry  IS '区の領域';
