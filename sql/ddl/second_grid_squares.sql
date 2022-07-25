-- create table of second grid squares
CREATE TABLE
  second_grid_squares
  (
    second_grid_square_code char(6)           NOT NULL PRIMARY KEY
  , first_grid_square_code  char(4)           NOT NULL
  , geometry                  geometry(polygon) NOT NULL
  , FOREIGN KEY (first_grid_square_code)
      REFERENCES first_grid_squares (first_grid_square_code)
);

-- set the logical name of the table
COMMENT ON TABLE second_grid_squares IS '第２次地域区画';

-- set the logical name of the columns
COMMENT ON COLUMN second_grid_squares.second_grid_square_code
  IS '２次メッシュコード';
COMMENT ON COLUMN second_grid_squares.first_grid_square_code
  IS '１次メッシュコード';
COMMENT ON COLUMN second_grid_squares.geometry
  IS '第２次地域区画の領域';
