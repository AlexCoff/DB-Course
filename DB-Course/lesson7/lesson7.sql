-- Тема “Сложные запросы”
-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE shop;
select @@sql_mode;
-- ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
SET GLOBAL sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
select @@sql_mode;
-- Немного хитрости от mysql и создадим пользователя который не совершал покупки
INSERT INTO users (name, birthday_at) VALUES
  ('Фёдор', '1990-10-05');
select A.id, A.name, COUNT(A.ord_id) from (select
us.id ,
us.name ,
orders.id as ord_id
from users AS us RIGHT JOIN orders
on us.id = orders.user_id
) A GROUP by A.name ORDER BY A.id;


-- Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT 
	p.name ,
	c.name 
FROM 
	catalogs AS c 
JOIN
	products AS p
ON
	c.id = p.catalog_id ;
	
-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to 
-- и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
CREATE DATABASE IF NOT EXISTS extend_hw;
USE extend_hw;
DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
	id SERIAL PRIMARY KEY,
	`from` VARCHAR (100) NOT NULL,
	`to` VARCHAR (100) not null
) COMMENT = 'Список рейсов';
DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
	`label` VARCHAR (100) NOT NULL,
	`name` VARCHAR (100) NOT NULL,
	INDEX labels_idx (`label`)
);
INSERT INTO flights (`from`,`to`) VALUES
	('moscow','omsk'),
	('novgorod','kazan'),
	('irkutsk','moscow'),
	('omsk','irkutsk'),
	('moscow','kazan');
INSERT INTO cities (label,name) VALUES
	('moscow','Москва'),
	('irkutsk','Иркутск'),
	('novgorod','Новгород'),
	('kazan','Казань'),
	('omsk','Омск');
select * from flights;

-- корявенько но работает боюсь представить сколько уйдет времени на такой запрос в реальной базе, хотя сама база неправильная
SELECT DISTINCT A.id , A.`from` , D.`to`
FROM
(select fs.id , ci.`name` as `from` from flights AS fs RIGHT JOIN cities AS ci on fs.`from` LIKE ci.label) A
JOIN
(select fs1.id , ci1.`name` as `to` from flights AS fs1 RIGHT JOIN cities AS ci1 on fs1.`to` LIKE ci1.label) D
ON A.id = D.id
ORDER BY A.id;
























