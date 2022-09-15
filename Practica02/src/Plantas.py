from CSVManager import CSVManager
from typing import Dict, List

class Plantas:
    def __init__(self, plantas:CSVManager, viveros:CSVManager, plantas_disponibilidad:CSVManager):
        self.plantas = plantas
        self.viveros = viveros
        self.plantas_disponibilidad = plantas_disponibilidad

    def add(self, nombre:str, precio:int, genero:str, cuidados_basicos:str, tipo_sustrato:str, sol_sombra_resolana:str, fecha_germinacion:str, intervalo_riego:str, disponibles_en_vivero:Dict[str, int]):
        if nombre in self.plantas.dict:
            raise ValueError(f'La planta {nombre} ya existe')

        self.plantas.add_row([nombre, str(precio), genero, cuidados_basicos, tipo_sustrato, sol_sombra_resolana, fecha_germinacion, intervalo_riego])
        for vivero in disponibles_en_vivero.keys():
            if vivero not in self.viveros.dict:
                raise ValueError(f'El vivero {vivero} no esta regitrado')
        for vivero in self.viveros.dict.keys():
            disponibilidad:int = 0
            if vivero in disponibles_en_vivero:
                disponibilidad = disponibles_en_vivero[vivero]
            self.plantas_disponibilidad.add_row([vivero, nombre, str(disponibilidad)])#type: ignore
            # la llave de vivero es siempre str, por lo tanto podemos suprimir el error
        
    def delete(self, name:str):
        for vivero in self.viveros.dict.keys():
            self.plantas_disponibilidad.delete_row((vivero, name))#type: ignore
        self.plantas.delete_row(name)
    
    def modify(self, nombre:str, precio:int, genero:str, cuidados_basicos:str, tipo_sustrato:str, sol_sombra_resolana:str, fecha_germinacion:str, intervalo_riego:str, disponibles_en_vivero:Dict[str, int]):
        self.delete(nombre)
        self.add(nombre, precio, genero, cuidados_basicos, tipo_sustrato, sol_sombra_resolana, fecha_germinacion, intervalo_riego, disponibles_en_vivero)
    
    def __getitem__(self, nombre:str):
        plantas_disponibilidad:List[str] = []
        for vivero in self.viveros.dict.keys():
            disponibilidad = self.plantas_disponibilidad[(vivero, nombre)][0]#type: ignore
            plantas_disponibilidad.append(f'{vivero}: {disponibilidad}')

            return [nombre, *self.plantas[nombre], *plantas_disponibilidad]