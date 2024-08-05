CREATE TABLE animal_types (
   animal_type_id bigserial CONSTRAINT animal_types_key PRIMARY KEY,
   common_name varchar(100) NOT NULL,
   scientific_name varchar(100) NOT NULL,
   conservation_status varchar(50) NOT NULL
);


CREATE TABLE menagerie (
   menagerie_id bigserial CONSTRAINT menagerie_key PRIMARY KEY,
   animal_type_id bigint REFERENCES animal_types (animal_type_id),
   date_acquired date NOT NULL,
   gender varchar(1),
   acquired_from varchar(100),
   name varchar(100),
   notes text
);



INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
       ('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');


INSERT INTO menagerie (animal_type_id, date_acquired, gender, acquired_from, name, notes)
VALUES
(1, '3/12/1996', 'F', 'Dhaka Zoo', 'Ariel', 'Healthy coat at last exam.'),
(2, '9/30/2000', 'F', 'National Zoo', 'Freddy', 'Strong appetite.');


INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Javan Rhino', 'Rhinoceros sondaicus' 'Critically Endangered');


SELECT school, first_name, last_name
FROM teachers
ORDER BY school, last_name;


SELECT first_name, last_name, school, salary
FROM teachers
WHERE first_name LIKE 'S%' -- remember that LIKE is case-sensitive!
      AND salary > 40000;


SELECT last_name, first_name, school, hire_date, salary
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;


numeric(4,1)


varchar(50)


SELECT CAST('4//2017' AS timestamp with time zone);


COPY actors
FROM 'C:\Users\Public\MyWork\movies.txt'
WITH (FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#');


CREATE TABLE actors (
    id integer,
    movie text,
    actor text
);



COPY (
    SELECT geo_name, state_us_abbreviation, housing_unit_count_100_percent
    FROM us_counties_2010 ORDER BY housing_unit_count_100_percent DESC LIMIT 20
     )
TO 'C:\Users\Public\MyWork\us_counties_housing_export.txt'
WITH (FORMAT CSV, HEADER);


SELECT 3.14 * 5 ^ 2;


SELECT geo_name,
       state_us_abbreviation,
       p0010001 AS total_population,
       p0010005 AS american_indian_alaska_native_alone,
       (CAST (p0010005 AS numeric(8,1)) / p0010001) * 100
           AS percent_american_indian_alaska_native_alone
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY'
ORDER BY percent_american_indian_alaska_native_alone DESC;


SELECT percentile_cont(.5)
        WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY';

SELECT percentile_cont(.5)
        WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010
WHERE state_us_abbreviation = 'CA';


SELECT state_us_abbreviation,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY p0010001) AS median
FROM us_counties_2010
WHERE state_us_abbreviation IN ('NY', 'CA')
GROUP BY state_us_abbreviation;


SELECT state_us_abbreviation,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY p0010001) AS median
FROM us_counties_2010
GROUP BY state_us_abbreviation;


SELECT c2010.geo_name,
       c2010.state_us_abbreviation,
       c2000.geo_name
FROM us_counties_2010 c2010 LEFT JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
WHERE c2000.geo_name IS NULL;


SELECT c2010.geo_name,
       c2000.geo_name,
       c2000.state_us_abbreviation
FROM us_counties_2010 c2010 RIGHT JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
WHERE c2010.geo_name IS NULL;


SELECT median(round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 )) AS median_pct_change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips;


SELECT percentile_cont(.5)
       WITHIN GROUP (ORDER BY round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 )) AS percentile_50th
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips;



