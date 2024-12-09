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

# INNER JOIN

SELECT
    prod.id AS product_id,
    prod.name,
    ds.descr
FROM product prod
JOIN description ds
ON (prod.id = ds.id);

SELECT
    prod.id,
    prod.name,
    ds.id,
    ds.descr
FROM product prod
LEFT JOIN description ds
ON (prod.id = ds.id)
UNION
SELECT
    prod.id,
    prod.name,
    ds.id,
    ds.descr
FROM product prod
RIGHT JOIN description ds
ON (prod.id = ds.id);

# Измените скрипт разработчика, таким образом,
# чтобы вместо пустого значения для поля descr выводилось значение "Не заполнена":

SELECT
    prod.id,
    prod.name,
    IF (ISNULL(ds.descr), 'Не заполнена', ds.descr)
FROM product prod
LEFT JOIN description ds
ON (prod.id = ds.id);