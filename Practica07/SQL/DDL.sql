--no create database ?
--CREATE DATABASE gran_vivero

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TYPE asoleo_planta AS ENUM ('sol', 'sombra', 'resolana');
CREATE TYPE metodo_pago AS ENUM ('efectivo', 'debito', 'credito', 'transferencia', 'otro');

CREATE TABLE Planta (
	NombrePlanta VARCHAR(256),
	Cuidado TEXT,
	Genero VARCHAR(128),
	Precio INTEGER,--decimal en centavos
	TipoAsoleo asoleo_planta,
	TipoOrigen VARCHAR(128),
	FechaGerminacion DATE,
	IdVentaFisica INTEGER,
	IdVentaElectronica INTEGER
);

CREATE TABLE Vivero (
	NombreVivero VARCHAR(256),
	FechaApertura DATE,
	Estado VARCHAR(256),
	CP CHAR(5),--son 5 números fijos, los representamos como cadenas para evitar confusión en operaciones
	Calle VARCHAR(256),
	NumeroExterior VARCHAR(16)--Hay números que llevan letra, como en duplexes
);

CREATE TABLE ViveroTelefono (
	NombreVivero VARCHAR(256),
	Telefono CHAR(10)
);

CREATE TABLE Cliente (
	IdCliente INTEGER,
	FechaNacimiento DATE,
	Nombre VARCHAR(128),
	ApellidoP VARCHAR(128),
	ApellidoM VARCHAR(128),
	Estado VARCHAR(256),
	CP CHAR(5),
	Calle VARCHAR(256),
	NumeroExterior VARCHAR(16)
);

CREATE TABLE ClienteTelefono (
	IdCliente INTEGER,
	Telefono CHAR(10)
);

CREATE TABLE ClienteCorreoElectronico (
	IdCliente INTEGER,
	CorreoElectronico VARCHAR(128)
);

CREATE TABLE VentaElectronica (
	IdVentaElectronica INTEGER,
	IdCliente INTEGER,
	NumeroProductos INTEGER,
	MetodoPago metodo_pago,
	NumeroSeguimiento INTEGER,
	FechaPedido DATE,
	Estado VARCHAR(256),
	CP CHAR(5),
	Calle VARCHAR(256),
	NumeroExterior VARCHAR(16)
);

CREATE TABLE Empleado (
	IdEmpleado INTEGER,
	NombreVivero VARCHAR(256),
	FechaNacimiento DATE,
	Nombre VARCHAR(128),
	ApellidoP VARCHAR(128),
	ApellidoM VARCHAR(128),
	Estado VARCHAR(256),
	CP CHAR(5),
	Calle VARCHAR(256),
	NumeroExterior VARCHAR(16),
	Rol VARCHAR(128), --{gerente, cuidador de plantas, encargado de mostrar a cliente, cajero}
	Salario INTEGER --decimal en centavos
);

CREATE TABLE EmpleadoTelefono (
	IdEmpleado INTEGER,
	Telefono CHAR(10)
);

CREATE TABLE EmpleadoCorreoElectronico (
	IdEmpleado INTEGER,
	CorreoElectronico VARCHAR(128)
);

CREATE TABLE VentaFisica (
	IdVentaFisica INTEGER,
	IdCliente INTEGER,
	AyudarIdEmpleado INTEGER,
	CobrarIdEmpleado INTEGER,
	NumeroProductos INTEGER,
	MetodoPago metodo_pago
);

CREATE TABLE EntregarVentaFisica (
	IdVentaFisica INTEGER,
	NombrePlanta VARCHAR(256)
);

CREATE TABLE EntregarVentaElectronica (
	IdVentaElectronica INTEGER,
	NombrePlanta VARCHAR(256)
);

--Se llamaba En
CREATE TABLE EstarEn (
	NombreVivero VARCHAR(256),
	NombrePlanta VARCHAR(256),
	NumeroDePlantasVivero INTEGER
);

