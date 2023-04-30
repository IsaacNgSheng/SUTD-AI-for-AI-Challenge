use taf;

SELECT tail_number, 
CASE 
    WHEN airline_delay = 0 THEN NULL
    ELSE 1 
  END AS airline_delay_count,
CASE 
    WHEN weather_delay = 0 THEN NULL 
    ELSE 1
  END AS weather_delay_count,
CASE 
    WHEN nas_delay = 0 THEN NULL 
    ELSE 1
  END AS nas_delay_count,
CASE 
    WHEN security_delay = 0 THEN NULL 
    ELSE 1
  END AS security_delay_count,
CASE 
    WHEN late_aircraft_delay = 0 THEN NULL 
    ELSE 1
  END AS late_aircraft_delay_count
FROM taf.twoflights
WHERE airline_delay > 0 
OR weather_delay > 0
OR nas_delay > 0
OR security_delay > 0
OR late_aircraft_delay > 0
GROUP BY tail_number;

SELECT tail_number,
CASE WHEN nas_delay > 0 THEN 1 
    ELSE NULL
  END AS nas_delay,
CASE WHEN airline_delay > 0 THEN 1 
    ELSE NULL
  END AS airline_delay,
CASE WHEN weather_delay > 0 THEN 1 
    ELSE NULL
  END AS weather_delay,
  CASE WHEN security_delay > 0 THEN 1 
    ELSE NULL
  END AS security_delay,
    CASE WHEN late_aircraft_delay > 0 THEN 1 
    ELSE NULL
  END AS late_aircraft_delay
FROM taf.twoflights;

SELECT tn.tail_number, airlinedelay, weatherdelay, nasdelay, securitydelay, lateaircraftdelay
  FROM 
    (SELECT DISTINCT tail_number FRom taf.twoflights) as tn
  LEFT JOIN
    (SELECT tail_number, COUNT(airline_delay) as airlinedelay FRom taf.twoflights WHERE  airline_delay>0 GROUP BY tail_number) as ad
  ON tn.tail_number = ad.tail_number
  LEFT JOIN 
    (SELECT tail_number, COUNT(weather_delay) as weatherdelay  FRom taf.twoflights WHERE  weather_delay>0 GROUP BY tail_number) as wd
  ON tn.tail_number = wd.tail_number
  LEFT JOIN
    (SELECT tail_number, COUNT(nas_delay) as nasdelay FRom taf.twoflights WHERE  nas_delay>0 GROUP BY tail_number) as nd
  ON tn.tail_number = nd.tail_number
  LEFT JOIN
    (SELECT tail_number, COUNT(security_delay) as securitydelay FRom taf.twoflights WHERE  security_delay>0 GROUP BY tail_number) as sd
  ON tn.tail_number = sd.tail_number
  LEFT JOIN
    (SELECT tail_number, COUNT(late_aircraft_delay) as lateaircraftdelay FRom taf.twoflights WHERE  late_aircraft_delay>0 GROUP BY tail_number) as lad
  ON tn.tail_number = lad.tail_number;

-- Terminal Time
SELECT tail_number, fl_date, arrival_time, departure_time, (arrival_time - departure_time) AS terminal_time
FROM taf.twoflights
LIMIT 5;

SELECT TIMESTAMPDIFF(MINUTE, 
    CONCAT_WS(':', LPAD(FLOOR(time1/100), 2, '0'), LPAD(time1 % 100, 2, '0')), 
    CONCAT_WS(':', LPAD(FLOOR(time2/100), 2, '0'), LPAD(time2 % 100, 2, '0'))
) AS time_diff_in_minutes
FROM my_table;

SELECT origin_airport, destination_airport, airline, tail_number, fl_date, arrival_time, departure_time, ABS((arrival_time DIV 100 * 60 + arrival_time MOD 100) - (departure_time DIV 100 * 60 + departure_time MOD 100)) AS terminal_time
FROM taf.twoflights
LIMIT 10;

SELECT t0.origin_airport, (aa_in - ba_in) AS time_diff
FROM (SELECT Distinct origin_airport from taf.twoflights) as t0
	Left join
	(SElEct origin_airport, avg(taxi_out) as aa_in
    from taf.twoflights
    where airline = "AA"
    Group by origin_airport) as t1 on t0.origin_airport = t1.origin_airport
    LEFT join
    (SELECT  origin_airport, avg(taxi_out) as ba_in
    from taf.twoflights
    where airline = "BA"
    Group by origin_airport) as t2 on t0.origin_airport = t2.origin_airport
