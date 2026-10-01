-- Display all project tables
SELECT Table_Name
FROM User_Tables
WHERE Table_Name IN (
    'APP_USER',
    'CATEGORY',
    'PRODUCT',
    'CART',
    'ORDERS',
    'ORDER_ITEM',
    'PRODUCT_INTERACTION',
    'REVIEW'
)
ORDER BY Table_Name;

-- Display record count in each table
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

-- Display customer order summary
SELECT *
FROM Customer_Order_Summary
ORDER BY Total_Spent DESC;

-- Display product rating summary
SELECT *
FROM Product_Rating_View
ORDER BY Average_Rating DESC;

-- Display complete order details
SELECT *
FROM Order_Details_View
ORDER BY Order_ID;

-- Display recommended products
SELECT *
FROM Recommended_Product_View
ORDER BY Average_Rating DESC;

-- Display low stock products
SELECT Product_ID,
       Product_Name,
       Stock_Quantity
FROM Product
WHERE Stock_Quantity < 20
ORDER BY Stock_Quantity ASC;

-- Display PL/SQL object status
SELECT Object_Name,
       Object_Type,
       Status
FROM User_Objects
WHERE Object_Name IN (
    'SHOW_CUSTOMER_SPENDING',
    'GET_PRODUCT_AVERAGE_RATING',
    'SHOW_RECOMMENDED_PRODUCTS',
    'TRG_CART_UPDATE_DATE',
    'TRG_CHECK_PRODUCT_STOCK'
)
ORDER BY Object_Type, Object_Name;

-- Display PL/SQL object status
SELECT Object_Name,
       Object_Type,
       Status
FROM User_Objects
WHERE Object_Name IN (
    'SHOW_CUSTOMER_SPENDING',
    'GET_PRODUCT_AVERAGE_RATING',
    'SHOW_RECOMMENDED_PRODUCTS',
    'TRG_CART_UPDATE_DATE',
    'TRG_CHECK_PRODUCT_STOCK'
)
ORDER BY Object_Type, Object_Name;

-- Final project verification
SELECT 'Smart E-Commerce DBMS Project Completed Successfully' AS Project_Status
FROM Dual;
-- Display PL/SQL object status
SELECT Object_Name,
       Object_Type,
       Status
FROM User_Objects
WHERE Object_Name IN (
    'SHOW_CUSTOMER_SPENDING',
    'GET_PRODUCT_AVERAGE_RATING',
    'SHOW_RECOMMENDED_PRODUCTS',
    'GET_HYBRID_RECOMMENDATIONS',
    'TRG_CART_UPDATE_DATE',
    'TRG_CHECK_PRODUCT_STOCK'
)
ORDER BY Object_Type, Object_Name;
-- Test hybrid recommendation procedure
BEGIN
    Get_Hybrid_Recommendations(101);
END;
/