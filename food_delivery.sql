-- Tạo database db_cyber_food_delivery
CREATE DATABASE db_cyber_food_delivery;
USE db_cyber_food_delivery;

-- Tạo bảng user
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50),
    email VARCHAR(50),
    password VARCHAR(100)
);

-- Thêm dữ liệu cho bảng user
INSERT INTO user (full_name, email, password) VALUES
('Nguyễn Văn A', 'nguyenvana@gmail.com', '123456'),
('Trần Thị B', 'tranthib@gmail.com', '123456'),
('Lê Văn C', 'levanc@gmail.com', '123456'),
('Phạm Thị D', 'phamthid@gmail.com', '123456'),
('Hoàng Văn E', 'hoangvane@gmail.com', '123456');

-- Tạo bảng restaurant 
CREATE TABLE restaurant (
    res_id INT PRIMARY KEY AUTO_INCREMENT,
    res_name VARCHAR(50),
    image VARCHAR(255),
    description TEXT
);

-- Thêm dữ liệu cho bảng restaurant
INSERT INTO restaurant (res_name, image, description) VALUES
('Nhà hàng A', 'https://picsum.photos/200/300', 'Nhà hàng chuyên đồ Á'),
('Nhà hàng B', 'https://picsum.photos/200/300', 'Nhà hàng chuyên đồ Âu'), 
('Nhà hàng C', 'https://picsum.photos/200/300', 'Nhà hàng buffet'),
('Nhà hàng D', 'https://picsum.photos/200/300', 'Nhà hàng hải sản');

-- Tạo bảng rate_res
CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Thêm dữ liệu cho bảng rate_res
INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
(1, 1, 5, '2024-01-01 10:00:00'),
(2, 1, 4, '2024-01-02 11:00:00'),
(3, 2, 5, '2024-01-03 12:00:00'),
(4, 3, 3, '2024-01-04 13:00:00');

-- Tạo bảng like_res  
CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Thêm dữ liệu cho bảng like_res
INSERT INTO like_res (user_id, res_id, date_like) VALUES
(1, 1, '2024-01-01 10:00:00'),
(2, 1, '2024-01-02 11:00:00'),
(3, 2, '2024-01-03 12:00:00'),
(4, 2, '2024-01-04 13:00:00'),
(5, 3, '2024-01-05 14:00:00');

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

-- Thêm dữ liệu cho bảng food_type
INSERT INTO food_type (type_name) VALUES
('Món chính'),
('Món phụ'),
('Tráng miệng'),
('Đồ uống');

-- Thêm dữ liệu cho bảng food
INSERT INTO food (food_name, image, price, description, type_id) VALUES
('Cơm gà', 'https://picsum.photos/200/300', 50000, 'Cơm gà xối mỡ', 1),
('Phở bò', 'https://picsum.photos/200/300', 60000, 'Phở bò tái nạm', 1),
('Trà sữa', 'https://picsum.photos/200/300', 30000, 'Trà sữa trân châu', 4),
('Bánh flan', 'https://picsum.photos/200/300', 20000, 'Bánh flan caramel', 3);

-- Tạo bảng sub_food
CREATE TABLE sub_food (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(50),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Thêm dữ liệu cho bảng sub_food
INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Thêm trân châu', 5000, 3),
('Thêm thịt gà', 10000, 1),
('Thêm thịt bò', 15000, 2),
('Thêm trứng', 5000, 1);

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

-- Thêm dữ liệu cho bảng orders
INSERT INTO orders (user_id, food_id, amount, code, arr_sub_id) VALUES
(1, 1, 2, 'ORDER001', '2,4'),
(2, 2, 1, 'ORDER002', '3'),
(3, 3, 3, 'ORDER003', '1'),
(4, 4, 2, 'ORDER004', NULL);

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