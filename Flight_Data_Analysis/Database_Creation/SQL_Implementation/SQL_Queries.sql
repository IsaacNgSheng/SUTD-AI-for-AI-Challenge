Use tass; 

-- Question 1
SELECT c.CustomerID, c.FirstName, c.LastName
FROM tass.customer AS c
WHERE c.country = "Begonia"
ORDER BY c.CustomerID;

-- Question 2
SELECT b.FlightNumber
FROM tass.booking AS b
WHERE b.BookingDate LIKE "_____11%"
AND b.DepartureDateTime LIKE "2023/1/%";

-- Question 3
SELECT e.FromCurrency, e.ToCurrency, AVG(e.ExchangeRate) AS AverageExchangeRate
FROM tass.exchange AS e
GROUP BY e.ExchangeRate
HAVING e.ExchangeRate > 1
AND e.FromCurrency = "BegoniaDollar"
ORDER BY e.ExchangeRate;

-- Question 4
SELECT f.FlightNumber, COUNT(*) AS NumberOfFlights
FROM tass.flight AS f
INNER JOIN tass.flightavailability AS fa
ON f.FlightNumber = fa.FlightNumber
WHERE fa.OriginAirportCode = 'AP02' AND fa.DestinationAirportCode = 'AP09'
GROUP BY f.FlightNumber;

-- Question 5
SELECT f.AirlineCode, COUNT(DISTINCT f.FlightNumber) AS NumberOfFlightNumbers
FROM tass.flight AS f
GROUP BY f.AirlineCode;

-- Question 6
SELECT a.AirlineName, f.BusinessClassIndicator, COUNT(*) AS NumberOfFlightNumbers
FROM (
    SELECT DISTINCT AirlineCode, FlightNumber, BusinessClassIndicator
    FROM tass.flight
) AS f
INNER JOIN tass.airline AS a 
ON f.AirlineCode = a.AirlineCode
WHERE a.AirlineName LIKE '%u%'
GROUP BY a.AirlineName, f.BusinessClassIndicator
ORDER BY a.AirlineName, COUNT(*) ASC;

-- Question 7
SELECT b.OfficeID, COUNT(*) AS NumberOfBookings
FROM tass.booking AS b
GROUP BY b.OfficeID
ORDER BY NumberOfBookings DESC
LIMIT 3;

-- Question 8
SELECT fa.FlightNumber
FROM tass.flightavailability AS fa
GROUP BY fa.FlightNumber
ORDER BY AVG((fa.BookedBusinessSeats + fa.BookedEconomySeats) * 100 / (fa.TotalBusinessSeats + fa.TotalEconomySeats)) ASC
LIMIT 5;

-- Question 9
SELECT AVG(num_payments) AS AvgNumberOfPayments
FROM (
  SELECT b.BookingID, COUNT(DISTINCT p.PaymentID) AS num_payments
  FROM tass.booking AS b
  JOIN tass.payment AS p ON b.BookingID= p.BookingID
  WHERE b.StatusID = 'ST01'
  GROUP BY b.BookingID
) AS payment_counts;

-- Question 10
SELECT ROUND(100 * (
    SELECT COUNT(*) 
    FROM (
        SELECT DISTINCT c.CustomerID
        FROM tass.customer c
        WHERE c.nationality != c.country
    ) AS foreign_customers
) / COUNT(DISTINCT c.CustomerID), 2) AS ForeignerPercent
FROM tass.customer AS c;

-- Question 11
SELECT bookingID
FROM tass.booking
WHERE BookingDate BETWEEN '2022/10/16' AND '2022/11/15'
AND bookingID NOT IN (
  SELECT BookingId
  FROM tass.payment
  WHERE paymentId IS NOT NULL
);

-- Question 12
SELECT c.CustomerID, c.FirstName, c.LastName, MAX(p.PaymentDate) AS LatestPayment
FROM tass.customer AS c
INNER JOIN tass.payment AS p 
ON c.CustomerID = p.CustomerID
WHERE c.Nationality = "Begonia"
GROUP BY c.CustomerID, c.FirstName, c.LastName;

-- Question 13
SELECT 
    c.CustomerID,
    COALESCE((
        SELECT COUNT(*)
        FROM tass.booking b
        WHERE b.CustomerID = c.CustomerID
        GROUP BY b.CustomerID
    ), 0) AS NumberOfBookings,
    COALESCE((
        SELECT COUNT(*)
        FROM tass.customeremail ce
        WHERE ce.CustomerID = c.CustomerID
        GROUP BY ce.CustomerID
    ), 0) AS NumberOfEmails,
    COALESCE((
        SELECT COUNT(*)
        FROM tass.customerphone cp
        WHERE cp.CustomerID = c.CustomerID
        GROUP BY cp.CustomerID
    ), 0) AS NumberOfPhones
FROM 
    tass.customer c
ORDER BY 
    c.CustomerID ASC
LIMIT 5;

-- Question 14
SELECT 
  f.FlightNumber, 
  STDDEV(b.FlightPrice) AS StdFlightPrice, 
  AVG(fa.TotalBusinessSeats - fa.BookedBusinessSeats) AS AvgAvailableBusinessSeats, 
  AVG(fa.TotalEconomySeats - fa.BookedEconomySeats) AS AvgAvailableEconomySeats
