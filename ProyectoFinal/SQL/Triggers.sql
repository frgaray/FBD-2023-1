-- Trigger que revisa que los edificios NO tengan menos de 8 pisos
-- ni más de 10.
CREATE OR REPLACE FUNCTION check_num_pisos() RETURNS TRIGGER
AS $$
DECLARE
	num_pisos integer;
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		SELECT count(IdPiso) INTO num_pisos FROM Piso
		WHERE IdEdificio = NEW.IdEdificio;
		IF (num_pisos < 8 OR num_pisos > 10) THEN
			RAISE EXCEPTION 'El número de pisos de los edificios debe estar entre 8 y 10';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		SELECT count(IdPiso) INTO num_pisos FROM Piso
		WHERE IdEdificio = OLD.IdEdificio;
		IF (num_pisos < 8) THEN
			RAISE EXCEPTION 'El número de pisos de los edificios debe estar entre 8 y 10';
		END IF;
	END IF;
	IF (TG_OP = 'INSERT') THEN
		SELECT count(IdPiso) INTO num_pisos FROM Piso
		WHERE IdEdificio = NEW.IdEdificio;
		IF (num_pisos > 10) THEN
			RAISE EXCEPTION 'El número de pisos de los edificios debe estar entre 8 y 10';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER num_pisos
	AFTER INSERT OR UPDATE OR DELETE ON Piso
	FOR EACH ROW
	EXECUTE PROCEDURE check_num_pisos();

-- Trigger que revisa que el total de horas de un curso contratado
-- no sea mayor a 42 horas acumuladas exclusivamente de lunes a sábado.
CREATE OR REPLACE FUNCTION check_horas_contratadas() RETURNS TRIGGER
AS $$
DECLARE
	horas integer;
BEGIN 
	IF (TG_OP = 'INSERT') THEN
		IF (NEW.Dia = 'Domingo') THEN
			RAISE EXCEPTION 'Los cursos de entrenamiento no se imparten en domingo';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
		SELECT sum(Horas) INTO horas FROM HorasContratadasCurso
		WHERE IdCurso = NEW.IdCurso;
		IF (horas > 42) THEN
			RAISE EXCEPTION 'El número de horas contratadas por curso es como máximo 42 y sólo de lunes a sábado';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER horas_contratadas
	AFTER INSERT OR UPDATE ON HorasContratadasCurso
	FOR EACH ROW
	EXECUTE PROCEDURE check_horas_contratadas();


-- Trigger que revisa que un mismo entrenador no imparta dos cursos
-- diferentes en el mismo periodo.
CREATE OR REPLACE FUNCTION check_horarios_diferentes() RETURNS TRIGGER
AS $$
DECLARE
	dia DIA;
	turno TURNO;
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		SELECT Dia INTO dia FROM Impartir
		WHERE CURP = NEW.CURP;
		SELECT Turno INTO turno FROM (Impartir NATURAL JOIN Curso)
		WHERE CURP = NEW.CURP;
		IF (dia = NEW.Dia AND turno = NEW.turno) THEN
			RAISE EXCEPTION 'Los entrenadores no pueden impartir dos cursos en el mismo periodo de tiempo';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER horarios_diferentes
	AFTER INSERT OR UPDATE ON Impartir
	FOR EACH ROW
	EXECUTE PROCEDURE check_horarios_diferentes();

-- Trigger que revisa que un entrenador no tenga más de 20 agentes
-- a su cargo.
CREATE OR REPLACE FUNCTION check_num_agentes() RETURNS TRIGGER
AS $$
DECLARE
	num_agentes integer;
	curp_entrenador char(18);
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		SELECT Entrenador.CURP INTO curp_entrenador
		FROM (Agente NATURAL JOIN Curso NATURAL JOIN Impartir NATURAL JOIN Entrenador)
		WHERE IdCurso = NEW.IdCurso;
		SELECT count(Agente.CURP) INTO num_agentes
		FROM (Entrenador NATURAL JOIN Impartir NATURAL JOIN Curso NATURAL JOIN Agente)
		WHERE Entrenador.CURP = curp_entrenador;
		IF (num_agentes > 20) THEN
			RAISE EXCEPTION 'Un entrenador sólo puede tener como máximo a 20 agentes bajo su cargo';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER num_agentes
	AFTER INSERT OR UPDATE ON Agente
	FOR EACH ROW
	EXECUTE PROCEDURE check_num_agentes();

