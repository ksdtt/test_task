create table Region (
	id_Region int Primary Key,
	region_name varchar(50) not null Unique
);

insert into Region values (1, 'Ленинградская область'), (2, 'Саратовская область'), (3, 'Нижегородская область');

create table City (
	id_city int Primary Key,
	city_name varchar(30) not null unique,
	id_region int references Region(id_region) on delete cascade,
	Unique (city_name, id_region)
);

insert into City values (1, 'Санкт-Петербург', 1), (2, 'Саратов', 2), (3, 'Балоково', 2), (4, 'Нижний Новгород', 3), (5, 'Дзержинск', 3);

create table Passport_data (
	id_passport_data int Primary Key,
	series varchar(4) not null,
	number varchar(6) not null,
	data_of_issue date check(data_of_issue <= current_date) not null,
	division_code varchar(7) check(division_code ~'^[0-9][0-9][0-9]-[0-9][0-9][0-9]') not null,
	issued_by_whom varchar not null, 
	date_of_birth date check(date_part('year', age(date_of_birth)) >= 18) not null,
	place_of_birth int references City(id_city) on delete cascade,
	registration_region int references Region(id_region) on delete cascade,
	Unique (series, number)
);

insert into Passport_data values (1, '1234', '567891', '15-01-2014', '123-456', 'МВД', '22-01-1994', 3, 2), 
(2, '2345', '678912', '01-12-2017', '164-045', 'МВД', '19-10-1977', 1, 3),
(3, '3456', '789123', '26-06-2020', '123-123', 'МФЦ', '06-05-2000', 2, 2),
(4, '4567', '891234', '20-05-2005', '031-015', 'МФЦ', '13-09-1991', 5, 3),
(5, '1518', '123321', '22-08-2021', '123-123', 'МВД', '17-07-2001', 1, 1),
(6, '2222', '111111', '02-02-2015', '123-123', 'МВД', '01-01-1995', 4, 1);


create table Place_of_work (
	id_place_of_work int Primary Key,
	region_work int references Region(id_region) on delete cascade,
	itn varchar(12) not null unique,
	salary decimal not null check(salary >= 15000),
	company varchar(70) not null,
	post varchar(50) not null,
	date_of_employment date check(date_of_employment < current_date) not null
);

insert into Place_of_work values (1, 2, '111111111111', 20000, 'Аптека Заря', 'провизор', '19-09-2015'), 
(2, 3, '123456789123', 80000, 'ООО Радуга', 'инженер', '25-03-2003'),
(3, 2, '156481384913', 35000, 'Детский сад Колобок', 'воспитатель', '01-07-2020'),
(4, 3, '646418674564', 28000, 'Магазин', 'продавец', '14-02-2008'),
(5, 1, '974596563256', 55000, 'Банк', 'программист', '06-06-2021'),
(6, 1, '789433215542', 18000, 'Спортивный зал Сила', 'администратор', '03-03-2017');


create table Personal_data (
	id_personal_data int Primary Key,
	surname varchar(50) not null,
	name varchar(50) not null,
	patronymic varchar(50),
	phone_number varchar(15) check(phone_number ~ '^79[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]') not null  unique,
	phone_number_other varchar(15),
	e_mail varchar(40) check(e_mail like '%@%') unique,
	passport int references Passport_data(id_passport_data) on delete cascade,
	work int references Place_of_work(id_place_of_work) on delete cascade
);

insert into Personal_data values (1, 'Петров', 'Пётр', 'Сергеевич',  '7999-888-77-66', null, 'petrov@yandex.ru',  1, 1), 
(2, 'Cидоров', 'Пётр', 'Сергеевич', '7979-868-75-36', null,  'sidorov@mail.ru', 2, 2),
(3, 'Иванов', 'Данила', 'Алексеевич', '7920-513-57-02', null, 'ivanov@gmail.com', 3, 3),
(4, 'Иванов', 'Иван', 'Иванович', '7937-813-57-02', null,  'ivanov.ivan@gmail.com', 4, 4),
(5, 'Иванова', 'Мария', 'Андреевна', '7937-811-31-02', null, 'ivanova@mail.com', 5, 5),
(6, 'Петрова', 'Надежда', 'Владимировна',  '7916-324-68-72', null, 'petrova@yandex.ru', 6, 6);

create table Product_type (
	id_product_type int Primary Key,
	name_product_type varchar(30) unique not null
);

insert into Product_type values (1, 'Кредит наличными'), (2, 'Автокредит'), (3, 'Ипотечный кредит');

create table Purpose_of_loan (
	id_purpose_of_loan int Primary Key,
	name_purpose varchar(30) unique not null
);

insert into Purpose_of_loan values (1, 'Покупка товаров/услуг'), (2, 'Расширение жил.площади'), (3, 'Покупка автомобиля');

create table Parameters_application_form (
	id_param_app_form int Primary Key,
	product_type int not null references Product_type(id_product_type) on delete cascade,
	purpose_of_loan int not null references Purpose_of_loan(id_purpose_of_loan) on delete cascade,
	bet_size decimal not null check(bet_size > 0),
	loan_amount decimal not null check(loan_amount > 0),
	loan_period int not null check(loan_period > 0),
	date_credit date check(date_credit <= current_date) not null
);

insert into Parameters_application_form values (1, 1, 1, 7.7, 100000, 12, '29-04-2023'), 
(2, 2, 3, 5.7, 500000, 6, '15-03-2023'), 
(3, 1, 2, 8.7, 1000000, 24, '17-04-2023'),
(4, 1, 3, 4.4, 100000, 12, '15-01-2023'),
(5, 3, 2, 7.5, 2000000, 36, '03-02-2023'),
(6, 3, 1, 7.7, 1000000, 12, '18-08-2022'), 
(7, 3, 2, 13, 100000, 12, '01-02-2023');

create table Additional_services (
	id_add_serv int Primary Key,
	type_add_serv varchar(50) not null unique,
	cost_add_serv decimal not null
);

insert into Additional_services values (1, 'Страхование жизни', 25000), (2, 'Юридическая помощь', 15000);

create table Credit_application (
	id_credit_app int Primary Key,
	param_app int not null references Parameters_application_form(id_param_app_form) on delete cascade,
	person_data int not null references Personal_data(id_personal_data) on delete cascade,
	add_serv int references Additional_services(id_add_serv) on delete cascade,
	unique(param_app, person_data, add_serv)
);

insert into Credit_application values (1, 1, 1, 1), (2, 2, 2 , 1), (3, 3, 3, 2), 
(4, 4, 4, 2), (5, 5, 5, 2), (6, 6, 5, 1);


