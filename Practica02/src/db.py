#!/bin/env python

import sys
from CSVManager import CSVManager
from Empleados import Empleados
from aditionalTypes import *
from datetime import date

# Architecture:

# Command list:
# init
# 

# Table type definitions ------------------------------------------------------
# {primary key}
# (foreign key)
# [position]

manager_empleados = CSVManager('./Empleados.csv', [
    int, # {id} [key]
    str, # (vivero_nombre) [0]
    str, # nombre [1] 
    str, # direccion [2] 
    date.fromisoformat, # fecha de nacimiento [3] 
    int, # salario [4] 
    str # cargo [5]

])

manager_empleados_correos = CSVManager('./EmpleadosCorreos.csv', [
    str, # {correo} [key]
    str # (empleado_id) [0]
])

manager_empleados_telefonos = CSVManager('./EmpleadosTelefonos.csv', [
    telephone, # {telefono} [key]
    str # (id_empleado) [0]
])

manager_viveros = CSVManager('./Viveros.csv', [
    str, # {nombre} [key]
    str, # direccion [0]
    date.fromisoformat # fecha de apertura [1]
])

manager_viveros_telefonos = CSVManager('./ViverosTelefonos.csv', [
    telephone, # {telefono} [key]
    str # (vivero_nombre) [0]
])

manager_plantas = CSVManager('./Plantas.csv', [
    str, # {nombre} [key]
    int, # precio [0]
    str, # genero [1]
    str, # cuidados_basicos [2]
    str, # tipo_sustrato [3]
    str, # sol/sombra/resolana [4]
    str, #fecha_germinacion [5]
    str # intervalo_riego [6]
])

manager_plantas_disponibilidad = CSVManager('./PlantasDisponibilidad.csv', [
   str, # (vivero_nombre [key, fst]
   str, # planta_nombre) [key, snd]
   int, # cantidad_disponible [0]
], keys = 2)

# -----------------------------------------------------------------------------
empleados = Empleados(manager_viveros, manager_empleados, manager_empleados_correos, manager_empleados_telefonos, manager_viveros_telefonos)
empleados.add('viv0', 'John Doe', '1 Infinite loop', date.today(), 100, 'El pro', ['notmy@mail.xd'], ['55 1234 5678'])

a = empleados.seach_by_name('John Doe')

def main():
    "Starting point for the database"

    # parse arguments
    # check & load database
    # execute command into database
    # write changes into files
    # finish
    print(sys.argv)

main()

