from CSVManager import CSVManager
from typing import  List
from datetime import date
from random import randint

class Empleados:
    def __init__(self, viveros:CSVManager, empleados:CSVManager, correos:CSVManager, telefonos:CSVManager, viveros_telefonos:CSVManager):
        self.viveros = viveros
        self.empleados = empleados
        self.correos = correos
        self.telefonos = telefonos
        self.viveros_telefonos = viveros_telefonos
    
    def seach_by_name(self, name:str) -> List[int]:
        result:List[int] = []
        for key,value in self.empleados.dict.items():
            if value[1] == name:
                result.append(int(key))#type: ignore
                # We can ignore this error because unlike the linter, we are sure
                # The keys of the empleados dict will be strings castable to int
        return result 

    def add(self, vivero:str, nombre:str, direccion:str, fecha_de_nacimiento: date, salario:int, cargo:str, correos: List[str], telefonos: List[str]):
        id = 10000
        if vivero not in self.viveros.dict:
            raise ValueError(f'No existe el vivero ({vivero})')
        while str(id) in self.empleados.dict:
            id = randint(0, 20000)
        self.empleados.add_row([str(id), vivero, nombre, direccion, fecha_de_nacimiento.isoformat(), str(salario), cargo])
        for correo in correos:
            if correo in self.correos.dict:
                raise ValueError(f'El correo {correo} ya esta registrado por otra persona')
            self.correos.add_row([correo, str(id)])
        for telefono in telefonos:
            if telefono in self.telefonos.dict:
                raise ValueError(f'El telefono {telefono} ya esta registrado por otra persona')
            if telefono in self.viveros_telefonos.dict:
                raise ValueError(f'El telefono {telefono} esta registrado como telefono de un vivero')
            self.telefonos.add_row([telefono, str(id)])
        self.correos.write()
        self.telefonos.write()
        self.empleados.write()
    
    def delete(self, id: str):
        for key,value in self.correos.dict.items():
            if value[0] == id:
                self.correos.delete_row(key)

        for key,value in self.telefonos.dict.items():
            if value[0] == id:
                self.telefonos.delete_row(key)
        self.empleados.delete_row(id)
        self.correos.write()
        self.telefonos.write()
        self.empleados.write()
    
    def modify(self, id:str, vivero:str, nombre:str, direccion:str, fecha_de_nacimiento: date, salario:int, cargo:str, correos: List[str], telefonos: List[str]):
        self.delete(id)
        self.add(vivero, nombre, direccion, fecha_de_nacimiento, salario, cargo, correos, telefonos)

    def __getitem__(self, key: int):
        correos:List[str] = []
        for correo,empleado_id in self.correos.dict.items():
            if(empleado_id[0] == str(key)):
                correos.append(correo)#type: ignore
                #We ensure that keys of correos will be str, so we ignore type error

        telefonos:List[str] = []
        for telefono,empleado_id in self.telefonos.dict.items():
            if(empleado_id[0] == str(key)):
                telefonos.append(telefono)#type: ignore
                #We ensure that keys of telefonos will be str, so we ignore type error

        return [*self.empleados[str(key)], *correos, *telefonos] 