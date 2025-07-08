-- SQL PRACTICE QUESTIONS 20 OF 100+ SERIES -- 
create database rkt;
use rkt;
CREATE TABLE employees1 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT,
    dept_id INT,
    salary DECIMAL(10, 2)
    
);

INSERT INTO employees1 VALUES
(1, 'Alice', NULL, 10, 90000),
(2, 'Bob', 1, 10, 80000),
(3, 'Charlie', 1, 20, 70000),
(4, 'David', 2, NULL, 75000),
(5, 'Eva', 3, 20, 60000),
(6, 'Frank', 3, 30, 72000),
(7, 'Grace', 2, 30, 95000);
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    emp_id INT
);

INSERT INTO projects VALUES
(101, 'Recruitment Drive', 1),
(102, 'Payroll Automation', 2),
(103, 'Website Redesign', 3),
(104, 'App Development', 6);
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

INSERT INTO departments VALUES
(10, 'HR'),
(20, 'IT'),
(30, 'Finance'),
(40, 'Marketing');
CREATE TABLE products (
    prod_id INT PRIMARY KEY,
    name VARCHAR(100),
    supp_id INT,
    price DECIMAL(10, 2)
);

INSERT INTO products VALUES
(1, 'Laptop', 201, 60000),
(2, 'Mouse', 202, 500),
(3, 'Keyboard', NULL, 700),
(4, 'Monitor', 204, 12000);
CREATE TABLE suppliers (
    supp_id INT PRIMARY KEY,
    supp_name VARCHAR(100)
);

INSERT INTO suppliers VALUES
(201, 'TechZone'),
(202, 'GadgetHub'),
(203, 'OfficeMart'),
(204, 'CompWorld');
CREATE TABLE customers (
    cust_id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO customers VALUES
(1, 'Ravi'),
(2, 'Priya'),
(3, 'Anil'),
(4, 'Meena');
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    cust_id INT,
    amount DECIMAL(10, 2),
    order_date DATE
);

INSERT INTO orders VALUES
(1001, 1, 2500, '2025-07-01'),
(1002, 2, 4000, '2025-07-01'),
(1003, 1, 1500, '2025-07-02'),
(1004, 3, 3000, '2025-07-02');
CREATE TABLE sales (
    prod_id INT,
    amount DECIMAL(10, 2),
    category_id INT
);

INSERT INTO sales VALUES
(1, 50000, 100),
(2, 3000, 100),
(3, 7000, 101),
(4, 20000, 101),
(1, 15000, 100),
(3, 5000, 101);
-- JOINS-- 
-- Ans1--
select e.emp_id, e.name, e.dept_id,d.dept_name from employees1 as e
inner join departments as d on d.dept_id=e.dept_id;
-- Ans2-- 
select e1.emp_id,e1.name,e1.manager_id from employees1 as e1
join employees1 as e2 on e1.emp_id=e2.emp_id;
-- Ans3-- 
select e.name,p.project_name from employees1 as e
left join projects as p on p.emp_id=e.emp_id;
-- Ans 4-- 
select p.name,s.supp_name from products as p
right join suppliers as s on p.supp_id=s.supp_id;
-- Ans5--
select  c.name,o.order_id from customers as c
left join orders as o on c.cust_id=o.cust_id;
-- Ans6-- 
select e.name,d.dept_name from employees1 as e
left join departments as d on d.dept_id=e.dept_id;
-- Ans7--
 select e.emp_id, e.name, e.dept_id,d.dept_name from employees1 as e
left join departments as d on d.dept_id=e.dept_id
union
 select e.emp_id, e.name, e.dept_id,d.dept_name from employees1 as e
right join departments as d on d.dept_id=e.dept_id;
-- Window Functions-- 
-- Ans8-- 
with ranked_salary as
(select emp_id,name,salary,dept_id,rank() over (partition by dept_id order by salary desc) as rk from employees1)
select emp_id,name,salary,dept_id,rk from ranked_salary
where rk=1;
-- Ans9-- 
select l.emp_id,l.name,l.salary,l.dept_id,l.drg from
(select e.emp_id,e.name,e.salary,e.dept_id,avg(salary) over (partition by dept_id) as drg from employees1 as e) as l;
-- Ans10-- 
select order_id,cust_id,amount,order_date,total from
(select o.order_id,cust_id,amount,order_date,sum(o.amount) over(partition by cust_id) as total from orders as o) as c;
-- Ans11-- 
select emp_id,name,dept_id,salary,salary-lag(salary) over (partition by dept_id order by emp_id desc)
from employees1 as e;
-- Ans12-- 
select order_date,count(order_id) over (partition by order_date ) as total_orders from orders;
-- ans13-- 
select prod_id,min(price) over (partition by prod_id) as minimum,max(price) over (partition by prod_id) as minimum from products;
-- Ans14-- 
select emp_id,dept_id,salary,row_number() over(partition by dept_id order by salary desc) from employees1;
-- [CTE[COMMON TERM EXPRESSIONS]-- 
-- Ans15-- 
with highest_salary as(select emp_id,name,salary from employees1 order by salary desc limit 3)
select * from highest_salary ;
-- Ans16-- 
with recursive numbers as(
     select 1 as num
     union all 
     select num + 1
     from numbers
     where num <10
)
select * from numbers;
-- Ans17-- 
with ctw as (select emp_id,salary,name from employees1 as e1)
select emp_id,salary from ctw
where salary>(select avg(salary) from ctw);
-- Ans18-- 
with ct as (select dept_id,avg(salary) as t from employees1 as e1 group by dept_id)
select * from ct
where t > 50000; 
-- Ans19--
WITH RECURSIVE employee_hierarchy AS (
    -- Anchor member: Start with the given manager
    SELECT 
        emp_id, 
        name, 
        manager_id,
        1 AS level
    FROM 
        employees1
    WHERE 
        emp_id = 1  -- 👈 Replace with the root manager's ID

    UNION ALL

    -- Recursive member: Get direct reports of previous level
    SELECT 
        e.emp_id, 
        e.name, 
        e.manager_id,
        eh.level + 1 AS level
    FROM 
        employees1 e
    INNER JOIN 
        employee_hierarchy eh ON e.manager_id = eh.emp_id
)

SELECT * 
FROM employee_hierarchy
ORDER BY level;
-- Ans20-- 
with rt as ( select prod_id,amount,category_id, rank() over( partition by category_id order by amount desc) as rank1 from sales as s)
select * from rt
where rank1<=3;
		     
 