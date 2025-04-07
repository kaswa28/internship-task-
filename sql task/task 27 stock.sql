/*USE StockTradingDB;
-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    account_balance DECIMAL(15, 2),
    registration_date DATETIME
);

-- Stocks Table
CREATE TABLE Stocks (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    ticker_symbol VARCHAR(10) UNIQUE,
    company_name VARCHAR(100),
    current_price DECIMAL(10, 2),
    market_cap DECIMAL(15, 2)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    stock_id INT,
    order_type ENUM('buy', 'sell'),
    quantity INT,
    price_per_share DECIMAL(10, 2),
    order_status ENUM('pending', 'executed', 'canceled'),
    order_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    execution_price DECIMAL(10, 2),
    execution_time DATETIME,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- User Portfolio Table
CREATE TABLE User_Portfolio (
    portfolio_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    stock_id INT,
    quantity_owned INT,
    average_purchase_price DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);
-- Insert sample data into Users table
INSERT INTO Users (first_name, last_name, email, account_balance, registration_date)
VALUES
('Rahul', 'Mehta', 'rahul.mehta@example.com', 100000.00, NOW()),
('Priya', 'Sharma', 'priya.sharma@example.com', 200000.00, NOW());

-- Insert sample data into Stocks table
INSERT INTO Stocks (ticker_symbol, company_name, current_price, market_cap)
VALUES
('TCS', 'Tata Consultancy Services', 3500.00, 1000000000),
('INFY', 'Infosys Ltd', 1500.00, 700000000);

-- Insert sample data into Orders table
INSERT INTO Orders (user_id, stock_id, order_type, quantity, price_per_share, order_status, order_time)
VALUES
(1, 1, 'buy', 10, 3500.00, 'executed', NOW()),
(2, 2, 'sell', 5, 1500.00, 'executed', NOW());

-- Insert sample data into Transactions table
INSERT INTO Transactions (order_id, execution_price, execution_time)
VALUES
(1, 3500.00, NOW()),
(2, 1500.00, NOW());

-- Insert sample data into User_Portfolio table
INSERT INTO User_Portfolio (user_id, stock_id, quantity_owned, average_purchase_price)
VALUES
(1, 1, 10, 3500.00),
(2, 2, 5, 1500.00);*/
SELECT s.ticker_symbol, COUNT(o.order_id) AS trade_count
FROM Orders o
JOIN Stocks s ON o.stock_id = s.stock_id
WHERE o.order_time >= NOW() - INTERVAL 1 DAY
GROUP BY s.ticker_symbol
ORDER BY trade_count DESC
LIMIT 5;
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    SUM((s.current_price - up.average_purchase_price) * up.quantity_owned) AS profit_loss
FROM Users u
JOIN User_Portfolio up ON u.user_id = up.user_id
JOIN Stocks s ON up.stock_id = s.stock_id
GROUP BY u.user_id;
SELECT 
    o.order_id,
    u.first_name,
    u.last_name,
    o.price_per_share * o.quantity AS total_trade_value
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.order_type = 'buy'
AND (o.price_per_share * o.quantity) > (u.account_balance * 0.5);
SELECT 
    s.ticker_symbol,
    MAX(s.current_price) - MIN(s.current_price) AS price_volatility
FROM Stocks s
WHERE s.stock_id IN (
    SELECT stock_id 
    FROM Orders 
    WHERE order_time >= NOW() - INTERVAL 7 DAY
)
GROUP BY s.ticker_symbol
ORDER BY price_volatility DESC;
SELECT 
    o.user_id,
    COUNT(o.order_id) AS trade_count
FROM Orders o
WHERE o.order_time >= NOW() - INTERVAL 1 HOUR
GROUP BY o.user_id
HAVING trade_count > 100;
SELECT 
    s.ticker_symbol,
    DATE(t.execution_time) AS trade_date,
    SUM(o.quantity) AS total_volume
FROM Transactions t
JOIN Orders o ON t.order_id = o.order_id
JOIN Stocks s ON o.stock_id = s.stock_id
GROUP BY s.ticker_symbol, trade_date;
SELECT 
    o.order_id,
    u.first_name,
    u.last_name,
    o.order_status
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.order_status = 'pending';
SELECT 
    s.ticker_symbol,
    MIN(s.current_price) AS min_price,
    MAX(s.current_price) AS max_price
FROM Stocks s
WHERE s.current_price < MAX(s.current_price) * 0.9
GROUP BY s.ticker_symbol;
