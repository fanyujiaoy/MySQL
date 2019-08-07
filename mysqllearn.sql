# 第1课 安装MySQL数据库
/*
1. 下载MySQL8.0压缩包解压
2. 配置Path环境变量
3. 解压的文件夹中创建my.ini文件
4. 以管理员的方式打开CMD，cd到解压后的MySQL的bin目录
5. 初始化MySQL获取初始密码：mysqld --initialize-insecure --user=mysql
6. 安装服务：mysqld --install
7. 开启连接：net start mysql
8. 登录SQL：mysql -u root -p
9. 修改密码：alter user 'root'@'localhost' identified by 'MyNewPass';
*/
# 当前可运行SQL基于MySQL数据库
# 第2课 检索数据
# 查询指定列
SELECT prod_name FROM products;
SELECT prod_id, prod_name, prod_price
FROM products;
# 查询所有
SELECT * FROM products;

# DISTINCT 关键字，只返回不同（具有唯一性）的值
SELECT DISTINCT vend_id FROM products;

# 限制结果 
# 取前5行
SELECT prod_name FROM products LIMIT 5;
/*
SQL Server和Access
SELECT TOP 5 prod_name FROM products;

DB2
SELECT prod_name FROM products
FETCH FIRST 5 ROWS ONLY;

Oracle
SELECT prod_name FROM products
WHERE ROWNUM <=5;

MySQL、MariaDB、PostgreSQL 或者SQLite
SELECT prod_name FROM products LIMIT 5;
*/
# 返回从第5行起的5行数据，结果显示只有5行。第一个数字是检索的行数，第二个数字是指从哪儿开始。
# LIMIT 1 OFFSET 1 检索的是第2行，不是第1行。因为第一个被检索的行是第0行开始。如果想返回第一行，就是LIMIT 1 OFFSET 0
SELECT prod_name FROM products
LIMIT 3 OFFSET 5;
SELECT prod_name FROM products
LIMIT 5,3;

#第3课 排序检索数据
SELECT prod_name FROM products
ORDER BY prod_name;

SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price, prod_name;
# 上下SQL语句的查询结果一样
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY 2, 3;

# 降序 DESC（最贵的排在最前面），一般默认为升序，ASC
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC;

SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC, prod_name;

# 第4课 过滤数据
# 使用WHERE字句，3.49和3.4900 是一样的
# ORDER BY 位于 WHERE 之后
/*操作符		说明
= 					等于       
< > 				不等于   
!= 					不等于 	 
< 					小于 				
<= 					小于等于 
!< 					不小于
> 					大于
>= 					大于等于
!> 					不大于
BETWEEN 		在指定的两个值之间
IS NULL 		为NULL值*/
SELECT prod_name, prod_price
FROM products
WHERE prod_price = 3.49;

# 检查单个值
SELECT prod_name, prod_price
FROM products
WHERE prod_price < 10;

SELECT prod_name, prod_price
FROM products
WHERE prod_price <= 10;

# 不匹配检查
SELECT vend_id, prod_name
FROM products
WHERE vend_id <> 'DLL01';

SELECT vend_id, prod_name
FROM products
WHERE vend_id != 'DLL01';

# 范围值检查，包含5和10
SELECT prod_name, prod_price
FROM products
WHERE prod_price BETWEEN 5 AND 10;

# 空值检查
SELECT prod_name FROM products
WHERE prod_price IS NULL;

SELECT cust_name
FROM Customers
WHERE cust_email IS NULL;

# 第5课 高级数据过滤
SELECT prod_id, prod_price, prod_name
FROM products
WHERE vend_id = 'DLL01' AND prod_price <= 4;

# OR 操作符
SELECT prod_name, prod_price
FROM products
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01';

# 求值顺序 在处理OR 操作符前，优先处理AND 操作符
# 由供应商BRS01 制造的价格为10 美元以上的所有产品，以及由供应商DLL01 制造的所有产品，而不管其价格如何。
# 换句话说，由于AND 在求值过程中优先级更高，操作符被错误地组合了
SELECT prod_name, prod_price
FROM products
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01'
AND prod_price >= 10;

# 圆括号具有比AND 或OR 操作符更高的求值顺序，所以DBMS首先过滤圆括号内的OR条件
SELECT prod_name, prod_price
FROM products
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01')
AND prod_price >= 10;

# IN 操作符
SELECT prod_name, prod_price
FROM products
WHERE vend_id IN ( 'DLL01', 'BRS01' )
ORDER BY prod_name;
# 上下SQL语句的查询结果一样，IN 操作符一般比一组OR 操作符执行得更快
SELECT prod_name, prod_price
FROM products
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01'
ORDER BY prod_name;

