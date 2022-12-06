DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TYPE DIA AS ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo');

CREATE TABLE Edificio (
 IdEdificio INT,
 Ubicacion varchar(255) NOT NULL,
 PRIMARY KEY (IdEdificio)
);


CREATE TABLE Piso (
 IdEdificio INT REFERENCES Edificio,
 IdPiso INT,
 Estatus varchar(255) NOT NULL,
 PRIMARY KEY (IdEdificio, IdPiso)
);

CREATE TABLE Agente (
 CURP varchar(18),
 ApellidoMaterno varchar(255) NOT NULL,
 ApellidoPaterno varchar(255) NOT NULL,
 Nombre varchar(255) NOT NULL,
 FechaNacimiento INT NOT NULL,
 Correo varchar(255) NOT NULL,
 Fotografia varchar(255) NOT NULL,
 IdEdificio INT,
 IdPiso INT,
 PRIMARY KEY (CURP),
 FOREIGN KEY (IdEdificio, IdPiso) REFERENCES Piso ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE AgenteTelefono (
 CURP varchar(255),
 Telefono int,
 PRIMARY KEY (CURP, Telefono)
);


CREATE TABLE AgenteHorario (
 CURP varchar(18),
 Dia varchar(255),
 HoraEntrada INT,
 HoraSalida INT,
 PRIMARY KEY (CURP, Dia, HoraEntrada, HoraSalida)
);

CREATE TABLE Sala (
 IdSala INT,
 IdPiso INT,
 IdEdificio INT,
 PRIMARY KEY (IdSala),
 FOREIGN KEY (IdPiso, IdEdificio) REFERENCES Piso ON UPDATE CASCADE ON DELETE CASCADE
);     	     	

CREATE TABLE Entrenador (
 CURP varchar(18),
 Domicilio varchar(255) NOT NULL,
 ApellidoPaterno varchar(255) NOT NULL,
 ApellidoMaterno varchar(255) NOT NULL,
 Nombre varchar(255) NOT NULL,
 FechaDeNacimiento DATE NOT NULL,
 Correo varchar(255) NOT NULL,
 Fotografia varchar(255) NOT NULL,
 NSS INT NOT NULL,
 FechaIngreso DATE NOT NULL,
 HorasPorSemana INT NOT NULL,
 IdSala INT,
 PRIMARY KEY (CURP),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE EntrenadorTelefono (
 CURP varchar(18),
 Telefono INT,
 PRIMARY KEY (CURP, Telefono)
);

CREATE TABLE EntrenadorHorario (
 CURP varchar(18),
 Dia DIA,
 HoraEntrada INT,
 HoraSalida INT,
 PRIMARY KEY (CURP, Dia, HoraEntrada, HoraSalida)
);

CREATE TABLE Estacion (
 IdEstacion INT,
 Mouse varchar(255) NOT NULL,
 Teclado varchar(255) NOT NULL,
 HeadSet varchar(255) NOT NULL,
 IdSala INT,
 PRIMARY KEY (IdEstacion),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Cliente (
 RFC varchar(255),
 RazonSocial INT NOT NULL,
 Correo varchar(255) NOT NULL,
 ContactoApellidoPaterno varchar(255) NOT NULL,
 ContactoApellidoMaterno varchar(255) NOT NULL,
 ContactoNombre varchar(255) NOT NULL,
 PRIMARY KEY (RFC)
);

CREATE TABLE Reservacion (
 IdReservacion INT,
 Duracion INT NOT NULL,
 Turno INT NOT NULL,
 SistemaOperativo INT NOT NULL,
 IdSala INT,
 IdCliente varchar(255),
 PRIMARY KEY (IdReservacion),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IdCliente) REFERENCES Cliente ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ReservacionDias (
 IdReservacion INT REFERENCES Reservacion,
 Dia DIA,
 PRIMARY KEY (IdReservacion, Dia)
);

--Constraints:
