use telovendo; # acceso a la base de datos telovendo

CREATE USER 'ustlv'@'localhost' IDENTIFIED BY '12345678'; # creación de usuario en la base de datos

GRANT ALL PRIVILEGES ON telovendo.* TO 'ustlv'@'localhost'; # otorgar permisos de escritura, lectura, modificación y eliminiación

SHOW GRANTS FOR 'ustlv'@'localhost'; # consultar sobre los permisos otorgados
FLUSH PRIVILEGES; # Refrescar la estructura de la tabla y los permisos del usuario para asegurarse de que se apliquen los cambios recientes.

# Creación de tablas solicitadas
#1.Tabla de categoría.
CREATE TABLE categoria (id_categoria INT NOT NULL AUTO_INCREMENT,nombre VARCHAR(45) NOT NULL,
descripcion VARCHAR(45) NOT NULL, PRIMARY KEY (id_categoria));

#2.Tabla de productos
alter table producto drop column categoria_producto;
alter table producto add column color varchar(10), add column id_categoria int;
truncate producto;
alter table producto add constraint fk_categ  foreign key (id_categoria) references categoria(id_categoria);

#3.Tabla representante legal
CREATE TABLE representante_legal(id_repr_legal INT primary key AUTO_INCREMENT, nombre VARCHAR(45) not NULL);

#4.Tabla proveedor
CREATE TABLE proveedor(id_proveedor INT primary key AUTO_INCREMENT, id_repr_legal int not null, id_categoria INT NOT NULL, nombre VARCHAR(45) NOT NULL,
direccion VARCHAR(45) NOT NULL, email_facturacion VARCHAR(45) NOT NULL, FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria),
foreign key(id_repr_legal) references representante_legal(id_repr_legal));

#5.Tabla contacto proveedor
CREATE TABLE contacto_proveedor(id_contact INT primary key AUTO_INCREMENT, id_proveedor INT NOT NULL,
nombre VARCHAR(45) not NULL, telefono VARCHAR(15), FOREIGN KEY (id_proveedor) REFERENCES proveedor (id_proveedor));

#Agregando datos a la tabla categoría
insert into categoria (nombre,descripcion) value 
('Electrónica', 'Articulos de electrónica en general'),
('Accesorios', 'Mouse, teclado'),
('TV y Video', 'Tablet y Smart TV'),
('Audio', 'Parlantes, aurdífonos'),
('Otros', 'Varios');

#agragando datos a la tabla producto
insert into producto (nombre_producto, fabricante_producto, precio, id_categoria, stock_producto, color)
value 
('Reloj inteligente', 'Samsung','129990', '1', '125', 'Rojo'),
('Teclado', 'Chancho','10990', '2', '20', 'Morado'),
('Ipad', 'Apple','159990', '3', '10', 'Azul'),
('Audifonos', 'Maxx','21990', '4', '23', 'Plata'),
('Notebook', 'Genérico','8990', '1', '50', 'Verde'),
('Roku', 'Roku','89990', '1', '10', 'Negro'),
('Mouse', 'Utek','21990', '2', '20', 'Negro'),
('Smart Tv', 'Recco','189990', '3', '3', 'Blanco'),
('Barra de sonido', 'LG','79990', '4', '8', 'Negro'),
('Pendrive 32 GB', 'Genérico','5990', '5', '70', 'Plata');

#agregando datos a la tabla representante legal
insert into representante_legal (nombre) values
('Hendrick Sandwich'),
('Leeland Dafforne'),
('Winston Giacometti'),
('Sarge Sprigings'),
('Guendolen Paladino');

#Agregando datos a la tabla proveedor 
insert into proveedor (id_repr_legal, id_categoria, nombre, direccion, email_facturacion)
value
(1, 1, 'Todo electrónica','La casa de nadie','electronica@gmail.com'),
(2, 2, 'La casa del teclado','Condell 1980','lacasade@gmail.com'),
(3, 1, 'Apple Store ','Apoquindo 1923','astore@gmail.com'),
(4, 3, 'Teletronik','Ahumada 3098','telectronik@hotmail.com'),
(5, 1, 'El rey del circuito integrado','La huinca 38773','lahuinca@yahoo.com');

#Agregando datos a la tabla contacto proveedor  
insert into contacto_proveedor (id_proveedor,nombre, telefono)values
(1,'Carlos Santana','0964746454'),
(1, 'Tamqrah Zipsell', '(567) 9201165'),
(2,'Leonel Sánchez','0985756575'),
(2, 'Perla Griniov', '(194) 8949474'),
(3,'Karla Rubilar','0998765434'),
(3, 'Alverta Gebhardt', '(675) 4830975'),
(4,'Carolina Huerta','0976828393'),
(4, 'Bartlet Trumble', '(381) 9261404'),
(5,'Milenka Gómez','099857565'),
(5, 'Mellicent Brasier', '(870) 3102554');

#Agregando datos a la tabla cliente
insert into cliente (nombres_cliente,apellidos_cliente,telefono_cliente,direccion_cliente,comuna_cliente,correo_cliente)
values 
('Ana','García','023456789','Calle 1 # 123','Santiago','ana.garcia@terra.com'),
('Juan','Pérez','32987659','Avenida 2 # 456','Providencia','juan.perez@hotmail.com'),
('Maria','Fernandez','339828397','Calle 3 # 789','Las Condes','maria.fernandez@yahoo.com'),
('Carlos','Ramirez','329823334','Avenida 4 # 012','La Florida','carlos.ramirez@terra.com'),
('Sofia','Castro','02988555','Calle 5 # 345','Ñuñoa','sofia.castro@gmail.com');

#Cuál es la categoría de productos que más se repite.
SELECT categoria.nombre, count(*) as cantidad FROM categoria INNER JOIN producto ON categoria.id_categoria = producto.id_categoria
GROUP BY categoria.nombre ORDER BY cantidad DESC LIMIT 1;

#Cuáles son los productos con mayor stock
Select * from producto order by stock_producto desc;

#Qué color de producto es más común en nuestra tienda.
select color,count(color) as cantidad from producto group by color order by cantidad desc limit 1;

#Cual o cuales son los proveedores con menor stock de productos.
select proveedor.nombre, stock.total as total_stock from proveedor inner join categoria on proveedor.id_categoria = categoria.id_categoria
inner join (select id_categoria, sum(stock_producto) as total from producto group by id_categoria) as stock on stock.id_categoria = categoria.id_categoria
where stock.total = (select min(stock.total) as min from (select id_categoria, sum(stock_producto) as total from producto group by id_categoria) as stock) order by total_stock asc;

#Cambien la categoría de productos más popular por ‘Electrónica y computación’.
UPDATE categoria SET nombre = 'Electrónica y computación' WHERE id_categoria = (select id_categoria from proveedor group by id_categoria order by count(id_proveedor) desc limit 1);