-- Q1. Display all users

SELECT *
FROM App_User;

-- Q2. Display the important product details

SELECT Product_ID,
       Product_Name,
       Brand,
       Price,
       Stock_Quantity
FROM Product
ORDER BY Product_ID;

-- Q3. Display products that cost more than 3000

SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Price > 3000
ORDER BY Price DESC;

-- Q4. Display products with fewer than 30 units in stock

SELECT Product_ID,
       Product_Name,
       Stock_Quantity
FROM Product
WHERE Stock_Quantity < 30
ORDER BY Stock_Quantity;

-- Q5. Display delivered orders

SELECT Order_ID,
       User_ID,
       Order_Date,
       Total_Amount
FROM Orders
WHERE Order_Status = 'DELIVERED'
ORDER BY Order_Date;

-- Q6. Count the total number of products

SELECT COUNT(*) AS Total_Products
FROM Product;

-- Q7. Display the minimum, maximum and average product price

SELECT MIN(Price) AS Minimum_Price,
       MAX(Price) AS Maximum_Price,
       ROUND(AVG(Price), 2) AS Average_Price
FROM Product;

-- Q8. Calculate the total value of all orders

SELECT SUM(Total_Amount) AS Total_Order_Value
FROM Orders;
-- Q9. Count the products in each category

SELECT Category_ID,
       COUNT(*) AS Product_Count
FROM Product
GROUP BY Category_ID
ORDER BY Category_ID;
-- Q10. Calculate the average product price in each category

SELECT Category_ID,
       ROUND(AVG(Price), 2) AS Average_Price
FROM Product
GROUP BY Category_ID
ORDER BY Category_ID;

-- Q11. Display categories containing more than one product

SELECT Category_ID,
       COUNT(*) AS Product_Count
FROM Product
GROUP BY Category_ID
HAVING COUNT(*) > 1
ORDER BY Category_ID;
-- Q12. Display products priced between 1000 and 5000

SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Price BETWEEN 1000 AND 5000
ORDER BY Price;
-- Q13. Display products belonging to categories 10 or 50

SELECT Product_ID,
       Product_Name,
       Category_ID
FROM Product
WHERE Category_ID IN (10, 50)
ORDER BY Category_ID, Product_ID;
-- Q14. Display products whose names contain the word 'Smart'

SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Product_Name LIKE '%Smart%';
-- Q15. Display pending or confirmed orders

SELECT Order_ID,
       User_ID,
       Order_Status,
       Total_Amount
FROM Orders
WHERE Order_Status = 'PENDING'
   OR Order_Status = 'CONFIRMED'
ORDER BY Order_ID;
-- Q16. Display electronics products that cost less than 30000

SELECT Product_ID,
       Product_Name,
       Category_ID,
       Price
FROM Product
WHERE Category_ID = 10
  AND Price < 30000
ORDER BY Price;
-- Q17. Display the different order statuses

SELECT DISTINCT Order_Status
FROM Orders
ORDER BY Order_Status;
-- Q18. Temporarily update the price of product 207

SAVEPOINT Before_Product_Update;

UPDATE Product
SET Price = 999.00
WHERE Product_ID = 207;

SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Product_ID = 207;

ROLLBACK TO Before_Product_Update;

SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Product_ID = 207;
-- Q19. Temporarily delete review 705

SAVEPOINT Before_Review_Delete;

DELETE FROM Review
WHERE Review_ID = 705;

SELECT Review_ID,
       User_ID,
       Product_ID,
       Rating
FROM Review
WHERE Review_ID = 705;

ROLLBACK TO Before_Review_Delete;

SELECT Review_ID,
       User_ID,
       Product_ID,
       Rating
FROM Review
WHERE Review_ID = 705;