SELECT c2010.geo_name,
       c2010.state_us_abbreviation,
       c2010.p0010001 AS pop_2010,
       c2000.p0010001 AS pop_2000,
       c2010.p0010001 - c2000.p0010001 AS raw_change,
       round( (CAST(c2010.p0010001 AS DECIMAL(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 ) AS pct_change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
ORDER BY pct_change ASC;



CREATE TABLE albums (
    album_id bigserial,
    album_catalog_code varchar(100),
    album_title text,
    album_artist text,
    album_time interval,
    album_release_date date,
    album_genre varchar(40),
    album_description text
);

CREATE TABLE songs (
    song_id bigserial,
    song_title text,
    song_artist text,
    album_id bigint
);



CREATE TABLE albums (
    album_id bigserial,
    album_catalog_code varchar(100) NOT NULL,
    album_title text NOT NULL,
    album_artist text NOT NULL,
    album_release_date date,
    album_genre varchar(40),
    album_description text,
    CONSTRAINT album_id_key PRIMARY KEY (album_id),
    CONSTRAINT release_date_check CHECK (album_release_date > '1/1/1925')
);

CREATE TABLE songs (
    song_id bigserial,
    song_title text NOT NULL,
    song_artist text NOT NULL,
    album_id bigint REFERENCES albums (album_id),
    CONSTRAINT song_id_key PRIMARY KEY (song_id)
);



SELECT pls14.stabr,
       sum(pls14.gpterms) AS gpterms_2014,
       sum(pls09.gpterms) AS gpterms_2009,
       round( (CAST(sum(pls14.gpterms) AS decimal(10,1)) - sum(pls09.gpterms)) /
                    sum(pls09.gpterms) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.gpterms >= 0 AND pls09.gpterms >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;


SELECT pls14.stabr,
       sum(pls14.pitusr) AS pitusr_2014,
       sum(pls09.pitusr) AS pitusr_2009,
       round( (CAST(sum(pls14.pitusr) AS decimal(10,1)) - sum(pls09.pitusr)) /
                    sum(pls09.pitusr) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.pitusr >= 0 AND pls09.pitusr >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;


-- a) sum() visits by region.

SELECT pls14.obereg,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.obereg
ORDER BY pct_change DESC;

-- b) Bonus: creating the regions lookup table and adding it to the query.

CREATE TABLE obereg_codes (
    obereg varchar(2) CONSTRAINT obereg_key PRIMARY KEY,
    region varchar(50)
);

INSERT INTO obereg_codes
VALUES ('01', 'New England (CT ME MA NH RI VT)'),
       ('02', 'Mid East (DE DC MD NJ NY PA)'),
       ('03', 'Great Lakes (IL IN MI OH WI)'),
       ('04', 'Plains (IA KS MN MO NE ND SD)'),
       ('05', 'Southeast (AL AR FL GA KY LA MS NC SC TN VA WV)'),
       ('06', 'Soutwest (AZ NM OK TX)'),
       ('07', 'Rocky Mountains (CO ID MT UT WY)'),
       ('08', 'Far West (AK CA HI NV OR WA)'),
       ('09', 'Outlying Areas (AS GU MP PR VI)');

-- sum() visits by region.

SELECT obereg_codes.region,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
   ON pls14.fscskey = pls09.fscskey
JOIN obereg_codes
   ON pls14.obereg = obereg_codes.obereg
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY obereg_codes.region
ORDER BY pct_change DESC;


-- 3. Thinking back to the types of joins you learned in Chapter 6, which join
-- type will show you all the rows in both tables, including those without a
-- match? Write such a query and add an IS NULL filter in a WHERE clause to
-- show agencies not included in one or the other table.

-- Answer: a FULL OUTER JOIN will show all rows in both tables.

SELECT pls14.libname, pls14.city, pls14.stabr, pls14.statstru, pls14.c_admin, pls14.branlib,
       pls09.libname, pls09.city, pls09.stabr, pls09.statstru, pls09.c_admin, pls09.branlib
FROM pls_fy2014_pupld14a pls14 FULL OUTER JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.fscskey IS NULL OR pls09.fscskey IS NULL;



-- a) Add the columns

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN meat_processing boolean;
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN poultry_processing boolean;

SELECT * FROM meat_poultry_egg_inspect; -- view table with new empty columns

-- b) Update the columns

UPDATE meat_poultry_egg_inspect
SET meat_processing = TRUE
WHERE activities ILIKE '%meat processing%'; -- case-insensitive match with wildcards

UPDATE meat_poultry_egg_inspect
SET poultry_processing = TRUE
WHERE activities ILIKE '%poultry processing%'; -- case-insensitive match with wildcards

-- c) view the updated table

