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

## Especificación del proyecto

ents: entrenadores, agentes, edificios, pisos, salas, cursos, clientes, estaciones

entrenadores:
Nombre completo
domicilio
fecha nacimiento
telefono cel
correo
CURP
número seguridad social
foto (nombre de archivo + extensión)
fecha ingreso
horas/semana
salario

agentes telefónicos:
Nombre completo
domicilio
fecha nacimiento
teléfono cel
correo
CURP
foto (nombre de archivo + extensión)
dias entrenamiento + horario entrenamiento (matutino o vespertino)
salario

Edificios:
ubicación
cantidad pisos
salas por piso
cantidad estaciones por piso
> entre 8 y 10 pisos 

Pisos:
> pisos son de capacitación u operaciones
> pisos estatus: disponible u ocupado

Estaciones:
OS {Linux, Windows}
mouse, teclado, headset
> conocer edificio, piso (si aplica) y sala de ubi
> sospecho que OS no varia por piso

> entrenadores único piso asociado

> hora de entrada y salida de piso para cada entrenador
> agentes único piso asociado
> hora de entrada y salida de piso para cada agente

Cursos:
> los toman los agentes
> pertenecen a un cliente
nombre
duración
días de imparte
línea o presencial

Cliente:
razón social
RFC
teléfono contacto
persona contacto
correo de contacto
> contratan un cierto número de horas de entrenamiento
> horas de entrenamiento repartidas de lunes a sábado
> max 42 horas por semana

> A un entrenador le corresponden muchos cursos (diferentes clientes)
> Un entrenador solo puede impartir un curso en el mismo período
> entrenador entrena máximo 20 agentes (por sesión)
> curso/entrenador asignado un piso y sala particular

> horarios en (matutino, vespertino)
>> sala,periodo,cursos,entrenadores

> pisos repartidos entre salas de capacitación y/o operaciones
> cliente tiene reservado todo el piso o una parte
> si piso reservado como ops, no puede haber cursos durante el periodo de reserva (para el cliente)

> Asistencia agentes
> 3 inasistencia registran como baja
> horas de capacitación agentes (por día)

> $40 hora pago a agentes
> $70 hora pago a entrenadores

> agentes tienen evaluación por curso, mínimo 8 para pasar a ops, si es menor es baja
> agente en capacitación tienen un solo cliente, asociados a un solo edificio

> salas tienen costo de $5,000.00 al dia
> piso tiene max 8 salas de entrenamiento
> "Cada edificio tiene como máximo 4 pisos que tendrán la mitad del espacio (4 salas) reservado para piso
de operaciones"
> conocer monto que paga cada cliente por dia y/o para todo su periodo (capacitación o piso ops)

---
## ER:

- añadi HorasPorSemana a Entrenador
- Cambie salario, a salario semanal que es calculado (todos los entrenadores ganan $70 la hora)
- Quité baja de impartir y moví calificación a Tomar
- Moví baja a Agente de Tomar
- Añadi SalarioSemanal como calculado a Agente (ganan $40 la hora) ¿Debería de ser como salario a corte o algo así?
- En curso cambié duración por HorasTotales
- A persona de contacto añadí los subcampos de un nombre completo
- Trabajar ahora tiene participación forzada del lado de Agente

notas para doc:
Constraint Edificios entre 8 y 10 pisos
Mouse, teclado y headset solo registran sus números de inventario

--
## Relacional
notas:
-añadí id a edifício
-deberiamos denotar la pk de sala a edificio ?
-(Los sistemas operativos se asignan a la reservación por que reinstalar el OS en cada máquina sería imposible.
Suponemos/Proponemos que se utilice un sistema de netboot para satisfacer que Linux este disponible en una hora y
windows en la siguiente)
- Que sala sea una entidad debil hace que nuestras FK sean enormes bro
- Reservar no puede ser relación por que una sala puede que la abarquen dos turnos diferentes etc
