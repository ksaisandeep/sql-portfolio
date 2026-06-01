-- Employees Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(50),
    hire_date DATE NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    warehouse_id INT
);

-- Warehouses Table
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    capacity_sq_ft INT,
    manager_id INT
);

-- Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    unit_price DECIMAL(10, 2) NOT NULL,
    weight_kg DECIMAL(10, 2)
);

-- Inventory Table
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_id, warehouse_id) -- A product can only be in one warehouse location at a time
);

-- Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(50),
    address VARCHAR(255)
);

-- Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(50) NOT NULL
);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- Freight Companies Table
CREATE TABLE freight_companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone_number VARCHAR(50),
    email VARCHAR(100)
);

-- Shipments Table
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    company_id INT NOT NULL,
    shipment_date DATE NOT NULL,
    delivery_date DATE,
    shipping_cost DECIMAL(10, 2),
    tracking_number VARCHAR(100) UNIQUE,
    shipment_status VARCHAR(50) NOT NULL
);

-- Add Foreign Key Constraints after all tables are created
ALTER TABLE employees ADD CONSTRAINT fk_employees_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id);
ALTER TABLE warehouses ADD CONSTRAINT fk_warehouses_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id) DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE inventory ADD CONSTRAINT fk_inventory_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_order FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_company FOREIGN KEY (company_id) REFERENCES freight_companies(company_id);

-- Indexes for performance
CREATE INDEX idx_employees_warehouse_id ON employees (warehouse_id);
CREATE INDEX idx_inventory_product_id ON inventory (product_id);
CREATE INDEX idx_inventory_warehouse_id ON inventory (warehouse_id);
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_order_items_order_id ON order_items (order_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);
CREATE INDEX idx_shipments_order_id ON shipments (order_id);
CREATE INDEX idx_shipments_warehouse_id ON shipments (warehouse_id);
CREATE INDEX idx_shipments_company_id ON shipments (company_id);

-- Sample Data for Products and Employees
-- Use these commands in pgAdmin 4's Query Tool to insert data into your warehouse_db.

-- 1. Insert Freight Companies
INSERT INTO freight_companies (company_name, contact_person, phone_number, email) VALUES
('Global Express', 'John Smith', '555-0101', 'contact@globalexpress.com'),
('Swift Logistics', 'Sarah Johnson', '555-0102', 'info@swiftlogistics.com'),
('Oceanic Shipping', 'Mike Brown', '555-0103', 'ops@oceanic.com'),
('SkyHigh Freight', 'Emily Davis', '555-0104', 'support@skyhigh.com'),
('Rapid Roadways', 'David Wilson', '555-0105', 'dispatch@rapidroad.com');

-- 2. Insert Products
INSERT INTO products (product_name, description, category, unit_price, weight_kg) VALUES
('Ultra-Lightweight Hiking Boots', 'Durable and breathable hiking boots for long treks.', 'Footwear', 129.99, 1.2),
('Waterproof Camping Tent', '4-person tent with superior weather protection.', 'Camping Gear', 249.50, 4.5),
('Solar Powered Lantern', 'Eco-friendly lantern with multiple brightness settings.', 'Accessories', 35.00, 0.4),
('Thermal Sleeping Bag', 'Rated for sub-zero temperatures, compact design.', 'Camping Gear', 89.00, 1.8),
('Heavy-Duty Backpack', '60L capacity with ergonomic support.', 'Bags', 110.00, 2.1),
('Portable Gas Stove', 'Single burner stove for outdoor cooking.', 'Kitchenware', 45.00, 0.9),
('Aluminum Cookware Set', 'Lightweight 5-piece set for camping.', 'Kitchenware', 55.00, 1.5),
('High-Performance Compass', 'Precision compass with luminous dial.', 'Accessories', 25.00, 0.1),
('Quick-Dry Microfiber Towel', 'Large towel that folds into a small pouch.', 'Accessories', 15.99, 0.2),
('Multi-Tool Pocket Knife', '15 functions including screwdriver and pliers.', 'Tools', 40.00, 0.3);

