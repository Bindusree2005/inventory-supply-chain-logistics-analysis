use inventory_supply_chain;
create database inventory_supply_chain;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    reorder_level INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    city VARCHAR(60),
    state VARCHAR(60),
    contact_email VARCHAR(100)
);


CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(60) NOT NULL,
    state VARCHAR(60) NOT NULL,
    storage_capacity INT NOT NULL
);


CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    last_updated DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
    UNIQUE (product_id, warehouse_id)
);


CREATE TABLE purchase_orders (
    po_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    order_date DATE NOT NULL,
    expected_delivery_date DATE NOT NULL,
    po_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);


CREATE TABLE purchase_order_items (
    po_item_id INT PRIMARY KEY AUTO_INCREMENT,
    po_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_ordered INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    po_id INT NOT NULL,
    carrier_name VARCHAR(100) NOT NULL,
    shipping_cost DECIMAL(10,2) NOT NULL,
    dispatch_date DATE,
    expected_delivery_date DATE NOT NULL,
    actual_delivery_date DATE,
    shipment_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id)
);


CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity_sold INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

SHOW TABLES;

INSERT INTO suppliers
(supplier_name, city, state, contact_email)
VALUES
('TechSource Distributors', 'Bengaluru', 'Karnataka', 'contact@techsource.in'),
('Prime Electronics', 'Chennai', 'Tamil Nadu', 'sales@primeelectronics.in'),
('Metro Wholesale', 'Hyderabad', 'Telangana', 'info@metrowholesale.in'),
('National Supplies', 'Mumbai', 'Maharashtra', 'orders@nationalsupplies.in'),
('SmartBuy Traders', 'Delhi', 'Delhi', 'sales@smartbuy.in'),
('Reliable Components', 'Pune', 'Maharashtra', 'contact@reliablecomponents.in'),
('SouthStar Distributors', 'Vijayawada', 'Andhra Pradesh', 'info@southstar.in'),
('Apex Industrial Supply', 'Ahmedabad', 'Gujarat', 'sales@apexindustrial.in'),
('GreenCart Suppliers', 'Kochi', 'Kerala', 'orders@greencart.in'),
('Universal Trade Links', 'Jaipur', 'Rajasthan', 'contact@universaltrade.in');


INSERT INTO products
(product_name, category, unit_cost, reorder_level, unit_price)
VALUES
('Laptop', 'Electronics', 45000, 10, 55000),
('Wireless Mouse', 'Electronics', 400, 25, 650),
('Keyboard', 'Electronics', 700, 20, 1100),
('Monitor', 'Electronics', 8500, 10, 11000),
('Headphones', 'Electronics', 1200, 20, 1800),
('Office Chair', 'Furniture', 4500, 10, 6500),
('Office Desk', 'Furniture', 7000, 8, 9500),
('Notebook Pack', 'Stationery', 120, 50, 200),
('Printer Paper', 'Stationery', 250, 40, 350),
('Ballpoint Pens', 'Stationery', 80, 50, 130),
('Water Bottle', 'Accessories', 180, 30, 300),
('Backpack', 'Accessories', 900, 15, 1400),
('Desk Lamp', 'Home & Office', 650, 15, 1000),
('USB Drive 64GB', 'Electronics', 450, 25, 750),
('Power Bank', 'Electronics', 1100, 20, 1700);


INSERT INTO warehouses
(warehouse_name, city, state, storage_capacity)
VALUES
('Bengaluru Central Warehouse', 'Bengaluru', 'Karnataka', 10000),
('Chennai Distribution Hub', 'Chennai', 'Tamil Nadu', 8000),
('Hyderabad Logistics Center', 'Hyderabad', 'Telangana', 9000),
('Mumbai Main Warehouse', 'Mumbai', 'Maharashtra', 12000),
('Vijayawada Regional Warehouse', 'Vijayawada', 'Andhra Pradesh', 6000);


INSERT INTO inventory
(product_id, warehouse_id, stock_quantity, last_updated)
VALUES
-- Bengaluru warehouse (ID 1)
(1, 1, 5, '2026-10-10'),
(2, 1, 120, '2026-10-10'),
(3, 1, 18, '2026-10-10'),
(4, 1, 35, '2026-10-10'),
(5, 1, 8, '2026-10-10'),
(6, 1, 45, '2026-10-10'),

