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
    
    menu_options = {
    1: 'Viveros',
    2: 'Empleados',
    3: 'Plantas',
    4: 'Salir'
    }

    sec_menu_options = {
    1: 'Agregar',
    2: 'Eliminar',
    3: 'Buscar',
    4: 'Editar',
    5: 'Regresar'
    }  
    

    def print_menu(menu):
        for key in menu.keys():
            print (key, '--', menu[key] )

    def option1():
        print('Handle option \'Option 1\'')

    def option2():
        print('Handle option \'Option 2\'')

    def option3():
        print('Handle option \'Option 3\'')

    if __name__=='__main__':
        while(True):
            print_menu(menu=menu_options)
            option = ''
        
            try:
                option = int(input('Escribe el numero: '))
            except:
                print('Porfavor ingresa un numero')
        
        
        
            if option == 1:
                option1()
            elif option == 2:
                option2()
            elif option == 3:
                option3()
            elif option == 4:
                print('Saliendo...\nSuerte')
                exit()
            else:
                print('Opcion invalida, ingresa solo el numero de la opcion elegida')




    print(sys.argv)

main()

