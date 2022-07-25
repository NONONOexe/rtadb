-- create table of half grid squares
CREATE TABLE
  half_grid_squares
  (
    half_grid_square_code  char(9)           NOT NULL PRIMARY KEY
  , basic_grid_square_code char(8)           NOT NULL
  , geometry               geometry(polygon) NOT NULL
  , FOREIGN KEY (basic_grid_square_code)
      REFERENCES basic_grid_squares (basic_grid_square_code)
);

-- set the logical name of the table
COMMENT ON TABLE half_grid_squares IS '２分の１地域メッシュ';

-- set the logical name of the columns
COMMENT ON COLUMN half_grid_squares.half_grid_square_code
  IS '２分の１地域メッシュコード';
COMMENT ON COLUMN half_grid_squares.basic_grid_square_code
  IS '基準地域メッシュコード';
COMMENT ON COLUMN half_grid_squares.geometry
  IS '２分の１地域メッシュの領域';