-- 3. Insert Employees (Initially without warehouse_id to avoid FK issues)
INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_title, salary) VALUES
('Robert', 'Miller', 'robert.miller@warehouse.com', '555-1001', '2022-01-15', 'Warehouse Manager', 75000.00),
('Linda', 'Garcia', 'linda.garcia@warehouse.com', '555-1002', '2022-02-20', 'Warehouse Manager', 72000.00),
('James', 'Anderson', 'james.anderson@warehouse.com', '555-1003', '2022-03-10', 'Inventory Specialist', 55000.00),
('Patricia', 'Taylor', 'patricia.taylor@warehouse.com', '555-1004', '2022-04-05', 'Logistics Coordinator', 58000.00),
('Michael', 'Thomas', 'michael.thomas@warehouse.com', '555-1005', '2022-05-12', 'Warehouse Associate', 45000.00);

-- 4. Insert Warehouses (Assigning managers from the employees inserted above)
INSERT INTO warehouses (warehouse_name, location, capacity_sq_ft, manager_id) VALUES
('North Hub', '123 North St, Chicago, IL', 50000, 1),
('South Depot', '456 South Ave, Dallas, TX', 75000, 2),
('East Coast Center', '789 East Blvd, Newark, NJ', 60000, 1);

-- 5. Update Employees with their Warehouse IDs
UPDATE employees SET warehouse_id = 1 WHERE employee_id IN (1, 3, 5);
UPDATE employees SET warehouse_id = 2 WHERE employee_id = 2;
UPDATE employees SET warehouse_id = 3 WHERE employee_id = 4;

-- 6. Insert Inventory
INSERT INTO inventory (product_id, warehouse_id, quantity) VALUES
(1, 1, 150), (1, 2, 80), (1, 3, 45),
(2, 1, 30), (2, 2, 120),
(3, 1, 500), (3, 3, 250),
(4, 2, 60), (4, 3, 15),
(5, 1, 100), (5, 2, 100), (5, 3, 100);

-- 7. Insert Customers
INSERT INTO customers (first_name, last_name, email, phone_number, address) VALUES
('Alice', 'Walker', 'alice.w@email.com', '555-2001', '101 Pine St, Seattle, WA'),
('Bob', 'Stevens', 'bob.s@email.com', '555-2002', '202 Oak Ave, Denver, CO'),
('Charlie', 'Green', 'charlie.g@email.com', '555-2003', '303 Maple Rd, Austin, TX'),
('Diana', 'Prince', 'diana.p@email.com', '555-2004', '404 Cedar Ln, Miami, FL'),
('Edward', 'Norton', 'edward.n@email.com', '555-2005', '505 Birch St, Boston, MA');

-- 8. Insert Orders
INSERT INTO orders (customer_id, order_date, total_amount, order_status) VALUES
(1, '2023-10-01 10:30:00', 379.49, 'Delivered'),
(2, '2023-10-02 14:15:00', 249.50, 'Shipped'),
(3, '2023-10-03 09:00:00', 70.00, 'Processing'),
(4, '2023-10-04 11:45:00', 129.99, 'Pending'),
(5, '2023-10-05 16:20:00', 110.00, 'Delivered');

-- 9. Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 129.99), (1, 2, 1, 249.50),
(2, 2, 1, 249.50),
(3, 3, 2, 35.00),
(4, 1, 1, 129.99),
(5, 5, 1, 110.00);

-- 10. Insert Shipments
INSERT INTO shipments (order_id, warehouse_id, company_id, shipment_date, delivery_date, shipping_cost, tracking_number, shipment_status) VALUES
(1, 1, 1, '2023-10-02', '2023-10-05', 15.50, 'TRK001-GE', 'Delivered'),
(2, 2, 2, '2023-10-03', NULL, 12.00, 'TRK002-SL', 'Shipped'),
(5, 3, 5, '2023-10-06', '2023-10-09', 18.00, 'TRK005-RR', 'Delivered');

--SELECT * FROM freight_companies;
--SELECT * FROM employees;
--SELECT * FROM orders;
--SELECT * FROM products;
--SELECT * FROM inventory;
--SELECT * FROM warehouses;
--SELECT * FROM customers;
--SELECT * FROM orders_items;
--SELECT * FROM shipments;