SELECT * FROM meat_poultry_egg_inspect;

-- d) Count meat and poultry processors

SELECT count(meat_processing), count(poultry_processing)
FROM meat_poultry_egg_inspect;

-- e) Count those who do both

SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE meat_processing = TRUE AND
      poultry_processing = TRUE;



SELECT
    round(
      corr(median_hh_income, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_income_r,
    round(
      corr(median_hh_income, pct_masters_higher)::numeric, 2
      ) AS masters_income_r
FROM acs_2011_2015_stats;



SELECT
    city,
    st,
    population,
    motor_vehicle_theft,
    round(
        (motor_vehicle_theft::numeric / population) * 100000, 1
        ) AS vehicle_theft_per_100000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY vehicle_theft_per_100000 DESC;


SELECT
    city,
    st,
    population,
    violent_crime,
    round(
        (violent_crime::numeric / population) * 100000, 1
        ) AS violent_crime_per_100000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY violent_crime_per_100000 DESC;


SELECT
    libname,
    stabr,
    visits,
    popu_lsa,
    round(
        (visits::numeric / popu_lsa) * 1000, 1
        ) AS visits_per_1000,
    rank() OVER (ORDER BY (visits::numeric / popu_lsa) * 1000 DESC)
FROM pls_fy2014_pupld14a
WHERE popu_lsa >= 250000;



SELECT
    trip_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    tpep_dropoff_datetime - tpep_pickup_datetime AS length_of_ride
FROM nyc_yellow_taxi_trips_2016_06_01
ORDER BY length_of_ride DESC;


SELECT '2100-01-01 00:00:00-05' AT TIME ZONE 'US/Eastern' AS new_york,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Europe/London' AS london,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Africa/Johannesburg' AS johannesburg,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Europe/Moscow' AS moscow,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Australia/Melbourne' AS melbourne;




SELECT
    round(
          corr(total_amount, (
              date_part('epoch', tpep_dropoff_datetime) -
              date_part('epoch', tpep_pickup_datetime)
                ))::numeric, 2
          ) AS amount_time_corr,
    round(
        regr_r2(total_amount, (
              date_part('epoch', tpep_dropoff_datetime) -
              date_part('epoch', tpep_pickup_datetime)
        ))::numeric, 2
    ) AS amount_time_r2,
    round(
          corr(total_amount, trip_distance)::numeric, 2
          ) AS amount_distance_corr,
    round(
        regr_r2(total_amount, trip_distance)::numeric, 2
    ) AS amount_distance_r2
FROM nyc_yellow_taxi_trips_2016_06_01
WHERE tpep_dropoff_datetime - tpep_pickup_datetime <= '3 hours'::interval;



WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN '90 or more'
                WHEN max_temp BETWEEN 88 AND 89 THEN '88-89'
                WHEN max_temp BETWEEN 86 AND 87 THEN '86-87'
                WHEN max_temp BETWEEN 84 AND 85 THEN '84-85'
                WHEN max_temp BETWEEN 82 AND 83 THEN '82-83'
                WHEN max_temp BETWEEN 80 AND 81 THEN '80-81'
                WHEN max_temp <= 79 THEN '79 or less'
            END
    FROM temperature_readings
    WHERE station_name = 'WAIKIKI 717.2 HI US')

SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY max_temperature_group;



SELECT *
FROM crosstab('SELECT flavor,
                      office,
                      count(*)
               FROM ice_cream_survey
               GROUP BY flavor, office
               ORDER BY flavor',

              'SELECT office
               FROM ice_cream_survey
               GROUP BY office
               ORDER BY office')

AS (flavor varchar(20),
    downtown bigint,
    midtown bigint,
    uptown bigint);



SELECT replace('Williams, Sr.', ', ', ' ');
SELECT regexp_replace('Williams, Sr.', ', ', ' ');



SELECT (regexp_match('Williams, Sr.', '.*, (.*)'))[1];


WITH
    word_list (word)
AS
    (
        SELECT regexp_split_to_table(speech_text, '\s') AS word
        FROM president_speeches
        WHERE speech_date = '1974-01-30'
    )

SELECT lower(
               replace(replace(replace(word, ',', ''), '.', ''), ':', '')
             ) AS cleaned_word,
       count(*)
FROM word_list
WHERE length(word) >= 5
GROUP BY cleaned_word
ORDER BY count(*) DESC;


SELECT president,
       speech_date,
       ts_rank_cd(search_speech_text, search_query, 2) AS rank_score
FROM president_speeches,
     to_tsquery('war & security & threat & enemy') search_query
WHERE search_speech_text @@ search_query
ORDER BY rank_score DESC
LIMIT 5;



SELECT statefp10 AS st,
       round (
              ( sum(ST_Area(geom::geography) / 2589988.110336))::numeric, 2
             ) AS square_miles
FROM us_counties_2010_shp
GROUP BY statefp10
ORDER BY square_miles DESC;



WITH
    market_start (geog_point) AS
    (
     SELECT geog_point
     FROM farmers_markets
     WHERE market_name = 'The Oakleaf Greenmarket'
    ),
    market_end (geog_point) AS
    (
     SELECT geog_point
     FROM farmers_markets
     WHERE market_name = 'Columbia Farmers Market'
    )
SELECT ST_Distance(market_start.geog_point, market_end.geog_point) / 1609.344 -- convert to meters to miles
FROM market_start, market_end;



SELECT census.name10,
       census.statefp10,
       markets.market_name,
       markets.county,
       markets.st
FROM farmers_markets markets JOIN us_counties_2010_shp census
    ON ST_Intersects(markets.geog_point, ST_SetSRID(census.geom,4326)::geography)
    WHERE markets.county IS NULL
ORDER BY census.statefp10, census.name10



CREATE VIEW nyc_taxi_trips_per_hour AS
    SELECT
         date_part('hour', tpep_pickup_datetime),
         count(date_part('hour', tpep_pickup_datetime))
    FROM nyc_yellow_taxi_trips_2016_06_01
    GROUP BY date_part('hour', tpep_pickup_datetime)
    ORDER BY date_part('hour', tpep_pickup_datetime);

SELECT * FROM nyc_taxi_trips_per_hour;



CREATE OR REPLACE FUNCTION
rate_per_thousand(observed_number numeric,
                  base_number numeric,
                  decimal_places integer DEFAULT 1)
RETURNS numeric(10,2) AS $$
BEGIN
    RETURN
        round(
        (observed_number / base_number) * 1000, decimal_places
        );
END;
$$ LANGUAGE plpgsql;

-- Test the function:

SELECT rate_per_thousand(50, 11000, 2);


-- a) Add the column

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date date;

-- b) Create the function that the trigger will execute.

CREATE OR REPLACE FUNCTION add_inspection_date()
    RETURNS trigger AS $$
    BEGIN
       NEW.inspection_date = now() + '6 months'::interval; -- Here, we set the inspection date to six months in the future
    RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- c) Create the trigger

CREATE TRIGGER inspection_date_update
  BEFORE INSERT
  ON meat_poultry_egg_inspect
  FOR EACH ROW
  EXECUTE PROCEDURE add_inspection_date();

-- d) Test the insertion of a company and examine the result

INSERT INTO meat_poultry_egg_inspect(est_number, company)
VALUES ('test123', 'testcompany');

SELECT * FROM meat_poultry_egg_inspect
WHERE company = 'testcompany';



