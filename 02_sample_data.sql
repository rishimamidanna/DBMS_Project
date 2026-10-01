-- 1. INSERT SAMPLE USERS

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (101, 'Aarav Sharma', 'aarav@gmail.com',
     'hash_aarav_101', '9876500001', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (102, 'Diya Reddy', 'diya@gmail.com',
     'hash_diya_102', '9876500002', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (103, 'Arjun Kumar', 'arjun@gmail.com',
     'hash_arjun_103', '9876500003', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (104, 'Meera Patel', 'meera@gmail.com',
     'hash_meera_104', '9876500004', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (105, 'Rohan Singh', 'rohan@gmail.com',
     'hash_rohan_105', '9876500005', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (106, 'Ananya Rao', 'ananya@gmail.com',
     'hash_ananya_106', '9876500006', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (107, 'Vikram Das', 'vikram@gmail.com',
     'hash_vikram_107', '9876500007', 'CUSTOMER');

INSERT INTO App_User
    (User_ID, Name, Email, Password_Hash, Phone, Role)
VALUES
    (108, 'Admin User', 'admin@smartecommerce.com',
     'hash_admin_108', '9876500008', 'ADMIN');

COMMIT;

SELECT User_ID, Name, Email, Phone, Role
FROM App_User
ORDER BY User_ID;

-- 2. INSERT SAMPLE CATEGORIES

INSERT INTO Category
    (Category_ID, Category_Name, Description)
VALUES
    (10, 'Electronics', 'Electronic devices and accessories');

INSERT INTO Category
    (Category_ID, Category_Name, Description)
VALUES
    (20, 'Fashion', 'Clothing, footwear and fashion accessories');

INSERT INTO Category
    (Category_ID, Category_Name, Description)
VALUES
    (30, 'Home and Kitchen', 'Home appliances and kitchen products');

INSERT INTO Category
    (Category_ID, Category_Name, Description)
VALUES
    (40, 'Books', 'Educational, technical and general books');

INSERT INTO Category
    (Category_ID, Category_Name, Description)
VALUES
    (50, 'Sports', 'Sports equipment and fitness products');

COMMIT;

SELECT Category_ID, Category_Name, Description
FROM Category
ORDER BY Category_ID;

-- 3. INSERT SAMPLE PRODUCTS

INSERT INTO Product VALUES
(201, 'Smartphone X1', 10, 'NovaTech', 24999.00, 25,
 '5G smartphone with 128 GB storage');

INSERT INTO Product VALUES
(202, 'Wireless Headphones', 10, 'SoundMax', 2999.00, 40,
 'Bluetooth headphones with noise cancellation');

INSERT INTO Product VALUES
(203, 'Laptop Pro 14', 10, 'TechBook', 64999.00, 15,
 '14-inch laptop with 16 GB RAM');

INSERT INTO Product VALUES
(204, 'Mens Casual Shirt', 20, 'UrbanStyle', 1299.00, 50,
 'Cotton casual shirt for men');

INSERT INTO Product VALUES
(205, 'Womens Running Shoes', 20, 'ActiveWear', 2499.00, 35,
 'Lightweight running shoes for women');

INSERT INTO Product VALUES
(206, 'Mixer Grinder', 30, 'HomePro', 3499.00, 20,
 'Three-jar kitchen mixer grinder');

INSERT INTO Product VALUES
(207, 'LED Study Lamp', 30, 'BrightHome', 899.00, 45,
 'Rechargeable LED desk lamp');

INSERT INTO Product VALUES
(208, 'Database Management Systems', 40, 'TechPress', 799.00, 60,
 'Introductory textbook on database systems');

INSERT INTO Product VALUES
(209, 'Yoga Mat', 50, 'FitLife', 699.00, 55,
 'Non-slip exercise and yoga mat');

INSERT INTO Product VALUES
(210, 'Cricket Bat', 50, 'SportStar', 1999.00, 30,
 'English-willow practice cricket bat');

COMMIT;
SELECT Product_ID,
       Product_Name,
       Category_ID,
       Price,
       Stock_Quantity
FROM Product
ORDER BY Product_ID;

-- 4. INSERT SAMPLE CARTS

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (301, 101);

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (302, 102);

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (303, 103);

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (304, 104);

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (305, 105);

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (306, 106);

INSERT INTO Cart (Cart_ID, User_ID)
VALUES (307, 107);

COMMIT;
SELECT Cart_ID,
       User_ID,
       Created_At,
       Updated_At
FROM Cart
ORDER BY Cart_ID;

-- 5. INSERT SAMPLE ORDERS

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (401, 101, DATE '2026-09-01', 27998.00, 'DELIVERED');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (402, 102, DATE '2026-09-03', 3798.00, 'DELIVERED');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (403, 103, DATE '2026-09-05', 65798.00, 'SHIPPED');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (404, 104, DATE '2026-09-07', 4398.00, 'CONFIRMED');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (405, 105, DATE '2026-09-10', 3397.00, 'DELIVERED');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (406, 101, DATE '2026-09-12', 799.00, 'DELIVERED');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (407, 106, DATE '2026-09-15', 5998.00, 'PENDING');

INSERT INTO Orders
    (Order_ID, User_ID, Order_Date, Total_Amount, Order_Status)
VALUES
    (408, 107, DATE '2026-09-18', 24999.00, 'CONFIRMED');

COMMIT;
SELECT Order_ID,
       User_ID,
       Order_Date,
       Total_Amount,
       Order_Status
FROM Orders
ORDER BY Order_ID;

-- 6. INSERT SAMPLE ORDER ITEMS

INSERT INTO Order_Item VALUES
(501, 401, 201, 1, 24999.00);

INSERT INTO Order_Item VALUES
(502, 401, 202, 1, 2999.00);

INSERT INTO Order_Item VALUES
(503, 402, 205, 1, 2499.00);

INSERT INTO Order_Item VALUES
(504, 402, 204, 1, 1299.00);

INSERT INTO Order_Item VALUES
(505, 403, 203, 1, 64999.00);

INSERT INTO Order_Item VALUES
(506, 403, 208, 1, 799.00);

INSERT INTO Order_Item VALUES
(507, 404, 206, 1, 3499.00);

INSERT INTO Order_Item VALUES
(508, 404, 207, 1, 899.00);

INSERT INTO Order_Item VALUES
(509, 405, 210, 1, 1999.00);

INSERT INTO Order_Item VALUES
(510, 405, 209, 2, 699.00);

INSERT INTO Order_Item VALUES
(511, 406, 208, 1, 799.00);

INSERT INTO Order_Item VALUES
(512, 407, 202, 2, 2999.00);

INSERT INTO Order_Item VALUES
(513, 408, 201, 1, 24999.00);

COMMIT;
SELECT Order_Item_ID,
       Order_ID,
       Product_ID,
       Quantity,
       Unit_Price,
       Quantity * Unit_Price AS Item_Total
FROM Order_Item
ORDER BY Order_Item_ID;


-- 7. INSERT SAMPLE PRODUCT INTERACTIONS

INSERT INTO Product_Interaction VALUES
(601, 101, 201, 'VIEW', DATE '2026-08-28');

INSERT INTO Product_Interaction VALUES
(602, 101, 201, 'PURCHASE', DATE '2026-09-01');

INSERT INTO Product_Interaction VALUES
(603, 101, 202, 'PURCHASE', DATE '2026-09-01');

INSERT INTO Product_Interaction VALUES
(604, 101, 208, 'PURCHASE', DATE '2026-09-12');

INSERT INTO Product_Interaction VALUES
(605, 101, 203, 'WISHLIST', DATE '2026-09-20');

INSERT INTO Product_Interaction VALUES
(606, 102, 205, 'VIEW', DATE '2026-09-02');

INSERT INTO Product_Interaction VALUES
(607, 102, 205, 'PURCHASE', DATE '2026-09-03');

INSERT INTO Product_Interaction VALUES
(608, 102, 204, 'PURCHASE', DATE '2026-09-03');

INSERT INTO Product_Interaction VALUES
(609, 102, 209, 'WISHLIST', DATE '2026-09-21');

INSERT INTO Product_Interaction VALUES
(610, 103, 203, 'PURCHASE', DATE '2026-09-05');

INSERT INTO Product_Interaction VALUES
(611, 103, 208, 'PURCHASE', DATE '2026-09-05');

INSERT INTO Product_Interaction VALUES
(612, 103, 202, 'CART', DATE '2026-09-22');

INSERT INTO Product_Interaction VALUES
(613, 104, 206, 'PURCHASE', DATE '2026-09-07');

INSERT INTO Product_Interaction VALUES
(614, 104, 207, 'PURCHASE', DATE '2026-09-07');

INSERT INTO Product_Interaction VALUES
(615, 104, 209, 'VIEW', DATE '2026-09-23');

INSERT INTO Product_Interaction VALUES
(616, 105, 210, 'PURCHASE', DATE '2026-09-10');

INSERT INTO Product_Interaction VALUES
(617, 105, 209, 'PURCHASE', DATE '2026-09-10');

INSERT INTO Product_Interaction VALUES
(618, 105, 205, 'VIEW', DATE '2026-09-24');

INSERT INTO Product_Interaction VALUES
(619, 106, 202, 'CART', DATE '2026-09-15');

INSERT INTO Product_Interaction VALUES
(620, 106, 203, 'VIEW', DATE '2026-09-25');

INSERT INTO Product_Interaction VALUES
(621, 107, 201, 'CART', DATE '2026-09-18');

INSERT INTO Product_Interaction VALUES
(622, 107, 202, 'WISHLIST', DATE '2026-09-26');

COMMIT;
SELECT Interaction_ID,
       User_ID,
       Product_ID,
       Interaction_Type,
       Interaction_Date
FROM Product_Interaction
ORDER BY Interaction_ID;

-- 8. INSERT SAMPLE REVIEWS

INSERT INTO Review VALUES
(701, 101, 201, 5, 'Excellent phone with good performance',
 DATE '2026-09-08');

INSERT INTO Review VALUES
(702, 101, 202, 4, 'Good sound quality and comfortable design',
 DATE '2026-09-08');

INSERT INTO Review VALUES
(703, 101, 208, 5, 'Very useful book for learning DBMS concepts',
 DATE '2026-09-18');

INSERT INTO Review VALUES
(704, 102, 205, 4, 'Comfortable shoes suitable for daily running',
 DATE '2026-09-10');

INSERT INTO Review VALUES
(705, 102, 204, 3, 'Good shirt but the size was slightly large',
 DATE '2026-09-10');

INSERT INTO Review VALUES
(706, 105, 210, 4, 'Good cricket bat for practice sessions',
 DATE '2026-09-16');

INSERT INTO Review VALUES
(707, 105, 209, 5, 'The mat has a good grip and is easy to carry',
 DATE '2026-09-16');

COMMIT;

SELECT Review_ID,
       User_ID,
       Product_ID,
       Rating,
       Review_Comment,
       Review_Date
FROM Review
ORDER BY Review_ID;

SELECT 'APP_USER' AS Table_Name, COUNT(*) AS Record_Count
FROM App_User
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