/*
Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
 */

USE vk;
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
ALTER TABLE users
DROP COLUMN created_at,
DROP COLUMN updated_at;

ALTER TABLE users 
ADD COLUMN created_at TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP;

UPDATE users 
SET 
created_at = CURRENT_TIMESTAMP,
updated_at = CURRENT_TIMESTAMP
WHERE 
created_at IS NULL OR updated_at IS NULL;

ALTER TABLE users 
MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
MODIFY COLUMN updated_at TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP;

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

ALTER TABLE users
DROP COLUMN created_at,
DROP COLUMN updated_at;

ALTER TABLE users 
ADD COLUMN created_at VARCHAR(20) DEFAULT "20.10.2017 8:10",
ADD COLUMN updated_at VARCHAR(20) DEFAULT "20.10.2017 8:10";

-- Оптимальным пуием будет создание новых полей для сохранения совместимости со старыми скриптами.
-- Создаем новые столбцы
ALTER TABLE users 
ADD COLUMN created_at_new TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at_new TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP;

-- Заполняем новыми значениями ,все последующие записи будут правильно работать при использование старого скрипта.
UPDATE users
SET 
created_at_new = DATE_FORMAT(str_to_date( created_at, '%e.%c.%Y %H:%i'),'%Y-%m-%d %H:%m:%s'),
updated_at_new = DATE_FORMAT(str_to_date( updated_at, '%e.%c.%Y %H:%i'),'%Y-%m-%d %H:%m:%s')
WHERE
created_at RLIKE '^[0-9]+\.[0-9]+\.[0-9]+.[0-9]+:[0-9]+' OR updated_at RLIKE '^[0-9]+\.[0-9]+\.[0-9]+.[0-9]+:[0-9]+';

USE shop;
INSERT INTO catalogs 
	(name)
VALUES
('Что-то'),
('Gde-to');

INSERT INTO products
  (name, desription , price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор Intel', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор Intel', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор AMD', 4780.00, 1),
  ('AMD FX-8320', 'Процессор AMD', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'B250, Socket 1151, DDR4, mATX', 5060.00, 2);

SELECT id, name, catalog_id FROM products;