# NOT 操作符 有且只有一个功能，那就是否定其后所跟的任何条件
SELECT prod_name FROM products
WHERE NOT vend_id = 'DLL01'
ORDER BY prod_name;
# 上下SQL语句的查询结果一样
SELECT prod_name FROM products
WHERE vend_id <> 'DLL01'
ORDER BY prod_name;

# 第6课 用通配符进行过滤
# LIKE 操作符 根据DBMS的不同及其配置，搜索可以是区分大小写的。
# 百分号（%）通配符
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE 'Fish%';

SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '%bean bag%';

SELECT prod_name
FROM products
WHERE prod_name LIKE 'F%y%';

# 下划线（_）通配符，下划线的用途与%一样，但它只匹配单个字符，而不是多个字符。一个字符是_，两个是__，以此类推
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '__ inch teddy bear';

SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '% inch teddy bear';

# 方括号（[]）通配符用来指定一个字符集，它必须匹配指定位置（通配符的位置）的一个字符。
SELECT cust_contact FROM customers
WHERE cust_contact LIKE '[JM]%'
ORDER BY cust_contact;
# 上下SQL语句的查询结果相反
SELECT cust_contact FROM customers
WHERE cust_contact LIKE '[^JM]%'
ORDER BY cust_contact;
# 上下SQL语句的查询结果一样
SELECT cust_contact FROM customers
WHERE NOT cust_contact LIKE '[JM]%'
ORDER BY cust_contact;

# 第7课 创建计算字段
# 拼接字段 CONCAT，使用别名 AS
/* 其它DBMS
SELECT vend_name + ' (' + vend_country + ')'
FROM vendors
ORDER BY vend_name;
# 上下SQL语句的查询结果一样
SELECT vend_name || ' (' || vend_country || ')'
FROM vendors
ORDER BY vend_name;
*/
SELECT CONCAT(vend_name, ' (', vend_country, ')') AS new_name
FROM vendors
ORDER BY vend_name;

# 去空格
/* 其它DBMS
SELECT RTRIM(vend_name) + ' (' + RTRIM(vend_country) + ')'
FROM vendors
ORDER BY vend_name;
# 上下SQL语句的查询结果一样
SELECT RTRIM(vend_name) || ' (' || RTRIM(vend_country) || ')'
FROM vendors
ORDER BY vend_name;
*/

# 执行算术计算
/*操作符 说明
		+ 		加
		- 		减
		* 		乘
		/ 		除
*/
SELECT 1+1 AS jia;
SELECT 2-1 AS jian;
SELECT 2*2 AS cheng;
SELECT 4/2 AS chu;

# 第8课 使用函数处理数据
# 文本处理函数
/*函数 																					说明
LEFT()（或使用子字符串函数） 						返回字符串左边的字符
LENGTH()（也使用DATALENGTH()或LEN()） 	返回字符串的长度
LOWER()（Access使用LCASE()） 						将字符串转换为小写
LTRIM() 																去掉字符串左边的空格
RIGHT()（或使用子字符串函数） 					返回字符串右边的字符
RTRIM() 																去掉字符串右边的空格
SOUNDEX() 															返回字符串的SOUNDEX值
UPPER()（Access使用UCASE()） 						将字符串转换为大写
*/
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM vendors
ORDER BY vend_name;

# 入系统的是Michelle Green，实际上应该是Michael Green，根据Michael Green去查，结果为空
SELECT cust_name, cust_contact
FROM customers
WHERE cust_contact = 'Michael Green';

# 于是用SOUNDEX函数，匹配所有发音类似于Michael Green 的联系名
SELECT cust_name, cust_contact,SOUNDEX(cust_contact) AS new_cust_contact,SOUNDEX('Michael Green') AS new_mg
FROM customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

# 日期和时间处理函数
/*其它DBMS
SELECT order_num FROM orders
WHERE DATEPART(yy, order_date) = 2012;
# 上下SQL语句的查询结果一样
SELECT order_num FROM orders
WHERE DATEPART('yyyy', order_date) = 2012;
# 上下SQL语句的查询结果一样
SELECT order_num FROM orders
WHERE DATE_PART('year', order_date) = 2012;
# 上下SQL语句的查询结果一样
SELECT order_num FROM orders
WHERE to_number(to_char(order_date, 'YYYY')) = 2012;
# 上下SQL语句的查询结果一样
SELECT order_num FROM orders
WHERE strftime('%Y', order_date) = '2012';
*/
SELECT order_num FROM orders
WHERE YEAR(order_date) = 2012;

