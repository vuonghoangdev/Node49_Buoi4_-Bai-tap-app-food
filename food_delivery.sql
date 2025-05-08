-- Tạo database food_delivery
CREATE DATABASE food_delivery;
USE food_delivery;

-- Tạo bảng user
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50),
    email VARCHAR(50),
    password VARCHAR(100)
);

-- Tạo bảng restaurant 
CREATE TABLE restaurant (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(50),
    image VARCHAR(255),
    description TEXT
);

-- Tạo bảng rate_res
CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng like_res  
CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng food
CREATE TABLE food (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(50),
    image VARCHAR(255),
    price FLOAT,
    description TEXT,
    type_id INT
);

-- Tạo bảng food_type   
CREATE TABLE food_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50)
);

-- Tạo bảng sub_food
CREATE TABLE sub_food (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(50),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Tạo bảng order
CREATE TABLE orders (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(50),
    arr_sub_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Thêm khóa ngoại cho bảng food
ALTER TABLE food
ADD FOREIGN KEY (type_id) REFERENCES food_type(type_id);


-- BÀI TẬP SQL YÊU CẦU
-- Tìm 5 người đã like nhà hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(lr.res_id) as total_likes
FROM user u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_likes DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất  
SELECT r.res_id, r.res_name, COUNT(lr.user_id) as like_count
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY like_count DESC
LIMIT 2;

-- Tìm người đã đặt hàng nhiều nhất
SELECT u.user_id, u.full_name, COUNT(o.food_id) as total_orders
FROM user u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_orders DESC
LIMIT 1;

-- Tìm người dùng không hoạt động trong hệ thống
SELECT u.user_id, u.full_name
FROM user u
LEFT JOIN orders o ON u.user_id = o.user_id
LEFT JOIN like_res lr ON u.user_id = lr.user_id
LEFT JOIN rate_res rr ON u.user_id = rr.user_id
WHERE o.user_id IS NULL 
AND lr.user_id IS NULL
AND rr.user_id IS NULL;