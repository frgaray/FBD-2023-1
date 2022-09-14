from CSVManager import CSVManager
from typing import Union, List
from datetime import date
from random import randint

class Empleados:
    def __init__(self, viveros:CSVManager, empleados:CSVManager, correos:CSVManager, telefonos:CSVManager):
        self.viveros = viveros
        self.empleados = empleados
        self.correos = correos
        self.telefonos = telefonos
    
    def seach_by_name(self, name:str) -> Union[str, None]:
        for key,value in self.empleados.dict.items():
            if value[1] == name:
                return key # type: ignore
                # We ignore the type error here, because we can be sure the key
                # from the empleados table is an str castable to int, but the type
                # checker is oblivious to this
        return None

    def add(self, vivero:str, nombre:str, direccion:str, fecha_de_nacimiento: date, salario:int, cargo:str, correos: List[str], telefonos: List[str]):
        id = 10000
        while not str(id) in self.empleados.dict:
            id = randint(0, 20000)
        self.empleados.add_row([str(id), vivero, nombre, direccion, fecha_de_nacimiento.isoformat(), str(salario), cargo])
        for correo in correos:
            self.correos.add_row([correo, str(id)])
        for telefono in telefonos:
            self.telefonos.add_row([telefono, str(id)])
    
    def delete(self, id: str):
        for key,value in self.correos.dict.items():
            if value[0] == id:
                self.correos.delete_row(key)

        for key,value in self.telefonos.dict.items():
            if value[0] == id:
                self.telefonos.delete_row(key)
        self.empleados.delete_row(id)
    
    def modify(self, id:str, vivero:str, nombre:str, direccion:str, fecha_de_nacimiento: date, salario:int, cargo:str, correos: List[str], telefonos: List[str]):
        self.delete(id)
        self.add(vivero, nombre, direccion, fecha_de_nacimiento, salario, cargo, correos, telefonos)

    def __getitem__(self, key: int):
        return self.empleados[str(key)]