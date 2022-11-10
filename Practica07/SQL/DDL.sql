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
ALTER TABLE EntregarVentaFisica ALTER COLUMN NombrePlanta SET NOT NULL;

ALTER TABLE EntregarVentaElectronica ALTER COLUMN IdVentaElectronica SET NOT NULL;
ALTER TABLE EntregarVentaElectronica ALTER COLUMN NombrePlanta SET NOT NULL;

ALTER TABLE EstarEn ALTER COLUMN NombreVivero SET NOT NULL;
ALTER TABLE EstarEn ALTER COLUMN NombrePlanta SET NOT NULL;
ALTER TABLE EstarEn ALTER COLUMN NumeroDePlantasVivero SET NOT NULL;
