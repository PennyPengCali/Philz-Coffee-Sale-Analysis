CREATE DATABASE Final_Project;
USE Final_Project;

######### Part_I Table Creation
#1. create customer table
CREATE TABLE customer(
customer_id INT NOT NULL AUTO_INCREMENT,
customer_first  VARCHAR(45),
cutomer_last  VARCHAR(45),
customer_phone VARCHAR(45),
customer_email VARCHAR(45),
CONSTRAINT customer_PK PRIMARY KEY (customer_id)
);

#2. create store table
CREATE TABLE store (
store_id int NOT NULL,
store_address varchar(50),
store_phone varchar(15),
CONSTRAINT store_PK PRIMARY KEY (store_id)
);

#3. create employee table
CREATE TABLE employee (
employee_id INT NOT NULL,
employee_first VARCHAR(45),
employee_last VARCHAR(45),
employee_type VARCHAR(5),
store_id INT,
CONSTRAINT employee_PK PRIMARY KEY (employee_id),
CONSTRAINT employee_FK FOREIGN KEY (store_id) REFERENCES store (store_id)
);

#4. create a feedback table
CREATE TABLE feedback (
feedback_id INT NOT NULL,
feedback_rating DOUBLE,
feedback_comment varchar(100),
customer_id int,
CONSTRAINT feedback_PK PRIMARY KEY (feedback_id),
CONSTRAINT feedback_FK FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

#5. create a food table
CREATE TABLE food (
food_id int NOT NULL,
food_name varchar(50),
food_type varchar(20),
food_price DOUBLE,
food_description varchar(50),
CONSTRAINT food_PK PRIMARY KEY (food_id)
);

#6. create an order table
CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE,
order_day VARCHAR(15),
customer_id INT,
employee_id INT,
CONSTRAINT orders_PK PRIMARY KEY (order_id),
CONSTRAINT orders_customer_FK FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
CONSTRAINT orders_employee_FK FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);

#7. create an orderline table
CREATE TABLE orderline(
line_id INT NOT NULL,
quantity INT,
price DECIMAL(10,2),
order_id INT,
food_id INT,
CONSTRAINT orderline_PK PRIMARY KEY (line_id),
CONSTRAINT orderline_food_FK FOREIGN KEY (food_id) REFERENCES food (food_id),
CONSTRAINT orderline_order_FK FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

#8. create a payment table
CREATE TABLE payment (
payment_id INT NOT NULL,
payment_method VARCHAR(15),
payment_total DOUBLE,
payment_tip DOUBLE,
order_id INT,
CONSTRAINT payment_PK PRIMARY KEY (payment_id),
CONSTRAINT payment_FK FOREIGN KEY (order_employeeid) REFERENCES orders (order_id)
);

############ SQL Queries - Without Joins
#1. What item is the most expensive?
SELECT *
FROM food
where food_price = (SELECT MAX(food_price) from food);

#2. Which day is the busiest day during the week?
SELECT order_day, count(order_day) as 'Orders'
FROM orders GROUP BY order_day
ORDER BY Orders DESC;

#3. What are the total orders of each payment method?
SELECT payment_method,COUNT(payment_method)
FROM payment 
GROUP BY 
payment_method;

#4. What’s the average feedback rating on all Philz coffee shop?
SELECT avg(feedback_rating) AS 'Average Rating'
FROM feedback;

############## SQL Queries - With Joins
#1. Which Philz Coffee shop has the most orders?
SELECT s.store_address , COUNT(s.store_address) AS Orders
from Orders o 
JOIN Employee e 
ON o.employee_id = e.employee_id 
JOIN Store s 
ON e.store_id = s.store_id 
GROUP BY s.store_address;

#2. What’s the average feedback rating for each store?
SELECT s.store_address , round (avg(feedback_rating), 2) AS Rating
FROM Feedback f 
INNER JOIN
Orders o
ON f.customer_id = o.customer_id 
INNER JOIN Employee e 
ON o.employee_id = e.employee_id 
INNER JOIN Store s 
ON e.store_id = s.store_id 
GROUP BY s.store_address;

#3. What are the customer feedback comments of each store?
SELECT store_address, feedback_comment
FROM feedback f, orders o, employee e, store s
WHERE f.customer_id = o.customer_id
AND o.employee_id = e.employee_id
AND e.store_id = s.store_id
ORDER BY s.tore_address;

#4. Which customer placed the highest total orders?
SELECT   CONCAT(customer.customer_first,' ', customer.customer_last) AS name, COUNT(*) AS 'total_orders'
FROM customer INNER JOIN orders
WHERE orders.customer_id = customer.customer_id
GROUP BY name
ORDER BY total_orders DESC;


#5. How many orders were placed on each item?
SELECT food_name,COUNT(*) AS 'Orders'
FROM food, orders, orderline
WHERE food.food_id = orderline.food_id
AND orderline.order_id = orders.order_id
GROUP BY food_name
ORDER BY Orders DESC;






