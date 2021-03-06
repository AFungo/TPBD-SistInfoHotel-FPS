--
-- Dumping data para la tabla `gestion_hotel_sc.persona`
--

SET FOREIGN_KEY_CHECKS = 0;
truncate table atiende;	-- dni_m fk mucama  nro_hab fk habitacion
truncate table modificaciones_ocupada;	-- nro_hab fk habitacion  dni_cli fk cliente
truncate table ocupada;	-- nro_hab fk habitacion  dni_cli fk cliente
truncate table habitacion;	-- cod_tipo fk tipo_hab
truncate table tipo_habitacion;
truncate table comision;	-- dni_g fk gerente
truncate table gerente;	-- dni_g fk persona
truncate table mucama;	-- dni_m fk persona
truncate table cliente;	-- dni_c fk persona
truncate table persona;
SET FOREIGN_KEY_CHECKS = 1;

/*!40000 alter table `persona` disable keys*/;
insert into `persona` (`dni_persona`, `apellido`, `nombre`, `fecha_nac`) values
(43189994, 'SUAREZ', 'MATEO', '2001-05-14'),
(43433129, 'ARIAS SCHIAVI', 'JUAN PABLO', '2004-06-01'),
(30214255, 'BARALE', 'MAYCO', '1996-01-04'),
(22943126, 'BETTIOL', 'NICOLAS MATIAS', '1980-05-10'),
(37263176, 'BONO', 'FEDERICO', '1998-07-30'),
(26013149, 'CABRAL', 'HERNAN', '1960-09-26'),
(34148124, 'CAMPAGNA', 'JULIETA', '1976-12-02'),
(41221496, 'CAMPOS', 'GONZALO', '1999-10-06'),
(31228919, 'CARDETTI', 'SILVINA', '2000-05-14'),
(19452983, 'CARRENO', 'GERMAN', '1950-04-23'),
(24150753, 'CASTELLI', 'JESUS', '1974-03-16'),
(42119854, 'CASTELLINA', 'FRANCO', '2000-05-17'),
(35253256, 'CHIOTTA', 'FRANCISCO', '1992-12-14'),
(33578090, 'DOMINGUEZ', 'ELIANA', '1990-01-10'),
(29934733, 'TURLETTI', 'LUCAS', '1983-05-14'),
(21437887, 'PAUTASSO', 'MATIAS', '1968-04-28'),
(40124612, 'ONTIVERO', 'MARIANO', '1994-05-24'),
(42788292, 'FERREYRA', 'LUDMILA', '2000-07-17'),
(39102573, 'BELTRAME', 'PAULA', '1992-11-29');
/*!40000 alter table `persona` enable keys*/;

--
-- Dumping data para la tabla `gestion_hotel_sc.cliente`
--

/*!40000 alter table `cliente` disable keys*/;
insert into `cliente` (`dni_cliente`, `fecha_1ra_vez`) values
(43189994, '2020-05-14'),
(29934733, '2013-04-23'),
(21437887, '2010-11-02'),
(24150753, '2012-01-21'),
(22943126, '2016-08-29'),
(30214255, '2018-06-17'),
(34148124, '2014-09-23');
/*!40000 alter table `cliente` enable keys*/;

--
-- Dumping data para la tabla `gestion_hotel_sc.mucama`
--

/*!40000 alter table `mucama` disable keys*/;
insert into `mucama` (`dni_mucama`, `fecha_ingreso`, `sueldo`) values
(42788292, '2020-05-05', 39167.00),
(33578090, '2012-01-02', 65250.00),
(34148124, '2020-01-08', 39167.00),
(39102573, '2020-06-05', 39167.00),
(31228919, '2010-02-07', 71633.00);
/*!40000 alter table `mucama` enable keys*/;

--
-- Dumping data para la tabla `gestion_hotel_sc.gerente`
--

/*!40000 alter table `gerente` disable keys*/;
insert into `gerente` (`dni_gerente`, `fecha_ingreso`, `sueldo`) values
(29934733, '2020-02-03', 97167.00),
(26013149, '2011-10-06', 127250.00),
(19452983, '2010-01-01', 150630.00);
/*!40000 alter table `gerente` enable keys*/;

-- 
-- Dumping data para la tabla `gestion_hotel_sc.comision`
-- 

/*!40000 alter table `comision` disable keys*/;
insert into `comision` (`nro_comision`, `dni_gerente`, `monto`) values
(325, 29934733, 457.00),
(452, 26013149, 583.00),
(124, 19452983, 704.00);
/*!40000 alter table `comision` enable keys*/;

-- 
-- Dumping data para la tabla `gestion_hotel_sc.tipo_habitacion`
-- 

/*!40000 alter table `tipo_habitacion` disable keys*/;
insert into `tipo_habitacion` (`cod_tipo`, `descripcion`, `costo`) values
(001, 'Es una habitacion economica que cumple con su objetivo.', 2500),
(002, 'Es una habitacion con ambientes mas espaciosos y una mejor vista.', 3500),
(003, 'Es una habitacion con algunos lujos extras.', 4000),
(004, 'Es la habitacion con mejor vista, mejores lujos, mas espaciosa, la mejor.', 5900);
/*!40000 alter table `tipo_habitacion` enable keys*/;

-- 
-- Dumping data para la tabla `gestion_hotel_sc.habitacion`
-- 

/*!40000 alter table `habitacion` disable keys*/;
insert into `habitacion` (`nro_habitacion`, `cant_camas`, `cod_tipo`) values
(23, 2, 002),
(18, 1, 001),
(21, 1, 001),
(47, 3, 003),
(5 , 1, 001),
(32, 1, 001),
(40, 2, 002);
/*!40000 alter table `habitacion` enable keys*/;

-- 
-- Dumping data para la tabla `gestion_hotel_sc.atiende`
-- 

/*!40000 alter table `atiende` disable keys*/;
insert into `atiende` (`dni_mucama`, `nro_habitacion`) values
(42788292, 23),
(34148124, 18),
(39102573, 47),
(31228919, 5),
(33578090, 32),
(31228919, 40);
/*!40000 alter table `atiende` enable keys*/;

-- 
-- Dumping data para la tabla `gestion_hotel_sc.ocupada`
-- 

/*!40000 alter table `ocupada` disable keys*/;
insert into `ocupada` (`nro_habitacion`, `fecha_ocup`, `dni_cliente`, `precio_noche`, `cant_dias`) values
(23, '2020-05-14', 43189994, 3500.00, 5),
(18, '2010-11-02', 21437887, 2500.00, 1),
(47, '2012-01-21', 24150753, 4000.00, 4),
(5, '2016-08-29', 22943126, 2500.00, 2),
(32, '2018-06-17', 30214255, 2500.00, 2),
(23, '2019-07-12', 21437887, 3500.00, 4),
(47, '2020-01-07', 30214255, 4000.00, 2),
(18, '2013-09-25', 24150753, 2500.00, 1),
(40, '2014-09-23', 34148124, 5900.00, 3);
/*!40000 alter table `ocupada` enable keys*/;