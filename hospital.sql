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

insert talons (doctor_num, oms_num, visit_time)
VALUES
    (1, 47327844534, '2017-07-23 13:10:11'),
    (2, 36327844534, '2018-07-23 13:10:11'),
    (2, 78327844534, '2019-07-23 13:10:11'),
    (1, 48324544531, '2019-07-23 13:10:11'),
    (2, 78327844534, '2019-07-23 13:10:11');

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