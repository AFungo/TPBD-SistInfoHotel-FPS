--
-- Crea la base de datos gestion_hotel_sc
--

create schema /*!32312 if not exists*/ gestion_hotel_sc;
use gestion_hotel_sc;

-- 
-- Estructura de la tabla `gestion_hotel_sc.persona`
-- 

drop table if exists `atiende`;
drop table if exists `modificaciones_ocupada`;
drop table if exists `ocupada`;
drop table if exists `habitacion`;
drop table if exists `tipo_habitacion`;
drop table if exists `comision`;
drop table if exists `gerente`;
drop table if exists `mucama`;
drop table if exists `cliente`;
drop table if exists `persona`;

create table `persona`(
	dni_persona int(10) not null primary key,
    nombre varchar(40) not null,
    apellido varchar(40) not null,
    fecha_nac date not null,
    constraint valid_dni check (dni_persona > 0)
);

delimiter $$
create trigger trigger_fecha_nac_persona
	before insert on persona
	for each row
		begin
            declare dni_varchar varchar(8);
            declare output varchar(100);
			set dni_varchar = new.dni_persona;
            set output = concat('Fecha invalida al insertar DNI: ', dni_varchar, '. Debe ser Mayor de Edad');
            
			if new.fecha_nac >= date_sub(curdate(), interval 18 year) then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

-- 
-- Estructura de la tabla `gestion_hotel_sc.cliente`
-- 

create table `cliente`(
	dni_cliente int not null primary key,
    fecha_1ra_vez date not null, -- previa a la fecha corriente
    constraint foreign key (dni_cliente) references persona (dni_persona) on delete cascade
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

-- 
-- Estructura de la tabla `gestion_hotel_sc.mucama`
-- 

create table `mucama`(
	dni_mucama int not null primary key,
    fecha_ingreso date not null, -- previa a la fecha corriente
    sueldo float not null, -- positivo
    constraint foreign key (dni_mucama) references persona (dni_persona) on delete cascade,
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

-- 
-- Estructura de la tabla `gestion_hotel_sc.gerente`
-- 

create table `gerente`(
	dni_gerente int not null primary key,
    fecha_ingreso date not null, -- previa a la fecha corriente
    sueldo float not null, -- positivo
    constraint foreign key (dni_gerente) references persona (dni_persona) on delete cascade,
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

-- 
-- Estructura de la tabla `gestion_hotel_sc.comision`
-- 

create table `comision`(
	nro_comision int not null, -- positivo
	dni_gerente int not null,
    monto float not null, -- positivo
    constraint foreign key (dni_gerente) references gerente (dni_gerente) on delete cascade,
	constraint primary key (nro_comision, dni_gerente),
    constraint nc_positive check(nro_comision >= 0)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.tipo_habitacion`
-- 

create table `tipo_habitacion`(
	cod_tipo int not null primary key,
	descripcion varchar(200) not null,
    costo float not null, -- positivo
    constraint costo_positive check(costo >= 0),
    constraint ct_positive check(cod_tipo >= 1 and cod_tipo <= 4)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.habitacion`
-- 

create table `habitacion`(
	nro_habitacion int not null primary key, -- positivo
	cant_camas int not null, -- mayor que 0 menor que 3 habitaciones hasta triples
    cod_tipo int not null,
    constraint foreign key (cod_tipo) references tipo_habitacion (cod_tipo) on delete cascade,
	constraint cant_camas_rest check(cant_camas > 0 and cant_camas < 4),
    constraint nh_positive check(nro_habitacion >= 0)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.atiende`
-- 

create table `atiende`(
	dni_mucama int not null,
	nro_habitacion int not null,
    constraint foreign key (dni_mucama) references mucama (dni_mucama) on delete cascade,
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion) on delete cascade,
	constraint primary key (dni_mucama, nro_habitacion)
);

-- 
-- Estructura de la tabla `gestion_hotel_sc.ocupada`
-- 

create table `ocupada`(
	nro_habitacion int not null,
    fecha_ocup date not null,
    dni_cliente int not null,
    precio_noche float not null,
    cant_dias int not null,
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion) on delete cascade,
    constraint foreign key (dni_cliente) references cliente (dni_cliente) on delete cascade,
	constraint primary key (nro_habitacion, fecha_ocup),
    constraint pn_positive check(precio_noche > 0),
    constraint cd_positive check(cant_dias > 0)
);

delimiter $$
create trigger trigger_fecha_current_ocupada
	before insert on ocupada
	for each row
		begin
            declare output varchar(100);
            set output = concat('Fecha invalida: ', new.fecha_ocup);
            
			if new.fecha_ocup > curdate() then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

delimiter $$
create trigger trigger_cliente_ocupa_1_hab
	before insert on ocupada
	for each row
		begin
            declare dni_varchar varchar(8);
            declare output varchar(100);
			set dni_varchar = new.dni_cliente;
            set output = concat('El cliente con DNI: ', dni_varchar, ' no puede ser registrado en mas de una habitacion el mismo dia');
            
			if new.nro_habitacion != (select nro_habitacion from ocupada oc where new.dni_cliente = oc.dni_cliente and new.fecha_ocup = oc.fecha_ocup) then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

delimiter $$
create trigger trigger_clientes_al_mismo_tiempo_misma_hab
	before insert on ocupada
	for each row
		begin
            declare output varchar(200);
            declare cant_dias_registrada int;
            declare fecha_ocup_registrada date;
            declare fecha_ocup_varchar date;
            
            select cant_dias into cant_dias_registrada from ocupada oc where new.nro_habitacion = oc.nro_habitacion order by fecha_ocup desc limit 1;
            select fecha_ocup into fecha_ocup_registrada from ocupada oc where new.nro_habitacion = oc.nro_habitacion order by fecha_ocup desc limit 1;
            
            set fecha_ocup_varchar = date_add(fecha_ocup_registrada, interval cant_dias_registrada day);
            set output = concat('Habitacion ocupada. La habitacion nro ', new.nro_habitacion,' estara ocupada desde: ', fecha_ocup_registrada, ' hasta: ', fecha_ocup_varchar);
            
			if fecha_ocup_registrada < date_add(new.fecha_ocup, interval new.cant_dias day) and new.fecha_ocup < date_add(fecha_ocup_registrada, interval cant_dias_registrada day) then
				signal sqlstate '45000' set message_text = output;
            end if;
		end;
$$
delimiter ;

create table `modificaciones_ocupada`(
	nro_habitacion int not null,
    fecha_modificacion date not null,
    dni_cliente_anterior int not null,
    dni_cliente_posterior int not null,
    usuario_realizo_cambio char(30) not null,
    constraint foreign key (nro_habitacion) references habitacion (nro_habitacion) on delete cascade,
    constraint foreign key (dni_cliente_anterior) references cliente (dni_cliente) on delete cascade,
    constraint foreign key (dni_cliente_posterior) references cliente (dni_cliente) on delete cascade
);

delimiter $$
create trigger trigger_modificacion_hab_ocup
	after update on ocupada
	for each row
		begin
			insert into modificaciones_ocupada values(old.nro_habitacion, now(), old.dni_cliente, new.dni_cliente, current_user());
		end;
$$
delimiter ;

/*
Ejemplo actualizacion de habitacion ocupada
update ocupada set fecha_ocup = '2022-05-14', dni_cliente = 43189932, precio_noche = 3543.00, cant_dias = 3
where nro_habitacion = 5 and fecha_ocup = '2016-08-29';
*/