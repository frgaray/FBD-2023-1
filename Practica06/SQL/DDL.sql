--no create database ?
--CREATE DATABASE gran_vivero

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TYPE asoleo_planta AS ENUM ('sol', 'sombra', 'resolana');
CREATE TYPE metodo_pago AS ENUM ('efectivo', 'debito', 'credito', 'transferencia', 'otro');

CREATE TABLE Planta (
	NombrePlanta varchar(256),
	Cuidado text,
	Genero varchar(128),
	Precio integer,--decimal en centavos
	TipoAsoleo asoleo_planta,
	TipoOrigen varchar(128),
	FechaGerminacion date
);

CREATE TABLE Vivero (
	NombreVivero varchar(256),
	FechaApertura date,
	Estado varchar(256),
	CP char(5),--son 5 números fijos, los representamos como cadenas para evitar confusión en operaciones
	Calle varchar(256),
	NumeroExterior varchar(16)--Hay números que llevan letra, como en duplexes
);

CREATE TABLE ViveroTelefono (
	NombreVivero varchar(256),
	Telefono char(10)
);

CREATE TABLE Cliente (
	IdCliente integer,
	FechaNacimiento date,
	Nombre varchar(128),
	ApellidoP varchar(128),
	ApellidoM varchar(128),
	Estado varchar(256),
	CP char(5),
	Calle varchar(256),
	NumeroExterior varchar(16)
);

CREATE TABLE ClienteTelefono (
	IdCliente integer,
	Telefono char(10)
);

CREATE TABLE ClienteCorreoElectronico (
	IdCliente integer,
	CorreoElectronico varchar(128)
);

CREATE TABLE VentaElectronica (
	IdVentaElectronica integer,
	IdCliente integer,
	NumeroProductos integer,
	MetodoPago metodo_pago,
	NumeroSeguimiento integer,
	FechaPedido date,
	Estado varchar(256),
	CP char(5),
	Calle varchar(256),
	NumeroExterior varchar(16)
);

CREATE TABLE Empleado (
	IdEmpleado integer,
	NombreVivero varchar(256),
	FechaNacimiento date,
	Nombre varchar(128),
	ApellidoP varchar(128),
	ApellidoM varchar(128),
	Estado varchar(256),
	CP char(5),
	Calle varchar(256),
	NumeroExterior varchar(16),
	Rol varchar(128), --{gerente, cuidador de plantas, encargado de mostrar a cliente, cajero}
	Salario integer --decimal en centavos
);

CREATE TABLE EmpleadoTelefono (
	IdEmpleado integer,
	Telefono char(10)
);

CREATE TABLE EmpleadoCorreoElectronico (
	IdEmpleado integer,
	CorreoElectronico varchar(128)
);

CREATE TABLE VentaFisica (
	IdVentaFisica integer,
	IdCliente integer,
	AyudarIdEmpleado integer,
	CobrarIdEmpleado integer,
	NumeroProductos integer,
	MetodoPago metodo_pago
);

CREATE TABLE EntregarVentaFisica (
	IdVentaFisica integer,
	NombrePlanta varchar(256)
);

CREATE TABLE EntregarVentaElectronica (
	IdVentaElectronica integer,
	NombrePlanta varchar(256)
);

--Se llamaba En
CREATE TABLE EstarEn (
	NombreVivero varchar(256),
	NombrePlanta varchar(256),
	NumeroDePlantasVivero integer
);

--- Restricciones:
--PK
ALTER TABLE Planta ADD PRIMARY KEY (NombrePlanta);
ALTER TABLE Vivero ADD PRIMARY KEY (NombreVivero);
ALTER TABLE ViveroTelefono ADD PRIMARY KEY (NombreVivero, Telefono);
ALTER TABLE Cliente ADD PRIMARY KEY (IdCliente);
ALTER TABLE ClienteTelefono ADD PRIMARY KEY (IdCliente, Telefono);
ALTER TABLE ClienteCorreoElectronico ADD PRIMARY KEY (IdCliente, CorreoElectronico);
ALTER TABLE VentaElectronica ADD PRIMARY KEY (IdVentaElectronica);
ALTER TABLE Empleado ADD PRIMARY KEY (IdEmpleado);
ALTER TABLE EmpleadoTelefono ADD PRIMARY KEY (IdEmpleado, Telefono);
ALTER TABLE EmpleadoCorreoElectronico ADD PRIMARY KEY (IdEmpleado, CorreoElectronico);
ALTER TABLE VentaFisica ADD PRIMARY KEY (IdVentaFisica);

--FK
ALTER TABLE Empleado ADD FOREIGN KEY (NombreVivero) REFERENCES Vivero(NombreVivero);
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
ALTER TABLE Planta ALTER COLUMN Genero SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN Precio SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN TipoAsoleo SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN TipoOrigen SET NOT NULL;
ALTER TABLE Planta ALTER COLUMN FechaGerminacion SET NOT NULL;
ALTER TABLE Planta ADD Constraint dinero CHECK (Precio >= 0);

ALTER TABLE Vivero ALTER COLUMN FechaApertura SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN Estado SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN CP SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN Calle SET NOT NULL;
ALTER TABLE Vivero ALTER COLUMN NumeroExterior SET NOT NULL;

ALTER TABLE Cliente ALTER COLUMN FechaNacimiento SET NOT NULL;
ALTER TABLE CLiente ALTER COLUMN Nombre SET NOT NULL;
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
ALTER TABLE Empleado ADD Constraint dinero CHECK (Salario >= 0);

ALTER TABLE VentaFisica ALTER COLUMN CobrarIdEmpleado SET NOT NULL;
ALTER TABLE VentaFisica ALTER COLUMN NumeroProductos SET NOT NULL;
ALTER TABLE VentaFisica ALTER COLUMN MetodoPago SET NOT NULL;

ALTER TABLE EntregarVentaFisica ALTER COLUMN IdVentaFisica SET NOT NULL;
ALTER TABLE EntregarVentaFisica ALTER COLUMN NombrePlanta;

ALTER TABLE EntregarVentaElectronica ALTER COLUMN IdVentaFisica SET NOT NULL;
ALTER TABLE EntregarVentaElectronica ALTER COLUMN NombrePlanta SET NOT NULL;

ALTER TABLE EstarEn ALTER COLUMN NombreVivero SET NOT NULL;
ALTER TABLE EstarEn ALTER COLUMN NombrePlanta SET NOT NULL;
ALTER TABLE EstarEn ALTER COLUMN NumeroDePlantasVivero SET NOT NULL;

--faltan restricciones para:
