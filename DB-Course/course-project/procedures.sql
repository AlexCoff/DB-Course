DROP PROCEDURE IF EXISTS `sp_add_user`;

DELIMITER //

CREATE PROCEDURE `sp_add_user`(firstname varchar(100), lastname varchar(100), email varchar(100), phone varchar(12), locale INT, birthday DATE, OUT tran_result varchar(200))
BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);
    DECLARE last_user_id int;

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
		        
    START TRANSACTION;
		INSERT INTO users (first_name, last_name , email, phone)
		  VALUES (firstname, lastname, email, phone);
	
		INSERT INTO users_profiles (user_id, locale_id,birthday_at)
		  VALUES (last_insert_id(), locale_id,birthday); 
	
	    IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
		set tran_result := 'ok';
	       COMMIT;
	    END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS `sp_add_product_to_order`;

DELIMITER //

CREATE PROCEDURE `sp_add_product_to_order`(product_id BIGINT, storehose_id BIGINT,order_id BIGINT, quantity BIGINT, OUT tran_result varchar(200))
BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
		        
    START TRANSACTION;
		INSERT INTO product_in_reserve (product_id ,storehous_id ,quantity,order_id )
		  VALUES (product_id, storehose_id, quantity, order_id);
	
		INSERT INTO orders_products (product_id , total ,order_id )
		  VALUES (product_id, quantity, order_id); 
	
	    IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
		set tran_result := 'ok';
	       COMMIT;
	    END IF;
END //

DELIMITER ;