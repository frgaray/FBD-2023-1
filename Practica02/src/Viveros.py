from datetime import date
from CSVManager import CSVManager
from typing import List, Dict

class Viveros:
    def __init__(self, viveros:CSVManager, empleados:CSVManager, telefonos:CSVManager, plantas:CSVManager, plantas_disponibilidad:CSVManager, empleados_telefonos:CSVManager):
        self.viveros = viveros
        self.empleados = empleados
        self.telefonos = telefonos
        self.plantas = plantas
        self.plantas_disponibilidad = plantas_disponibilidad
        self.empleados_telefonos = empleados_telefonos
    
    def add(self, nombre:str, direccion:str, fecha_de_apertura: date, telefonos: List[str], plantas_disponibles:Dict[str, int]):
        if nombre in self.viveros.dict:
            raise ValueError(f'El vivero {nombre} ya existe')
        for telefono in telefonos:
            if telefono in self.telefonos.dict:
                raise ValueError(f'El telefono {telefono} ya esta registrado por otro vivero')
            if telefono in self.empleados_telefonos.dict:
                raise ValueError(f'El telefono {telefono} le pertenece a un empleado')
            self.telefonos.add_row([telefono, nombre])
        self.viveros.add_row([nombre, direccion, fecha_de_apertura.isoformat()])
        for planta in plantas_disponibles.keys():
            if planta not in self.plantas.dict:
                raise ValueError(f'La planta {planta} no esta registrada')
        for planta in self.plantas.dict.keys():
            disponibilidad = 0
            if planta in plantas_disponibles:  
                disponibilidad = plantas_disponibles[planta]
            self.plantas_disponibilidad.add_row([nombre, planta, str(disponibilidad)])# type: ignore
            # Here we can ignore the type error because we know that the keys of
            # the plantas dictionary are of type str, but the linter doesn't know
    
    def delete(self, name:str):
        for key,value in self.telefonos.dict.items():
            if value[0] == name:
                self.telefonos.delete_row(key)
        for planta in self.plantas:
            self.plantas_disponibilidad.delete_row((name, planta))# type: ignore
            # This type error involves both the fact that plantas has a str type
            # for keys, and that plantas_disponibilidad has a Tuple[str, str] type
            # for keys, but the linter is unaware that we ensure both of those things
        for empleado,values in self.empleados.dict.items():
            if values[0] == name:
                self.empleados.modify_row(empleado, ['', *values[1:]])

        self.viveros.delete_row(name)
    
    def modify(self, nombre:str, direccion: str, fecha_de_apertura:date, telefonos:List[str], plantas_disponibles:Dict[str, int]):
        self.delete(nombre)
        self.add(nombre, direccion, fecha_de_apertura, telefonos, plantas_disponibles)
    
    def write(self):
        self.viveros.write()
        self.telefonos.write()
        self.empleados.write()
        self.plantas_disponibilidad.write()
    
    def __getitem__(self, nombre: str):
        telefonos:List[str] = []
        for telefono,vivero_id in self.telefonos.dict.items():
            if(vivero_id[0] == nombre):
                telefonos.append(telefono)#type: ignore
                # The key of telefonos will always be str, so we ignore the error
        plantas_disponibilidad:List[str] = []
        for planta in self.plantas.dict.keys():
            disponibilidad = self.plantas_disponibilidad[(nombre, planta)][0]#type: ignore
            # The key of plantas is guaranteed to be str, and the key of plantas_disponibilidad
            # is guaranteed to be Tuple[str, str] so we can ignore the type error
            plantas_disponibilidad.append(f'{planta}: {disponibilidad}')

        return [nombre, *self.viveros[nombre] ,*telefonos, *plantas_disponibilidad]