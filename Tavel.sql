SELECT * FROM taxi_booking_service 

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Taxi_Booking_Service';

ALTER TABLE Taxi_Booking_Service
DROP COLUMN `Vehicle Images`;

ALTER TABLE Taxi_Booking_Service
RENAME COLUMN `Vehicle Images` TO Vehicle_Images;

ALTER TABLE Taxi_Booking_Service
DROP COLUMN Canceled_Rides_by_Customer, 
DROP COLUMN Canceled_Rides_by_Driver, 
DROP COLUMN Incomplete_Rides_Reason, 
DROP COLUMN Vehicle_Images,
DROP COLUMN MyUnknownColumn;

SELECT SUM(Booking_Value) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE Payment_Method IS NOT NULL;

SELECT SUM(Booking_Value) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE Payment_Method IS NULL;

SELECT CAST(Date_of_Service AS DATE) AS Booking_Day, 
       SUM(Booking_Value) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE Booking_Value IS not NULL
GROUP BY CAST(Date_of_Service as DATE)
ORDER BY Total_Booking_Value;

SELECT CAST(Date_of_Service AS DATE) AS Booking_Day,
	COUNT(Booking_ID) AS Total_ride
FROM Taxi_Booking_Service
WHERE Booking_Status = 'Success'
GROUP BY CAST(Date_of_Service as DATE)
ORDER BY Booking_Day;

SELECT
    CAST(Date_of_Service AS DATE) AS Service_Day,
    CONCAT(ROUND(COUNT(Booking_ID)/1000,1), 'K') AS Total_ride,
    SUM(Booking_Value) AS Total_Booking_Value
FROM  Taxi_Booking_Service
WHERE  
Booking_Status = 'Success' AND Date_of_Service = '2024-07-01'


SELECT 
    CASE WHEN DAYOFWEEK(Date_of_Service) IN (6,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(COUNT(Booking_ID)/1000,1), 'K') AS Total_ride,
    SUM(Booking_Value) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE  
Booking_Status = 'Success' AND  Date_of_Service BETWEEN '2024-07-01' AND '2024-07-07'
GROUP BY
    CASE WHEN DAYOFWEEK(Date_of_Service) IN (6,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END 
   
SELECT 
    Vehicle_Type, 
    SUM(Ride_Distance) AS Total_Distance
FROM Taxi_Booking_Service
WHERE  
Booking_Status = 'Success'
GROUP BY Vehicle_Type
ORDER BY Total_Distance DESC; 

SELECT 
    Vehicle_Type, 
    MAX(Ride_Distance) AS Max_Ride_Distance,
    ROUND(AVG(Ride_Distance), 2) AS Avg_Ride_Distance
FROM Taxi_Booking_Service
WHERE Booking_Status = 'Success'
GROUP BY Vehicle_Type
ORDER BY Avg_Ride_Distance DESC;


SELECT 
    AVG(Booking_Value) AS AVG_Booking_value
FROM
	(
   SELECT SUM(Booking_Value) AS Booking_Value
	FROM Taxi_Booking_Service
	WHERE Booking_Status = 'Success' AND  Date_of_Service = '2024-07-02'
	GROUP BY CAST(Date_of_Service as DATE)
    ) AS Daily_Booking;


SELECT 
    DAY(Date_of_Service) AS day_of_week,
    SUM(Booking_Value) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE Booking_Status = 'Success' 
GROUP BY DAY (Date_of_Service)
ORDER BY DAY (Date_of_Service)

WITH Value_data AS (
    SELECT 
        DAY(Date_of_Service) AS day_of_week,
        SUM(Booking_Value) AS Total_Booking_Value,
        AVG(SUM(Booking_Value)) OVER () AS AVG_Booking_Value
    FROM Taxi_Booking_Service
    WHERE Booking_Status = 'Success'
    GROUP BY DAY(Date_of_Service)
)

SELECT 
    day_of_week,
    CASE 
        WHEN Total_Booking_Value > AVG_Booking_Value THEN 'Above Average'
        WHEN Total_Booking_Value < AVG_Booking_Value THEN 'Below Average'
        ELSE 'Average'
    END AS Value_amount,
    Total_Booking_Value
FROM Value_data
ORDER BY day_of_week;

SELECT
    Vehicle_Type,
    SUM(Booking_Value) AS Total_Booking_Value
FROM  Taxi_Booking_Service
WHERE Booking_Status = 'Success'
GROUP BY  Vehicle_Type
ORDER BY SUM(Booking_Value) DESC 

SELECT 
    Booking_Status, 
    COUNT(*) AS cancel_Trips
FROM Taxi_Booking_Service
WHERE Incomplete_Rides IS NULL
GROUP BY Booking_Status
ORDER BY cancel_Trips

SELECT
   SUM(Booking_Value) AS Total_Booking_Value,
   COUNT(Booking_ID) AS Total_ride
FROM Taxi_Booking_Service
WHERE Booking_Status = 'Success'
AND DAYOFWEEK(Date_of_Service) = 2
AND HOUR(Time_of_Service) = 15

SELECT 
   HOUR(Time_of_Service),
   SUM(Booking_Value) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE Booking_Status = 'Success'
GROUP BY HOUR(Time_of_Service)
ORDER BY HOUR(Time_of_Service)

SELECT 
   CASE
      WHEN DAYOFWEEK(Date_of_Service) = 1 THEN 'Monday'
      WHEN DAYOFWEEK(Date_of_Service) = 2 THEN 'Tuesday'
      WHEN DAYOFWEEK(Date_of_Service) = 3 THEN 'Wednesday'
      WHEN DAYOFWEEK(Date_of_Service) = 4 THEN 'Thursday'
      WHEN DAYOFWEEK(Date_of_Service) = 5 THEN 'Friday'
      WHEN DAYOFWEEK(Date_of_Service) = 6 THEN 'Saturday'
      ELSE 'Sunday'
  END AS Day_Of_Week,
  ROUND(SUM(Booking_Value)) AS Total_Booking_Value
FROM Taxi_Booking_Service
WHERE Booking_Status = 'Success'
GROUP BY
     CASE
      WHEN DAYOFWEEK(Date_of_Service) = 1 THEN 'Monday'
      WHEN DAYOFWEEK(Date_of_Service) = 2 THEN 'Tuesday'
      WHEN DAYOFWEEK(Date_of_Service) = 3 THEN 'Wednesday'
      WHEN DAYOFWEEK(Date_of_Service) = 4 THEN 'Thursday'
      WHEN DAYOFWEEK(Date_of_Service) = 5 THEN 'Friday'
      WHEN DAYOFWEEK(Date_of_Service) = 6 THEN 'Saturday'
      ELSE 'Sunday'  
   END;   