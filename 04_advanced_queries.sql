-- Display orders with customer names

SELECT O.Order_ID,
       U.Name AS Customer_Name,
       O.Order_Date,
       O.Total_Amount,
       O.Order_Status
FROM Orders O
JOIN App_User U
    ON O.User_ID = U.User_ID
ORDER BY O.Order_ID;

-- Display products with category names

SELECT P.Product_ID,
       P.Product_Name,
       C.Category_Name,
       P.Brand,
       P.Price
FROM Product P
JOIN Category C
    ON P.Category_ID = C.Category_ID
ORDER BY C.Category_Name, P.Product_Name;

-- Display complete order-item details

SELECT O.Order_ID,
       U.Name AS Customer_Name,
       P.Product_Name,
       OI.Quantity,
       OI.Unit_Price,
       OI.Quantity * OI.Unit_Price AS Item_Total
FROM Orders O
JOIN App_User U
    ON O.User_ID = U.User_ID
JOIN Order_Item OI
    ON O.Order_ID = OI.Order_ID
JOIN Product P
    ON OI.Product_ID = P.Product_ID
ORDER BY O.Order_ID, P.Product_Name;

-- Display reviews with user and product names

SELECT R.Review_ID,
       U.Name AS Customer_Name,
       P.Product_Name,
       R.Rating,
       R.Review_Comment,
       R.Review_Date
FROM Review R
JOIN App_User U
    ON R.User_ID = U.User_ID
JOIN Product P
    ON R.Product_ID = P.Product_ID
ORDER BY R.Review_ID;

-- Display products with average ratings

SELECT P.Product_ID,
       P.Product_Name,
       ROUND(AVG(R.Rating), 2) AS Average_Rating,
       COUNT(R.Review_ID) AS Review_Count
FROM Product P
LEFT JOIN Review R
    ON P.Product_ID = R.Product_ID
GROUP BY P.Product_ID, P.Product_Name
ORDER BY P.Product_ID;
-- Display products without reviews

SELECT P.Product_ID,
       P.Product_Name
FROM Product P
LEFT JOIN Review R
    ON P.Product_ID = R.Product_ID
WHERE R.Review_ID IS NULL
ORDER BY P.Product_ID;
-- Display total spent by each customer
SELECT U.User_ID,
       U.Name AS Customer_Name,
       NVL(SUM(O.Total_Amount), 0) AS Total_Spent
FROM App_User U
LEFT JOIN Orders O
    ON U.User_ID = O.User_ID
WHERE U.Role = 'CUSTOMER'
GROUP BY U.User_ID, U.Name
ORDER BY Total_Spent DESC;

-- Display total quantity sold for each product
SELECT P.Product_ID,
       P.Product_Name,
       NVL(SUM(OI.Quantity), 0) AS Total_Quantity_Sold
FROM Product P
LEFT JOIN Order_Item OI
    ON P.Product_ID = OI.Product_ID
GROUP BY P.Product_ID, P.Product_Name
ORDER BY Total_Quantity_Sold DESC;
-- Display products priced above average
SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Price > (
    SELECT AVG(Price)
    FROM Product
)
ORDER BY Price DESC;

-- Display customers who placed orders
SELECT User_ID,
       Name,
       Email
FROM App_User
WHERE User_ID IN (
    SELECT User_ID
    FROM Orders
)
ORDER BY User_ID;

-- Display customers without orders
SELECT User_ID,
       Name,
       Email
FROM App_User
WHERE Role = 'CUSTOMER'
AND User_ID NOT IN (
    SELECT User_ID
    FROM Orders
)
ORDER BY User_ID;

-- Display products never purchased
SELECT Product_ID,
       Product_Name,
       Price
FROM Product
WHERE Product_ID NOT IN (
    SELECT Product_ID
    FROM Order_Item
)
ORDER BY Product_ID;
-- Display highest order value
SELECT Order_ID,
       User_ID,
       Total_Amount,
       Order_Status
FROM Orders
WHERE Total_Amount = (
    SELECT MAX(Total_Amount)
    FROM Orders
);
-- Display products with rating above average
SELECT P.Product_ID,
       P.Product_Name,
       AVG(R.Rating) AS Average_Rating
FROM Product P
JOIN Review R
    ON P.Product_ID = R.Product_ID
GROUP BY P.Product_ID, P.Product_Name
HAVING AVG(R.Rating) > (
    SELECT AVG(Rating)
    FROM Review
)
ORDER BY Average_Rating DESC;

-- Display customer purchase count
SELECT U.User_ID,
       U.Name AS Customer_Name,
       COUNT(O.Order_ID) AS Total_Orders
FROM App_User U
LEFT JOIN Orders O
    ON U.User_ID = O.User_ID
WHERE U.Role = 'CUSTOMER'
GROUP BY U.User_ID, U.Name
ORDER BY Total_Orders DESC;

-- Display users who reviewed products
SELECT User_ID,
       Name
