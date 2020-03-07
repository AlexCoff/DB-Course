DROP DATABASE IF EXISTS `elctronic_shop`;
CREATE DATABASE `elctronic_shop`;
use  `elctronic_shop`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL COMMENT 'Имя покупателя',
  `last_name` varchar(255) DEFAULT NULL COMMENT 'Фамилия покупателя',
  `email` varchar(255) NOT NULL UNIQUE COMMENT 'E-mail',
  `phone` bigint NOT NULL UNIQUE COMMENT 'Phone',
  `is_active` BIT DEFAULT 1,
  INDEX full_name_idx (`first_name`, `last_name`),
  INDEX email_idx (`email`),
  PRIMARY KEY (`id`)
) COMMENT='Покупатели';

DROP TABLE IF EXISTS `locales`;
CREATE TABLE `locales` (
  `id` SERIAL PRIMARY KEY,
  `name` varchar(255) NOT NULL UNIQUE
) COMMENT='Локали';

DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE `users_profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint  unsigned DEFAULT NULL,
  `locale_id` bigint  unsigned DEFAULT 1,
  `birthday_at` date DEFAULT NULL COMMENT 'Дата рождения',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Дата регистрации',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  INDEX user_locale_idx(`user_id`,`locale_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`)
) COMMENT='Профиль пользователя';

DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
 `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `locale_id` bigint unsigned,
 `name` varchar(255) NOT NULL UNIQUE,
 FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`)
) COMMENT='Страны';

DROP TABLE IF EXISTS `city`;
CREATE TABLE `city` (
 `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `locale_id` bigint unsigned DEFAULT NULL COMMENT 'id локали',
 `country_id` bigint unsigned DEFAULT NULL COMMENT 'id страны',
 `name` varchar(255) COMMENT 'Имя города',
 FOREIGN KEY (`country_id`) REFERENCES `country` (`id`),
 FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`)
) COMMENT='Города';

DROP TABLE IF EXISTS `shipping_address`;
CREATE TABLE `shipping_address` (
	`id` SERIAL PRIMARY KEY,
	`user_id` bigint  unsigned DEFAULT NULL,
	`country_id` bigint unsigned DEFAULT NULL,
	`city_id` bigint unsigned DEFAULT NULL,
	`zip_code` bigint DEFAULT NULL,
	`local_address` varchar(255) default NULL,
	`created_at` datetime DEFAULT current_timestamp(),
    `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (`country_id`) REFERENCES `country` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (`city_id`) REFERENCES `city` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='Адреса доставки';



DROP TABLE IF EXISTS `catalogs`;
CREATE TABLE `catalogs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Название раздела' UNIQUE,
  PRIMARY KEY (`id`)
) COMMENT='Разделы интернет-магазина';

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Название',
  `desription` text COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Описание',
  `price` decimal(11,2) DEFAULT NULL COMMENT 'Цена',
  `catalog_id` bigint unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` BIT DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `product_name_idx` (`name`),
  KEY `index_of_catalog_id` (`catalog_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`catalog_id`) REFERENCES `catalogs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='Товарные позиции';

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `status` ENUM('Submitted', 'Paid', 'Parts Picked ', 'Parts Verified' ,'Scanned for Dispatch' , 'Ready to Ship','Picked Up by Carrier','Traceable','Delivered'),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `index_of_user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='Скидки';

DROP TABLE IF EXISTS `orders_products`;
CREATE TABLE `orders_products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned DEFAULT NULL,
  `product_id` bigint unsigned DEFAULT NULL,
  `total` int unsigned DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orders_products_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `orders_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='Состав заказа';

DROP TABLE IF EXISTS `storehouses`;
CREATE TABLE `storehouses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Название',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) COMMENT='Склады';

DROP TABLE IF EXISTS `product_at_storehouse`;
CREATE TABLE `product_at_storehouse` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `product_id` bigint unsigned DEFAULT NULL,
  `storehous_id` bigint unsigned DEFAULT NULL,
  `quantity` BIGINT DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  FOREIGN KEY (`storehous_id`) REFERENCES `storehouses` (`id`),
  UNIQUE KEY `unique_products_at_store_idx`(`product_id`, `storehous_id`)
) COMMENT='Склады';

DROP TABLE IF EXISTS `product_in_reserve`;
CREATE TABLE `product_in_reserve` (
	`id` SERIAL PRIMARY KEY,
	`product_id` bigint unsigned DEFAULT NULL,
	`storehous_id` bigint unsigned DEFAULT NULL,
	`order_id` bigint unsigned DEFAULT NULL,
	`quantity` bigint DEFAULT NULL,
	FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (`storehous_id`) REFERENCES `product_at_storehouse` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='Товары в резерве';