-- Trigger que revisa el número de inasistencias de un agente
-- a su curso. En caso de que haya más de 3, se le da de baja 
-- de su curso.
CREATE OR REPLACE FUNCTION check_baja() RETURNS TRIGGER
AS $$
DECLARE
	inasistencias integer;
	a Agente%ROWTYPE;
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		SELECT * INTO a FROM Agente
		WHERE CURP = NEW.CURP;
		SELECT count(CASE WHEN (NOT myCol) THEN 1 END) INTO inasistencias
		FROM TomarHorasPorDia
		WHERE CURP = NEW.CURP;
		IF (inasistencias >= 3 OR a.TomarCalificacion < 8) THEN
			INSERT INTO Agente (CURP, ApellidoMaterno,
				 	    ApellidoPaterno, Nombre,
					    FechaNacimiento, Correo,
					    Fotografia, TomarCalificacion,
					    IdEdificio, IdPiso, IdCurso)
			VALUES (a.CURP, a.ApellidoMaterno, a.ApellidoPaterno,
				a.Nombre, a.FechaNacimiento, a.Correo,
				a.Fotografia, 0, a.IdEdificio, a.IdPiso, NULL);
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER baja
	AFTER INSERT OR UPDATE ON TomarHorasPorDia
	FOR EACH ROW
	EXECUTE PROCEDURE check_baja();

-- Trigger que revisa que un agente no pueda estar en operaciones
-- si es que tiene menos de 8 puntos en la calificación de su curso.
CREATE OR REPLACE FUNCTION check_operaciones() RETURNS TRIGGER
AS $$
DECLARE
	calif decimal;
	tipo TIPOSALA;
	a Agente%ROWTYPE;
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		SELECT TIPOSALA INTO tipo
		FROM (Agente NATURAL JOIN PISO NATURAL JOIN SALA)
		WHERE CURP = NEW.CURP;
		IF (NEW.TomarCalificacion < 8 AND tipo = 'Operaciones') THEN
			RAISE EXCEPTION 'Agentes con menor calificación a 8 no pueden estar en salas de operaciones';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER operaciones
	AFTER INSERT OR UPDATE ON Agente
	FOR EACH ROW
	EXECUTE PROCEDURE check_operaciones();

-- Trigger que revisa que un mismo piso no tenga más de 8 salas.
CREATE OR REPLACE FUNCTION check_num_salas() RETURNS TRIGGER
AS $$
DECLARE
	num_salas integer;
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		SELECT count(IdSala) into num_salas FROM (Sala NATURAL JOIN Piso)
		WHERE IdPiso = NEW.IdPiso;
		IF (num_salas > 8) THEN
			RAISE EXCEPTION 'Un piso no puede tener más de 8 salas';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER num_salas
	AFTER INSERT OR UPDATE ON Sala
	FOR EACH ROW
	EXECUTE PROCEDURE check_num_salas();

-- Trigger que revisa que un piso no tenga más de 4 salas de tipo
-- operaciones.
CREATE OR REPLACE FUNCTION check_salas_operacion() RETURNS TRIGGER
AS $$
DECLARE
	num_salas integer;
BEGIN
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
		SELECT count(IdSala) INTO num_salas FROM (Sala NATURAL JOIN Piso)
		WHERE (IdPiso = NEW.IdPiso AND Tipo = 'Operaciones');
		IF (num_salas > 4) THEN
			RAISE EXCEPTION 'Un piso no puede tener más de 4 salas de operaciones';
		END IF;
	END IF;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER salas_operacion
	AFTER INSERT OR UPDATE ON Sala
	FOR EACH ROW
	EXECUTE PROCEDURE check_salas_operacion();

-- Trigger que revisa que un edifico no tenga más de 4 pisos con
-- salas de operaciones.
CREATE OR REPLACE FUNCTION check_pisos_operacion() RETURNS TRIGGER
AS $$
DECLARE
	num_pisos integer;
BEGIN
	IF ((TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW) THEN
		SELECT count(IdPiso) INTO num_pisos
		FROM (Edificio NATURAL JOIN Piso NATURAL JOIN Sala)
		WHERE (IdEdificio = NEW.IdEdificio AND Tipo = 'Operaciones')
		GROUP BY IdPiso;
		IF (num_pisos > 4) THEN
			RAISE EXCEPTION 'Un edificio no puede tener más de 4 pisos con salas de operaciones';
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER pisos_operacion
	AFTER INSERT OR UPDATE ON Sala
	FOR EACH ROW
	EXECUTE PROCEDURE check_pisos_operacion();












