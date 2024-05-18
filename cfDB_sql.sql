CREATE DATABASE cookie_factoryDB;

-- Product Categories Table
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL
);

-- Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name NVARCHAR(100) NOT NULL,
    address NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    email NVARCHAR(100) NOT NULL
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    category_id INT FOREIGN KEY REFERENCES Categories(category_id),
    product_name NVARCHAR(100) NOT NULL,
    recipe NVARCHAR(MAX),
    unit_price DECIMAL(10, 2),
    stock_quantity INT,
    minimum_stock INT DEFAULT 0,
    maximum_stock INT,
    supplier_id INT FOREIGN KEY REFERENCES Suppliers(supplier_id),
    batch_number NVARCHAR(50),
    expiration_date DATE,
    CHECK(stock_quantity >= 0),
    CHECK(minimum_stock >= 0),
    CHECK(maximum_stock > 0),
    CHECK(minimum_stock <= maximum_stock)
);

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    company_id INT NULL,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    company_name NVARCHAR(100),
    address NVARCHAR(MAX) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    CHECK(first_name <> ''),
    CHECK(last_name <> '')
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE DEFAULT GETDATE(),
    delivery_date DATE,
    status NVARCHAR(50) DEFAULT 'Pending',
    payment_type NVARCHAR(50),
    total_amount DECIMAL(10, 2),
    invoice_id INT NULL,
    CHECK(total_amount >= 0)
);

-- Order Details Table
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT,
    unit_price DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    total_amount AS (quantity * unit_price - discount_amount),
    CHECK(quantity > 0),
    CHECK(unit_price >= 0),
    CHECK(discount_amount >= 0)
);

-- Personnel Table
CREATE TABLE Personnel (
    personnel_id INT PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    position NVARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    hourly_rate DECIMAL(10, 2),
    salary_type NVARCHAR(20) DEFAULT 'Monthly',
    CHECK(first_name <> ''),
    CHECK(last_name <> ''),
    CHECK(position <> ''),
    CHECK(salary >= 0),
    CHECK(hourly_rate >= 0)
);

-- Production Table
CREATE TABLE Production (
    production_id INT PRIMARY KEY,
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT,
    production_date DATE DEFAULT GETDATE(),
    personnel_id INT FOREIGN KEY REFERENCES Personnel(personnel_id),
    CHECK(quantity > 0)
);

-- Inventory Table
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT,
    inventory_date DATE DEFAULT GETDATE(),
    CHECK(quantity >= 0)
);

-- Payment Methods Table
CREATE TABLE PaymentMethods (
    payment_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    payment_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX),
    CHECK(payment_name <> '')
);