-- Chennai warehouse (ID 2)
(1, 2, 15, '2026-10-11'),
(3, 2, 40, '2026-10-11'),
(7, 2, 6, '2026-10-11'),
(8, 2, 200, '2026-10-11'),
(9, 2, 75, '2026-10-11'),
(10, 2, 25, '2026-10-11'),

-- Hyderabad warehouse (ID 3)
(2, 3, 10, '2026-10-12'),
(4, 3, 7, '2026-10-12'),
(5, 3, 50, '2026-10-12'),
(11, 3, 90, '2026-10-12'),
(12, 3, 12, '2026-10-12'),
(13, 3, 4, '2026-10-12'),

-- Mumbai warehouse (ID 4)
(1, 4, 25, '2026-10-13'),
(6, 4, 3, '2026-10-13'),
(7, 4, 30, '2026-10-13'),
(9, 4, 150, '2026-10-13'),
(14, 4, 60, '2026-10-13'),
(15, 4, 9, '2026-10-13'),

-- Vijayawada warehouse (ID 5)
(2, 5, 5, '2026-10-14'),
(3, 5, 12, '2026-10-14'),
(8, 5, 300, '2026-10-14'),
(10, 5, 15, '2026-10-14'),
(11, 5, 6, '2026-10-14'),
(12, 5, 80, '2026-10-14');


INSERT INTO purchase_orders
(supplier_id, order_date, expected_delivery_date, po_status)
VALUES
(1, '2026-08-01', '2026-08-06', 'Delivered'),
(2, '2026-08-03', '2026-08-09', 'Delivered'),
(3, '2026-08-05', '2026-08-12', 'Delivered'),
(4, '2026-08-08', '2026-08-15', 'Delivered'),
(5, '2026-08-10', '2026-08-17', 'Delivered'),
(6, '2026-08-12', '2026-08-19', 'Delivered'),
(7, '2026-08-15', '2026-08-22', 'Delivered'),
(8, '2026-08-18', '2026-08-25', 'Delivered'),
(9, '2026-08-20', '2026-08-27', 'Delivered'),
(10, '2026-08-22', '2026-08-29', 'Delivered'),
(1, '2026-09-01', '2026-09-07', 'Delivered'),
(3, '2026-09-05', '2026-09-12', 'Delivered'),
(5, '2026-09-10', '2026-09-17', 'In Transit'),
(7, '2026-09-15', '2026-09-22', 'Pending'),
(9, '2026-09-20', '2026-09-27', 'Pending');


INSERT INTO purchase_order_items
(po_id, product_id, quantity_ordered, unit_cost)
VALUES
-- Purchase order 1
(1, 1, 20, 45000),
(1, 2, 100, 400),
(1, 3, 60, 700),

-- Purchase order 2
(2, 4, 25, 8500),
(2, 5, 40, 1200),

-- Purchase order 3
(3, 6, 15, 4500),
(3, 7, 10, 7000),

-- Purchase order 4
(4, 8, 200, 120),
(4, 9, 150, 250),

-- Purchase order 5
(5, 10, 300, 80),
(5, 11, 100, 180),

-- Purchase order 6
(6, 12, 40, 900),
(6, 13, 35, 650),

-- Purchase order 7
(7, 14, 100, 450),
(7, 15, 60, 1100),

-- Purchase order 8
(8, 1, 10, 45000),
(8, 4, 15, 8500),

-- Purchase order 9
(9, 2, 150, 400),
(9, 8, 250, 120),

-- Purchase order 10
(10, 5, 50, 1200),
(10, 6, 20, 4500),

-- Purchase order 11
(11, 3, 80, 700),
(11, 14, 120, 450),

-- Purchase order 12
(12, 7, 15, 7000),
(12, 13, 40, 650),

-- Purchase order 13
(13, 1, 8, 45000),
(13, 15, 25, 1100),

-- Purchase order 14
(14, 9, 100, 250),
(14, 10, 200, 80),