FROM App_User
WHERE User_ID IN (
    SELECT User_ID
    FROM Review
)
ORDER BY User_ID;

-- Display products viewed or purchased
SELECT Product_ID
FROM Product_Interaction
WHERE Interaction_Type = 'VIEW'
UNION
SELECT Product_ID
FROM Product_Interaction
WHERE Interaction_Type = 'PURCHASE'
ORDER BY Product_ID;

-- Display products both viewed and purchased
SELECT Product_ID
FROM Product_Interaction
WHERE Interaction_Type = 'VIEW'
INTERSECT
SELECT Product_ID
FROM Product_Interaction
WHERE Interaction_Type = 'PURCHASE'
ORDER BY Product_ID;

-- Display viewed products not purchased
SELECT Product_ID
FROM Product_Interaction
WHERE Interaction_Type = 'VIEW'
MINUS
SELECT Product_ID
FROM Product_Interaction
WHERE Interaction_Type = 'PURCHASE'
ORDER BY Product_ID;

-- Display order status labels
SELECT Order_ID,
       Total_Amount,
       Order_Status,
       CASE
           WHEN Order_Status = 'DELIVERED' THEN 'Completed Order'
           WHEN Order_Status = 'CANCELLED' THEN 'Cancelled Order'
           ELSE 'Active Order'
       END AS Status_Label
FROM Orders
ORDER BY Order_ID;
-- Display price category for products
SELECT Product_ID,
       Product_Name,
       Price,
       CASE
           WHEN Price >= 50000 THEN 'High Price'
           WHEN Price >= 10000 THEN 'Medium Price'
           ELSE 'Low Price'
       END AS Price_Category
FROM Product
ORDER BY Price DESC;
-- Display top 5 expensive products
SELECT Product_ID,
       Product_Name,
       Price
FROM Product
ORDER BY Price DESC
FETCH FIRST 5 ROWS ONLY;
-- Display top 3 customers by spending
SELECT U.User_ID,
       U.Name AS Customer_Name,
       SUM(O.Total_Amount) AS Total_Spent
FROM App_User U
JOIN Orders O
    ON U.User_ID = O.User_ID
GROUP BY U.User_ID, U.Name
ORDER BY Total_Spent DESC
FETCH FIRST 3 ROWS ONLY;
-- Display recommended products by rating
SELECT P.Product_ID,
       P.Product_Name,
       ROUND(AVG(R.Rating), 2) AS Average_Rating
FROM Product P
JOIN Review R
    ON P.Product_ID = R.Product_ID
GROUP BY P.Product_ID, P.Product_Name
HAVING AVG(R.Rating) >= 4
ORDER BY Average_Rating DESC;
-- Display recommendation using user interests
SELECT DISTINCT P.Product_ID,
       P.Product_Name,
       P.Brand,
       P.Price
FROM Product P
JOIN Product_Interaction PI
    ON P.Product_ID = PI.Product_ID
WHERE PI.Interaction_Type IN ('VIEW', 'CART', 'WISHLIST')
ORDER BY P.Product_ID;

-- Display products in same category as purchased products
SELECT DISTINCT P2.Product_ID,
       P2.Product_Name,
       P2.Category_ID,
       P2.Price
FROM Product P1
JOIN Order_Item OI
    ON P1.Product_ID = OI.Product_ID
JOIN Product P2
    ON P1.Category_ID = P2.Category_ID
WHERE P2.Product_ID <> P1.Product_ID
ORDER BY P2.Category_ID, P2.Product_ID;
-- Display recommendation from viewed category
SELECT DISTINCT P.Product_ID,
       P.Product_Name,
       P.Category_ID,
       P.Price
FROM Product P
WHERE P.Category_ID IN (
    SELECT P2.Category_ID
    FROM Product P2
    JOIN Product_Interaction PI
        ON P2.Product_ID = PI.Product_ID
    WHERE PI.Interaction_Type = 'VIEW'
)
ORDER BY P.Category_ID, P.Product_ID;
-- Display low stock products
SELECT Product_ID,
       Product_Name,
       Stock_Quantity
FROM Product
WHERE Stock_Quantity < 20
ORDER BY Stock_Quantity ASC;
-- Display final record count
SELECT 'APP_USER' AS Table_Name, COUNT(*) AS Record_Count FROM App_User
UNION ALL
SELECT 'CATEGORY', COUNT(*) FROM Category
UNION ALL
SELECT 'PRODUCT', COUNT(*) FROM Product
UNION ALL
SELECT 'CART', COUNT(*) FROM Cart
UNION ALL
SELECT 'ORDERS', COUNT(*) FROM Orders
UNION ALL
SELECT 'ORDER_ITEM', COUNT(*) FROM Order_Item
UNION ALL
SELECT 'PRODUCT_INTERACTION', COUNT(*) FROM Product_Interaction
UNION ALL
SELECT 'REVIEW', COUNT(*) FROM Review;