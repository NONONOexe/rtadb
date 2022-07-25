-- create the table of each traffic accident
CREATE TABLE accidents
(
  accident_id        varchar(11)     NOT NULL PRIMARY KEY
, occurrence_date    date                NULL
, day_of_week        text                NULL
, day_night_type     text                NULL
, occurrence_hour    smallint            NULL
, police_office      text                NULL
, occurrence_place   text                NULL
, weather            text                NULL
, road_surface       text                NULL
, road_type          text                NULL
, road_shape         text                NULL
, road_alignment     text                NULL
, carriageway_width  text                NULL
, traffic_signal     text                NULL
, injury_pattern     text                NULL
, fatality           smallint            NULL
, severe_injury      smallint            NULL
, slight_injury      smallint            NULL
, impact_type        text                NULL
, collision_position text                NULL
, special_category_1 text                NULL
, special_category_2 text                NULL
, special_category_3 text                NULL
, geometry           geometry(point)     NULL
);

-- set the logical name of the table
COMMENT ON TABLE accidents IS '交通事故';

-- set the logical name of the columns
COMMENT ON COLUMN accidents.accident_id
  IS '本票番号';
COMMENT ON COLUMN accidents.occurrence_date
  IS '発生年月日';
COMMENT ON COLUMN accidents.day_of_week
  IS '曜日';
COMMENT ON COLUMN accidents.day_night_type
  IS '昼夜';
COMMENT ON COLUMN accidents.occurrence_hour
  IS '発生時';
COMMENT ON COLUMN accidents.police_office
  IS '警察署';
COMMENT ON COLUMN accidents.occurrence_place
  IS '発生場所';
COMMENT ON COLUMN accidents.weather
  IS '天候';
COMMENT ON COLUMN accidents.road_surface
  IS '路面状態';
COMMENT ON COLUMN accidents.road_type
  IS '路線種別';
COMMENT ON COLUMN accidents.road_shape
  IS '道路形状';
COMMENT ON COLUMN accidents.road_alignment
  IS '道路線形';
COMMENT ON COLUMN accidents.carriageway_width
  IS '車道幅員';
COMMENT ON COLUMN accidents.traffic_signal
  IS '信号機';
COMMENT ON COLUMN accidents.injury_pattern
  IS '事故内容';
COMMENT ON COLUMN accidents.fatality
  IS '死亡者数';
COMMENT ON COLUMN accidents.severe_injury
  IS '重傷者数';
COMMENT ON COLUMN accidents.slight_injury
  IS '軽傷者数';
COMMENT ON COLUMN accidents.impact_type
  IS '事故類型';
COMMENT ON COLUMN accidents.collision_position
  IS '衝突地点';
COMMENT ON COLUMN accidents.special_category_1
  IS '特殊事故１';
COMMENT ON COLUMN accidents.special_category_2
  IS '特殊事故２';
COMMENT ON COLUMN accidents.special_category_3
  IS '特殊事故３';
COMMENT ON COLUMN accidents.geometry
  IS '交通事故の発生地点';
