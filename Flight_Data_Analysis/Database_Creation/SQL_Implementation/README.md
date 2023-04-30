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
