-- create table of first grid squares
CREATE TABLE
  first_grid_squares
  (
    first_grid_square_code char(4)           NOT NULL PRIMARY KEY
  , geometry                 geometry(polygon) NOT NULL
);

-- set the logical name of the table
COMMENT ON TABLE first_grid_squares IS '第１次地域区画';

-- set the logical name of the columns
COMMENT ON COLUMN first_grid_squares.first_grid_square_code
  IS '１次メッシュコード';
COMMENT ON COLUMN first_grid_squares.geometry
  IS '第１次地域区画の領域';
