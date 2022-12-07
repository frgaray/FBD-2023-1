DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TYPE DIA AS ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo');
CREATE TYPE ESTATUS AS ENUM('Disponible', 'Ocupado');
CREATE TYPE MODALIDAD AS ENUM('Virtual', 'Presencial');
CREATE TYPE SO AS ENUM('Linux', 'Windows');
CREATE TYPE TIPOSALA AS ENUM('Capacitacion', 'Operaciones');
CREATE TYPE TURNO AS ENUM('Matutino', 'Vespertino');

CREATE TABLE Edificio (
 IdEdificio INT,
 Ubicacion varchar(255) NOT NULL,
 PRIMARY KEY (IdEdificio)
);


CREATE TABLE Piso (
 IdEdificio INT REFERENCES Edificio,
 IdPiso INT,
 Estatus ESTATUS NOT NULL,
 PRIMARY KEY (IdEdificio, IdPiso)
);

CREATE TABLE Cliente (
 RFC varchar(13),
 RazonSocial varchar(255) NOT NULL,
 Correo varchar(255) NOT NULL,
 ContactoApellidoPaterno varchar(255) NOT NULL,
 ContactoApellidoMaterno varchar(255) NOT NULL,
 ContactoNombre varchar(255) NOT NULL,
 PRIMARY KEY (RFC)
);

CREATE TABLE Sala (
 IdSala INT,
 Tipo TIPOSALA,
 IdPiso INT,
 IdEdificio INT,
 PRIMARY KEY (IdSala),
 FOREIGN KEY (IdPiso, IdEdificio) REFERENCES Piso ON UPDATE CASCADE ON DELETE CASCADE
);     	     	

CREATE TABLE Reservacion (
 IdReservacion INT,
 Duracion TIME NOT NULL,
 Turno TURNO NOT NULL,
 SistemaOperativo SO NOT NULL,
 IdSala INT,
 IdCliente varchar(13),
 PRIMARY KEY (IdReservacion),
 FOREIGN KEY (IdSala) REFERENCES Sala ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IdCliente) REFERENCES Cliente ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Curso (
 IdCurso INT,
 Modalidad MODALIDAD NOT NULL,
 Turno TURNO NOT NULL,
 Nombre varchar(255) NOT NULL,
 IdReservacion INT,
 PRIMARY KEY (IdCurso),
 FOREIGN KEY (IdReservacion) REFERENCES Reservacion ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE Agente (
 CURP varchar(18),
 ApellidoMaterno varchar(255) NOT NULL,
 ApellidoPaterno varchar(255) NOT NULL,
 Nombre varchar(255) NOT NULL,
 FechaNacimiento DATE NOT NULL,
 Correo varchar(255) NOT NULL,
 Fotografia varchar(255) NOT NULL,
 TomarCalificacion decimal,
 IdEdificio INT,
 IdPiso INT,
 IdCurso INT,
 PRIMARY KEY (CURP),
 FOREIGN KEY (IdEdificio, IdPiso) REFERENCES Piso ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IdCurso) REFERENCES Curso ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE AgenteTelefono (
 CURP varchar(18),
 Telefono int,
 PRIMARY KEY (CURP, Telefono)
);


CREATE TABLE AgenteHorario (
 CURP varchar(18),
 Dia DIA,
 HoraEntrada TIME,
 HoraSalida TIME,
 PRIMARY KEY (CURP, Dia, HoraEntrada, HoraSalida)
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
 HoraEntrada TIME,
 HoraSalida TIME,
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

CREATE TABLE ReservacionDias (
 IdReservacion INT REFERENCES Reservacion,
 Dia DIA,
 PRIMARY KEY (IdReservacion, Dia)
);

CREATE TABLE Ocupar (
 IdReservacion INT REFERENCES Reservacion,
 IdSala INT REFERENCES Sala,
 PRIMARY KEY (IdReservacion, IdSala)
);

CREATE TABLE Impartir (
 IdCurso INT REFERENCES Curso,
 CURP varchar(18) REFERENCES Entrenador,
 Dia DIA,
 Horas TIME,
 PRIMARY KEY (IdCurso, CURP, Dia, Horas)
);

CREATE TABLE HorasContratadasCurso (
 IdCurso INT REFERENCES Curso,
 Dia DIA,
 Horas TIME,
 PRIMARY KEY (IdCurso, Dia, Horas)
);

CREATE TABLE TomarHorasPorDia (
 CURP varchar(18) REFERENCES Agente,
 Dia DIA,
 Horas TIME,
 Asistencia boolean,
 PRIMARY KEY (CURP, Dia, Horas)
);
