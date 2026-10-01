-- Create customer order summary view
CREATE OR REPLACE VIEW Customer_Order_Summary AS
SELECT U.User_ID,
       U.Name AS Customer_Name,
       U.Email,
       COUNT(O.Order_ID) AS Total_Orders,
       NVL(SUM(O.Total_Amount), 0) AS Total_Spent
FROM App_User U
LEFT JOIN Orders O
    ON U.User_ID = O.User_ID
WHERE U.Role = 'CUSTOMER'
GROUP BY U.User_ID, U.Name, U.Email;

-- View customer order summary
SELECT *
FROM Customer_Order_Summary
ORDER BY Total_Spent DESC;

-- Create product rating view
CREATE OR REPLACE VIEW Product_Rating_View AS
SELECT P.Product_ID,
       P.Product_Name,
       P.Brand,
       P.Price,
       ROUND(AVG(R.Rating), 2) AS Average_Rating,
       COUNT(R.Review_ID) AS Review_Count
FROM Product P
LEFT JOIN Review R
    ON P.Product_ID = R.Product_ID
GROUP BY P.Product_ID, P.Product_Name, P.Brand, P.Price;

-- View product rating summary
SELECT *
FROM Product_Rating_View
ORDER BY Average_Rating DESC;

-- Create order details view
CREATE OR REPLACE VIEW Order_Details_View AS
SELECT O.Order_ID,
       U.Name AS Customer_Name,
       P.Product_Name,
       OI.Quantity,
       OI.Unit_Price,
       O.Order_Status
FROM Orders O
JOIN App_User U
    ON O.User_ID = U.User_ID
JOIN Order_Item OI
    ON O.Order_ID = OI.Order_ID
JOIN Product P
    ON OI.Product_ID = P.Product_ID;

-- View complete order details
SELECT *
FROM Order_Details_View
ORDER BY Order_ID;

-- Create recommended product view
CREATE OR REPLACE VIEW Recommended_Product_View AS
SELECT P.Product_ID,
       P.Product_Name,
       P.Brand,
       P.Price,
       ROUND(AVG(R.Rating), 2) AS Average_Rating
FROM Product P
JOIN Review R
    ON P.Product_ID = R.Product_ID
GROUP BY P.Product_ID, P.Product_Name, P.Brand, P.Price
HAVING AVG(R.Rating) >= 4;

-- View recommended products
SELECT *
FROM Recommended_Product_View
ORDER BY Average_Rating DESC;

-- Create index on product category
CREATE INDEX idx_product_category
ON Product(Category_ID);

-- Create index on order user
CREATE INDEX idx_orders_user
ON Orders(User_ID);

-- Create index on review product
CREATE INDEX idx_review_product
ON Review(Product_ID);

-- Create index on interaction type
CREATE INDEX idx_interaction_type
ON Product_Interaction(Interaction_Type);

-- Display created views
SELECT View_Name
FROM User_Views
WHERE View_Name IN (
    'CUSTOMER_ORDER_SUMMARY',
    'PRODUCT_RATING_VIEW',
    'ORDER_DETAILS_VIEW',
    'RECOMMENDED_PRODUCT_VIEW'
)
ORDER BY View_Name;

-- Display created indexes
SELECT Index_Name,
       Table_Name
FROM User_Indexes
WHERE Index_Name IN (
    'IDX_PRODUCT_CATEGORY',
    'IDX_ORDERS_USER',
    'IDX_REVIEW_PRODUCT',
    'IDX_INTERACTION_TYPE'
)
ORDER BY Index_Name;
-- Count rows from each view
SELECT 'CUSTOMER_ORDER_SUMMARY' AS View_Name, COUNT(*) AS Row_Count
FROM Customer_Order_Summary
UNION ALL
SELECT 'PRODUCT_RATING_VIEW', COUNT(*)
FROM Product_Rating_View
UNION ALL
SELECT 'ORDER_DETAILS_VIEW', COUNT(*)
FROM Order_Details_View
UNION ALL
SELECT 'RECOMMENDED_PRODUCT_VIEW', COUNT(*)
FROM Recommended_Product_View;

