USE elctronic_shop;
DROP FUNCTION IF EXISTS product_popularity;

DELIMITER //

CREATE FUNCTION `product_popularity`(check_prod_id BIGINT) RETURNS float
    READS SQL DATA
BEGIN
	DECLARE products_ordered_total BIGINT;
	DECLARE products_in_orders BIGINT;
		
-- Получаем количество продуктов на складах
	SET products_ordered_total = (
		SELECT 
			SUM(total)
		FROM elctronic_shop.orders_products tot2
		);
-- Получаем количество заказанных продуктов
	SET products_in_orders = (
		SELECT 
 			SUM(total)
		FROM elctronic_shop.orders_products op2 
		JOIN orders sh2 ON sh2.id <=> op2.order_id 
		WHERE op2.product_id <=> check_prod_id
	);
	RETURN products_in_orders / products_ordered_total;
END //


DELIMITER ;
DROP FUNCTION IF EXISTS total_products_quantity;
DELIMITER //

CREATE FUNCTION `total_products_quantity`(check_prod_id BIGINT) RETURNS BIGINT
    READS SQL DATA
BEGIN
	DECLARE total_quantity BIGINT;
		SET total_quantity = (
			SELECT 
				SUM(quantity)
			FROM (SELECT *
				FROM product_at_storehouse pas 
				WHERE pas.product_id <=> check_prod_id) AS olo
	);
	RETURN total_quantity;
END //
DELIMITER ;