DROP DATABASE if exists hospital;
CREATE DATABASE hospital;

USE hospital;

CREATE TABLE med_area (
    area_num TINYINT NOT NULL AUTO_INCREMENT,
    area_address VARCHAR(1000),
    PRIMARY KEY (area_num)
);

CREATE TABLE doctors
(
    doctor_num INT AUTO_INCREMENT,
    doctor_name VARCHAR(250) NOT NULL,
    spec VARCHAR(100),
    cabinet_num TINYINT,
    PRIMARY KEY(doctor_num)
);

CREATE TABLE patients
(
    full_name VARCHAR(100) NOT NULL,
    sex CHAR(1) DEFAULT 'м',
    birth_date DATE,
    oms_num BIGINT UNIQUE,
    card_num INT,
    area_num TINYINT,
    PRIMARY KEY(oms_num),
    FOREIGN KEY (area_num) REFERENCES med_area(area_num)
);

CREATE TABLE talons
(
    doctor_num INT,
    oms_num BIGINT,
    visit_time DATETIME NOT NULL,
    visit_amount BIGINT,
    FOREIGN KEY (doctor_num) REFERENCES doctors(doctor_num),
    FOREIGN KEY (oms_num) REFERENCES patients(oms_num)
);

##### ВСТАВКА ДАННЫХ #####

INSERT INTO doctors (doctor_name, cabinet_num)
VALUES('Мурзина Наталья Сергеевна', 16);

INSERT INTO doctors (doctor_name, spec, cabinet_num)
VALUES('Жуков Василий Петрович', 'кардиолог', 21);

INSERT INTO med_area (area_address)
VALUES
('ул. Ленина'),
('ул. Рижская'),
('ул. Вавилова');

INSERT INTO med_area (area_address)
VALUES
('ул. Зеленая'),
('ул. Керамическая');

INSERT INTO patients (full_name, sex, birth_date, oms_num, card_num, area_num)
VALUES ('Скрипкина Надежда Константиновна', 'ж', '1965-06-23', 47327844534, 1677, 2),
('Чусов Виктор Петрович', 'м', '1978-09-01', 36327844534, 235, 3),
('Калинина Юлия Васильевна', 'ж', '1995-03-15', 78327844534, 3265, 1);

INSERT INTO patients (full_name, sex, birth_date, oms_num, card_num, area_num)
VALUES
('Быкова Светлана Ивановна', 'ж', '2001-12-16', 48324544531, 5623, 2),
('Иванов Сергей Эдуардович', 'м', '1965-08-15', 3224584531, 2345, 1),
('Скрябин Евгений Дмитриевич', 'м', '1985-11-25	', 45320544731, 2678, 3);

insert talons (doctor_num, oms_num, visit_time, visit_amount)
VALUES
    (1, 47327844534, '2017-07-23 13:10:11', 1350.00),
    (2, 36327844534, '2018-07-23 13:10:11', 1500.00),
    (2, 78327844534, '2019-07-23 13:10:11', 1350.00),
    (1, 48324544531, '2019-07-23 13:10:11', 1500.00),
    (2, 78327844534, '2019-07-23 13:10:11', 1500.00);

##### СКРИПТЫ #####

# Выведите ФИО всех врачей и пациентов, назовите это поле fio.
# Также для каждого ФИО пометьте Врач это или Пациент,
# назовите поле doc_pat. Результат отсортируйте по ФИО в порядке возрастания.

SELECT doctor_name AS fio, 'Врач' AS doc_pat FROM doctors
UNION ALL
SELECT full_name, 'Пациент' from patients
ORDER BY fio;

# Выведите ФИО всех врачей и пациентов, назовите это поле fio. Также выведите номер ОМС (oms_num),
# для врачей проставьте 0. Результат отсортируйте по номеру ОМС в порядке убывания.

SELECT patients.full_name AS fio, oms_num FROM patients
UNION ALL
SELECT doctors.doctor_name, 0 FROM doctors
ORDER BY oms_num DESC;

# Необходимо получить информацию о приемах врачей. Выведите ФИО врачей, их специализацию,
# дату приема и номер ОМС пациента из таблиц doctors и talons.

SELECT d.doctor_name, d.spec, t.visit_time, t.oms_num FROM doctors d
JOIN talons t ON (d.doctor_num = t.doctor_num);

# Необходимо получить информацию о том, к каким участкам привязаны пациенты.
# Выведите ФИО пациентов, номер ОМС, номер участка и адреса из таблиц patients и med_area.

