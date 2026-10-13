PRAGMA foreign_keys = ON;

-- 1. CUSTOMER
CREATE TABLE CUSTOMER (
    CustomerID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT,
    Phone TEXT,
    Address TEXT,
    City TEXT,
    Postcode TEXT
);

-- 2. PRODUCT
CREATE TABLE PRODUCT (
    ProductID INTEGER PRIMARY KEY,
    ProductName TEXT NOT NULL,
    Description TEXT,
    Category TEXT,
    UnitPrice REAL NOT NULL,
    ReorderLevel INTEGER
);

-- 3. SUPPLIER
CREATE TABLE SUPPLIER (
    SupplierID INTEGER PRIMARY KEY,
    SupplierName TEXT NOT NULL,
    ContactName TEXT,
    Email TEXT,
    Phone TEXT,
    Address TEXT,
    City TEXT,
    Postcode TEXT
);

-- 4. LOCATION
CREATE TABLE LOCATION (
    LocationID INTEGER PRIMARY KEY,
    LocationName TEXT NOT NULL,
    LocationType TEXT NOT NULL,
    Address TEXT,
    City TEXT,
    Postcode TEXT
);

-- 5. SALES_ORDER
CREATE TABLE SALES_ORDER (
    SalesOrderID INTEGER PRIMARY KEY,
    CustomerID INTEGER NOT NULL,
    OrderDate TEXT NOT NULL,
    Status TEXT,
    TotalAmount REAL,

    FOREIGN KEY (CustomerID)
        REFERENCES CUSTOMER(CustomerID)
);

-- 6. SALES_ORDER_ITEM
CREATE TABLE SALES_ORDER_ITEM (
    SalesOrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    UnitPrice REAL NOT NULL,

    PRIMARY KEY (SalesOrderID, ProductID),

    FOREIGN KEY (SalesOrderID)
        REFERENCES SALES_ORDER(SalesOrderID),

    FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
);

-- 7. PURCHASE_ORDER
CREATE TABLE PURCHASE_ORDER (
    PurchaseOrderID INTEGER PRIMARY KEY,
    SupplierID INTEGER NOT NULL,
    OrderDate TEXT NOT NULL,
    ExpectedDate TEXT,
    Status TEXT,
    TotalAmount REAL,

    FOREIGN KEY (SupplierID)
        REFERENCES SUPPLIER(SupplierID)
);

-- 8. PURCHASE_ORDER_ITEM
CREATE TABLE PURCHASE_ORDER_ITEM (
    PurchaseOrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL,
    UnitCost REAL NOT NULL,

    PRIMARY KEY (PurchaseOrderID, ProductID),

    FOREIGN KEY (PurchaseOrderID)
        REFERENCES PURCHASE_ORDER(PurchaseOrderID),

    FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID)
);

-- 9. STOCK
CREATE TABLE STOCK (
    ProductID INTEGER NOT NULL,
    LocationID INTEGER NOT NULL,
    QuantityOnHand INTEGER NOT NULL,
    LastUpdated TEXT,

    PRIMARY KEY (ProductID, LocationID),

    FOREIGN KEY (ProductID)
        REFERENCES PRODUCT(ProductID),

    FOREIGN KEY (LocationID)
        REFERENCES LOCATION(LocationID)
);

-- 10. INVOICE
CREATE TABLE INVOICE (
    InvoiceID INTEGER PRIMARY KEY,
    SalesOrderID INTEGER NOT NULL UNIQUE,
    InvoiceDate TEXT NOT NULL,
    TotalAmount REAL NOT NULL,
    Status TEXT,

    FOREIGN KEY (SalesOrderID)
        REFERENCES SALES_ORDER(SalesOrderID)
);

-- 11. PAYMENT
CREATE TABLE PAYMENT (
    PaymentID INTEGER PRIMARY KEY,
    InvoiceID INTEGER NOT NULL,
    PaymentDate TEXT NOT NULL,
    Amount REAL NOT NULL,
    PaymentMethod TEXT,
    Status TEXT,

    FOREIGN KEY (InvoiceID)
        REFERENCES INVOICE(InvoiceID)
);

-- 12. DELIVERY
CREATE TABLE DELIVERY (
    DeliveryID INTEGER PRIMARY KEY,
    SalesOrderID INTEGER NOT NULL,
    DeliveryDate TEXT,
    Carrier TEXT,
    TrackingNumber TEXT,
    Status TEXT,

    FOREIGN KEY (SalesOrderID)
        REFERENCES SALES_ORDER(SalesOrderID)
);

PRAGMA foreign_keys = ON;

INSERT INTO CUSTOMER (CustomerID, FirstName, LastName, Email, Phone, Address, City, Postcode) VALUES
(1, 'Emily', 'Nguyen', 'emily.nguyen@example.com', '0411000101', '12 King Street', 'Sydney', '2000'),
(2, 'James', 'Patel', 'james.patel@example.com', '0411000102', '48 Macquarie Street', 'Parramatta', '2150'),
(3, 'Olivia', 'Brown', 'olivia.brown@example.com', '0411000103', '7 Railway Parade', 'Blacktown', '2148'),
(4, 'Liam', 'Kumar', 'liam.kumar@example.com', '0411000104', '21 Northumberland Street', 'Liverpool', '2170'),
(5, 'Chloe', 'Martin', 'chloe.martin@example.com', '0411000105', '3 Victoria Avenue', 'Chatswood', '2067');

