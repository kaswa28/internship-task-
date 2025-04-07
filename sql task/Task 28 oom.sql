CREATE DATABASE online_orders;
USE online_orders;
CREATE TABLE new_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
SHOW TABLES;
INSERT INTO new_orders (product_name, quantity, price) VALUES 
('Laptop', 2, 75000.50),
('Smartphone', 5, 25000.75),
('Tablet', 3, 15000.99);
SELECT * FROM new_orders;
USE online_orders;
SHOW Databases