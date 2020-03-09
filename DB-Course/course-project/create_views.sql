-- Представления
-- Вывод оставшихся неактивных товаров по складам  
CREATE or replace VIEW view_storehouse_inactive_prod
AS 
	SELECT
	 	pas.id,
	 	p2.name,
	 	pas.quantity,
	 	sh2.name AS storehouse_name
	FROM product_at_storehouse pas
	JOIN products p2 ON pas.product_id = p2.id 
	JOIN storehouses sh2 ON pas.storehous_id = sh2.id 
	WHERE p2.is_active = 0 AND pas.quantity > 0
	ORDER BY sh2.name;

-- Вывод товаров на складах
CREATE or replace VIEW view_products_by_storehous
AS 
	SELECT 
		pas.id,
		pas.product_id,
		p2.name AS product_name,
		pas.quantity ,
		p2.price ,
		sh2.name
	FROM product_at_storehouse pas 
	JOIN products p2 ON pas.product_id = p2.id 
	JOIN storehouses sh2 ON pas.storehous_id = sh2.id 
	WHERE pas.quantity > 0
	ORDER BY sh2.id ;

-- Вывод основной пользовательской информации
CREATE or replace VIEW view_user_info
AS
	SELECT 
		u2.id ,
		u2.first_name ,
		u2.last_name ,
		u2.email ,
		u2.phone ,
		pf2.birthday_at ,
		sa2.local_address 
	FROM users u2 
	JOIN users_profiles pf2 ON u2.id = pf2.user_id
	JOIN shipping_address sa2 ON sa2.user_id = u2.id 
	WHERE u2.is_active = 1 
	ORDER BY u2.id ;