SELECT
    p.full_name,
    p.oms_num,
    m.area_num,
    m.area_address
FROM
    patients p
JOIN
    med_area m ON (p.area_num = m.area_num);

# Необходимо получить информацию о приемах врачей. Выведите ФИО докторов, их специализацию,
# дату приема, ФИО пациента и дату его рождения из таблиц doctors, talons и patients.

SELECT
    d.doctor_name,
    d.spec,
    t.visit_time,
    p.full_name,
    p.birth_date
FROM
    patients p
JOIN
    talons t ON p.oms_num = t.oms_num
JOIN
    doctors d ON t.doctor_num = d.doctor_num;

# Выведите ФИО ВСЕХ докторов, которые есть в таблице doctors,
# а также дату посещения из таблицы talons для каждого доктора.

SELECT
    d.doctor_name,
    t.visit_time
FROM
    doctors d
LEFT JOIN
        talons t ON d.doctor_num = t.doctor_num;

# Вывести ФИО ВСЕХ пациентов, а также даты приемов, когда пациенты посещали врачей.

SELECT
    p.full_name,
    t.visit_time
FROM
    talons t
RIGHT JOIN patients p on p.oms_num = t.oms_num;

# Выведите информацию (full_name, sex, birth_date, oms_num) о всех пациентах,
# одного пола с пациентом, родившимся в 1995 году.
# Результат отсортируйте по дате рождения - по возрастанию.

SELECT
	p1.full_name,
	p1.sex,
	p1.birth_date,
	p1.oms_num
FROM patients p1
JOIN patients p2
ON (p1.sex = p2.sex)
WHERE YEAR(p2.birth_date) = 1995
ORDER BY p1.birth_date;

# Вывести информацию обо всех пациентах,
# возраст которых больше возраста пациента Чусова Виктора Петровича.

SELECT *
FROM patients
WHERE birth_date < (SELECT birth_date
                    FROM patients
                    WHERE full_name = 'Чусов Виктор Петрович');

# Вывести информацию о визитах,
# стоимость которых не ниже средней стоимости визитов по всем талонам.

SELECT *
FROM talons
WHERE visit_amount >= (SELECT AVG(visit_amount)
                      FROM talons);

# Вывести уникальные ФИО врачей, к которому были визиты с минимальной стоимостью.

SELECT
	DISTINCT doctor_name
FROM talons t
JOIN doctors d
ON (t.doctor_num = d.doctor_num)
WHERE t.visit_amount = (SELECT MIN(visit_amount) FROM talons);

# Вывести информацию о тех пациентах, которые хотя бы один раз были у врача.

SELECT * FROM patients p
WHERE EXISTS (SELECT *
              FROM talons t
              WHERE p.oms_num = t.oms_num);

# Вывести информацию о пациентах, которые ни разу не были у кардиолога.


SELECT * FROM patients p
WHERE p.oms_num NOT IN(SELECT t.oms_num
                FROM talons t
                JOIN doctors d on t.doctor_num = d.doctor_num
                WHERE d.spec = 'кардиолог');

# Вывести список фамилий пациентов,
# которые посещают ТОЛЬКО врача-терапевта (остальных врачей пациент не посещал).

SELECT p.full_name FROM patients p
WHERE p.oms_num IN(SELECT t.oms_num
                FROM talons t
                JOIN doctors d on t.doctor_num = d.doctor_num
                WHERE d.spec = 'терапевт');

# Вывести информацию о каждом талоне с указанием ФИО врача, специализации, фамилии пациента,
# даты и времени приема, суммы визита, а также вычисляемое поле pensioner,
# которое рассчитывается следующим образом:
#
# Если пациент - женщина, которая старше 60 лет, или мужчина старше 65 лет,
# то выводим: "Пенсионер", иначе оставляем поле пустым.
# Отсортируйте результат по ФИО пациента и дате визита.

SELECT
	d.doctor_name,
	d.spec,
	p.full_name,
	t.visit_time,
	t.visit_amount,
	IF((p.sex = 'м' AND (2024 - YEAR(p.birth_date)) >= 65)
	OR (p.sex = 'ж' AND (2024 - YEAR(p.birth_date)) >= 60), 'Пенсионер', NULL) AS pensioner
FROM talons t
JOIN patients p
ON (p.oms_num = t.oms_num)
JOIN doctors d
ON (t.doctor_num = d.doctor_num)
ORDER BY 3,4;