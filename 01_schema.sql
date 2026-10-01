CREATE TABLE App_User (
    User_ID INTEGER PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Role VARCHAR(20) DEFAULT 'CUSTOMER' NOT NULL,
    CONSTRAINT CHK_User_Role
        CHECK (Role IN ('CUSTOMER', 'ADMIN'))
);
DESC App_User;

CREATE TABLE Category (
    Category_ID INTEGER PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);
DESC Category;
CREATE TABLE Product (
    Product_ID INTEGER PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Category_ID INTEGER NOT NULL,
    Brand VARCHAR(100),
    Price NUMBER(10,2) NOT NULL,
    Stock_Quantity INTEGER DEFAULT 0 NOT NULL,
    Description VARCHAR(255),

    CONSTRAINT CHK_Product_Price
        CHECK (Price >= 0),

    CONSTRAINT CHK_Product_Stock
        CHECK (Stock_Quantity >= 0),

    CONSTRAINT FK_Product_Category
        FOREIGN KEY (Category_ID)
        REFERENCES Category(Category_ID)
);
DESC Product;
CREATE TABLE Cart (
    Cart_ID INTEGER PRIMARY KEY,
    User_ID INTEGER NOT NULL UNIQUE,
    Created_At DATE DEFAULT SYSDATE NOT NULL,
    Updated_At DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT FK_Cart_User
        FOREIGN KEY (User_ID)
        REFERENCES App_User(User_ID)
);
DESC Cart;

CREATE TABLE Orders (
    Order_ID INTEGER PRIMARY KEY,
    User_ID INTEGER NOT NULL,
    Order_Date DATE DEFAULT SYSDATE NOT NULL,
    Total_Amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    Order_Status VARCHAR(30) DEFAULT 'PENDING' NOT NULL,

    CONSTRAINT CHK_Order_Total
        CHECK (Total_Amount >= 0),

    CONSTRAINT CHK_Order_Status
        CHECK (
            Order_Status IN (
                'PENDING',
                'CONFIRMED',
                'SHIPPED',
                'DELIVERED',
                'CANCELLED'
            )
        ),

    CONSTRAINT FK_Order_User
        FOREIGN KEY (User_ID)
        REFERENCES App_User(User_ID)
);
DESC Orders;

CREATE TABLE Order_Item (
    Order_Item_ID INTEGER PRIMARY KEY,
    Order_ID INTEGER NOT NULL,
    Product_ID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    Unit_Price NUMBER(10,2) NOT NULL,

    CONSTRAINT CHK_Order_Item_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CHK_Order_Item_Price
        CHECK (Unit_Price >= 0),

    CONSTRAINT UQ_Order_Product
        UNIQUE (Order_ID, Product_ID),

    CONSTRAINT FK_Order_Item_Order
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),

    CONSTRAINT FK_Order_Item_Product
        FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
);
DESC Order_Item;
CREATE TABLE Product_Interaction (
    Interaction_ID INTEGER PRIMARY KEY,
    User_ID INTEGER NOT NULL,
    Product_ID INTEGER NOT NULL,
    Interaction_Type VARCHAR(30) NOT NULL,
    Interaction_Date DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT CHK_Interaction_Type
        CHECK (
            Interaction_Type IN (
                'VIEW',
                'CART',
                'WISHLIST',
                'PURCHASE'
            )
        ),

    CONSTRAINT FK_Interaction_User
        FOREIGN KEY (User_ID)
        REFERENCES App_User(User_ID),

    CONSTRAINT FK_Interaction_Product
        FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
);
DESC Product_Interaction;

CREATE TABLE Review (
    Review_ID INTEGER PRIMARY KEY,
    User_ID INTEGER NOT NULL,
    Product_ID INTEGER NOT NULL,
    Rating INTEGER NOT NULL,
    Review_Comment VARCHAR(500),
    Review_Date DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT CHK_Review_Rating
        CHECK (Rating BETWEEN 1 AND 5),

    CONSTRAINT UQ_User_Product_Review
        UNIQUE (User_ID, Product_ID),

    CONSTRAINT FK_Review_User
        FOREIGN KEY (User_ID)
        REFERENCES App_User(User_ID),

    CONSTRAINT FK_Review_Product
        FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
);
DESC Review;

SELECT Table_Name
FROM User_Tables
ORDER BY Table_Name;
SELECT Table_Name,
       Constraint_Name,
       Constraint_Type
FROM User_Constraints
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
ORDER BY Table_Name, Constraint_Type;