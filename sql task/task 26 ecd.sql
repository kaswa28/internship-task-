-- Creating the E-Commerce Database
CREATE DATABASE ecommerce_system;
USE ecommerce_system;

-- Creating the Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

-- Inserting Sample Data into Products Table
INSERT INTO Products (name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 800.00, 50),
('Smartphone', 'Electronics', 600.00, 100),
('Headphones', 'Accessories', 50.00, 200),
('Chair', 'Furniture', 120.00, 75),
('Table', 'Furniture', 300.00, 30);

-- Creating the Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    registration_date DATE NOT NULL
);

-- Inserting Sample Data into Customers Table
INSERT INTO Customers (first_name, last_name, email, registration_date) VALUES
('John', 'Doe', 'john.doe@example.com', '2024-01-10'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-12-15'),
('Alice', 'Johnson', 'alice.johnson@example.com', '2023-11-20');

-- Creating the Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME NOT NULL,
    status ENUM('pending', 'shipped', 'delivered', 'canceled') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Inserting Sample Data into Orders Table
INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-02-10 10:30:00', 'shipped'),
(2, '2024-02-12 12:15:00', 'delivered'),
(3, '2024-02-14 14:00:00', 'pending');

-- Creating the Order_Items Table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Inserting Sample Data into Order_Items Table
INSERT INTO Order_Items (order_id, product_id, quantity, total_price) VALUES
(1, 1, 1, 800.00),
(2, 2, 2, 1200.00),
(3, 3, 3, 150.00);

-- Creating the Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATETIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('credit_card', 'paypal', 'bank_transfer') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Inserting Sample Data into Payments Table
INSERT INTO Payments (order_id, payment_date, amount, payment_method) VALUES
(1, '2024-02-11 11:00:00', 800.00, 'credit_card'),
(2, '2024-02-13 13:00:00', 1200.00, 'paypal'),
(3, '2024-02-15 15:00:00', 150.00, 'bank_transfer');

-- Query 1: Top 5 Best-Selling Products
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;

-- Query 2: Total Revenue for the Last 6 Months
SELECT SUM(amount) AS total_revenue
FROM Payments
WHERE payment_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH);

-- Query 3: Customers Who Placed More Than 10 Orders
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING order_count > 10;

-- Query 4: Products That Have Never Been Purchased
SELECT p.product_id, p.name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Query 5: Average Order Value per Customer
SELECT c.customer_id, c.first_name, c.last_name, 
       AVG(o_total.total_order_value) AS avg_order_value
FROM Customers c
JOIN (
    SELECT o.customer_id, SUM(p.amount) AS total_order_value
    FROM Orders o
    JOIN Payments p ON o.order_id = p.order_id
    GROUP BY o.order_id, o.customer_id
) o_total ON c.customer_id = o_total.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Query 6: Month with the Highest Sales in the Last 2 Years
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(amount) AS total_sales
FROM Payments
WHERE payment_date >= DATE_SUB(NOW(), INTERVAL 2 YEAR)
GROUP BY month
ORDER BY total_sales DESC
LIMIT 1;

-- Query 7: Customers Who Haven't Ordered Anything in the Last 12 Months
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id 
    AND o.order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
WHERE o.customer_id IS NULL;

-- Query 8: Most Popular Payment Method
SELECT payment_method, COUNT(payment_id) AS usage_count
FROM Payments
GROUP BY payment_method
ORDER BY usage_count DESC
LIMIT 1;