INSERT INTO PRODUCT
(ProductID, ProductName, Description, Category, UnitPrice, ReorderLevel)
VALUES
(1, 'Wireless Mouse', 'Wireless optical mouse', 'Electronics', 29.95, 20),
(2, 'USB-C Cable', '1 metre USB-C charging cable', 'Electronics', 14.95, 30),
(3, 'Laptop Stand', 'Adjustable aluminium laptop stand', 'Accessories', 49.95, 15),
(4, 'Notebook', 'A4 ruled notebook', 'Stationery', 6.50, 40),
(5, 'Desk Lamp', 'LED adjustable desk lamp', 'Home Office', 39.95, 10),
(6, 'Keyboard', 'USB wireless keyboard', 'Electronics', 44.95, 15),
(7, 'Water Bottle', '750ml reusable water bottle', 'Home', 19.95, 20),
(8, 'Backpack', 'Everyday laptop backpack', 'Accessories', 59.95, 10);

INSERT INTO SUPPLIER
(SupplierID, SupplierName, ContactName, Email, Phone, Address, City, Postcode)
VALUES
(1, 'TechSource Australia', 'Daniel Lee', 'daniel@techsource.com.au', '0291112233', '15 Market Street', 'Sydney', '2000'),
(2, 'Office Supply Co', 'Sarah Green', 'sarah@officesupply.com.au', '0292223344', '28 Church Street', 'Parramatta', '2150'),
(3, 'Home Essentials Pty Ltd', 'Michael Chen', 'michael@homeessentials.com.au', '0293334455', '9 Pacific Highway', 'Chatswood', '2067'),
(4, 'Metro Distribution', 'Anna Wilson', 'anna@metrodistribution.com.au', '0294445566', '42 George Street', 'Liverpool', '2170');

-- ==========================================
-- 1. LOCATION
-- ==========================================
INSERT INTO LOCATION
(LocationID, LocationName, LocationType, Address, City, Postcode)
VALUES
(1, 'Sydney CBD Store', 'Store', '100 George Street', 'Sydney', '2000'),
(2, 'Parramatta Store', 'Store', '159 Church Street', 'Parramatta', '2150'),
(3, 'Western Sydney Warehouse', 'Warehouse', '25 Distribution Drive', 'Eastern Creek', '2766'),
(4, 'Liverpool Store', 'Store', '33 Macquarie Street', 'Liverpool', '2170');


-- ==========================================
-- 2. SALES_ORDER
-- ==========================================
INSERT INTO SALES_ORDER
(SalesOrderID, CustomerID, OrderDate, Status, TotalAmount)
VALUES
(1, 1, '2026-08-15', 'Completed', 74.85),
(2, 2, '2026-08-18', 'Completed', 99.90),
(3, 3, '2026-08-22', 'Processing', 64.90),
(4, 4, '2026-08-25', 'Completed', 79.90),
(5, 5, '2026-09-01', 'Pending', 104.90),
(6, 1, '2026-09-05', 'Processing', 89.90);


-- ==========================================
-- 3. SALES_ORDER_ITEM
-- ==========================================
INSERT INTO SALES_ORDER_ITEM
(SalesOrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 2, 29.95),
(1, 2, 1, 14.95),
(2, 3, 2, 49.95),
(3, 4, 1, 6.50),
(3, 7, 1, 19.95),
(3, 5, 1, 38.45),
(4, 5, 2, 39.95),
(5, 6, 1, 44.95),
(5, 8, 1, 59.95),
(6, 6, 2, 44.95);


-- ==========================================
-- 4. PURCHASE_ORDER
-- ==========================================
INSERT INTO PURCHASE_ORDER
(PurchaseOrderID, SupplierID, OrderDate, ExpectedDate, Status, TotalAmount)
VALUES
(1, 1, '2026-08-01', '2026-08-08', 'Received', 1200.00),
(2, 2, '2026-08-05', '2026-08-12', 'Received', 650.00),
(3, 3, '2026-08-20', '2026-08-28', 'Received', 900.00),
(4, 1, '2026-09-02', '2026-09-10', 'Pending', 1500.00),
(5, 4, '2026-09-04', '2026-09-12', 'Processing', 800.00);


-- ==========================================
-- 5. PURCHASE_ORDER_ITEM
-- ==========================================
INSERT INTO PURCHASE_ORDER_ITEM
(PurchaseOrderID, ProductID, Quantity, UnitCost)
VALUES
(1, 1, 30, 20.00),
(1, 2, 50, 8.00),
(1, 6, 10, 20.00),
(2, 3, 10, 35.00),
(2, 4, 50, 4.00),
(2, 7, 10, 10.00),
(3, 5, 20, 25.00),
(3, 8, 10, 40.00),
(4, 1, 50, 20.00),
(4, 6, 25, 20.00),
(5, 7, 40, 10.00),
(5, 8, 10, 40.00);


