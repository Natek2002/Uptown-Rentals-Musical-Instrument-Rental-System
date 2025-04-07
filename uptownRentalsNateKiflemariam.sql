-- Name: Nate Kiflemariam 
-- Purpose: Using SQL to answer questions and analyze data from the Uptown Rentals 
-- Date: 03-27-2025


USE uptown;


-- a.) What is the list of all instrument rentals in inventory? (Show the list displayed in Figure 1, along with any other rentals in your database.)
SELECT 
    r.RentalID,
    c.CustomerName,
    r.RentalDate,
    r.DueDate,
    i.InstrumentType,
    i.RentalTier,
    c.ContactEmail,
    s.StaffName,
    r.ReturnDate,
    i.DailyRentalFee
FROM RENTAL r
JOIN CUSTOMER c ON r.CustomerID = c.CustomerID
JOIN INSTRUMENT i ON r.SerialNumber = i.SerialNumber
JOIN STAFF s ON r.StaffID = s.StaffID;

-- b.) What are the youngest and oldest customers of Uptown Rentals? Write one SQL program to display both.
SELECT MIN(Age) AS Youngest, MAX(Age) AS Oldest
FROM CUSTOMER;
SELECT CustomerName, Age
FROM CUSTOMER
WHERE Age = (SELECT MIN(Age) FROM CUSTOMER)
   OR Age = (SELECT MAX(Age) FROM CUSTOMER);
   
   
-- c.) List the aggregated (summed) rental amounts per customer. Sequence the result to show the customer with the highest rental amount first.
SELECT Customer.CustomerName, SUM(Instrument.DailyRentalFee) AS TotalAmount
FROM RENTAL
JOIN CUSTOMER ON RENTAL.CustomerID = CUSTOMER.CustomerID
JOIN INSTRUMENT ON RENTAL.SerialNumber = INSTRUMENT.SerialNumber
GROUP BY Customer.CustomerName
ORDER BY TotalAmount DESC;

-- d.) Which customer has the most rentals (the highest count) across all time?
SELECT Customer.CustomerName, COUNT(*) AS RentalCount
FROM RENTAL
JOIN CUSTOMER ON RENTAL.CustomerID = CUSTOMER.CustomerID
GROUP BY Customer.CustomerName
ORDER BY RentalCount DESC
LIMIT 1;

-- e.) Which customer had the most rentals in January 2025, and what was their average rental total per rental?
SELECT Customer.CustomerName, COUNT(*) AS RentalCount, 
       AVG(Instrument.DailyRentalFee) AS AvgRentalAmount
FROM RENTAL
JOIN CUSTOMER ON RENTAL.CustomerID = CUSTOMER.CustomerID
JOIN INSTRUMENT ON RENTAL.SerialNumber = INSTRUMENT.SerialNumber
WHERE MONTH(RentalDate) = 1 AND YEAR(RentalDate) = 2025
GROUP BY Customer.CustomerName
ORDER BY RentalCount DESC
LIMIT 1;

-- f.) Which staff member (name) is associated with the most rentals in January 2025?
SELECT S.StaffName, COUNT(*) AS RentalCount
FROM RENTAL R
JOIN STAFF S ON R.StaffID = S.StaffID
WHERE MONTH(R.RentalDate) = 1 AND YEAR(R.RentalDate) = 2025
GROUP BY S.StaffName
ORDER BY RentalCount DESC
LIMIT 1;

-- g.) For each customer that has an overdue rental, how many days have passed since the rental was due?
SELECT 
  CUSTOMER.CustomerName,
  RENTAL_HISTORY.SerialNumber,
  RENTAL.DueDate,
  RENTAL_HISTORY.ReturnDate,
  DATEDIFF(RENTAL_HISTORY.ReturnDate, RENTAL.DueDate) AS DaysLate
FROM RENTAL_HISTORY, RENTAL, CUSTOMER
WHERE 
  RENTAL_HISTORY.SerialNumber = RENTAL.SerialNumber AND
  RENTAL_HISTORY.CustomerID = RENTAL.CustomerID AND
  CUSTOMER.CustomerID = RENTAL_HISTORY.CustomerID AND
  RENTAL_HISTORY.ReturnDate > RENTAL.DueDate;

-- h.) What is the total rental amount by Rental tier?
SELECT 
  I.RentalTier,
  SUM(I.DailyRentalFee) AS TotalRentalAmount
FROM RENTAL R
JOIN INSTRUMENT I ON R.SerialNumber = I.SerialNumber
GROUP BY I.RentalTier;

-- i.) Who are the top three store staff members in terms of total rental amounts?
SELECT s.StaffName, SUM(i.DailyRentalFee) AS TotalRentalAmount
FROM RENTAL r
JOIN STAFF s ON r.StaffID = s.StaffID
JOIN INSTRUMENT i ON r.SerialNumber = i.SerialNumber
GROUP BY s.StaffName
ORDER BY TotalRentalAmount DESC
LIMIT 3;

-- j.) What is the total rental amount by instrument type, where the instrument type is Flute or Bass Guitar?
SELECT i.InstrumentType, SUM(i.DailyRentalFee) AS TotalRentalAmount
FROM RENTAL r
JOIN INSTRUMENT i ON r.SerialNumber = i.SerialNumber
WHERE i.InstrumentType IN ('Flute', 'Bass Guitar')
GROUP BY i.InstrumentType;

-- k.) What is the name of any customer who has two or more overdue rentals?
SELECT c.CustomerName
FROM RENTAL_HISTORY rh
JOIN CUSTOMER c ON rh.CustomerID = c.CustomerID
WHERE rh.LateFeePaid > 0
GROUP BY c.CustomerName
HAVING COUNT(*) >= 2;

-- l.) List all of the instruments in inventory in 2025 that were damaged upon return or needed maintenance. 
-- Include the employee that handled the rental, the repair cost, and the maintenance date.
SELECT 
    i.InstrumentType,
    r.RentalDate,
    s.StaffName,
    m.RepairCost,
    m.MaintenanceDate
FROM MAINTENANCE m
JOIN INSTRUMENT i ON m.SerialNumber = i.SerialNumber
JOIN RENTAL r ON i.SerialNumber = r.SerialNumber
JOIN STAFF s ON r.StaffID = s.StaffID
WHERE YEAR(m.MaintenanceDate) = 2025;



-- m.) Create a query of your choice that includes a subquery.
-- Customers who rented instruments with daily fee over $40
SELECT DISTINCT c.CustomerName
FROM CUSTOMER c
JOIN RENTAL r ON c.CustomerID = r.CustomerID
WHERE r.SerialNumber IN (
    SELECT SerialNumber
    FROM INSTRUMENT
    WHERE DailyRentalFee > 40
);

-- n.) What are the names and emails of customers who rented an instrument in 2025?
SELECT DISTINCT c.CustomerName, c.ContactEmail
FROM CUSTOMER c
JOIN RENTAL r ON c.CustomerID = r.CustomerID
WHERE YEAR(r.RentalDate) = 2025;

