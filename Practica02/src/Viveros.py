from CSVManager import CSVManager
from typing import  List
from datetime import date
from random import randint

class Viveros:
    def __init__(self, viveros:CSVManager, empleados:CSVManager, correos:CSVManager, telefonos:CSVManager, viveros_telefonos:CSVManager):
        self.viveros = viveros
        self.empleados = empleados
        self.correos = correos
        self.telefonos = telefonos
        self.viveros_telefonos = viveros_telefonos