-- Purchase order 15
(15, 11, 80, 180),
(15, 12, 30, 900);


INSERT INTO shipments
(po_id, carrier_name, shipping_cost, dispatch_date,
 expected_delivery_date, actual_delivery_date, shipment_status)
VALUES
(1, 'BlueDart', 4500, '2026-08-02', '2026-08-06', '2026-08-05', 'Delivered'),
(2, 'Delhivery', 2800, '2026-08-04', '2026-08-09', '2026-08-11', 'Delivered'),
(3, 'DTDC', 3200, '2026-08-06', '2026-08-12', '2026-08-12', 'Delivered'),
(4, 'BlueDart', 1800, '2026-08-09', '2026-08-15', '2026-08-14', 'Delivered'),
(5, 'India Post', 1200, '2026-08-11', '2026-08-17', '2026-08-19', 'Delivered'),
(6, 'Delhivery', 2400, '2026-08-13', '2026-08-19', '2026-08-18', 'Delivered'),
(7, 'DTDC', 1600, '2026-08-16', '2026-08-22', '2026-08-22', 'Delivered'),
(8, 'BlueDart', 2100, '2026-08-19', '2026-08-25', '2026-08-28', 'Delivered'),
(9, 'India Post', 900, '2026-08-21', '2026-08-27', '2026-08-26', 'Delivered'),
(10, 'Delhivery', 1900, '2026-08-23', '2026-08-29', '2026-08-29', 'Delivered'),
(11, 'BlueDart', 2600, '2026-09-02', '2026-09-07', '2026-09-06', 'Delivered'),
(12, 'DTDC', 1500, '2026-09-06', '2026-09-12', '2026-09-15', 'Delivered'),
(13, 'Delhivery', 2200, '2026-09-11', '2026-09-17', NULL, 'In Transit'),
(14, 'India Post', 1100, '2026-09-16', '2026-09-22', NULL, 'Pending'),
(15, 'BlueDart', 1700, '2026-09-21', '2026-09-27', NULL, 'Pending');


INSERT INTO sales
(product_id, warehouse_id, sale_date, quantity_sold, unit_price)
VALUES
-- August sales
(1, 1, '2026-08-02', 4, 55000),
(2, 1, '2026-08-03', 20, 650),
(3, 1, '2026-08-05', 12, 1100),
(4, 2, '2026-08-06', 8, 11000),
(5, 2, '2026-08-08', 15, 1800),
(6, 3, '2026-08-10', 5, 6500),
(7, 3, '2026-08-12', 3, 9500),
(8, 2, '2026-08-14', 60, 200),
(9, 2, '2026-08-16', 35, 350),
(10, 5, '2026-08-18', 80, 130),
(11, 3, '2026-08-20', 25, 300),
(12, 4, '2026-08-22', 10, 1400),
(13, 1, '2026-08-24', 8, 1000),
(14, 4, '2026-08-26', 30, 750),
(15, 1, '2026-08-28', 12, 1700),

-- September sales
(1, 1, '2026-09-02', 6, 55000),
(2, 5, '2026-09-04', 18, 650),
(3, 5, '2026-09-06', 15, 1100),
(4, 3, '2026-09-08', 5, 11000),
(5, 1, '2026-09-10', 10, 1800),
(6, 4, '2026-09-12', 7, 6500),
(7, 2, '2026-09-14', 4, 9500),
(8, 5, '2026-09-16', 75, 200),
(9, 4, '2026-09-18', 40, 350),
(10, 2, '2026-09-20', 90, 130),
(11, 5, '2026-09-22', 30, 300),
(12, 3, '2026-09-24', 12, 1400),
(13, 1, '2026-09-26', 10, 1000),
(14, 4, '2026-09-28', 45, 750),
(15, 1, '2026-09-30', 18, 1700);


SELECT 'products' AS table_name, COUNT(*) AS total_rows FROM products
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'warehouses', COUNT(*) FROM warehouses
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'purchase_orders', COUNT(*) FROM purchase_orders
UNION ALL
SELECT 'purchase_order_items', COUNT(*) FROM purchase_order_items
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL
SELECT 'sales', COUNT(*) FROM sales;

