SELECT order_num FROM orders
WHERE DATE_FORMAT(order_date, '%Y') = 2012;

SELECT order_num FROM orders
WHERE DATE_FORMAT(order_date, '%Y%m') = 201201;

# 数值函数处理
/*函数 					说明
ABS() 		返回一个数的绝对值
COS() 		返回一个角度的余弦
EXP() 		返回一个数的指数值
PI() 			返回圆周率
SIN() 		返回一个角度的正弦
SQRT() 		返回一个数的平方根
TAN() 		返回一个角度的正切
*/
SELECT PI() AS PI

# 第9课 汇总数据
# 聚集函数
/*函数 				说明
AVG() 		返回某列的平均值
COUNT() 	返回某列的行数
MAX() 		返回某列的最大值
MIN() 		返回某列的最小值
SUM() 		返回某列值之和
*/

# AVG() 只用于单个列，忽略列值为NULL的行
SELECT AVG(prod_price) AS avg_price
FROM products;

SELECT AVG(prod_price) AS avg_price
FROM products
WHERE vend_id = 'DLL01';

# COUNT(*)		  对表中行的数目进行计数，不管表列中包含的是空值（NULL）还是非空值
# COUNT(column) 对特定列中具有值的行进行计数，忽略NULL 值
SELECT COUNT(*) AS num_cust
FROM customers;

# 有两行数据为NULL，所以只有3条
SELECT COUNT(cust_email) AS num_cust
FROM Customers;

SELECT * FROM customers;

# MAX() 最大的数值或日期值，忽略列值为NULL 的行
# 在用于文本数据时，MAX()返回该列排序后的最后一行
# MIN() 最小的数值或日期值，忽略列值为NULL 的行
# 在用于文本数据时，MIN()返回该列排序后最前面的行
SELECT MAX(prod_price) AS max_price
FROM products;

SELECT MIN(prod_price) AS min_price
FROM products;

# SUM()函数忽略列值为NULL 的行
SELECT SUM(quantity) AS items_ordered
FROM orderitems
WHERE order_num = 20005;

SELECT SUM(item_price*quantity) AS total_price
FROM orderitems
WHERE order_num = 20005;

# 聚集不同值
SELECT DISTINCT prod_price AS avg_price
FROM products
WHERE vend_id = 'DLL01';

# 之前AVG的结果是3.865000，现在有了DISTINCT是4.240000
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM products
WHERE vend_id = 'DLL01';

# 组合聚集函数
SELECT COUNT(*) AS num_items,
MIN(prod_price) AS price_min,
MAX(prod_price) AS price_max,
AVG(prod_price) AS price_avg
FROM products;

# 第10课 分组数据
# GROUP BY 创建分组
# GROUP BY 子句中列出的每一列都必须是检索列或有效的表达式（但不能是聚集函数）
# 如果分组列中包含具有NULL 值的行，则NULL 将作为一个分组返回。如果列中有多行NULL 值，它们将分为一组
# GROUP BY 子句必须出现在WHERE 子句之后，ORDER BY 子句之前
SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id;

# HAVING 过滤分组，过滤COUNT(*) >= 2（两个以上订单）的那些分组
SELECT cust_id, COUNT(*) AS orders
FROM orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;

SELECT * FROM products;
# 具有两个以上产品且其价格大于等于4 的供应商
SELECT vend_id, COUNT(*) AS num_prods
FROM products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;

SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id
HAVING COUNT(*) >= 2;

# 分组和排序
/*ORDER BY与GROUP BY的差别
ORDER BY 																GROUP BY
对产生的输出排序 							  对行分组，但输出可能不是分组的顺序
任意列都可以使用（甚至非			  只可能使用选择列或表达式列，
选择的列也可以使用）						而且必须使用每个选择列表达式
不一定需要 											如果与聚集函数一起使用列（或表达式），则必须使用
*/
# 按订购物品的数目排序输出
SELECT order_num, COUNT(*) AS items
FROM orderitems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;

# SELECT 子句顺序
/*SELECT子句及其顺序
子句 					说明 								是否必须使用
SELECT			要返回的列或表达式 			是
FROM 				从中检索数据的表 				仅在从表选择数据时使用
WHERE 			行级过滤 								否
GROUP BY 		分组说明 								仅在按组计算聚集时使用
HAVING			组级过滤 								否
ORDER BY		输出排序顺序						否
*/

