# Narrative
There are six different airlines in six different countries (named after flowers): Begonia – BeAir, Carnation – CarAir, Gaura - GauAir, Ipomoea – IpoAir, Rose - RoseAir, and Tulip - TulAir. Their flights involve the following 12 cities (named after metals): Barium and Boron in Begonia, Copper and Cesium in Carnation, Gallium and Germanium in Gaura, Iron and Iridium in Ipomoea, Radium and Rhodium in Rose, and Thorium and Titanium in Tulip. In each of the 12 cities, there is a (single) booking office.

Design a central seat-booking database to be used by all booking offices.

A flight has a flight number which is unique, an airline code, and a business class indicator.

Flight availability has flight number, date and time of departure, number of total seats available in business class, number of confirmed seats in business class, number of total seats available in economy class, and number of confirmed seats in economy class.

Customers may come from any country, not just from the six countries above. A customer is identified by a customer id (which is unique) and has a first name, a last name and a mailing address. A customer also has zero or more phone numbers, and zero or more email addresses.

A mailing address is composed of street, city, province, country and postal code. Phone number has country code, area code and local number which is unique in the country. Email address has only one string, and no structure is assumed.

A customer can book one or more flights. Two or more customers may have same mailing address and/or same phone number(s). But the email address is unique for each customer. First name and last name do not have to be unique.


Booking has the following information:
  • a unique booking id
  • booking city
  • booking date
  • flight number
  • departure date and time (in local time, and time is always in hours and minutes: in 24 hours format e.g. 13:00 for 1pm exactly)
  • arrival date and time (in local time)
  • class indicator (i.e., business or economy). This is to be considered as an entity.
  • total price (airport tax in origin airport plus airport tax in destination airport plus flight price – in local currency)
  • flight price (business class flight price is 1.5 times of flight price)
  • status indicator (there are three types: confirmed – the booking is reserved/booked for the customer; canceled – the customer canceled the booking, scratched – the customer had not paid in full 30 days prior to the departure). This is to be considered as an entity.
  • paid by (the customer who is responsible for payment)
  • paid amount (amount-paid-so far (in local currency))
  • balance (outstanding balance (in local currency))

Some additional information:
  • The first name and last name are to be printed on the ticket.
  • The airport taxes must be stored in local currencies (i.e. Begonia dollars, Carnation dollars, Gaura dollars, Ipomoea dollars, Rose dollars, and Tulip dollars).
  • Since the exchange rates change daily, they also must be stored for calculations of all prices involved.

Assume the followings:
  • One City only has one Airport.
  • One Country must have at least one City.
  • Customers may come from countries other than the six countries listed here; the names of their originating countries will be provided in the database.
  • A Customer in the list may not have any booking.
  • All Booking Offices have at least one booking.
  • One booking is for one available Flight only.
  • All derived attributes (if any) are to be stored in their respective database tables.

# Requirements
1. Develop a conceptual data model based on the above Narrative. You may use the Chen’s notation, the Crow-feet notation, or the Unified Modeling Language notation to present the conceptual data model. A summary of steps for developing the conceptual data model is given here:
  a. Identify strong entities, their associated attributes, and primary key attribute(s).
  b. Identify weak entities and their associated attributes where applicable.
  c. Identify the relationships between entities:
    i. Identify associated relationship attributes
    ii. Identify cardinality of relationships (including multiplicity and participation constraints)
  d. Produce an Entity-Relationship Diagram depicting the conceptual data model.
2. Produce a logical data model from the conceptual data model you have developed in (1). A summary of steps for developing the logical data model is given here:
  a. Transform the Entity-Relationship Diagram into relational schemas (i.e., tables).
  b. Refine the relational schemas by combining schemas and normalizing the tables where necessary to produce the final logical data model.
3. Produce the conceptual data model and logical data model in a Powerpoint presentation file.
