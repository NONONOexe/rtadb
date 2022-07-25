-- create table of the section traffic volumes
CREATE TABLE
  traffic_volumes
  (
    time           timestamp NOT NULL
  , point_id       char(5)   NOT NULL
  , traffic_volume int       NOT NULL
  , PRIMARY KEY (time, point_id)
  , FOREIGN KEY (point_id) REFERENCES traffic_volume_points (point_id)
  )
;

-- set the logical name of the table
COMMENT ON TABLE traffic_volumes IS '断面交通量情報';

-- set the logical name of the columns
COMMENT ON COLUMN traffic_volumes.time
  IS '計測時間';
COMMENT ON COLUMN traffic_volumes.point_id
  IS '計測地点番号';
COMMENT ON COLUMN traffic_volumes.traffic_volume
  IS '断面交通量';