FROM tass.flight AS f 
LEFT JOIN tass.flightavailability AS fa ON f.FlightNumber = fa.FlightNumber 
LEFT JOIN tass.booking AS b ON f.FlightNumber = b.FlightNumber 
GROUP BY f.FlightNumber 
ORDER BY StdFlightPrice DESC 
LIMIT 5;

-- Question 15
SELECT c.CustomerID,
CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
CONCAT(cp.CountryCode, '-', cp.AreaCode, '-', cp.LocalNumber) AS PhoneNo
FROM tass.customer AS c 
JOIN tass.customerphone AS cp ON c.CustomerID = cp.CustomerID
LEFT JOIN tass.customeremail AS ce ON c.CustomerID = ce.CustomerID
WHERE ce.Email IS NULL 
AND NOT EXISTS (
    SELECT 1 
    FROM tass.customerphone AS cp2 
    WHERE cp2.CustomerID = c.CustomerID AND cp2.LocalNumber != cp.LocalNumber
  )
GROUP BY c.CustomerID, FullName, PhoneNo
HAVING COUNT(*) = 1
ORDER BY c.CustomerID ASC;

-- Question 16 
SELECT c.CountryName, ct.CityName,
SUM(b.TotalPrice) AS TotalSales
FROM tass.booking AS b
INNER JOIN tass.status AS s 
ON s.StatusID = b.StatusID AND s.status != 'Canceled'
INNER JOIN tass.bookingoffice AS bo 
ON b.OfficeID = bo.OfficeID
INNER JOIN tass.city AS ct 
ON bo.CityCode = ct.CityCode
INNER JOIN tass.country AS c 
ON ct.CountryCode = c.CountryCode
GROUP BY c.CountryName, ct.CityName
HAVING SUM(b.TotalPrice) = (
	SELECT MAX(TotalSales)
	FROM (
		SELECT
		c.CountryName,
		ct.CityName,
		SUM(b.TotalPrice) AS TotalSales
		FROM tass.booking b
		INNER JOIN tass.status s ON s.StatusID = b.StatusID AND s.status != 'Canceled'
		INNER JOIN tass.bookingoffice bo ON b.OfficeID = bo.OfficeID
		INNER JOIN tass.city ct ON bo.CityCode = ct.CityCode
		INNER JOIN tass.country c ON ct.CountryCode = c.CountryCode
		GROUP BY c.CountryName, ct.CityName
		) subq
	WHERE subq.CountryName = c.CountryName)
ORDER BY c.CountryName;

-- Question 17 
SELECT b.BookingID, b.FlightNumber, b.ArrivalDateTime, b.DepartureDateTime,
a1.CityCode AS OriginCityCode, a2.CityCode AS DestinationCityCode
FROM tass.booking b
INNER JOIN tass.airport a1
ON a1.AirportCode = (
  SELECT OriginAirportCode 
  FROM tass.flightavailability 
  WHERE FlightNumber = b.FlightNumber
  LIMIT 1
)
INNER JOIN tass.airport a2
ON a2.AirportCode = (
  SELECT DestinationAirportCode 
  FROM tass.flightavailability 
  WHERE FlightNumber = b.FlightNumber
  LIMIT 1
)
WHERE b.statusID IN (
  SELECT StatusID
  FROM tass.status
  WHERE Status = "Canceled"
)
ORDER BY b.FlightPrice DESC
LIMIT 5;

-- Question 18
SELECT COUNT(DISTINCT b.FlightNumber) AS NumberOfPotentialAffected
FROM tass.booking AS b
INNER JOIN tass.customer AS c ON b.CustomerID = c.CustomerID AND c.Country = 'Rose'
INNER JOIN tass.flightavailability AS fa ON b.FlightNumber = fa.FlightNumber 
AND (
	fa.OriginAirportCode IN (
		SELECT AirportCode
		FROM tass.airport AS a
		INNER JOIN tass.city AS ct ON a.CityCode = ct.CityCode
		INNER JOIN tass.country AS c ON ct.CountryCode = c.CountryCode
		WHERE c.CountryName = 'Carnation'
)
OR 
    fa.DestinationAirportCode IN (
		SELECT AirportCode
		FROM tass.airport AS a
		INNER JOIN tass.city AS ct ON a.CityCode = ct.CityCode
		INNER JOIN tass.country AS c ON ct.CountryCode = c.CountryCode
		WHERE c.CountryName = 'Carnation'
    )
  );

-- Question 19
SELECT 
    OriginAirportCode AS AirportCode, 
    DENSE_RANK() OVER(ORDER BY no_flights DESC) AS "Rank" 
FROM 
    (SELECT 
        OriginAirportCode, 
        SUM(no_flights) AS no_flights 
    FROM 
        (SELECT 
            OriginAirportCode, 
            COUNT(FlightNumber) AS no_flights 
        FROM 
            tass.flightavailability AS fa
        WHERE 
            weekday(DepartureDateTime) < 5 
        GROUP BY 
            OriginAirportCode
        UNION ALL 
        SELECT 
            DestinationAirportCode AS OriginAirportCode, 
            COUNT(FlightNumber) AS no_flights 
        FROM 
            tass.flightavailability AS fa
        WHERE 
            weekday(ArrivalDateTime) < 5 
        GROUP BY 
            DestinationAirportCode
        ) AS subq
    GROUP BY 
        OriginAirportCode
    ) AS c;



