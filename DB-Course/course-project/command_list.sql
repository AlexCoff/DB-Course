-- Вывод количества снятых с производдства товаров по складам
SELECT
 	pas.id,
 	p2.name,
 	pas.quantity,
 	sh2.name 
FROM product_at_storehouse pas
JOIN products p2 ON pas.product_id = p2.id 
JOIN storehouses sh2 ON pas.storehous_id = sh2.id 
WHERE p2.is_active = 0 AND pas.quantity > 0
ORDER BY sh2.name;

-- Вывод товаров по складам c выводом общей стоимостью.
SELECT 
	pas.id,
	pas.product_id,
	p2.name AS product_name,
	pas.quantity ,
	p2.price ,
	(pas.quantity * p2.price ) AS total_price,
	sh2.name AS sh_name
FROM product_at_storehouse pas 
JOIN products p2 ON pas.product_id = p2.id 
JOIN storehouses sh2 ON pas.storehous_id = sh2.id 
WHERE p2.is_active = 1 AND pas.quantity > 0
ORDER BY sh2.id ;

-- Информация о пользователе cо всеми адресами доставки и локалью пользователя
SELECT 
	u2.id ,
	u2.first_name ,
	u2.last_name ,
	u2.email ,
	u2.phone ,
	pf2.birthday_at ,
	sa2.local_address ,
	lo2.name 
FROM users u2 
JOIN users_profiles pf2 ON u2.id = pf2.user_id
JOIN shipping_address sa2 ON sa2.user_id = u2.id 
JOIN locales lo2 ON pf2.locale_id = lo2.id 
WHERE u2.is_active = 1 
ORDER BY u2.id ;

SELECT @@sql_mode;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SELECT COUNT(*)
FROM product_at_storehouse pas
GROUP BY storehous_id ;

-- Выводим количество товарных позиций по складам и складскую стоимость
SELECT 
	cu2.storehous_id,
	cu2.sh_name,
	COUNT(*) AS product_count,
 	SUM(cu2.total_price) AS total_sh_price
FROM
	(SELECT 
		pas.id,
	 	pas.product_id ,
	 	pas.storehous_id ,
	 	pas.quantity ,
	 	p2.price ,
	 	sh2.name AS sh_name,
		(p2.price * pas.quantity ) AS total_price
	FROM product_at_storehouse pas
	JOIN products p2 ON pas.product_id <=> p2.id
	JOIN storehouses sh2 ON sh2.id <=> pas.storehous_id 
 	WHERE pas.quantity > 0
	) AS cu2
GROUP BY cu2.storehous_id
ORDER BY cu2.storehous_id;

-- количество товара на всех складах
SELECT 
	SUM(quantity)
	FROM elctronic_shop.product_at_storehouse pas 
			WHERE pas.product_id = 103;

-- Количество товаров в зазазах
SELECT 
 	SUM(total)
FROM elctronic_shop.orders_products op2 
WHERE op2.product_id <=> 103;

-- Общее количество заказов
SELECT 
	SUM(total)
FROM elctronic_shop.orders_products op2;

Use elctronic_shop;
-- Рэйтинг товара больше лучше
SELECT product_popularity(402);

-- Запрос из разряда давай сделаем базе больно. Выводит топ 200 популярных товаров. В качестве модернизации базы можно сделать поле 
SELECT *
FROM (SELECT 
	p.id ,
	p.name, 
 	(product_popularity(p.id)) AS popularity
	FROM products p) AS olo
WHERE olo.popularity > 0
ORDER BY
olo.popularity DESC
LIMIT 200;

-- Вывод заказов в которых есть товар с id 2
SELECT *
FROM orders_products op 
WHERE op.product_id = 2;

-- Вывод товаров которые были отправлены или уже выполнены с ID 2
SELECT 
			SUM(total)
		FROM orders_products op2
		JOIN orders sh2 ON sh2.id <=> op2.order_id 
		WHERE op2.product_id <=> 2 AND (sh2.status = 'Delivered' OR sh2.status = 'Ready to Ship' OR sh2.status = 'Picked Up by Carrier' OR sh2.status = 'Traceable' OR sh2.status = 'Delivered');

	
-- Вывод товаров и количества складов на которых доступен товар
SELECT *
FROM (
	SELECT 
 		pro2.id ,
 		COUNT(*) as count_p,
		SUM(pas.quantity ) AS quantity
	FROM product_at_storehouse pas
	JOIN storehouses sh2 ON pas.storehous_id = sh2.id 
	JOIN products pro2 ON pas.product_id = pro2.id 
	GROUP BY pas.product_id ) AS pc2
WHERE pc2.count_p > 1
ORDER BY pc2.id;

-- Вывод количества количества товара на всех складах
SELECT SUM(quantity)
FROM (SELECT *
		FROM product_at_storehouse pas 
		WHERE pas.product_id <=> 5) AS olo;
	
SELECT total_products_quantity(10);

-- Добавляем пользователя
-- CREATE PROCEDURE `sp_add_user`(firstname varchar(100), lastname varchar(100), email varchar(100), phone varchar(12), locale INT, birthday DATE, OUT tran_result varchar(200))
call sp_add_user('Alexander', 'Korovin', 'new87@mail.com', 454545456, 1, '1988-06-23', @tran_result);
-- результат транзакции
select @tran_result;

-- Выводим товары снятые с производства
SELECT *
FROM products p 
WHERE p.is_active = 0;

-- Корректируем нулевую цену после генерации
UPDATE products SET price = 1 WHERE price = 0;

-- Просто вывод представления
SELECT * from view_storehouse_inactive_prod;

-- Фильтруем представление по имени товара
SELECT * FROM view_products_by_storehous vpbs 
WHERE vpbs.product_name LIKE 'aut';

-- Выводим все адреса доставки для пользователя через представление
SELECT * from view_user_info where id=205;