--- Restricciones:
--PK
ALTER TABLE Planta ADD CONSTRAINT Planta_pkey PRIMARY KEY (NombrePlanta);
ALTER TABLE Vivero ADD CONSTRAINT Vivero_pkey PRIMARY KEY (NombreVivero);
ALTER TABLE ViveroTelefono ADD CONSTRAINT ViveroTelefono_pkey PRIMARY KEY (NombreVivero, Telefono);
ALTER TABLE Cliente ADD CONSTRAINT Cliente_pkey PRIMARY KEY (IdCliente);
ALTER TABLE ClienteTelefono ADD CONSTRAINT ClienteTelefono_pkey PRIMARY KEY (IdCliente, Telefono);
ALTER TABLE ClienteCorreoElectronico ADD CONSTRAINT ClienteCorreoElectronico_pkey PRIMARY KEY (IdCliente, CorreoElectronico);
ALTER TABLE VentaElectronica ADD CONSTRAINT VentaElectronica_pkey PRIMARY KEY (IdVentaElectronica);
ALTER TABLE Empleado ADD CONSTRAINT Empleado_pkey PRIMARY KEY (IdEmpleado);
ALTER TABLE EmpleadoTelefono ADD CONSTRAINT EmpleadoTelefono_pkey PRIMARY KEY (IdEmpleado, Telefono);
ALTER TABLE EmpleadoCorreoElectronico ADD CONSTRAINT EmpleadoCorreoElectronico_pkey PRIMARY KEY (IdEmpleado, CorreoElectronico);
ALTER TABLE VentaFisica ADD CONSTRAINT VentaFisica_pkey PRIMARY KEY (IdVentaFisica);

--FK
ALTER TABLE Planta ADD FOREIGN KEY (IdVentaFisica) REFERENCES VentaFisica(IdVentaFisica);
ALTER TABLE Planta ADD FOREIGN KEY (IdVentaElectronica) REFERENCES VentaElectronica(IdVentaElectronica);

ALTER TABLE Empleado ADD FOREIGN KEY (NombreVivero) REFERENCES Vivero(NombreVivero);

ALTER TABLE EmpleadoTelefono ADD FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado);

ALTER TABLE VentaElectronica ADD FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);
ALTER TABLE VentaFisica ADD FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);
ALTER TABLE VentaFisica ADD FOREIGN KEY (AyudarIdEmpleado) REFERENCES Empleado(IdEmpleado);
ALTER TABLE VentaFisica ADD FOREIGN KEY (CobrarIdEmpleado) REFERENCES Empleado(IdEmpleado);

ALTER TABLE EntregarVentaElectronica ADD FOREIGN KEY (IdVentaElectronica) REFERENCES VentaElectronica(IdVentaElectronica);
ALTER TABLE EntregarVentaElectronica ADD FOREIGN KEY (NombrePlanta) REFERENCES Planta(NombrePlanta);
ALTER TABLE EntregarVentaFisica ADD FOREIGN KEY (IdVentaFisica) REFERENCES VentaFisica(IdVentaFisica);
ALTER TABLE EntregarVentaFisica ADD FOREIGN KEY (NombrePlanta) REFERENCES Planta(NombrePlanta);

ALTER TABLE EstarEn ADD FOREIGN KEY (NombreVivero) REFERENCES Vivero(NombreVivero);
ALTER TABLE EstarEn ADD FOREIGN KEY (NombrePlanta) REFERENCES Planta(NombrePlanta);

-- restricciones de dominio
ALTER TABLE Planta ALTER COLUMN Cuidado SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN Genero SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN Precio SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN TipoAsoleo SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN TipoOrigen SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN FechaGerminacion SET NOT NULL;
ALTER TABLE Planta ADD CONSTRAINT dinero CHECK (Precio >= 0);

ALTER TABLE Vivero ALTER COLUMN FechaApertura SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN Estado SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN CP SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN Calle SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN NumeroExterior SET NOT NULL;

ALTER TABLE Cliente ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN ApellidoP SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN ApellidoM SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN Estado SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN CP SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN Calle SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN NumeroExterior SET NOT NULL;

