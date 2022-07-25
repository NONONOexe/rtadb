-- create the table of the parties involved in the accident
-- each party is linked to the data of "accidents"
CREATE TABLE parties
(
  accident_id      varchar(11) NOT NULL
, car_id           varchar(2)  NOT NULL
, passenger_id     varchar(3)  NOT NULL
, party_rank       text        NOT NULL
, violation_type   text            NULL
, violation_detail text            NULL
, cause_road       text            NULL
, cause_car        text            NULL
, cause_human      text            NULL
, action_type      text            NULL
, move_direction   text            NULL
, car_light_state  text            NULL
, party_type       text            NULL
, party_subtype    text            NULL
, party_subsubtype text            NULL
, car_tire         text            NULL
, use_type         text            NULL
, use_detail       text            NULL
, injured_part     text            NULL
, injury_level     text            NULL
, seat_belt        text            NULL
, helmet           text            NULL
, air_bag          text            NULL
, side_air_bag     text            NULL
, alcohol_intake   text            NULL
, cell_phone       text            NULL
, car_nav_system   text            NULL
, critical_speed   text            NULL
, party_gender     text            NULL
, party_age        smallint        NULL
, home_prefecture  text            NULL
, home_address     text            NULL
, home_distance    text            NULL
, party_job        text            NULL
, purpose          text            NULL
, PRIMARY KEY ( accident_id, car_id, passenger_id )
, CONSTRAINT fk_accident
    FOREIGN KEY ( accident_id )
    REFERENCES  accidents
);

-- set the logical name of the table
COMMENT ON TABLE parties IS '当事者';

-- set the logical name of the columns
COMMENT ON COLUMN parties.accident_id
  IS '本票番号';
COMMENT ON COLUMN parties.car_id
  IS '当事車両番号';
COMMENT ON COLUMN parties.passenger_id
  IS '搭乗者番号';
COMMENT ON COLUMN parties.party_rank
  IS '当事者順位';
COMMENT ON COLUMN parties.violation_type
  IS '法令違反種別';
COMMENT ON COLUMN parties.violation_detail
  IS '法令違反詳細';
COMMENT ON COLUMN parties.cause_road
  IS '環境的要因';
COMMENT ON COLUMN parties.cause_car
  IS '車両的要因';
COMMENT ON COLUMN parties.cause_human
  IS '人的要因';
COMMENT ON COLUMN parties.action_type
  IS '行動類型';
COMMENT ON COLUMN parties.move_direction
  IS '進行方向';
COMMENT ON COLUMN parties.car_light_state
  IS 'ライト点灯状況';
COMMENT ON COLUMN parties.party_type
  IS '当事者大種別';
COMMENT ON COLUMN parties.party_subtype
  IS '当事者中種別';
COMMENT ON COLUMN parties.party_subsubtype
  IS '当事者小種別';
COMMENT ON COLUMN parties.car_tire
  IS 'タイヤ';
COMMENT ON COLUMN parties.use_type
  IS '用途区分';
COMMENT ON COLUMN parties.use_detail
  IS '用途詳細';
COMMENT ON COLUMN parties.injured_part
  IS '人身損傷主部位';
COMMENT ON COLUMN parties.injury_level
  IS '人身損傷程度';
COMMENT ON COLUMN parties.seat_belt
  IS 'シートベルト';
COMMENT ON COLUMN parties.helmet
  IS 'ヘルメット';
COMMENT ON COLUMN parties.air_bag
  IS 'エアバッグ';
COMMENT ON COLUMN parties.side_air_bag
  IS 'サイド・エアバッグ';
COMMENT ON COLUMN parties.alcohol_intake
  IS '飲酒状況';
COMMENT ON COLUMN parties.cell_phone
  IS '携帯電話使用状況';
COMMENT ON COLUMN parties.car_nav_system
  IS 'カーナビ使用状況';
COMMENT ON COLUMN parties.critical_speed
  IS '危険認知速度';
COMMENT ON COLUMN parties.party_gender
  IS '性別';
COMMENT ON COLUMN parties.party_age
  IS '年齢';
COMMENT ON COLUMN parties.home_prefecture
  IS '居住県';
COMMENT ON COLUMN parties.home_address
  IS '居住市区町村';
COMMENT ON COLUMN parties.home_distance
  IS '自宅距離';
COMMENT ON COLUMN parties.party_job
  IS '職業区分';
COMMENT ON COLUMN parties.purpose
  IS '通行目的';
