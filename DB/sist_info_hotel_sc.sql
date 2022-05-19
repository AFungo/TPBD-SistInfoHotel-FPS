--
-- Crea la base de datos gestion_hotel_sc
--

create schema /*!32312 if not exists*/ gestion_hotel_sc;
use gestion_hotel_sc;

-- 
-- Estructura de la tabla `gestion_hotel_sc.persona`
-- 

drop table if exists `persona`;
create table `persona`(
	dni_persona int not null primary key,
    nombre varchar(40) not null,
    apellido varchar(40) not null
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.cliente`
-- 

drop table if exists `cliente`;
create table `cliente`(
	dni_cliente int not null primary key,
    fecha_1ra_vez date not null,
    constraint foreign key (dni_cliente) references persona (dni_persona)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.mucama`
-- 

SELECT CURDATE() AS Today;
drop table if exists `mucama`;
create table `mucama`(
	dni_mucama int not null primary key,
    fecha_ingreso date not null, -- previa a la fecha corriente
    sueldo float not null,-- positivo
    constraint foreign key (dni_mucama) references persona (dni_persona),
    constraint sueldo_positive check(sueldo >= 0),
    constraint fecha_current check (Today > fecha_ingreso)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.gerente`
-- 

drop table if exists `gerente`;
create table `gerente`(
	dni_gerente int not null primary key,
    fecha_ingreso date not null, -- previa a la fecha corriente
    sueldo float not null, -- positivo
    constraint foreign key (dni_gerente) references persona (dni_persona),
    constraint sueldo_positive check(sueldo >= 0)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.comision`
-- 

drop table if exists `comision`;
create table `comision`(
	nro_comision int not null,
	dni_gerente int not null,
    monto float not null, -- positivo
    constraint foreign key (dni_gerente) references gerente (dni_gerente),
	constraint primary key (nro_comision, dni_gerente),
    constraint nc_positive check(nro_comision >= 0)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.tipo_habitacion`
-- 

drop table if exists `tipo_habitacion`;
create table `tipo_habitacion`(
	cod_tipo int not null primary key,
	descripcion varchar(200) not null,
    costo float not null, -- positivo
    constraint costo_positive check(costo>=0),
    constraint ct_positive check(cod_tipo>=0)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.habitacion`
-- 

drop table if exists `habitacion`;
create table `habitacion`(
	nro_habitacion int not null primary key, -- positivo
	cant_camas int not null, -- mayor que 0 menor que 3 habitaciones hasta triples
    cod_tipo int not null,
    constraint foreign key (cod_tipo) references tipo_habitacion (cod_tipo),
	constraint cant_camas_rest check(cant_camas>0 and cant_camas<4),
    constraint nh_positive check(nro_habitacion >= 0)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.atiende`
-- 

drop table if exists `atiende`;
create table `atiende`(
	dni_mucama int not null,
	nro_habitacion int not null,
    constraint foreign key (dni_mucama) references mucama (dni_mucama),
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion),
	constraint primary key (dni_mucama, nro_habitacion)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.fecha`
-- 

drop table if exists `fecha`;
create table `fecha`(
	fecha date not null primary key
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.ocupada`
-- 

drop table if exists `ocupada`;
create table `ocupada`(
	nro_habitacion int not null,
    fecha date not null,
    dni_cliente int not null,
    precio_noche float not null,
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion),
    constraint foreign key (fecha) references fecha (fecha),
    constraint foreign key (dni_cliente) references cliente (dni_cliente),
	constraint primary key (nro_habitacion, fecha),
    constraint pn_positive check(precio_noche>0)
);