# 第11课 使用子查询
/*假如需要列出订购物品RGAN01 的所有顾客
(1) 检索包含物品RGAN01 的所有订单的编号。
(2) 检索具有前一步骤列出的订单编号的所有顾客的ID。
(3) 检索前一步骤返回的所有顾
*/
SELECT order_num
FROM orderitems
WHERE prod_id = 'RGAN01';

SELECT cust_id
FROM orders
WHERE order_num IN (20007,20008);

# 合并上面的语句
SELECT cust_id FROM orders WHERE order_num IN (
SELECT order_num FROM OrderItems WHERE prod_id='RGAN01');

SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN ('1000000004','1000000005');

# 合并上面的语句
SELECT cust_name,cust_contact FROM customers WHERE cust_id IN (
SELECT cust_id FROM orders WHERE order_num IN (
SELECT order_num FROM orderitems WHERE prod_id='RGAN01'));

# 作为计算字段使用子查询
/*假如需要显示Customers 表中每个顾客的订单总数。
订单与相应的顾客ID 存储在orders 表中。
执行这个操作，要遵循下面的步骤：
(1) 从customers 表中检索顾客列表；
(2) 对于检索出的每个顾客，统计其在Orders 表中的订单数目。
*/
SELECT COUNT(*) AS orders
FROM orders
WHERE cust_id = '1000000001';

# 完全限定列名就是指定表名和列名，如orders.cust_id
SELECT cust_name,cust_state,
(SELECT COUNT(*) FROM orders WHERE =customers.cust_id) AS orders 
FROM customers ORDER BY cust_name;

# 第12课 联结表
# 等值联结（equijoin）
SELECT vend_name, prod_name, prod_price
FROM vendors, products
WHERE vendors.vend_id = products.vend_id;

/*笛卡儿积（cartesian product）
由没有联结条件的表关系返回的结果为笛卡儿积。检索出的行的数目将是第一个表中的行数乘以第二个表中的行数。
有时，返回笛卡儿积的联结，也称叉联结（cross join）。
*/
SELECT * FROM vendors;
SELECT * FROM products;
SELECT vend_name, prod_name, prod_price
FROM vendors, products;

# 内联结（inner join）
SELECT vend_name, prod_name, prod_price
FROM vendors 
INNER JOIN products ON vendors.vend_id = products.vend_id;

# 联结多个表
SELECT prod_name, vend_name, prod_price, quantity
FROM orderitems, products, vendors
WHERE products.vend_id = vendors.vend_id
  AND orderitems.prod_id = products.prod_id
  AND order_num = 20007;

# 性能考虑
SELECT cust_name,cust_contact FROM customers WHERE cust_id IN (
SELECT cust_id FROM orders WHERE order_num IN (
SELECT order_num FROM orderitems WHERE prod_id='RGAN01'));
# 上下SQL语句的查询结果一样
SELECT cust_name, cust_contact
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
	AND orderitems.order_num = orders.order_num
	AND prod_id = 'RGAN01';

# 第13课 创建高级联结
SELECT cust_name, cust_contact
FROM customers AS C, orders AS O, orderitems AS OI
WHERE C.cust_id = O.cust_id
AND OI.order_num = O.order_num
AND OI.prod_id = 'RGAN01';

# 自联结
SELECT cust_id,cust_name,cust_contact FROM customers WHERE cust_name=(
SELECT cust_name FROM customers WHERE cust_contact='Jim Jones');
# 上下SQL语句的查询结果一样
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM customers AS c1, customers AS c2
WHERE c1.cust_name = c2.cust_name
AND c2.cust_contact = 'Jim Jones';

# 自然联结
SELECT C.*, O.order_num, O.order_date,OI.prod_id, OI.quantity, OI.item_price
FROM customers AS C, orders AS O, orderitems AS OI
WHERE C.cust_id = O.cust_id
  AND OI.order_num = O.order_num
  AND prod_id = 'RGAN01';

# 外联结 
/*
在使用OUTER JOIN 语法时，必须使用RIGHT 或LEFT 关键字指定包括其所有行的表
（RIGHT 指出的是OUTER JOIN 右边的表，而LEFT 指出的是OUTER JOIN左边的表）
*/
SELECT customers.cust_id, orders.order_num
FROM customers 
LEFT OUTER JOIN orders ON customers.cust_id = orders.cust_id;

SELECT customers.cust_id, orders.order_num
FROM customers 
RIGHT OUTER JOIN orders ON orders.cust_id = customers.cust_id;

