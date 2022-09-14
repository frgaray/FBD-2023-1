#!/bin/env python

import sys
from CSVManager import CSVManager
from aditionalTypes import *
from datetime import date

# Architecture:

# Command list:
# init
# 

# Testing, delete afterwards---------------------------------------------------
prueba = CSVManager('./test.csv', [int, int, int, int, int], has_header= True)
prueba.modify_row('20', ['21', '22', '23', '24'])
prueba.add_row(['100', '101', '102', '103', '104'])
prueba.delete_row('19')
prueba.write()
# -----------------------------------------------------------------------------

# [primary key]
# (foreign key)

manager_empleados = CSVManager('./Empleados.csv', [
    int, # [id]
    str, # (vivero_nombre)
    str, # nombre
    str, # direccion
    date.fromisoformat, # fecha de nacimiento
    int, # salario
    str # cargo

])

manager_empleados_correos = CSVManager('./EmpleadosCorreos.csv', [
    str, # [correo]
    str # (empleado_id)
])

manager_empleados_telefonos = CSVManager('./EmpleadosTelefonos.csv', [
    telephone, # telefono
    str # (id_empleado)
])

manager_viveros = CSVManager('./Viveros.csv', [
    str, # [nombre]
    str, # direccion 
    date.fromisoformat # fecha de apertura
])

manager_viveros_telefonos = CSVManager('./ViverosTelefonos.csv', [
    telephone, # telefono
    str # (vivero_nombre)
])

# [nombre] / precio / genero / 
manager_plantas = CSVManager('./Plantas.csv', [
    str, # [nombre]
    int, # precio
    str, # genero
    str, # cuidados_basicos
    str, # tipo_sustrato
    str, # sol/sombra/resolana
    str, #fecha_germinacion
    str # intervalo_riego
])

#
manager_plantas_disponibilidad = CSVManager('./PlantasDisponibilidad.csv', [
   str, # (vivero_nombre,
   str, # planta_nombre)
   int, # cantidad_disponible
], keys = 2)


def main():
    "Starting point for the database"

    # parse arguments
    # check & load database
    # execute command into database
    # write changes into files
    # finish
    print(sys.argv)

main()