ORDER BY time_diff DESC;

-- AA query
SELECT tn.airline, tn.tail_number, airlinedelay, weatherdelay, nasdelay, securitydelay, lateaircraftdelay
FROM 
(SELECT DISTINCT airline, tail_number FRom taf.twoflights WHERE airline = "AA") as tn
LEFT JOIN
(SELECT airline, tail_number, COUNT(airline_delay) as airlinedelay FRom taf.twoflights WHERE airline_delay>0 AND airline = "AA" GROUP BY tail_number) as ad
ON tn.tail_number = ad.tail_number
LEFT JOIN 
(SELECT airline, tail_number, COUNT(weather_delay) as weatherdelay  FRom taf.twoflights WHERE weather_delay>0 AND airline = "AA" GROUP BY tail_number) as wd
ON tn.tail_number = wd.tail_number
LEFT JOIN
(SELECT airline, tail_number, COUNT(nas_delay) as nasdelay FRom taf.twoflights WHERE nas_delay>0 AND airline = "AA" GROUP BY tail_number) as nd
ON tn.tail_number = nd.tail_number
LEFT JOIN
(SELECT airline, tail_number, COUNT(security_delay) as securitydelay FRom taf.twoflights WHERE security_delay>0 AND airline = "AA" GROUP BY tail_number) as sd
ON tn.tail_number = sd.tail_number
LEFT JOIN
(SELECT airline, tail_number, COUNT(late_aircraft_delay) as lateaircraftdelay FRom taf.twoflights WHERE late_aircraft_delay>0 AND airline = "AA" GROUP BY tail_number) as lad
ON tn.tail_number = lad.tail_number;

-- BA query
SELECT tn.airline, tn.tail_number, airlinedelay, weatherdelay, nasdelay, securitydelay, lateaircraftdelay
FROM 
(SELECT DISTINCT airline, tail_number FRom taf.twoflights WHERE airline = "BA") as tn
LEFT JOIN
(SELECT airline, tail_number, COUNT(airline_delay) as airlinedelay FRom taf.twoflights WHERE airline_delay>0 AND airline = "BA" GROUP BY tail_number) as ad
ON tn.tail_number = ad.tail_number
LEFT JOIN 
(SELECT airline, tail_number, COUNT(weather_delay) as weatherdelay  FRom taf.twoflights WHERE weather_delay>0 AND airline = "BA" GROUP BY tail_number) as wd
ON tn.tail_number = wd.tail_number
LEFT JOIN
(SELECT airline, tail_number, COUNT(nas_delay) as nasdelay FRom taf.twoflights WHERE nas_delay>0 AND airline = "BA" GROUP BY tail_number) as nd
ON tn.tail_number = nd.tail_number
LEFT JOIN
(SELECT airline, tail_number, COUNT(security_delay) as securitydelay FRom taf.twoflights WHERE security_delay>0 AND airline = "BA" GROUP BY tail_number) as sd
ON tn.tail_number = sd.tail_number
LEFT JOIN
(SELECT airline, tail_number, COUNT(late_aircraft_delay) as lateaircraftdelay FRom taf.twoflights WHERE late_aircraft_delay>0 AND airline = "BA" GROUP BY tail_number) as lad
ON tn.tail_number = lad.tail_number;

-- Overall
SELECT tn.airline, airlinedelay, weatherdelay, nasdelay, securitydelay, lateaircraftdelay
FROM 
(SELECT DISTINCT airline FRom taf.twoflights) as tn
LEFT JOIN
(SELECT airline, COUNT(airline_delay) as airlinedelay FRom taf.twoflights WHERE airline_delay>0 GROUP BY airline) as ad
ON tn.airline = ad.airline
LEFT JOIN 
(SELECT airline, COUNT(weather_delay) as weatherdelay  FRom taf.twoflights WHERE weather_delay>0 GROUP BY airline) as wd
ON tn.airline = wd.airline
LEFT JOIN
(SELECT airline, COUNT(nas_delay) as nasdelay FRom taf.twoflights WHERE nas_delay>0 GROUP BY airline) as nd
ON tn.airline = nd.airline
LEFT JOIN
(SELECT airline, COUNT(security_delay) as securitydelay FRom taf.twoflights WHERE security_delay>0 GROUP BY airline) as sd
ON tn.airline = sd.airline
LEFT JOIN
(SELECT airline, COUNT(late_aircraft_delay) as lateaircraftdelay FRom taf.twoflights WHERE late_aircraft_delay>0 GROUP BY airline) as lad
ON tn.airline = lad.airline;