# 全外联结（full outer join），它检索两个表中的所有行并关联那些可以关联的行
# Access、MariaDB、MySQL、Open Office Base 和SQLite 不支持FULLOUTER JOIN 语法。
/*其它DBMS
SELECT customers.cust_id, orders.order_num
FROM orders 
FULL OUTER JOIN customers ON orders.cust_id = customers.cust_id;
*/

# 使用带聚集函数的联结
# 检索所有顾客及每个顾客所下的订单数
SELECT customers.cust_id,COUNT(orders.order_num) AS num_ord
FROM customers 
INNER JOIN orders ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id;

SELECT customers.cust_id,COUNT(orders.order_num) AS num_ord
FROM customers 
LEFT OUTER JOIN orders ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id;

# 第14课 组合查询
/*UNION 规则
UNION 中的每个查询必须包含相同的列、表达式或聚集函数（不过，各个列不需要以相同的次序列出）
列数据类型必须兼容：类型不必完全相同，但必须是DBMS 可以隐含转换的类型（例如，不同的数值类型或不同的日期类型）。
*/
# 使用UNION 过滤重复行
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_name = 'Fun4All';
# 上下SQL语句的查询结果一样
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_state IN ('IL','IN','MI') OR cust_name = 'Fun4All';

# 使用UNION ALL 不过滤重复行，显示两个查询语句的全部结果
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_state IN ('IL','IN','MI')
UNION ALL
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_name = 'Fun4All';