ALTER TABLE VentaElectronica ALTER COLUMN NumeroProductos SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN MetodoPago SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN NumeroSeguimiento SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN FechaPedido SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN Estado SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN CP SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN Calle SET NOT NULL;
ALTER TABLE VentaElectronica ALTER COLUMN NumeroExterior SET NOT NULL;

ALTER TABLE Empleado ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN Nombre SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN ApellidoP SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN ApellidoM SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN Estado SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN CP SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN Calle SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN NumeroExterior SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN Rol SET NOT NULL;
ALTER TABLE Empleado ALTER COLUMN Salario SET NOT NULL;
ALTER TABLE Empleado ADD CONSTRAINT dinero CHECK (Salario >= 0);

ALTER TABLE VentaFisica ALTER COLUMN CobrarIdEmpleado SET NOT NULL;
ALTER TABLE VentaFisica ALTER COLUMN NumeroProductos SET NOT NULL;
ALTER TABLE VentaFisica ALTER COLUMN MetodoPago SET NOT NULL;

ALTER TABLE EntregarVentaFisica ALTER COLUMN IdVentaFisica SET NOT NULL;
ALTER TABLE EntregarVentaFisica ALTER COLUMN NombrePlanta SET NOT NULL;

ALTER TABLE EntregarVentaElectronica ALTER COLUMN IdVentaElectronica SET NOT NULL;
ALTER TABLE EntregarVentaElectronica ALTER COLUMN NombrePlanta SET NOT NULL;

ALTER TABLE EstarEn ALTER COLUMN NombreVivero SET NOT NULL;
ALTER TABLE EstarEn ALTER COLUMN NombrePlanta SET NOT NULL;
ALTER TABLE EstarEn ALTER COLUMN NumeroDePlantasVivero SET NOT NULL;

--Comments

COMMENT ON TABLE Planta IS 'Tabla que contiene la informacion de las Plantas';
COMMENT ON COLUMN Planta.NombrePlanta IS 'Nombre de la planta ';
COMMENT ON COLUMN Planta.Cuidado IS 'Cuidados especiales que requiere cada planta';
COMMENT ON COLUMN Planta.Genero IS 'Genero de la planta (Genero de orden cientifico)';
COMMENT ON COLUMN Planta.Precio IS 'Costo de la planta';
COMMENT ON COLUMN Planta.TipoAsoleo IS 'Asoleo que requiere recibir la planta';
COMMENT ON COLUMN Planta.TipoOrigen IS 'Sustrato que requiere la planta';
COMMENT ON COLUMN Planta.FechaGerminacion IS 'Fecha en la que la planta germina';
COMMENT ON COLUMN Planta.IdVentaFisica IS '';--A decir verdad no tengo idea de que onda con esto
COMMENT ON COLUMN Planta.IdVentaElectronica IS '';--Lo mismo aqui
COMMENT ON CONSTRAINT Planta_pkey ON Planta IS 'Llave primaria de la tabla Planta';
COMMENT ON CONSTRAINT dinero ON Planta IS 'Nos aseguramos que el valor de la columna Precio no sea negativo';

COMMENT ON TABLE Vivero IS 'Tabla que contiene la informacion de los viveros';
COMMENT ON COLUMN Vivero.NombreVivero IS 'Nombre del vivero';
COMMENT ON COLUMN Vivero.FechaApertura IS 'Fecha de apertura del vivero';
COMMENT ON COLUMN Vivero.Estado IS 'Estado en el que se encuentra el vivero';
COMMENT ON COLUMN Vivero.CP IS 'Codigo postal correspondiente al vivero';
COMMENT ON COLUMN Vivero.Calle IS 'Calle en la que se encuentra el vivero';
COMMENT ON COLUMN Vivero.NumeroExterior IS 'Numero exterior de la direccion del vivero';
COMMENT ON CONSTRAINT Vivero_pkey ON Vivero Is 'Llave primaria de la tabla Vivero';

