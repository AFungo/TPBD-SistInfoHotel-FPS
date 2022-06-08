/*
6. Resolver las siguientes consultas:
a) Devolver clientes que no se registraron en habitaciones “dobles”.
b) Listar los clientes con el total que abonó en todas sus registraciones.
c) Listar el personal que es cliente del Hotel con todos sus datos personales.
d) Definir consultas propias (no menos de tres), donde por lo menos una utilice subconsultas.
*/

-- a)
select dni_cliente from cliente
where dni_cliente not in(select dni_cliente from habitacion natural join ocupada where cant_camas = 2);

-- b)
select dni_cliente, sum(precio_noche * cant_dias) as total_abonado from cliente natural join ocupada
group by dni_cliente;

-- c)
(select dni_cliente, fecha_1ra_vez, fecha_ingreso, sueldo from cliente join mucama on dni_cliente = dni_mucama) union (select dni_cliente, fecha_1ra_vez, fecha_ingreso, sueldo from cliente join gerente on dni_cliente = dni_gerente);

-- d)
-- Habitaciones, con su tipo y precio por noche, que no estan ocupadas
select nro_habitacion, cant_camas, cod_tipo, precio_noche from habitacion natural join ocupada
where fecha_ocup != curdate() and curdate() - fecha_ocup > cant_dias
group by nro_habitacion;

-- Habitaciones que nunca fueron ocupadas
select nro_habitacion, cant_camas, cod_tipo from habitacion
where nro_habitacion not in(select distinct nro_habitacion from ocupada);

-- Cuantas veces se hospedaron los clientes con sus datos
select cliente.dni_cliente, nombre, apellido, fecha_nac, count(ocupada.dni_cliente) as cant_hospedajes from (cliente join persona on dni_cliente = dni_persona) join ocupada on cliente.dni_cliente = ocupada.dni_cliente
group by dni_cliente;