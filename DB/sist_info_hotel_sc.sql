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
	dni_persona int(10) not null primary key,
    nombre varchar(40) not null,
    apellido varchar(40) not null
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.cliente`
-- 

drop table if exists `cliente`;
create table `cliente`(
	dni_cliente int not null primary key,
    fecha_1ra_vez date not null, -- previa a la fecha corriente
    constraint foreign key (dni_cliente) references persona (dni_persona)
);

delimiter $$
create trigger trigger_fecha_current_cliente
	before insert on cliente
	for each row
		begin
            declare dni_varchar varchar(8);
            declare output varchar(100);
			set dni_varchar = new.dni_cliente;
            set output = concat('Fecha invalida en cliente al insertar DNI: ', dni_varchar);
            
			if new.fecha_1ra_vez > curdate() then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

delimiter $$
create trigger trigger_baja_cliente
	before delete on cliente
	for each row
		begin
			delete from ocupada where old.dni_cliente = ocupada.dni_cliente;
            if old.dni_cliente != gerente.dni_gerente or old.dni_cliente != mucama.dni_mucama then
				delete from persona where old.dni_cliente = persona.dni_persona;
			end if;
		end;
$$
delimiter ;

-- 
-- Estructura de la tabla `gestion_hotel_sc.mucama`
-- 

drop table if exists `mucama`;
create table `mucama`(
	dni_mucama int not null primary key,
    fecha_ingreso date not null, -- previa a la fecha corriente
    sueldo float not null, -- positivo
    constraint foreign key (dni_mucama) references persona (dni_persona),
    constraint sueldo_mucama_positive check(sueldo >= 0)
);

delimiter $$
create trigger trigger_fecha_current_mucama
	before insert on mucama
	for each row
		begin
            declare dni_varchar varchar(8);
            declare output varchar(100);
			set dni_varchar = new.dni_mucama;
            set output = concat('Fecha invalida en mucama al insertar DNI: ', dni_varchar);
            
			if new.fecha_ingreso > curdate() then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

delimiter $$
create trigger trigger_baja_mucama
	before delete on mucama
	for each row
		begin
			delete from atiende where old.dni_mucama = atiende.dni_mucama;
			if old.dni_mucama != cliente.dni_cliente then
				delete from persona where old.dni_mucama = persona.dni_persona;
			end if;
		end;
$$
delimiter ;

-- 
-- Estructura de la tabla `gestion_hotel_sc.gerente`
-- 

drop table if exists `gerente`;
create table `gerente`(
	dni_gerente int not null primary key,
    fecha_ingreso date not null, -- previa a la fecha corriente
    sueldo float not null, -- positivo
    constraint foreign key (dni_gerente) references persona (dni_persona),
    constraint sueldo_gerente_positive check(sueldo >= 0)
);

delimiter $$
create trigger trigger_fecha_current_gerente
	before insert on gerente
	for each row
		begin
            declare dni_varchar varchar(8);
            declare output varchar(100);
			set dni_varchar = new.dni_gerente;
            set output = concat('Fecha invalida en gerente al insertar DNI: ', dni_varchar);
            
			if new.fecha_ingreso > curdate() then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

delimiter $$
create trigger trigger_baja_gerente
	before delete on gerente
	for each row
		begin
			delete from comision where old.dni_gerente = comision.dni_gerente;
			if old.dni_gerente != cliente.dni_cliente then
				delete from persona where old.dni_gerente = persona.dni_persona;
			end if;
		end;
$$
delimiter ;

-- 
-- Estructura de la tabla `gestion_hotel_sc.comision`
-- 

drop table if exists `comision`;
create table `comision`(
	nro_comision int not null, -- positivo
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
    constraint costo_positive check(costo >= 0),
    constraint ct_positive check(cod_tipo >= 0)
);

delimiter $$
create trigger trigger_baja_tipo_hab
	before delete on tipo_habitacion
	for each row
		begin
			delete from habitacion where old.cod_tipo = habitacion.cod_tipo;
		end;
$$
delimiter ;

-- 
-- Estructura de la tabla `gestion_hotel_sc.habitacion`
-- 

drop table if exists `habitacion`;
create table `habitacion`(
	nro_habitacion int not null primary key, -- positivo
	cant_camas int not null, -- mayor que 0 menor que 3 habitaciones hasta triples
    cod_tipo int not null,
    constraint foreign key (cod_tipo) references tipo_habitacion (cod_tipo),
	constraint cant_camas_rest check(cant_camas > 0 and cant_camas < 4),
    constraint nh_positive check(nro_habitacion >= 0)
);

delimiter $$
create trigger trigger_baja_habitacion
	before delete on habitacion
	for each row
		begin
			if old.nro_habitacion != ocupada.nro_habitacion then
				delete from atiende where old.nro_habitacion = atiende.nro_habitacion;
			end if;
		end;
$$
delimiter ;

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
	fecha_art date not null primary key -- previa a la fecha corriente
);

delimiter $$
create trigger trigger_fecha_current_fecha
	before insert on fecha
	for each row
		begin
            declare output varchar(100);
            set output = concat('Fecha invalida: ', fecha_art);
            
			if new.fecha_art > curdate() then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

-- 
-- Estructura de la tabla `gestion_hotel_sc.ocupada`
-- 

drop table if exists `ocupada`;
create table `ocupada`(
	nro_habitacion int not null,
    fecha_art date not null,
    dni_cliente int not null,
    precio_noche float not null,
    cantid_dias int not null,
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion),
    constraint foreign key (fecha_art) references fecha (fecha_art),
    constraint foreign key (dni_cliente) references cliente (dni_cliente),
	constraint primary key (nro_habitacion, fecha_art),
    constraint pn_positive check(precio_noche > 0),
    constraint cd_positive check(cantid_dias > 0)
);