# 对组合查询结果排序
# 虽然ORDERBY 子句似乎只是最后一条SELECT 语句的组成部分，但实际上DBMS 将用它来排序所有SELECT 语句返回的所有结果。
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_state IN ('IL','IN','MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;

# 第15课 插入数据
# 插入完整的行
/*其它DBMS
INSERT INTO VALUES ('1000000106','Toy Land','123 Any Street','New York','NY','11111','USA',NULL,NULL);
*/
SELECT * FROM customers;
INSERT INTO customers (cust_id,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country,cust_contact,cust_email) 
							 VALUES ('1000000206','Toy Land','123 Any Street','New York','NY','11111','USA',NULL,NULL);
							 
INSERT INTO customers (cust_id,cust_contact,cust_email,cust_name,cust_address,cust_city,cust_state,cust_zip) 
							 VALUES ('1000000306',NULL,NULL,'Toy Land','123 Any Street','New York','NY','11111');
							 
# 插入部分行，省略部分列
INSERT INTO customers (cust_id,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country) 
							 VALUES ('1000000406','Toy Land','123 Any Street','New York','NY','11111','USA');

# 插入检索出的数据
INSERT INTO customers (cust_id,cust_contact,cust_email,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country)
SELECT 1000000506 AS cust_id,cust_contact,cust_email,cust_name,cust_address,cust_city,cust_state,cust_zip,cust_country 
FROM customers WHERE cust_id=1000000001;

# 从一个表复制到另一个表 SELECT INTO
/*说明：INSERT SELECT 与SELECT INTO
它们之间的一个重要差别是前者插入数据，而后者导出数据。
*/
/*其它DBMS
SELECT * INTO custcopy FROM customers;
*/
CREATE TABLE custcopy AS SELECT * FROM customers;

SELECT * FROM custcopy;

# 第16课 更新和删除数据
SELECT * FROM customers;
# 更新数据 UPDATE
UPDATE customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = '1000000005';

UPDATE customers
SET cust_email = NULL
WHERE cust_id = '1000000005';

# 更新多个列
UPDATE customers
SET cust_contact = 'Sam Roberts',
			cust_email = 'sam@toyland.com'
WHERE cust_id = '1000000206';

# 删除数据 DELETE
DELETE FROM customers
WHERE cust_id = '1000000206';

# 第17课 创建和操纵表
# 创建表 CREATE TABLE
/*其它DBMS
CREATE TABLE newproducts
(
	prod_id CHAR(10) NOT NULL,
	vend_id CHAR(10) NOT NULL,
	prod_name CHAR(254) NOT NULL,
	prod_price DECIMAL(8,2) NOT NULL,
	prod_desc VARCHAR(1000) NULL
);
*/
CREATE TABLE newproducts
(
	prod_id CHAR(10) NOT NULL,
	vend_id CHAR(10) NOT NULL,
	prod_name CHAR(254) NOT NULL,
	prod_price DECIMAL(8,2) NOT NULL,
	prod_desc TEXT NULL
);

# 使用NULL值
CREATE TABLE neworders
(
	order_num INTEGER NOT NULL,
	order_date DATETIME NOT NULL,
	cust_id CHAR(10) NOT NULL
);

# 混合了NULL 和NOT NULL
CREATE TABLE newvendors
(
	vend_id CHAR(10) NOT NULL,
	vend_name CHAR(50) NOT NULL,
	vend_address CHAR(50) ,
	vend_city CHAR(50) ,
	vend_state CHAR(5) ,
	vend_zip CHAR(10) ,
	vend_country CHAR(50)
);

# 指定默认值
CREATE TABLE neworderitems
(
	order_num INTEGER NOT NULL,
	order_item INTEGER NOT NULL,
	prod_id CHAR(10) NOT NULL,
	quantity INTEGER NOT NULL DEFAULT 1,
	item_price DECIMAL(8,2) NOT NULL
);

/*获得系统日期
DBMS 				函数/变量
Access 				NOW()
DB2 					CURRENT_DATE
MySQL 				CURRENT_DATE()
Oracle 				SYSDATE
PostgreSQL 		CURRENT_DATE
SQL Server 		GETDATE()
SQLite 				date('now')
*/

# 更新表 ALTER TABLE
# 使用ALTER TABLE 要极为小心，应该在进行改动前做完整的备份（表结构和数据的备份）。
SELECT * FROM newvendors;

# 增加一个名为vend_phone 的列，其数据类型为CHAR
ALTER TABLE newvendors
ADD vend_phone CHAR(20);

/*复杂的表结构更改一般需要手动删除过程，它涉及以下步骤：
(1) 用新的列布局创建一个新表；
(2) 使用INSERT SELECT 语句（关于这条语句的详细介绍，请参阅第15课）从旧表复制数据到新表。有必要的话，可以使用转换函数和计算字段；
(3) 检验包含所需数据的新表；
(4) 重命名旧表（如果确定，可以删除它）；
(5) 用旧表原来的名字重命名新表；
(6) 根据需要，重新创建触发器、存储过程、索引和外键。
*/

# 删除表 DROP TABLE
DROP TABLE custcopy;

# 第18课 使用视图
/*视图规则
与表一样，视图必须唯一命名
对于可以创建的视图数目没有限制。
*/
# 创建视图 CREATE VIEW
CREATE VIEW productcustomers AS
SELECT cust_name, cust_contact, prod_id
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
AND orderitems.order_num = orders.order_num;

SELECT cust_name, cust_contact
FROM productcustomers
WHERE prod_id = 'RGAN01';

# 用视图重新格式化检索出的数据
CREATE VIEW vendorlocations AS
SELECT CONCAT(vend_name, ' (', vend_country, ')') AS new_name
FROM vendors
ORDER BY vend_name;

SELECT * FROM vendorlocations;

# 用视图过滤不想要的数据
CREATE VIEW customeremailList AS
SELECT cust_id, cust_name, cust_email
FROM customers
WHERE cust_email IS NOT NULL;

SELECT * FROM customeremailList;

# 使用视图与计算字段
CREATE VIEW orderitemsexpanded AS
SELECT order_num,prod_id,quantity,item_price
,quantity*item_price AS expanded_price 
FROM orderitems;

SELECT * FROM orderitemsexpanded
WHERE order_num = 20008;

# 第19课 使用存储过程
/*其它DBMS
-------------------------------------
Oracle：
CREATE PROCEDURE MailingListCount (
	ListCount OUT INTEGER
)
IS
v_rows INTEGER;
BEGIN
	SELECT COUNT(*) INTO v_rows
	FROM Customers
	WHERE NOT cust_email IS NULL;
	ListCount := v_rows;
END;
调用：
var ReturnValue NUMBER
EXEC MailingListCount(:ReturnValue);
SELECT ReturnValue;
-------------------------------------
SQL Server：
CREATE PROCEDURE MailingListCount
AS
DECLARE @cnt INTEGER
SELECT @cnt = COUNT(*)
FROM Customers
WHERE NOT cust_email IS NULL;
RETURN @cnt;
调用:
DECLARE @ReturnValue INT
EXECUTE @ReturnValue=MailingListCount;
SELECT @ReturnValue;
*/
/*其它DBMS
SQL Server：
CREATE PROCEDURE NewOrder @cust_id CHAR(10)
AS
-- Declare variable for order number
DECLARE @order_num INTEGER
-- Get current highest order number
SELECT @order_num=MAX(order_num)
FROM Orders
-- Determine next order number
SELECT @order_num=@order_num+1
-- Insert new order
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(@order_num, GETDATE(), @cust_id)
-- Return order number
RETURN @order_num;
或者
CREATE PROCEDURE NewOrder @cust_id CHAR(10)
AS
-- Insert new order
INSERT INTO Orders(cust_id)
VALUES(@cust_id)
-- Return order number
SELECT order_num = @@IDENTITY;
*/
# 执行存储过程 CALL
# 其它DBMS是 EXECUTE
# 没有参数的存储过程
CREATE PROCEDURE mailinglistcountno()
BEGIN 
	SELECT COUNT(*) AS Cnt
	FROM customers
	WHERE NOT cust_email IS NULL;
END;
# 调用没有参数的存储过程
CALL mailinglistcountno();

# 带输出参数的存储过程
CREATE PROCEDURE mailinglistcount(OUT cnt INT)
BEGIN
	SELECT COUNT(*) INTO cnt
	FROM customers
	WHERE NOT cust_email IS NULL;
END;
# 调用带输出参数的存储过程
CALL mailinglistcount(@cnt);
SELECT @cnt AS Cnt;

# 带输入参数的存储过程
CREATE PROCEDURE mailinglistcountin(IN custname VARCHAR(30))
BEGIN
	SELECT * FROM customers
	WHERE cust_name = custname;
	# The Toy Store
END;
# 调用带输入参数的存储过程
CALL mailinglistcountin('The Toy Store');

# 创建带有输入输出参数的存储过程
CREATE PROCEDURE mailinglistcountio(IN custname VARCHAR(30),OUT cnt INT)
BEGIN 
	SELECT COUNT(*) INTO cnt 
	FROM customers 
	WHERE cust_name = custname;
END;

CALL mailinglistcountio('Toy Land',@cnt);
SELECT @cnt AS Cnt;

# 第20课 管理事务处理
/*术语
事务（transaction）指一组SQL 语句；
回退（rollback）指撤销指定SQL 语句的过程；
提交（commit）指将未存储的SQL 语句结果写入数据库表；
保留点（savepoint）指事务处理中设置的临时占位符（placeholder），可以对它发布回退（与回退整个事务处理不同）。
*/
/*
SQL Server：
BEGIN TRANSACTION
... // 必须完全执行或者完全不执行
COMMIT TRANSACTION

MariaDB 和MySQL：
START TRANSACTION
...

Oracle：
SET TRANSACTION
...

PostgreSQL：
BEGIN
...
*/
/* SQL的完整示例
BEGIN TRANSACTION
INSERT INTO Customers(cust_id, cust_name)
VALUES('1000000010', 'Toys Emporium');
SAVE TRANSACTION StartOrder;
INSERT INTO Orders(order_num, order_date, cust_id)
VALUES(20100,'2001/12/1','1000000010');
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity,item_price)
VALUES(20100, 1, 'BR01', 100, 5.49);
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
INSERT INTO OrderItems(order_num, order_item, prod_id, quantity,item_price)
VALUES(20100, 2, 'BR03', 100, 10.99);
IF @@ERROR <> 0 ROLLBACK TRANSACTION StartOrder;
COMMIT TRANSACTION
*/

#SELECT * FROM customers WHERE cust_id='1000000406';
START TRANSACTION;

SAVEPOINT delcust;

DELETE FROM customers 
WHERE cust_id='1000000406';

ROLLBACK TO delcust;
COMMIT;

# 第21课 使用游标
/*游标使用步骤
在使用游标前，必须声明（定义）它。这个过程实际上没有检索数据，它只是定义要使用的SELECT 语句和游标选项。
一旦声明，就必须打开游标以供使用。这个过程用前面定义的SELECT语句把数据实际检索出来。
对于填有数据的游标，根据需要取出（检索）各行。
在结束游标使用时，必须关闭游标，可能的话，释放游标（有赖于具体的DBMS）。
*/

/*创建游标
DB2、MariaDB、MySQL 和SQL Server：
DECLARE CustCursor CURSOR
FOR
SELECT * FROM Customers
WHERE cust_email IS NULL

Oracle 和PostgreSQL：
DECLARE CURSOR CustCursor
IS
SELECT * FROM Customers
WHERE cust_email IS NULL
*/
CREATE PROCEDURE cursortest()
BEGIN
	DECLARE no_cust INT DEFAULT 0;
	DECLARE custname VARCHAR(50);
	DECLARE custadd VARCHAR(50);

	# 创建游标
	DECLARE CustCursor CURSOR FOR SELECT cust_name,cust_address FROM customers WHERE cust_email IS NULL;
	# 这个是个条件处理，针对NOT FOUND的条件，当没有记录时赋值为1
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_cust = 1;
	# 打开游标
	OPEN CustCursor;

	# 开始循环游标里的数据
	FETCH CustCursor INTO custname,custadd;
	WHILE no_cust != 1 DO
		INSERT  INTO custback(cust_name,cust_address)
		VALUES  (custname,custadd);
	FETCH  CustCursor INTO custname, custadd;
	END WHILE;

	# 关闭游标
	CLOSE CustCursor;
END;

Call cursortest(); 
-- SELECT * FROM custback;
-- TRUNCATE TABLE custback;

# 第22课 高级SQL 特性
# 主键 PRIMARY KEY
CREATE TABLE vendorstest
(
	vend_id CHAR(10) NOT NULL, # PRIMARY KEY
	vend_name CHAR(50) NOT NULL,
	vend_address CHAR(50) NULL,
	vend_city CHAR(50) NULL,
	vend_state CHAR(5) NULL,
	vend_zip CHAR(10) NULL,
	vend_country CHAR(50) NULL
);

ALTER TABLE vendorstest
ADD CONSTRAINT PRIMARY KEY (vend_id);

# 创建外键 FOREIGN KEY
ALTER TABLE Orders
ADD CONSTRAINT
FOREIGN KEY (cust_id) REFERENCES Customers (cust_id)

# 唯一约束
/*唯一约束和主键的区别
表可包含多个唯一约束，但每个表只允许一个主键。
唯一约束列可包含NULL 值。
唯一约束列可修改或更新。
唯一约束列的值可重复使用。
与主键不一样，唯一约束不能用来定义外键。
*/
# 唯一约束既可以用UNIQUE 关键字在表定义中定义，也可以用单独的CONSTRAINT 定义

# 检查约束 CHECK
CREATE TABLE orderitemstest
(
	order_num INTEGER NOT NULL,
	order_item INTEGER NOT NULL,
	prod_id CHAR(10) NOT NULL,
	quantity INTEGER NOT NULL CHECK (quantity > 0),
	item_price MONEY NOT NULL
);

# 检查名为gender 的列只包含M 或F
ADD CONSTRAINT CHECK (gender LIKE '[MF]')

# 索引
/*
索引改善检索操作的性能，但降低了数据插入、修改和删除的性能。在执行这些操作时，DBMS 必须动态地更新索引。
索引数据可能要占用大量的存储空间。
并非所有数据都适合做索引。取值不多的数据（如州）不如具有更多
可能值的数据（如姓或名），能通过索引得到那么多的好处。
索引用于数据过滤和数据排序。如果你经常以某种特定的顺序排序数据，则该数据可能适合做索引。
可以在索引中定义多个列（例如，州加上城市）。这样的索引仅在以州加城市的顺序排序时有用。如果想按城市排序，则这种索引没有用处。
*/
CREATE INDEX prod_name_ind ON products (prod_name);

# 触发器
/*触发器内的代码具有以下数据的访问权：
INSERT 操作中的所有新数据；
UPDATE 操作中的所有新数据和旧数据；
DELETE 操作中删除的数据。
*/
/*
SQL Server：
CREATE TRIGGER customer_state
ON Customers
FOR INSERT, UPDATE
AS
UPDATE Customers
SET cust_state = Upper(cust_state)
WHERE Customers.cust_id = inserted.cust_id;

Oracle 和PostgreSQL：
CREATE TRIGGER customer_state
AFTER INSERT OR UPDATE
FOR EACH ROW
BEGIN
UPDATE Customers
SET cust_state = Upper(cust_state)
WHERE Customers.cust_id = :OLD.cust_id
END;
*/
DROP TABLE IF EXISTS tab1;
CREATE TABLE tab1(
    tab1_id varchar(11)
);

DROP TABLE IF EXISTS tab2;
CREATE TABLE tab2(
    tab2_id varchar(11)
);
# 创建新增触发器：t_afterinsert_on_tab1
DROP TRIGGER IF EXISTS t_afterinsert_on_tab1;
CREATE TRIGGER t_afterinsert_on_tab1 
AFTER INSERT ON tab1
FOR EACH ROW
BEGIN
     INSERT INTO tab2(tab2_id) VALUES(new.tab1_id);
END;

INSERT INTO tab1(tab1_id) values('0001');

SELECT * FROM tab1;
SELECT * FROM tab2;

# 创建删除触发器：t_afterdelete_on_tab1
DROP TRIGGER IF EXISTS t_afterdelete_on_tab1;
CREATE TRIGGER t_afterdelete_on_tab1
AFTER DELETE ON tab1
FOR EACH ROW
BEGIN
      DELETE FROM tab2 WHERE tab2_id=old.tab1_id;
END;

DELETE FROM tab1 WHERE tab1_id='0001';