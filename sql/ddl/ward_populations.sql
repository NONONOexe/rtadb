-- create table of the population of wards
CREATE TABLE
  ward_populations
  (
    ward_code                      char(5)       NOT NULL PRIMARY KEY
  , population_total               int               NULL
  , population_male                int               NULL
  , population_female              int               NULL
  , population_density             decimal(6, 1)     NULL
  , age_mean                       decimal(3, 1)     NULL
  , age_median                     decimal(3, 1)     NULL
  , population_age_under_15        int               NULL
  , population_age_15_to_64        int               NULL
  , population_age_over_65         int               NULL
  , population_age_male_under_15   int               NULL
  , population_age_male_15_to_64   int               NULL
  , population_age_male_over_65    int               NULL
  , population_age_female_under_15 int               NULL
  , population_age_female_15_to_64 int               NULL
  , population_age_female_over_65  int               NULL
  , population_japanese            int               NULL
  , population_foreigner           int               NULL
  , household_total                int               NULL
  , household_general              int               NULL
  , household_facility             int               NULL
  , FOREIGN KEY (ward_code) REFERENCES wards (ward_code)
  )
;

-- set the logical name of the table
COMMENT ON TABLE ward_populations IS '区人口';

-- set the logical name of the columns
COMMENT ON COLUMN ward_populations.ward_code
  IS '区コード';
COMMENT ON COLUMN ward_populations.population_total
  IS '総人口';
COMMENT ON COLUMN ward_populations.population_male
  IS '男性人口';
COMMENT ON COLUMN ward_populations.population_female
  IS '女性人口';
COMMENT ON COLUMN ward_populations.population_density
  IS '人口密度';
COMMENT ON COLUMN ward_populations.age_mean
  IS '平均年齢';
COMMENT ON COLUMN ward_populations.age_median
  IS '年齢中位数';
COMMENT ON COLUMN ward_populations.population_age_under_15
  IS '１５歳未満人口';
COMMENT ON COLUMN ward_populations.population_age_15_to_64
  IS '１５～６４歳人口';
COMMENT ON COLUMN ward_populations.population_age_over_65
  IS '６５歳以上人口';
COMMENT ON COLUMN ward_populations.population_age_male_under_15
  IS '１５歳未満男性人口';
COMMENT ON COLUMN ward_populations.population_age_male_15_to_64
  IS '１５～６４歳男性人口';
COMMENT ON COLUMN ward_populations.population_age_male_over_65
  IS '６５歳以上男性人口';
COMMENT ON COLUMN ward_populations.population_age_female_under_15
  IS '１５歳未満女性人口';
COMMENT ON COLUMN ward_populations.population_age_female_15_to_64
  IS '１５～６４歳女性人口';
COMMENT ON COLUMN ward_populations.population_age_female_over_65
  IS '６５歳以上女性人口';
COMMENT ON COLUMN ward_populations.population_japanese
  IS '日本人人口';
COMMENT ON COLUMN ward_populations.population_foreigner
  IS '外国人人口';
COMMENT ON COLUMN ward_populations.household_total
  IS '総世帯数';
COMMENT ON COLUMN ward_populations.household_general
  IS '一般世帯数';
COMMENT ON COLUMN ward_populations.household_facility
  IS '施設等世帯数';