COMMENT ON TABLE ViveroTelefono IS 'Tabla que contiene los telefonos correspondientes a los viveros';
COMMENT ON COLUMN ViveroTelefono.NombreVivero IS 'Nombre del vivero al que pertenece el telefono';
COMMENT ON COLUMN ViveroTelefono.Telefono IS 'Numero telefonico';
COMMENT ON CONSTRAINT ViveroTelefono_pkey ON ViveroTelefono IS 'Llave primaria de la tabla ViveroTelefono';

COMMENT ON TABLE Cliente IS 'Tabla que contiene la informacion de los clientes';
COMMENT ON COLUMN Cliente.IdCliente IS 'Identificador del cliente';
COMMENT ON COLUMN Cliente.FechaNacimiento IS 'Fecha de nacimiento del cliente';
COMMENT ON COLUMN Cliente.Nombre IS 'Nombre(s) del cliente';
COMMENT ON COLUMN Cliente.ApellidoP IS 'Apellido paterno del cliente';
COMMENT ON COLUMN Cliente.ApellidoM IS 'Apellido materno del cliente';
COMMENT ON COLUMN Cliente.Estado IS 'Estado en el que vive el cliente';
COMMENT ON COLUMN Cliente.CP IS 'Codigo postal de la direccion del cliente';
COMMENT ON COLUMN Cliente.Calle IS 'Calle en la que vive el cliente';
COMMENT ON COLUMN Cliente.NumeroExterior IS 'Numero exterior de la direccion del cliente';
COMMENT ON CONSTRAINT Cliente_pkey ON Cliente IS 'Llave primaria de la tabla Cliente';

COMMENT ON TABLE ClienteTelefono IS 'Tabla que contiene los telefonos de los clientes';
COMMENT ON COLUMN ClienteTelefono.IdCliente IS 'Identificador del cliente al que pertenece el telefono';
COMMENT ON COLUMN ClienteTelefono.Telefono IS 'Numero telefonico';
COMMENT ON CONSTRAINT ClienteTelefono_pkey ON ClienteTelefono IS 'Llave primaria de la tabla ClienteTelefono';

COMMENT ON TABLE VentaElectronica IS 'Tabla contiene la informacion de las ventas electronicas';
COMMENT ON COLUMN VentaElectronica.IdVentaElectronica IS 'Identificador de la venta';
COMMENT ON COLUMN VentaElectronica.IdCliente IS 'Identificador del cliente que efectua la venta';
COMMENT ON COLUMN VentaElectronica.NumeroProductos IS 'Numero de productos en la venta';
COMMENT ON COLUMN VentaElectronica.MetodoPago IS 'Metodo de pago de la venta';
COMMENT ON COLUMN VentaElectronica.NumeroSeguimiento IS 'Numero de seguimiento del envio de la venta';
COMMENT ON COLUMN VentaElectronica.FechaPedido IS 'Fecha en la que se efectuo la venta';
COMMENT ON COLUMN VentaElectronica.Estado IS 'Estado al que se envia la venta';
COMMENT ON COLUMN VentaElectronica.CP IS 'Codigo postal al que se envia la venta';
COMMENT ON COLUMN VentaElectronica.Calle IS 'Calle de la direccion del envio';
COMMENT ON COLUMN VentaElectronica.NumeroExterior IS 'Numero exterior de la direccion del envio';
COMMENT ON CONSTRAINT VentaElectronica_pkey ON VentaElectronica IS 'Llave primaria de la tabla VentaElectronica';

COMMENT ON TABLE Empleado IS 'Tabla que contiene la informacion de los empleados ';
COMMENT ON COLUMN Empleado.IdEmpleado IS 'Identificador del empleado';
COMMENT ON COLUMN Empleado.NombreVivero IS 'Nombre del vivero en el que trabaja el empleado';
COMMENT ON COLUMN Empleado.FechaNacimiento IS 'Fecha de nacimiento del empleado';
COMMENT ON COLUMN Empleado.Nombre IS 'Nombre del empleado';
COMMENT ON COLUMN Empleado.ApellidoP IS 'Apellido paterno del empleado';
COMMENT ON COLUMN Empleado.ApellidoM IS 'Apellido materno del empleado';
COMMENT ON COLUMN Empleado.Estado IS 'Estado en el que vive el empleado';
COMMENT ON COLUMN Empleado.CP IS 'Codigo postal de la direccion del empleado';
COMMENT ON COLUMN Empleado.Calle IS 'Calle en la que vive el empleado';
COMMENT ON COLUMN Empleado.NumeroExterior IS 'Numero exterior de la direccion del empleado';
COMMENT ON COLUMN Empleado.Rol IS 'Rol del empleado en el vivero';
COMMENT ON COLUMN Empleado.Salario IS 'Salario del empleado';
COMMENT ON CONSTRAINT Empleado_pkey ON Empleado IS 'Llave primaria de la tabla Empleado';
COMMENT ON CONSTRAINT dinero ON Empleado IS 'Nos aseguramos que el valor de la columna Precio no sea negativo';

