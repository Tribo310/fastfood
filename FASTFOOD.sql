CREATE DATABASE FastFoodDB;
USE FastFoodDB;

-- FoodStorage table
CREATE TABLE IF NOT EXISTS FoodStorage (
    StorageID INT PRIMARY KEY AUTO_INCREMENT,
    Location VARCHAR(100) NOT NULL
);

-- Product table
CREATE TABLE IF NOT EXISTS Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    ExpirationDate DATE
);

-- Junction table for the many-to-many relationship
CREATE TABLE IF NOT EXISTS ProductStorage (
    ProductID INT,
    StorageID INT,
    QuantityStored INT,  -- Quantity of the product in the specific storage location
    PRIMARY KEY (ProductID, StorageID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (StorageID) REFERENCES FoodStorage(StorageID)
);

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Balance DECIMAL(10, 2) DEFAULT 0.00
);


-- Restaurants table
CREATE TABLE IF NOT EXISTS Restaurants (
    RestaurantID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    StorageID INT,
    FOREIGN KEY (StorageID) REFERENCES FoodStorage(StorageID)
);

-- Employees table
CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- WorkedDay table
CREATE TABLE IF NOT EXISTS WorkedDay (
    WorkedID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    Start_Time DATETIME NOT NULL,
    End_Time DATETIME NOT NULL,
    Duration DECIMAL(5,2) GENERATED ALWAYS AS (TIMESTAMPDIFF(MINUTE, Start_Time, End_Time) / 60) STORED,
    Salary DECIMAL(10,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Calendar table
CREATE TABLE IF NOT EXISTS Calendar (
    CalendarID INT PRIMARY KEY AUTO_INCREMENT,
    WorkedID INT NOT NULL,
    FOREIGN KEY (WorkedID) REFERENCES WorkedDay(WorkedID)
);

-- MenuItems table
CREATE TABLE IF NOT EXISTS MenuItems (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(5, 2) NOT NULL,
    RestaurantID INT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Orders table
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(7, 2) NOT NULL,
    RestaurantID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- OrderDetails table
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- MenuItemProducts table
CREATE TABLE IF NOT EXISTS MenuItemProducts (
    ItemID INT,
    ProductID INT,
    PRIMARY KEY (ItemID, ProductID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

ALTER TABLE MenuItems ADD COLUMN FoodStorageID INT;
ALTER TABLE MenuItems 
ADD CONSTRAINT fk_foodstorage
FOREIGN KEY (FoodStorageID) REFERENCES FoodStorage(StorageID);




CREATE TABLE IF NOT EXISTS TransactionLog (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10, 2),
    TransactionType ENUM('Purchase', 'Refund') NOT NULL,
    OrderID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
INSERT INTO FoodStorage (Location) VALUES
('Main Storage'),
('Cold Storage'),
('Dry Goods Storage'),
('Meat Locker'),
('Beverage Storage'),
('Ice Cream Section'),
('Vegetable Storage'),
('Frozen Foods Section'),
('Bakery Section'),
('Seafood Section');

-- Insert into Product table
INSERT INTO Product (ProductID, Name, Quantity, ExpirationDate) VALUES
(1, 'Burger Ingredients', 100, '2024-12-10'),
(2, 'Pizza Ingredients', 200, '2024-12-15'),
(3, 'Sushi Ingredients', 150, '2025-01-05'),
(4, 'Chicken Wings', 250, '2024-12-20'),
(5, 'French Fries', 500, '2024-11-30'),
(6, 'Soft Drink Syrup', 300, '2025-06-01'),
(7, 'Ice Cream Mix', 120, '2025-03-15'),
(8, 'Vegetable Mix', 400, '2024-12-01'),
(9, 'Bread Rolls', 350, '2024-12-05'),
(10, 'Frozen Fish Fillets', 180, '2025-01-20');




-- Insert into ProductStorage to connect products to storage locations
INSERT IGNORE INTO ProductStorage (ProductID, StorageID, QuantityStored) VALUES
(1, 1, 50),  
(1, 2, 50),  
(2, 1, 100),
(3, 3, 100),
(4, 1, 150),
(5, 4, 200),
(6, 2, 120),
(7, 6, 80),
(8, 7, 300),
(9, 8, 180);

INSERT INTO Restaurants (Name, Location, StorageID) VALUES
('Burger Shack', '123 Burger Lane', 1),
('Pizza Palace', '456 Pizza Street', 2),
('Sushi World', '789 Sushi Plaza', 3),
('Taco Town', '321 Taco Avenue', 4),
('Pasta House', '654 Pasta Road', 5),
('BBQ Barn', '987 BBQ Boulevard', 6),
('Salad Central', '741 Salad Square', 7),
('Bakery Bliss', '852 Bakery Circle', 8),
('Seafood Spot', '963 Seafood Drive', 9),
('Ice Cream Island', '159 Ice Cream Street', 10);

-- Insert into MenuItems table

INSERT INTO MenuItems (ItemID, ItemName, Category, Price, RestaurantID, FoodStorageID) VALUES
(1, 'Cheeseburger', 'Main Course', 5.99, 1, 1),
(2, 'Pepperoni Pizza', 'Main Course', 8.99, 2, 2),
(3, 'California Roll', 'Sushi', 10.99, 3, 3),
(4, 'Fish Tacos', 'Main Course', 7.99, 4, 4),
(5, 'Spaghetti', 'Pasta', 6.99, 5, 5),
(6, 'BBQ Ribs', 'BBQ', 12.99, 6, 6),
(7, 'Caesar Salad', 'Salad', 4.99, 7, 7),
(8, 'Croissant', 'Bakery', 3.99, 8, 8),
(9, 'Grilled Salmon', 'Main Course', 14.99, 9, 9),
(10, 'Chocolate Sundae', 'Dessert', 5.49, 10, 10);




INSERT INTO MenuItemProducts (ItemID, ProductID) VALUES
(1, 1),  -- Cheeseburger uses Burger Ingredients
(1, 5),  -- Cheeseburger uses French Fries
(2, 2),  -- Pepperoni Pizza uses Pizza Ingredients
(2, 5),  -- Pepperoni Pizza uses French Fries
(3, 3),  -- California Roll uses Sushi Ingredients
(4, 9),  -- Fish Tacos uses Frozen Fish Fillets
(4, 8),  -- Fish Tacos uses Vegetable Mix
(5, 4),  -- Spaghetti uses Chicken Wings (assuming a mistake; check ingredient)
(6, 4),  -- BBQ Ribs uses Chicken Wings
(7, 8),  -- Caesar Salad uses Vegetable Mix
(8, 9),  -- Croissant uses Bread Rolls
(9, 9),  -- Grilled Salmon uses Frozen Fish Fillets
(10, 7), -- Chocolate Sundae uses Ice Cream Mix
(10, 6); -- Chocolate Sundae uses Soft Drink Syrup


-- Insert customers
INSERT INTO Customers (Name, Phone, Email) VALUES
('Alice Johnson', '555-1234', 'alice.johnson@example.com'),
('Bob Smith', '555-5678', 'bob.smith@example.com'),
('Charlie Brown', '555-8765', 'charlie.brown@example.com'),
('Diana Prince', '555-9876', 'diana.prince@example.com'),
('Ethan Hunt', '555-2345', 'ethan.hunt@example.com'),
('Fiona Gallagher', '555-3456', 'fiona.gallagher@example.com'),
('George Martin', '555-4567', 'george.martin@example.com'),
('Helen Keller', '555-5679', 'helen.keller@example.com'),
('Ian Curtis', '555-6780', 'ian.curtis@example.com'),
('Jane Austen', '555-7890', 'jane.austen@example.com');


-- Insert orders
INSERT INTO Orders (CustomerID, TotalAmount, RestaurantID) VALUES
(1, 25.99, 1),
(2, 15.99, 2),
(3, 30.99, 3),
(4, 22.99, 4),
(5, 19.99, 5),
(6, 28.99, 6),
(7, 18.99, 7),
(8, 12.99, 8),  -- Fixed missing closing parenthesis and wrong restaurant ID
(9, 35.99, 9),
(10, 13.99, 10);


-- Insert order details
INSERT INTO OrderDetails (OrderID, ItemID, Quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 3),
(3, 4, 2),
(4, 5, 1),
(5, 6, 2),
(6, 7, 1),
(7, 8, 3),
(8, 9, 2),
(9, 10, 1);

INSERT INTO Product (Name, Quantity, ExpirationDate) VALUES
('Pasta Ingredients', 120, '2025-03-10'),
('Taco Shells', 200, '2024-12-18'),
('BBQ Sauce', 150, '2025-04-01'),
('Salad Dressing', 300, '2025-05-12'),
('Bakery Flour', 400, '2025-02-28'),
('Seafood Mix', 100, '2025-01-10'),
('Ice Cream Toppings', 250, '2025-07-15');

INSERT INTO ProductStorage (ProductID, StorageID, QuantityStored) VALUES
(11, 3, 60),  
(12, 4, 100),  
(13, 5, 80),
(14, 6, 150),
(15, 7, 120),
(16, 8, 90),
(17, 9, 110);

SET SQL_SAFE_UPDATES = 0;

DELETE FROM Customers;

INSERT INTO Customers (CustomerID, Name, Balance) VALUES
(11, 'John Doe', 100.00),  -- Customer with an initial balance of 100.00
(12, 'Jane Smith', 50.00), -- Customer with an initial balance of 50.00
(13, 'David Lee', 75.00),  -- Customer with an initial balance of 75.00
(14, 'Alice Brown', 120.00),
(15, 'Bob White', 60.00),
(16, 'Charlie Green', 80.00),
(17, 'Eve Black', 95.00),
(18, 'Frank Gray', 110.00),
(19, 'Grace Blue', 90.00),
(20, 'Hank Red', 130.00);




INSERT INTO Employees (Name, Position, RestaurantID) VALUES
('John Williams', 'Manager', 1),
('Sophia Martinez', 'Chef', 2),
('Daniel Lee', 'Server', 3),
('Emily Wilson', 'Cashier', 4),
('James Brown', 'Cook', 5),
('Isabella Adams', 'Manager', 6),
('Liam Scott', 'Waiter', 7),
('Lucas Green', 'Cleaner', 8),
('Grace Hill', 'Host', 9),
('Henry Baker', 'Chef', 10);


INSERT INTO WorkedDay (EmployeeID, Start_Time, End_Time, Salary) VALUES
(1, '2024-11-01 08:00:00', '2024-11-01 16:00:00', 80.00),
(2, '2024-11-02 09:00:00', '2024-11-02 17:00:00', 90.00),
(3, '2024-11-03 10:00:00', '2024-11-03 18:00:00', 85.00),
(4, '2024-11-04 11:00:00', '2024-11-04 19:00:00', 95.00),
(5, '2024-11-05 08:00:00', '2024-11-05 16:00:00', 75.00);


INSERT INTO Calendier (WorkedID) VALUES
(6),
(7),
(8),
(9),
(10);



INSERT INTO MenuItems (ItemName, Category, Price, RestaurantID, FoodStorageID) VALUES
('Veggie Burger', 'Main Course', 6.49, 1, 1),
('Margarita Pizza', 'Main Course', 7.99, 2, 2),
('Dragon Roll', 'Sushi', 12.49, 3, 3),
('Shrimp Tacos', 'Main Course', 8.99, 4, 4),
('Penne Alfredo', 'Pasta', 8.49, 5, 5);



INSERT INTO Orders (CustomerID, TotalAmount, RestaurantID) VALUES
(3, 19.99, 3),
(4, 25.49, 4),
(5, 30.99, 5),
(7, 15.99, 7),
(10, 22.99, 10);



INSERT INTO OrderDetails (OrderID, ItemID, Quantity) VALUES
(11, 3, 1),
(12, 4, 2),
(13, 5, 3),
(14, 7, 1),
(15, 10, 2);


INSERT INTO TransactionLog (CustomerID, Amount, TransactionType, OrderID) VALUES
(1, 25.99, 'Purchase', 1),
(2, 15.99, 'Purchase', 2),
(3, 30.99, 'Refund', 3),
(4, 22.99, 'Purchase', 4),
(5, 19.99, 'Refund', 5);

DELIMITER $$

CREATE PROCEDURE ProcessOrder(IN orderID INT, IN isReturn BOOLEAN)
BEGIN
    -- Declare variables
    DECLARE itemID INT;
    DECLARE orderQty INT;
    DECLARE productID INT;
    DECLARE productCost DECIMAL(10,2);
    DECLARE customerID INT;
    DECLARE totalAmount DECIMAL(10,2);
    DECLARE done BOOLEAN DEFAULT FALSE;

    -- Cursor to fetch order details
    DECLARE itemCursor CURSOR FOR
        SELECT OD.ItemID, OD.Quantity, MIP.ProductID
        FROM OrderDetails OD
        JOIN MenuItemProducts MIP ON OD.ItemID = MIP.ItemID
        WHERE OD.OrderID = orderID;

    -- Handler for the end of the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Start transaction
    START TRANSACTION;

    -- Get order total and customer ID
    SELECT CustomerID, TotalAmount INTO customerID, totalAmount
    FROM Orders WHERE OrderID = orderID;

    -- Handle returns
    IF isReturn THEN
        -- Refund customer
        UPDATE Customers SET Balance = Balance + totalAmount WHERE CustomerID = customerID;

        -- Restore stock
        OPEN itemCursor;
        readLoop: LOOP
            FETCH itemCursor INTO itemID, orderQty, productID;
            IF done THEN
                LEAVE readLoop;
            END IF;

            UPDATE ProductStorage
            SET QuantityStored = QuantityStored + orderQty
            WHERE ProductID = productID;
        END LOOP;
        CLOSE itemCursor;

        INSERT INTO TransactionLog (CustomerID, Amount, TransactionType, OrderID)
        VALUES (customerID, totalAmount, 'Refund', orderID);

        SELECT 'Order refunded successfully' AS Status;
    ELSE
        -- Check if customer has sufficient balance
        SELECT Balance INTO @customerBalance FROM Customers WHERE CustomerID = customerID;
        IF @customerBalance < totalAmount THEN
            ROLLBACK;
            SELECT 'Insufficient balance' AS Status;
        ELSE
            -- Deduct amount from customer balance
            UPDATE Customers SET Balance = Balance - totalAmount WHERE CustomerID = customerID;

            -- Process stock reduction
            OPEN itemCursor;
            readLoop: LOOP
                FETCH itemCursor INTO itemID, orderQty, productID;
                IF done THEN
                    LEAVE readLoop;
                END IF;

                UPDATE ProductStorage
                SET QuantityStored = QuantityStored - orderQty
                WHERE ProductID = productID;
            END LOOP;
            CLOSE itemCursor;

            INSERT INTO TransactionLog (CustomerID, Amount, TransactionType, OrderID)
            VALUES (customerID, totalAmount, 'Purchase', orderID);

            COMMIT;
            SELECT 'Order processed successfully' AS Status;
        END IF;
    END IF;
END$$

DELIMITER ;
UPDATE Customers SET Balance = 100.00 WHERE CustomerID <= 10;


CALL ProcessOrder(1, FALSE);  -- Process order (purchase)

CALL ProcessOrder(1, TRUE);  -- Process order (return)


-- Example of a customer making a purchase
UPDATE Customers
SET Balance = Balance - 25.99
WHERE CustomerID = 1;

-- Insert into Orders table
INSERT INTO Orders (CustomerID, TotalAmount, RestaurantID) VALUES
(1, 25.99, 1);

SELECT* FROM Customers;

UPDATE Customers
SET Balance = Balance + 10.00
WHERE CustomerID = 1;

UPDATE Orders
SET TotalAmount = TotalAmount - 10.00
WHERE OrderID = 1;



START TRANSACTION;

UPDATE Customers
SET Balance = Balance - 25.99
WHERE CustomerID = 11;

INSERT INTO Orders (CustomerID, TotalAmount, RestaurantID) VALUES
(1, 25.99, 1);

COMMIT;
ROLLBACK;


-- Start the transaction
DELIMITER $$

CREATE PROCEDURE ProcessPurchase()
BEGIN
    DECLARE customer_balance DECIMAL(10,2);

    -- Start the transaction
    START TRANSACTION;

    -- Get the customer's balance
    SELECT Balance INTO customer_balance
    FROM Customers
    WHERE CustomerID = 1
    FOR UPDATE;

    -- Check if the balance is sufficient
    IF customer_balance >= 25.99 THEN
        -- Update the balance
        UPDATE Customers
        SET Balance = Balance - 25.99
        WHERE CustomerID = 1;

        -- Insert the order
        INSERT INTO Orders (CustomerID, TotalAmount, RestaurantID)
        VALUES (1, 25.99, 1);

        -- Commit the transaction
        COMMIT;
    ELSE
        -- If the balance is not sufficient, rollback the transaction
        ROLLBACK;

        -- Optionally, you can handle this in your application
        SELECT 'Insufficient balance' AS ErrorMessage;
    END IF;
END$$

DELIMITER ;
-- Start the transaction
START TRANSACTION;

-- Check the customer's balance
SELECT Balance
FROM Customers
WHERE CustomerID = 11;

-- If the balance is sufficient, update and insert (handle in app)
UPDATE Customers
SET Balance = Balance - 25.99
WHERE CustomerID = 1 AND Balance >= 25.99;

-- Insert the order
INSERT INTO Orders (CustomerID, TotalAmount, RestaurantID)
VALUES (1, 25.99, 1);

-- Commit the transaction

COMMIT;


