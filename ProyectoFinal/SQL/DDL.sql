DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TYPE DIA AS ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo');

CREATE TABLE Agente (
 CURP varchar(18),
 ApellidoMaterno varchar(255) SET NOT NULL,
 ApellidoPaterno varchar(255) SET NOT NULL,
 Nombre varchar(255) SET NOT NULL,
 FechaNacimiento INT SET NOT NULL,
 Correo varchar(255) SET NOT NULL,
 Fotografia varchar(255) SET NOT NULL,
 IdEdificio INT,
 IdPiso INT
);

CREATE TABLE AgenteTelefono (
  CURP varchar(255),
  Telefono int
);


CREATE TABLE AgenteHorario (
  CURP varchar(18),
  Dia varchar(255),
  HoraEntrada INT,
  HoraSalida INT
);

CREATE TABLE Edificio (
  IdEdificio INT,
  Ubicacion varchar(255) SET NOT NULL
);

CREATE TABLE Piso (
  IdEdificio INT,
  IdPiso INT,
  Estatus varchar(255) SET NOT NULL
);

CREATE TABLE Sala (
 IdSala INT,
 IdPiso INT SET NOT NULL
);     	     

CREATE TABLE Entrenador (
 CURP varchar(18),
 Domicilio varchar(255) SET NOT NULL,
 ApellidoPaterno varchar(255) SET NOT NULL,
 ApellidoMaterno varchar(255) SET NOT NULL,
 Nombre varchar(255) SET NOT NULL,
 FechaDeNacimiento DATE SET NOT NULL,
 Correo varchar(255) SET NOT NULL,
 Fotografia varchar(255) SET NOT NULL,
 NSS INT SET NOT NULL,
 FechaIngreso DATE SET NOT NULL,
 HorasPorSemana INT SET NOT NULL,
 IdSala INT
);

CREATE TABLE EntrenadorTelefono (
 CURP varchar(18),
 Telefono INT,
);

CREATE TABLE EntrenadorHorario (
 CURP varchar(18),
 Dia DIA,
 HoraEntrada INT,
 HoraSalida INT
);

CREATE TABLE Estacion (
 IdEstacion INT,
 Mouse varchar(255) SET NOT NULL,
 Teclado varchar(255) SET NOT NULL,
 HeadSet varchar(255) SET NOT NULL,
 IdSala INT
);

CREATE TABLE ReservacionDias (
 IdReservacion INT,
 Dia DIA
);

CREATE TABLE Reservacion (
 IdReservacion INT,
 Duracion INT SET NOT NULL,
 Turno INT SET NOT NULL,
 SistemaOperativo INT SET NOT NULL,
 IdSala INT,
 IdCliente INT 
);

CREATE TABLE Cliente (
 RFC varchar(255),
 RazonSocial INT SET NOT NULL,
 Correo varchar(255) SET NOT NULL,
 ContactoApellidoPaterno varchar(255) SET NOT NULL,
 ContactoApellidoMaterno varchar(255) SET NOT NULL,
 ContactoNombre varchar(255) SET NOT NULL
);

--Constraints:
ALTER TABLE Agente ADD PRIMARY KEY (CURP);
ALTER TABLE Agente ADD FOREIGN KEY (IdEdificio);
ALTER TABLE Agente ADD FOREIGN KEY (IdPiso);
ALTER TABLE Agente ADD FOREIGN KEY (IdEdificio) REFERENCES Piso(IdEdificio) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Agente ADD FOREIGN KEY (IdPiso) REFERENCES Piso(IdPiso) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE AgenteTelefono ADD PRIMARY KEY (CURP);
ALTER TABLE AgenteTelefono ADD PRIMARY KEY (Telefono);

ALTER TABLE AgenteHorario ADD PRIMARY KEY (CURP);
ALTER TABLE AgenteHorario ADD PRIMARY KEY (Dia);
ALTER TABLE AgenteHorario ADD PRIMARY KEY (HoraEntrada);
ALTER TABLE AgenteHorario ADD PRIMARY KEY (HoraSalida);

ALTER TABLE Edifcio ADD PRIMARY KEY (IdEdificio);

ALTER TABLE Piso ADD PRIMARY KEY (IdPiso);
ALTER TABLE Piso ADD PRIMARY KEY (IdEdificio);

ALTER TABLE Sala ADD PRIMARY KEY (IdSala);
ALTER TABLE Sala ADD FOREIGN KEY (IdPiso) REFERENCES Piso(IdPiso) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Entrenador ADD PRIMARY KEY (CURP);
ALTER TABLE Entrenador ADD FOREIGN KEY (IdSala) REFERENCES Sala(IdSala) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE EntrenadorTelefono ADD PRIMARY KEY (CURP);
ALTER TABLE EntrenadorTelefono ADD PRIMARY KEY (Telefono);

ALTER TABLE EntrenadorHorario ADD PRIMARY KEY (CURP);
ALTER TABLE EntrenadorHorario ADD PRIMARY KEY (Dia);
ALTER TABLE EntrenadorHorario ADD PRIMARY KEY (HoraEntrada);
ALTER TABLE EntrenadorHorario ADD PRIMARY KEY (HoraSalida);

ALTER TABLE Estacion ADD PRIMARY KEY (IdEstacion);
ALTER TABLE Estacion ADD FOREIGN KEY (IdSala) REFERENCES Sala(IdSala) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Reservacion ADD PRIMARY KEY (IdReservacion);
ALTER TABLE Reservacion ADD FOREIGN KEY (IdSala) REFERENCES Sala(IdSala) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Reservacion ADD FOREIGN KEY (IdCliente) REFERENCES Cliente(RFC) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ClienteTelefono ADD PRIMARY KEY (RFC);
ALTER TABLE ClienteTelefono ADD PRIMARY KEY (Telefono);
