--DROP DATABASE IF EXISTS tele_llamada;
--CREATE DATABASE tele_llamada;
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TYPE DIA AS ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo');
CREATE TYPE ESTATUS AS ENUM('Disponible', 'Ocupado');
CREATE TYPE MODALIDAD AS ENUM('Virtual', 'Presencial');
CREATE TYPE SO AS ENUM('Linux', 'Windows');
CREATE TYPE TIPOSALA AS ENUM('Capacitacion', 'Operaciones');
CREATE TYPE TURNO AS ENUM('Matutino', 'Vespertino');

CREATE TABLE Edificio (
 IdEdificio serial,
 Ubicacion varchar(255) NOT NULL,
 PRIMARY KEY (IdEdificio)
);


CREATE TABLE Piso (
 IdEdificio integer REFERENCES Edificio,
 IdPiso serial ,
 Estatus ESTATUS NOT NULL,
 PRIMARY KEY (IdEdificio, IdPiso)
);

CREATE TABLE Cliente (
 RFC char(13),
 RazonSocial varchar(255) NOT NULL,
 Correo varchar(255) NOT NULL,
 ContactoApellidoPaterno varchar(255) NOT NULL,
 ContactoApellidoMaterno varchar(255) NOT NULL,
 ContactoNombre varchar(255) NOT NULL,
 PRIMARY KEY (RFC)
);

CREATE TABLE ClienteTelefono (
 RFC char(13),
 Telefono char(10),
 PRIMARY KEY (RFC, Telefono)
);

CREATE TABLE Sala (
 IdSala serial,
 Tipo TIPOSALA,
 IdPiso integer NOT NULL, 
 IdEdificio integer NOT NULL,
 PRIMARY KEY (IdSala),
 FOREIGN KEY (IdEdificio, IdPiso) REFERENCES Piso ON UPDATE CASCADE ON DELETE CASCADE
);     	     	

CREATE TABLE Reservacion (
 IdReservacion serial,
 FechaInicio DATE NOT NULL,
 FechaFin DATE NOT NULL,
 Turno TURNO NOT NULL,
 SistemaOperativo SO NOT NULL,
 IdSala integer,
 IdCliente char(13),
 PRIMARY KEY (IdReservacion),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IdCliente) REFERENCES Cliente ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Curso (
 IdCurso serial,
 Modalidad MODALIDAD NOT NULL,
 Turno TURNO NOT NULL,
 Nombre varchar(255) NOT NULL,
 IdReservacion integer,
 PRIMARY KEY (IdCurso),
 FOREIGN KEY (IdReservacion) REFERENCES Reservacion ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE Agente (
 CURP char(18),
 ApellidoMaterno varchar(255) NOT NULL,
 ApellidoPaterno varchar(255) NOT NULL,
 Nombre varchar(255) NOT NULL,
 FechaNacimiento DATE NOT NULL,
 Correo varchar(255) NOT NULL,
 Fotografia varchar(255) NOT NULL,
 TomarCalificacion decimal CHECK (TomarCalificacion >= 0 and TomarCalificacion <= 10),
 IdEdificio serial,
 IdPiso serial,
 IdCurso serial,
 PRIMARY KEY (CURP),
 FOREIGN KEY (IdEdificio, IdPiso) REFERENCES Piso ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IdCurso) REFERENCES Curso ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AgenteTelefono (
 CURP char(18),
 Telefono char(10),
 PRIMARY KEY (CURP, Telefono)
);


CREATE TABLE AgenteHorario (
 CURP char(18),
 Dia DIA,
 HoraEntrada TIME,
 HoraSalida TIME,
 PRIMARY KEY (CURP, Dia, HoraEntrada, HoraSalida)
);

CREATE TABLE Entrenador (
 CURP char(18),
 Domicilio varchar(255) NOT NULL,
 ApellidoPaterno varchar(255) NOT NULL,
 ApellidoMaterno varchar(255) NOT NULL,
 Nombre varchar(255) NOT NULL,
 FechaDeNacimiento DATE NOT NULL,
 Correo varchar(255) NOT NULL,
 Fotografia varchar(255) NOT NULL,
 NSS char(11) NOT NULL,
 FechaIngreso DATE NOT NULL,
 HorasPorSemana INT NOT NULL,
 IdSala serial,
 PRIMARY KEY (CURP),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE EntrenadorTelefono (
 CURP char(18),
 Telefono char(10),
 PRIMARY KEY (CURP, Telefono),
 FOREIGN KEY (CURP) REFERENCES Entrenador ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE EntrenadorHorario (
 CURP char(18),
 Dia DIA,
 HoraEntrada TIME,
 HoraSalida TIME,
 PRIMARY KEY (CURP, Dia, HoraEntrada, HoraSalida)
);

CREATE TABLE Estacion (
 IdEstacion serial,
 Mouse varchar(255) NOT NULL,
 Teclado varchar(255) NOT NULL,
 HeadSet varchar(255) NOT NULL,
 IdSala integer,
 PRIMARY KEY (IdEstacion),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ReservacionDias (
 IdReservacion integer REFERENCES Reservacion ON UPDATE CASCADE ON DELETE CASCADE,
 Dia DIA NOT NULL,
 PRIMARY KEY (IdReservacion, Dia)
);

CREATE TABLE Ocupar (
 IdReservacion integer REFERENCES Reservacion ON UPDATE CASCADE ON DELETE CASCADE,
 IdSala integer REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE,
 PRIMARY KEY (IdReservacion, IdSala)
);

CREATE TABLE Impartir (
 IdCurso integer REFERENCES Curso ON UPDATE CASCADE ON DELETE CASCADE,
 CURP char(18) REFERENCES Entrenador ON UPDATE CASCADE ON DELETE CASCADE,
 Dia DIA,
 Horas TIME,
 PRIMARY KEY (IdCurso, CURP, Dia, Horas)
);

CREATE TABLE HorasContratadasCurso (
 IdCurso integer REFERENCES Curso ON UPDATE CASCADE ON DELETE CASCADE,
 Dia DIA,
 Horas integer CHECK (Horas > 0),
 PRIMARY KEY (IdCurso, Dia)
);

CREATE TABLE TomarHorasPorDia (
 CURP char(18) REFERENCES Agente ON UPDATE CASCADE ON DELETE CASCADE,
 Dia DIA,
 Horas TIME,
 Asistencia boolean,
 PRIMARY KEY (CURP, Dia, Horas)
);

