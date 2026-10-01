-- Display customer spending using procedure
CREATE OR REPLACE PROCEDURE Show_Customer_Spending (
    p_user_id IN NUMBER
)
AS
    v_customer_name App_User.Name%TYPE;
    v_total_spent NUMBER(10,2);
BEGIN
    SELECT U.Name,
           NVL(SUM(O.Total_Amount), 0)
    INTO v_customer_name,
         v_total_spent
    FROM App_User U
    LEFT JOIN Orders O
        ON U.User_ID = O.User_ID
    WHERE U.User_ID = p_user_id
    GROUP BY U.Name;

    DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_customer_name);
    DBMS_OUTPUT.PUT_LINE('Total Spent: ' || v_total_spent);
END;
/

-- Test customer spending procedure
BEGIN
    Show_Customer_Spending(101);
END;
/

-- Return product average rating
CREATE OR REPLACE FUNCTION Get_Product_Average_Rating (
    p_product_id IN NUMBER
)
RETURN NUMBER
AS
    v_average_rating NUMBER(3,2);
BEGIN
    SELECT NVL(ROUND(AVG(Rating), 2), 0)
    INTO v_average_rating
    FROM Review
    WHERE Product_ID = p_product_id;

    RETURN v_average_rating;
END;
/

-- Test product average rating function
SELECT Product_ID,
       Product_Name,
       Get_Product_Average_Rating(Product_ID) AS Average_Rating
FROM Product
ORDER BY Product_ID;

-- Update cart date automatically
CREATE OR REPLACE TRIGGER trg_cart_update_date
BEFORE UPDATE ON Cart
FOR EACH ROW
BEGIN
    :NEW.Updated_At := SYSDATE;
END;
/

-- Test cart update trigger
UPDATE Cart
SET Created_At = Created_At
WHERE Cart_ID = 301;

SELECT Cart_ID,
       Created_At,
       Updated_At
FROM Cart
WHERE Cart_ID = 301;

ROLLBACK;

-- Prevent negative product stock
CREATE OR REPLACE TRIGGER trg_check_product_stock
BEFORE INSERT OR UPDATE ON Product
FOR EACH ROW
BEGIN
    IF :NEW.Stock_Quantity < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Stock quantity cannot be negative');
    END IF;
END;
/

-- Test stock validation trigger
UPDATE Product
SET Stock_Quantity = -5
WHERE Product_ID = 201;
-- Restore product stock after test
ROLLBACK;
-- Display highly rated recommended products
CREATE OR REPLACE PROCEDURE Show_Recommended_Products
AS
BEGIN
    FOR rec IN (
        SELECT Product_ID,
               Product_Name,
               Average_Rating
        FROM Recommended_Product_View
        ORDER BY Average_Rating DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Product_ID || ' - ' ||
            rec.Product_Name || ' - Rating: ' ||
            rec.Average_Rating
        );
    END LOOP;
END;
/
-- Test recommendation procedure
BEGIN
    Show_Recommended_Products;
END;
/
-- Display created PL/SQL objects
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
-- Display hybrid product recommendations
CREATE OR REPLACE PROCEDURE Get_Hybrid_Recommendations (
    p_user_id IN NUMBER
)
AS
BEGIN
    FOR rec IN (
        SELECT P.Product_ID,
               P.Product_Name,
               P.Brand,
               P.Price,
               ROUND(
                   NVL(AVG(R.Rating), 0) * 2
                   + COUNT(PI.Interaction_ID),
                   2
               ) AS Hybrid_Score
        FROM Product P
        LEFT JOIN Review R
            ON P.Product_ID = R.Product_ID
        LEFT JOIN Product_Interaction PI
            ON P.Product_ID = PI.Product_ID
        WHERE P.Product_ID NOT IN (
            SELECT Product_ID
            FROM Product_Interaction
            WHERE User_ID = p_user_id
        )
        GROUP BY P.Product_ID, P.Product_Name, P.Brand, P.Price
        ORDER BY Hybrid_Score DESC
        FETCH FIRST 5 ROWS ONLY
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Product_ID || ' - ' ||
            rec.Product_Name || ' - Score: ' ||
            rec.Hybrid_Score
        );
    END LOOP;
END;
/
-- Test hybrid recommendation procedure
BEGIN
    Get_Hybrid_Recommendations(101);
END;
/
-- Display created PL/SQL objects
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
