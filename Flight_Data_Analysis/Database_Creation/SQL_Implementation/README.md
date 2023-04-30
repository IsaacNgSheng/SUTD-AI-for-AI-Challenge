# Requirements
1. Implement the relational database (named “tass”) on MySQL (using the MySQL Workbench) based on the conceptual and logical data models provided and by importing the data in the ‘.csv’ files (these files are provided in the DataFiles.zip):
  a. Data representing the entities, attributes and relationships for TASS system are given in the following ‘.csv’ files:
    i. Airline: Airline.csv
    ii. Airport: Airport.csv
    iii. Booking: Booking.csv
    iv. BookingOffice: BookingOffice.csv
    v. City: City.csv
    vi. Class: Class.csv
    vii. Country: Country.csv
    viii. Currency: Currency.csv
    ix. Customer: Customer.csv
    x. CustomerEmail: CustomerEmail.csv
    xi. CustomerPhone: CustomerPhone.csv
    xii. Exchange: Exchange.csv
    xiii. Flight: Flight.csv
    xiv. FlightAvailability: FlightAvailability.csv
    xv. Payment: Payment.csv
    xvi. Status: Status.csv
  b. You need to create the tables in MySQL workbench using the logical data model specified in Appendix A before you import the data. Declare the fields using MySQL data types “varchar(xx)”, “int”, “float”, or “datetime” where appropriate. The size of the data structure is up to you e.g. CustomerID could be defined as varchar(30), FirstName as varchar(30), FlightPrice and TotalPrice as float, ArrivalDateTime and DepartureDateTime as datetime, TotalBusinessSeats and BookedEconomySeats as int, DestinationAirportCode as varchar(30), FlightNumber as varchar(30), etc. DO NOT CHANGE THE TABLE OR COLUMN NAME.
  c. Import the data into the newly created tables. Where the name is a MySQL reserved word (e.g. names used to define table names or variables) such as “Exchange”, “Date” and “Status”
  d. When you import the data from the csv files into MySQL Workbench, take note that there is a certain sequence by which the tables are to be created and imported because of the dependency due to foreign keys. Follow this sequence:
    i. Country
    ii. City
    iii. Airline
    iv. Flight
    v. BookingOffice
    vi. Currency
    vii. Airport
    viii. FlightAvailability
    ix. Class
    x. Status
    xi. Customer
    xii. CustomerEmail
    xiii. CustomerPhone
    xiv. Exchange
    xv. Booking
    xvi. Payment
  e. When the data are imported into MySQL Workbench, you will have the set of tables for the entities, attributes and relationships in the database, ready for executing the queries in Appendix B.
  f. You may consider the database to be static i.e. the database is a snapshot or an extraction of data, which will not automatically update itself with any value.
  g. You do not have to calculate any values by yourself.
  h. You also do not have to define any derived attributes when creating tables.
    i. Assumptions:
    i. All mentions of flight prices will be in Begonia dollars.
    ii. Airport tax is stored in local currencies where the airport is located.
2. Implement the queries listed in Appendix B directly in MySQL Workbench as MySQL scripts. Results tables for some of the queries are given.

# Conceptual Data Model
![image](https://user-images.githubusercontent.com/64978175/235363963-925d932f-359b-441f-ad8a-4b6c7623df46.png)

# Logical Data Model
![image](https://user-images.githubusercontent.com/64978175/235363969-c3c82dc8-fea5-4400-8d3f-131999331315.png)

# Queries
1. List all the customers whose mail addresses in Begonia. Display CustomerID, FirstName, and LastName. Sort results by CustomerID in ascending order.
2. List all different flight numbers that have been booked in November and will departure in 2023 January. Display FlightNumber only.
3. List average currency exchange rates from BegoniaDollar to other currencies, e.g. from Begonia Dollar to Carnation Dollar. Display average exchange rate(s) that is (are) greater than 1. Sort them by average exchange rate in ascending order. Display FromCurrency, ToCurrency, and average exchange rate as AverageExchangeRate.
4. List number of available flights for all flight numbers between BorAirport (airport code is 'AP02') and RadAirport (airport code is 'AP09'). Display FlightNumber and number of flights as NumberOfFlights
5. List number of flight numbers (FlightNumber) provided for each airline company. Display AirlineCode and number of flight numbers as NumberOfFlightNumbers.
6. List airline companies containing “u” in their names. Show the number of flight numbers having business class and the number of flight numbers do not provide business class for each of them. Display AirlineName, BusinessClassIndicator, and number of flight numbers as NumberOfFlightNumbers.
7. List top 3 booking offices which have highest number of bookings. You do not need to consider the status of booking; bookings with any status do count. Display OfficeID and number of bookings as NumberOfBookings.
8. List 5 flight numbers which have lowest average percentage of total booked seats (including economy and business) among their available flights. Display FlightNumber only.
9. For those booking status is “ST01”, calculate the average number of payments to settle those bookings. Display the average number of payments as AvgNumberOfPayments.
10. Calculate the percentage of foreigners in the customer list. Foreigner is identified as people whose country in mail address is not the same as his/her nationality. Display the percentage as ForeignerPercent. Round the percentage up to 2 decimal places, e.g. 50.99%.
11. List all Bookings placed between "2022-10-16" and "2022-11-15" which have not gotten any payments yet. "placed" refers to the booking that has been made; however, it does not mean this booking is confirmed.
12. List all customers come from Begonia (Nationality is “Begonia”). Find their latest payment dates. Display CustomerID, FirstName, LastName, and latest payment date as LatestPayment.
13. Sort customers by CustomerID in ascending order. Select the top five customers. List number of bookings, number of emails, number of phones for each of them. Display CustomerID, number of bookings as NumberOfBookings, number of Emails as NumberOfEmails, number of phones as NumberOfPhones.
14. List top 5 flight numbers (FlightNumber) which have the most fluctuating flight price. Display FlightNumber, standard deviation of flight price as StdFlightPrice, average available business seats of all available flights for each flight number (including those not in the “booking” table) as AvgAvailableBusinessSeats, average available economy seats of all available flights for each flight number (including those not in the “booking” table) as AvgAvailableEconomySeats.
15. Find customers who do not have email address but have phone number. List them who only has one phone number. Display CustomerID, full name (format as “FirstName LastName”, e.g. “Jean Smith”), and phone number (format as “CountryCode-AreaCode-LocalNumber”, e.g. “11-111-123456”). Sort them by CustomerID in ascending order.
16. Among cities in each country, list city with the highest sum of TotalPrice. Exclude canceled bookings. Display CountryName, CityName and sum of total price as TotalSales. Sort records by CountryName in ascending order. Assume you do not know the StatusID for “canceled”.
17. List top 5 canceled bookings which have the highest FlightPrice. Display BookingID, FlightNumber, ArrivalDateTime, DepartureDateTime, origin city code as OriginCityCode, destination city code as DestinationCityCode. Assuming you do not know the StatusID for “canceled” booking; you will have to JOIN tables to select canceled bookings
18. If the exchange rate from RoseDollar to CarnationDollar change (exchange rate from CarnationDollar to RoseDollar will not change), how many different flight numbers (FlightNumber) will be affected based on current booking situation. Display number of flight numbers as NumberOfPotentialAffected.
19. Rank airports based on total number of flights arrival and departure in weekdays. Display AirportCode and rank. (Airports with the same number of flights are treated as having the same rank.
