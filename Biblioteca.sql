
-- 1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas
-- definidas y sus atributos. (2 puntos).

CREATE DATABASE biblioteca;

\c biblioteca;

CREATE TABLE socios(
    rut INT PRIMARY KEY,
    nombre VARCHAR(20),
    apellido  VARCHAR(20),
    direccion VARCHAR(20),
    telefono INT);


CREATE TABLE libros(
    isbn BIGINT PRIMARY KEY,
    pag INT,
    titulo VARCHAR(50),
    dias_prestamos INT
);

CREATE TABLE autores(
    codautor SERIAL PRIMARY KEY,
    nombre_autor  VARCHAR(20),
    apellido_autor VARCHAR(20),
    tipo_autor VARCHAR(20),
    nacimiento INT,
    deceso INT NULL
);

CREATE TABLE historial_prestamo(
    socios_id INT,
    libro_id  BIGINT,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY  (socios_id) REFERENCES socios(rut),
    FOREIGN KEY (libro_id) REFERENCES libros(isbn)
);


CREATE TABLE libros_autores(
    codautor_id INT,
    isbn_id BIGINT,
    FOREIGN KEY (codautor_id) REFERENCES autores(codautor),
    FOREIGN KEY (isbn_id) REFERENCES libros(isbn)
);



-- 2. Se deben insertar los registros en las tablas correspondientes

INSERT INTO socios(rut,nombre,apellido,direccion,telefono)
VALUES (11111111,'JUAN','SOTO', 'AVENIDA 1, SANTIAGO' ,911111111);

INSERT INTO socios(rut,nombre,apellido,direccion,telefono)
VALUES (22222222,'ANA' ,'PÉREZ','PASAJE 2, SANTIAGO' ,922222222);

INSERT INTO socios(rut,nombre,apellido,direccion,telefono)
VALUES (33333333,'SANDRA' ,'AGUILAR','AVENIDA 2, SANTIAGO' ,933333333);

INSERT INTO socios(rut,nombre,apellido,direccion,telefono)
VALUES (44444444,'ESTEBAN' ,'JEREZ','AVENIDA 3, SANTIAGO' ,944444444);

INSERT INTO socios(rut,nombre,apellido,direccion,telefono)
VALUES (55555555,'SILVANA' ,'MUÑOZ','PASAJE 3, SANTIAGO' ,955555555);


INSERT INTO Libros (isbn,pag,titulo,dias_prestamos)
VALUES(1111111111111,344,'CUENTOS DE TERROR',7);

INSERT INTO Libros (isbn,pag,titulo,dias_prestamos)
VALUES(2222222222222,167,'POESÍAS CONTEMPORANEAS',7);  

INSERT INTO Libros (isbn,pag,titulo,dias_prestamos)
VALUES(3333333333333,511,'HISTORIA DE ASIA',14);  

INSERT INTO Libros (isbn,pag,titulo,dias_prestamos)
VALUES(4444444444444,298,'MANUAL DE MECÁNICA',14); 


INSERT INTO autores(nombre_autor,apellido_autor,tipo_autor,nacimiento,deceso)
VALUES('ANDRES','ULLOA','PRINCIPAL','1982',NULL);

INSERT INTO autores(nombre_autor,apellido_autor,tipo_autor,nacimiento,deceso)
VALUES('SERGIO','MARDONES ','PRINCIPAL','1950','2012');

INSERT INTO autores(nombre_autor,apellido_autor,tipo_autor,nacimiento,deceso)
VALUES('JOSE','SALGADO','PRINCIPAL','1968','2020');

INSERT INTO autores(nombre_autor,apellido_autor,tipo_autor,nacimiento,deceso)
VALUES('ANA','SALGADO','COAUTOR','1972',NULL);

INSERT INTO autores(nombre_autor,apellido_autor,tipo_autor,nacimiento,deceso)
VALUES('MARTIN','PORTA','PRINCIPAL','1976',NULL);



INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/20','2020/01/27',11111111,1111111111111);

INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/20','2020/01/30',55555555,2222222222222);

INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/22','2020/01/30',33333333,3333333333333);

INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/23','2020/01/30',44444444,4444444444444);

INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/27','2020/02/04',22222222,1111111111111);

INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/31','2020/02/12',11111111,4444444444444);

INSERT INTO historial_prestamo(fecha_prestamo,fecha_devolucion,socios_id,libro_id)
VALUES('2020/01/31','2020/02/12',33333333,2222222222222);

INSERT INTO libros_autores(codautor_id,isbn_id)
VALUES(1,2222222222222);

INSERT INTO libros_autores(codautor_id,isbn_id)
VALUES(2,3333333333333);

INSERT INTO libros_autores(codautor_id,isbn_id)
VALUES(3,1111111111111);

INSERT INTO libros_autores(codautor_id,isbn_id)
VALUES(4,1111111111111);

INSERT INTO libros_autores(codautor_id,isbn_id)
VALUES(5,4444444444444);



-- Realizar las siguientes consultas:
-- a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)

SELECT titulo,pag FROM libros WHERE pag BETWEEN 1 AND 300;



-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970.-- (0.5 puntos)


SELECT nombre_autor,apellido_autor,nacimiento FROM autores WHERE nacimiento  BETWEEN 1970 AND 2021;



-- c. ¿Cuál es el libro más solicitado? (0.5 puntos).

-- "having" permite seleccionar (o rechazar) un grupo de registros.
-- GROUP BY es un comando SQL que se usa para agrupar filas que tienen los mismos valores

SELECT A.libro_id, b.titulo FROM historial_prestamo AS A INNER JOIN Libros AS b ON A.libro_id = b.isbn GROUP BY A.libro_id ,b.titulo HAVING COUNT(*)>1; 

-- (HAVING COUNT(*)>1;  cuenta los registros que estan duplicados)


-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
--debería pagar cada usuario que entregue el préstamo después de 7 días.
-- (0.5 puntos)
-- _

-- FORMA 1 con nombre


SELECT A.nombre,A.Apellido,B.libro_id,titulo,B.fecha_devolucion,B.fecha_prestamo,
B.fecha_devolucion-B.fecha_prestamo 
AS diferencia,(B.fecha_devolucion-B.fecha_prestamo)-7 
AS diasdetraso,((B.fecha_devolucion-B.fecha_prestamo)-7)*100 
AS multa 
FROM socios 
AS A 
INNER JOIN historial_prestamo AS B ON A.rut =B.socios_id
INNER JOIN libros
ON B.libro_id = libros.isbn;

-- FORMA 2 con id socion y age

SELECT socios_id,fecha_prestamo,fecha_devolucion,libro_id,AGE(fecha_devolucion,fecha_prestamo) 
AS diasprestamo, (fecha_devolucion-fecha_prestamo)-7
AS diasdetraso,((fecha_devolucion-fecha_prestamo)-7)*100  
AS multa
FROM historial_prestamo;

-- FORMA 3 con id  libro
SELECT libro_id,fecha_devolucion-fecha_prestamo 
AS diferencia,(fecha_devolucion-fecha_prestamo)-7 
AS diasdetraso,((fecha_devolucion-fecha_prestamo)-7)*100 
AS multa 
FROM historial_prestamo;   