-- ==========================================
-- 6. STOCK
-- ==========================================
INSERT INTO STOCK
(ProductID, LocationID, QuantityOnHand, LastUpdated)
VALUES
(1, 1, 12, '2026-09-08'),
(1, 2, 25, '2026-09-08'),
(1, 3, 80, '2026-09-08'),

(2, 1, 18, '2026-09-08'),
(2, 2, 22, '2026-09-08'),
(2, 3, 100, '2026-09-08'),

(3, 1, 8, '2026-09-08'),
(3, 2, 12, '2026-09-08'),
(3, 3, 35, '2026-09-08'),

(4, 1, 35, '2026-09-08'),
(4, 2, 45, '2026-09-08'),
(4, 3, 120, '2026-09-08'),

(5, 1, 6, '2026-09-08'),
(5, 2, 14, '2026-09-08'),
(5, 3, 40, '2026-09-08'),

(6, 1, 10, '2026-09-08'),
(6, 2, 9, '2026-09-08'),
(6, 3, 55, '2026-09-08'),

(7, 1, 30, '2026-09-08'),
(7, 2, 16, '2026-09-08'),
(7, 3, 70, '2026-09-08'),

(8, 1, 7, '2026-09-08'),
(8, 2, 11, '2026-09-08'),
(8, 3, 30, '2026-09-08');





-- ==========================================
-- 7. INVOICE
-- ==========================================
INSERT INTO INVOICE
(InvoiceID, SalesOrderID, InvoiceDate, TotalAmount, Status)
VALUES
(1, 1, '2026-08-15', 74.85, 'Paid'),
(2, 2, '2026-08-18', 99.90, 'Paid'),
(3, 3, '2026-08-22', 64.90, 'Unpaid'),
(4, 4, '2026-08-25', 79.90, 'Paid'),
(5, 5, '2026-09-01', 104.90, 'Unpaid'),
(6, 6, '2026-09-05', 89.90, 'Partially Paid');


-- ==========================================
-- 8. PAYMENT
-- ==========================================
INSERT INTO PAYMENT
(PaymentID, InvoiceID, PaymentDate, Amount, PaymentMethod, Status)
VALUES
(1, 1, '2026-08-15', 74.85, 'Credit Card', 'Completed'),
(2, 2, '2026-08-18', 99.90, 'Debit Card', 'Completed'),
(3, 4, '2026-08-25', 79.90, 'PayPal', 'Completed'),
(4, 6, '2026-09-06', 40.00, 'Credit Card', 'Completed');


-- ==========================================
-- 9. DELIVERY
-- ==========================================
INSERT INTO DELIVERY
(DeliveryID, SalesOrderID, DeliveryDate, Carrier, TrackingNumber, Status)
VALUES
(1, 1, '2026-08-17', 'Australia Post', 'AUS100001', 'Delivered'),
(2, 2, '2026-08-20', 'Australia Post', 'AUS100002', 'Delivered'),
(3, 3, '2026-08-25', 'StarTrack', 'ST200001', 'In Transit'),
(4, 4, '2026-08-27', 'StarTrack', 'ST200002', 'Delivered'),
(5, 5, NULL, 'Australia Post', 'AUS100005', 'Pending'),
(6, 6, '2026-09-08', 'StarTrack', 'ST200006', 'In Transit');


--Scenario: The inventory manager wants to identify products with a unit price greater than $40.

SELECT ProductID, ProductName, Category, UnitPrice
FROM PRODUCT
WHERE UnitPrice > 40;

--Scenario: Staff want to identify sales orders that are currently being processed.

SELECT SalesOrderID, CustomerID, OrderDate, Status, TotalAmount
FROM SALES_ORDER
WHERE Status = 'Processing';

--Scenario: The inventory manager wants to identify products at each location where the available stock is below the product's reorder level.

SELECT
    p.ProductName,
    l.LocationName,
    s.QuantityOnHand,
    p.ReorderLevel
FROM STOCK s
JOIN PRODUCT p
    ON s.ProductID = p.ProductID
JOIN LOCATION l
    ON s.LocationID = l.LocationID
WHERE s.QuantityOnHand < p.ReorderLevel
ORDER BY s.QuantityOnHand;

--Scenario: Management wants to identify customers whose total spending is greater than the average spending across all customers.

WITH CustomerSpending AS (
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        SUM(so.TotalAmount) AS TotalSpent
    FROM CUSTOMER c
    JOIN SALES_ORDER so
        ON c.CustomerID = so.CustomerID
    GROUP BY
        c.CustomerID,
        c.FirstName,
        c.LastName
)

SELECT
    CustomerID,
    FirstName,
    LastName,
    TotalSpent
FROM CustomerSpending
WHERE TotalSpent > (
    SELECT AVG(TotalSpent)
    FROM CustomerSpending
)
ORDER BY TotalSpent DESC;