COMMENT ON TABLE EmpleadoTelefono IS 'Tabla que contiene los telefonos de los empleados';
COMMENT ON COLUMN EmpleadoTelefono.IdEmpleado IS 'Identificador del empleado al que pertenece el telefono';
COMMENT ON COLUMN EmpleadoTelefono.TELEFONO IS 'Numero telefonico';
COMMENT ON CONSTRAINT EmpleadoTelefono_pkey ON EmpleadoTelefono IS 'Llave primaria de la tabla EmpleadoTelefono';

COMMENT ON TABLE EmpleadoCorreoElectronico IS 'Tabla que contiene los correos electronicos de los empleados';
COMMENT ON COLUMN EmpleadoCorreoElectronico.IdEmpleado IS 'Identificador del empleado al que pertenece el correo electronico';
COMMENT ON COLUMN EmpleadoCorreoElectronico.CorreoElectronico IS 'Direccion de correo electronico';
COMMENT ON CONSTRAINT EmpleadoCorreoElectronico_pkey ON EmpleadoCorreoElectronico IS 'Llave primaria de la tabla EmpleadoCorreoElectronico';

COMMENT ON TABLE VentaFisica IS 'Tabla que contiene la informacion de las ventas fisicas';
COMMENT ON COLUMN VentaFisica.IdVentaFisica IS 'Identificador de la venta fisica';
COMMENT ON COLUMN VentaFisica.IdCliente IS 'Identificador del cliente que realiza la venta';
COMMENT ON COLUMN VentaFisica.AyudarIdEmpleado IS 'Identificador del empleado que ayuda con la venta';
COMMENT ON COLUMN VentaFisica.CobrarIdEmpleado IS 'Identificador del empleado que cobra la venta';
COMMENT ON COLUMN VentaFisica.NumeroProductos IS 'Numero de productos de la venta';
COMMENT ON COLUMN VentaFisica.MetodoPago IS 'Metodo de pago con el que se realizo la venta';
COMMENT ON CONSTRAINT VentaFisica_pkey ON VentaFisica IS 'Llave primaria de la tabla VentaFisica';

COMMENT ON TABLE EntregarVentaFisica IS 'Tabla que contiene la informacion de las entregas de plantas para las ventas fisicas';
COMMENT ON COLUMN EntregarVentaFisica.IdVentaFisica IS 'Identificador de la venta fisica';
COMMENT ON COLUMN EntregarVentaFisica.NombrePlanta IS 'Nombre de la planta';

COMMENT ON TABLE EntregarVentaElectronica IS 'Tabla que contiene la informacion de las entregas de plantas para las ventas electronicas';
COMMENT ON COLUMN EntregarVentaElectronica.IdVentaElectronica IS 'Identificador de la venta electronica';
COMMENT ON COLUMN EntregarVentaElectronica.NombrePlanta IS 'Nombre de la planta';

COMMENT ON TABLE EstarEn IS 'Tabla que contiene las existencias de plantas en cada vivero';
COMMENT ON COLUMN EstarEn.NombreVivero IS 'Nombre del vivero';
COMMENT ON COLUMN EstarEn.NombrePlanta IS 'Nombre de la planta';
COMMENT ON COLUMN EstarEn.NumeroDePlantasVivero IS 'Cantidad de plantas en vivero';