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
