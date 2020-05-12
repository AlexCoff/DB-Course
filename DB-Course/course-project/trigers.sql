
drop TRIGGER if exists check_user_age_before_update;
DELIMITER //

CREATE TRIGGER check_user_age_before_update BEFORE UPDATE ON users_profiles
FOR EACH ROW
begin
    IF NEW.birthday_at >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update Canceled. Birthday must be in the past!';
    END IF;
END//

DELIMITER ;

-- триггер для корректировки возраста пользователя при вставке новых строк

drop TRIGGER if exists check_user_age_before_insert;

DELIMITER //

CREATE TRIGGER check_user_age_before_insert BEFORE INSERT ON users_profiles
FOR EACH ROW
begin
    IF NEW.birthday_at > CURRENT_DATE() THEN
        SET NEW.birthday_at = CURRENT_DATE();
    END IF;
END//

DELIMITER ;


-- тригер для проверки пересорта на складе
drop TRIGGER if exists check_quantity_before_order_create;
DELIMITER //

CREATE TRIGGER check_quantity_before_order_create BEFORE UPDATE ON product_at_storehouse
FOR EACH ROW
begin
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Update Canceled. No more parts in storehose';
    END IF;
END//

DELIMITER ;


