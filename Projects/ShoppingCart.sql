CREATE TABLE ProductsMenu (
    Id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Cart (
    ProductId INT PRIMARY KEY,
    Qty INT,
    FOREIGN KEY (ProductId) REFERENCES ProductsMenu(Id)
);

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    Username VARCHAR(50)
);

CREATE TABLE OrderHeader (
    OrderID INT PRIMARY KEY,
    User_ID INT,
    Orderdate DATETIME,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE OrderDetails (
    OrderHeaderID INT,
    ProdID INT,
    Qty INT,
    PRIMARY KEY (OrderHeaderID, ProdID),
    FOREIGN KEY (OrderHeaderID) REFERENCES OrderHeader(OrderID),
    FOREIGN KEY (ProdID) REFERENCES ProductsMenu(Id)
);

-- Check if Coke exists in the cart; if yes, update the quantity, otherwise insert
IF EXISTS (SELECT * FROM Cart WHERE ProductId = 1)
BEGIN
    UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = 1;
END
ELSE
BEGIN
    INSERT INTO Cart (ProductId, Qty) VALUES (1, 1);
END;

-- Check if Chips exists in the cart; if yes, update the quantity, otherwise insert
IF EXISTS (SELECT * FROM Cart WHERE ProductId = 2)
BEGIN
    UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = 2;
END
ELSE
BEGIN
    INSERT INTO Cart (ProductId, Qty) VALUES (2, 1);
END;

-- Check cart contents
SELECT * FROM Cart;


-- Check if Coke exists and its quantity
IF EXISTS (SELECT * FROM Cart WHERE ProductId = 1 AND Qty > 1)
BEGIN
    UPDATE Cart SET Qty = Qty - 1 WHERE ProductId = 1;
END
ELSE
BEGIN
    DELETE FROM Cart WHERE ProductId = 1;
END;

-- Check cart contents
SELECT * FROM Cart;


-- Insert a new order into the OrderHeader table
INSERT INTO OrderHeader (User_ID, Orderdate)
VALUES (1, GETDATE());

-- Get the OrderID of the last inserted order
DECLARE @OrderID INT = SCOPE_IDENTITY();


-- Insert cart contents into OrderDetails
INSERT INTO OrderDetails (OrderHeaderID, ProdID, Qty)
SELECT @OrderID, ProductId, Qty FROM Cart;

-- Clear the cart after checkout
DELETE FROM Cart;

-- Check OrderDetails
SELECT * FROM OrderDetails WHERE OrderHeaderID = @OrderID;


-- Adding products to cart
INSERT INTO Cart (ProductId, Qty) VALUES (1, 2); -- Coke
INSERT INTO Cart (ProductId, Qty) VALUES (2, 1); -- Chips

-- Verify the insert
SELECT * FROM Cart;


-- Remove Coke from the cart
DELETE FROM Cart WHERE ProductId = 1;

-- Verify the delete
SELECT * FROM Cart;


-- Creating first order
INSERT INTO OrderHeader (User_ID, Orderdate) VALUES (2, GETDATE());
DECLARE @FirstOrderID INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (OrderHeaderID, ProdID, Qty) SELECT @FirstOrderID, ProductId, Qty FROM Cart;
DELETE FROM Cart;

-- Creating second order
INSERT INTO OrderHeader (User_ID, Orderdate) VALUES (1, GETDATE());
DECLARE @SecondOrderID INT = SCOPE_IDENTITY();
INSERT INTO OrderDetails (OrderHeaderID, ProdID, Qty) SELECT @SecondOrderID, ProductId, Qty FROM Cart;
DELETE FROM Cart;

-- View all orders
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;


-- Print details of the first order
SELECT OH.OrderID, OH.Orderdate, U.Username, PM.name, OD.Qty
FROM OrderHeader OH
JOIN Users U ON OH.User_ID = U.User_ID
JOIN OrderDetails OD ON OH.OrderID = OD.OrderHeaderID
JOIN ProductsMenu PM ON OD.ProdID = PM.Id
WHERE OH.OrderID = @FirstOrderID;


-- Print all orders for today
SELECT OH.OrderID, OH.Orderdate, U.Username, PM.name, OD.Qty
FROM OrderHeader OH
JOIN Users U ON OH.User_ID = U.User_ID
JOIN OrderDetails OD ON OH.OrderID = OD.OrderHeaderID
JOIN ProductsMenu PM ON OD.ProdID = PM.Id
WHERE CAST(OH.Orderdate AS DATE) = CAST(GETDATE() AS DATE);


-- Function to add an item to the cart
CREATE FUNCTION dbo.AddItemToCart (@ProductId INT)
RETURNS VOID
AS
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = @ProductId)
    BEGIN
        UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = @ProductId;
    END
    ELSE
    BEGIN
        INSERT INTO Cart (ProductId, Qty) VALUES (@ProductId, 1);
    END;
END;

-- Function to remove an item from the cart
CREATE FUNCTION dbo.RemoveItemFromCart (@ProductId INT)
RETURNS VOID
AS
BEGIN
    IF EXISTS (SELECT * FROM Cart WHERE ProductId = @ProductId AND Qty > 1)
    BEGIN
        UPDATE Cart SET Qty = Qty - 1 WHERE ProductId = @ProductId;
    END
    ELSE
    BEGIN
        DELETE FROM Cart WHERE ProductId = @ProductId;
    END;
END;
