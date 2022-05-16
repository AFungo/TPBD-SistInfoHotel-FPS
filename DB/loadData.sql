--
-- Dumping data para la tabla `gestion_hotel_sc.persona`
--

/*!40000 alter table `persona` disable keys*/;
insert into `persona` (`dni_persona`, `apellido`, `nombre`) values
(43189994, 'SUAREZ', 'MATEO'),
(43433129, 'ARIAS SCHIAVI', 'JUAN PABLO'),
(30214255, 'BARALE', 'MAYCO'),
(22943126, 'BETTIOL', 'NICOLAS MATIAS'),
(37263176, 'BONO', 'FEDERICO'),
(26013149, 'CABRAL', 'HERNAN'),
(34148124, 'CAMPAGNA', 'JULIETA'),
(41221496, 'CAMPOS', 'GONZALO'),
(31228919, 'CARDETTI', 'SILVINA'),
(19452983, 'CARRENO', 'GERMAN'),
(24150753, 'CASTELLI', 'JESUS'),
(42119854, 'CASTELLINA', 'FRANCO'),
(35253256, 'CHIOTTA', 'FRANCISCO'),
(33578090, 'DOMINGUEZ', 'ELIANA'),
(29934733, 'TURLETTI', 'LUCAS'),
(21437887, 'PAUTASSO', 'MATIAS'),
(40124612, 'ONTIVERO', 'MARIANO'),
(42788292, 'FERREYRA', 'LUDMILA'),
(39102573, 'BELTRAME', 'PAULA');
/*!40000 alter table `persona` enable keys*/;

--
-- Dumping data para la tabla `gestion_hotel_sc.cliente`
--

/*!40000 alter table `cliente` disable keys*/;
insert into `cliente` (`dni_cliente`, `fecha_1ra_vez`) values
(43189994, '14-05-2020'),
(21437887, '02-11-2010'),
(24150753, '21-01-2012'),
(22943126, '29-08-2016'),
(30214255, '17-06-2018'),
(34148124, '23-09-2014');
/*!40000 alter table `cliente` enable keys*/;

--
-- Dumping data para la tabla `gestion_hotel_sc.mucama`
--

/*!40000 alter table `mucama` disable keys*/;
insert into `mucama` (`dni_mucama`, `fecha_ingreso`, `sueldo`) values
(42788292, '05-05-2020', 39167.00),
(33578090, '02-01-2012', 65250.00),
(34148124, '08-01-2020', 39167.00),
(39102573, '05-06-2020', 39167.00),
(31228919, '07-02-2010', 71633.00);
/*!40000 alter table `mucama` enable keys*/;

--
-- Dumping data para la tabla `gestion_hotel_sc.gerente`
--

/*!40000 alter table `gerente` disable keys*/;
insert into `gerente` (`dni_gerente`, `fecha_ingreso`, `sueldo`) values
(29934733, '03-02-2020', 97167.00),
(26013149, '06-10-2011', 127250.00),
(19452983, '01-01-2010', 150630.00);
/*!40000 alter table `gerente` enable keys*/;