-- Lesson 2
-- Alexander Korovin
-- Задание 1
/*
mysql установлен на сервере rhel8 c включенной защитой root пользователь не может подключится удаленно, для подключения dbeaver используется ssh-тунель. Вход на сервер по паролю запрещен аутентификация только по ключам.

[alex@rhel-mysql ~]$ cat .my.cnf
[client]
user=root
password=mypassword
_________________________________
[alex@rhel-mysql ~]$ ls -la
total 44
drwx------. 3 alex alex 4096 Feb  1 12:33 .
drwxr-xr-x. 4 root root 4096 Feb  1 10:54 ..
-rw-------. 1 alex alex  581 Feb  1 12:46 .bash_history
-rw-r--r--. 1 alex alex   18 Jan 14  2019 .bash_logout
-rw-r--r--. 1 alex alex  141 Jan 14  2019 .bash_profile
-rw-r--r--. 1 alex alex  312 Jan 14  2019 .bashrc
-rw-------. 1 alex alex   42 Feb  1 12:32 .my.cnf
-rw-------. 1 alex alex  118 Feb  1 12:33 .mysql_history
drwx------. 2 alex alex 4096 Feb  1 11:07 .ssh
-rw-------. 1 alex alex  796 Feb  1 12:32 .viminfo
-rw-rw-r--. 1 alex alex    0 Feb  1 11:47 yum
-rw-r--r--. 1 alex alex  658 Dec 17  2018 .zshrc
*/
-- Задание 2
CREATE DATABASE IF NOT EXISTS example;
USE example;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) COMMENT 'Имя пользователя',
  UNIQUE unique_name(name(10)),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Создадим таблицу users';
-- Задание 3
/*
[alex@rhel-mysql ~]$ mysqldump example > example.sql

mysql> create database sample;
Query OK, 1 row affected (0.03 sec)
mysql> \! mysql sample < example.sql
mysql> USE sample
Database changed
mysql> SHOW TABLES;
+------------------+
| Tables_in_sample |
+------------------+
| users            |
+------------------+
1 row in set (0.00 sec)
*/

-- Задание 4
/*
[alex@rhel-mysql ~]$ mysqldump --opt --where="1 limit 100" mysql help_keyword  > help_keyword.sql
 */