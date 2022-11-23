# Proyecto final bases de datos

## To-do
- Modelo ER
- Modelo Relacional
- Modelo Relacional normalizado (opcional)
- Schema de DB en SQL
- Datos de DB en SQL (Mockaroo)
- Consultas de SQL
- Procedimientos almacenados y disparadores (al menos 2 de cada uno)
- Documento de diccionario de base de datos
- Documento de consultas
- App ?

## Specificación del proyecto
"TeleLlamadas"
- entrenadores: {
	nombre completo, domicilio, fecha nacimiento, teléfono,
	correo electrónico, CURP, NSS, fotografía {nombre y extensión},
	fecha ingreso, horas por semana, salario }
- agentes telefónicos: {
	nombre completo, domicilio, fecha nacimiento, teléfono,
	correo electrónico, CURP, fotografía, días de entrenamiento,
	horario de entrenamiento (matutino o vespertino), salario}
- salas de capacitación:

- edificio: {ubicación, cantidad de pisos, cantidad de salas por piso, cantidad de estaciones por piso}
--entre 8 y 10 pisos, capacitación o piso de operaciones, estatus {disponible, ocupado}

- estaciones (computadoras) {OS {windows/linux}, mouse, teclado, headset}
-- inventariados, conocer edificio piso y sala en la que estan ubicados
-- os depende de necesidades del cliente

- entrenadores y agentes estan asignados a un piso y solo tienen acceso a ese,
-- dia y horas de entrada y salida a este piso.

-curso capacitación: {nombre, duración, dias, linea/presencial, cliente que contrata}

-cliente: {razón social, RFC, telefono contacto, persona contacto, correo contacto}
-- número de horas de entrenamiento (lunes a sabado)
-- Maximo 42 horas impartidas

- entrenador imparte varios cursos, pero no simultaneamente.
-- max 20 agentes
-- asigna piso y sala en particular

- sala puede impartir en ambos horarios (matutino/vespertino),
-- conocer cursos y entrenadores asignados a cada sala y periodo

-pisos repartido entre salas de capacitacion y ops,
--asignan a un cliente total o en partes
--Si ops entonces no se pueden asignar cursos durante el periodo de reserva

-asistencia, tres inasistencias implican una baja
-registro de horas de capacitación que cumplen por dia.
-$40 hora agente, $70 hora entrendador

-Evaluación de cada curso.
--Un agente puede pasar a un piso de ops solo si tiene almenos 8 de calif, si es menor
--se dan de baja

-agentes en capacitación estan asignados a un único cliente y único edificio

-$5000 por dia, es el costo de una sala de entrenamiento.
-Cada piso máx 8 salas de entrenamiento.
-cada edificio max 4 pisos, mitad de espacio reservada para oeraciones
-Conocer monto que paga cada cliente que ha reservado espacio por dia y para todo su periodo.
..EN UNA BD
