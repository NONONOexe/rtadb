-- create table of standard grid squares
CREATE TABLE
  standard_grid_squares
  (
    standard_grid_square_code char(8)           NOT NULL PRIMARY KEY
  , second_grid_square_code   char(6)           NOT NULL
  , geometry                  geometry(polygon) NOT NULL
  , FOREIGN KEY (second_grid_square_code)
      REFERENCES second_grid_squares (second_grid_square_code)
);

-- set the logical name of the table
COMMENT ON TABLE standard_grid_squares IS '基準地域メッシュ';

-- set the logical name of the columns
COMMENT ON COLUMN standard_grid_squares.standard_grid_square_code
  IS '基準地域メッシュコード';
COMMENT ON COLUMN standard_grid_squares.second_grid_square_code
  IS '２次メッシュコード';
COMMENT ON COLUMN standard_grid_squares.geometry
  IS '基準地域メッシュの領域';
