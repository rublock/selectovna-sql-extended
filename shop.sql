DROP DATABASE if exists shop;
CREATE DATABASE shop;

use shop;

CREATE TABLE product
(
    id INT,
    name VARCHAR(25)
);

INSERT INTO product
(id, name)
values
(1, 'Карандаш'),
(3, 'Ручка'),
(4, 'Пластилин'),
(5, 'Клей');

CREATE TABLE description
(
    id INT,
    descr VARCHAR(50)
);

INSERT INTO description
(id, descr)
values
(1, 'Черный карандаш'),
(3, 'Гелевая ручка'),
(5, 'ПВА'),
(7, 'Кисть средняя');

SELECT id, name  FROM product
UNION ALL
SELECT id, descr FROM description
ORDER BY 2;

SELECT id  FROM product
UNION
SELECT id FROM description;

SELECT
	id, name, 'product' AS source
FROM product
UNION ALL
SELECT
	id, descr, 'description'
FROM description;

SELECT id, name  FROM product
EXCEPT
SELECT id, descr FROM description;