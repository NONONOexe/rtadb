-- create table of the mesurement points of section traffic volumes
CREATE TABLE
  traffic_volume_points
  (
    point_id   char(5) NOT NULL PRIMARY KEY
  , point_name text    NOT NULL
  , geometry   geometry(POINT)        NOT NULL
  )
;

-- set the logical name of the table
COMMENT ON TABLE traffic_volume_points IS '断面交通量計測地点';

-- set the logical name of the columns
COMMENT ON COLUMN traffic_volume_points.point_id
  IS '計測地点番号';
COMMENT ON COLUMN traffic_volume_points.point_name
  IS '計測地点名称';
COMMENT ON COLUMN traffic_volume_points.geometry
  IS '計測地点';
