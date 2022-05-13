/*
drop schema if exists `proyecto`;
create schema `proyecto`;
*/

create table `persona`(
	dni_persona int not null primary key,
    nombre varchar(40) not null,
    apellido varchar(40) not null
);

create table `cliente`(
	dni_cliente int not null primary key,
    fecha_1ra_vez date not null,
    constraint foreign key (dni_cliente) references persona (dni_persona)
);

create table `mucama`(
	dni_mucama int not null primary key,
    fecha_ingreso date not null,
    sueldo float not null,
    constraint foreign key (dni_mucama) references persona (dni_persona)
);

create table `gerente`(
	dni_gerente int not null primary key,
    fecha_ingreso date not null,
    sueldo float not null,
    constraint foreign key (dni_gerente) references persona (dni_persona)
);

create table `comision`(
	nro_comision int not null,
	dni_gerente int not null,
    monto float not null,
    constraint foreign key (dni_gerente) references gerente (dni_gerente),
	constraint primary key (nro_comision, dni_gerente)
);

create table `tipo_habitacion`(
	cod_tipo int not null primary key,
	descripcion varchar(200) not null,
    costo float not null
);

create table `habitacion`(
	nro_habitacion int not null primary key,
	cant_camas int not null,
    cod_tipo int not null,
    constraint foreign key (cod_tipo) references tipo_habitacion (cod_tipo)
);

create table `atiende`(
	dni_mucama int not null,
	nro_habitacion int not null,
    constraint foreign key (dni_mucama) references mucama (dni_mucama),
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion),
	constraint primary key (dni_mucama, nro_habitacion)
);

create table `fecha`(
	fecha date not null primary key
);

create table `ocupada`(
	nro_habitacion int not null,
    fecha date not null,
    dni_cliente int not null,
    precio_noche float not null,
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion),
    constraint foreign key (fecha) references fecha (fecha),
    constraint foreign key (dni_cliente) references cliente (dni_cliente),
	constraint primary key (nro_habitacion, fecha)
);