import csv
from typing import List, Dict
import os

class CSVManager:

    def __init__(self, file_name: str, types:List[type], has_header:bool = True):
        self.file_name = file_name
        self.dict:Dict[str, List[str]] = {}
        self.types = types
        if not os.path.exists(file_name):
            raise FileNotFoundError('No existe el archivo')

        with open(self.file_name, mode = 'r') as file:
            reader = csv.reader(file)
            if has_header:
                self.header = next(reader, None)
            else:
                self.header = None
            
            for index,row in enumerate(reader):
                errs = self.check_row(row)
                if len(errs) > 0:
                    if errs[0] == -1:
                        raise TypeError(f'La fila {index} no tiene el numero correcto de columnas \n {row}')
                    else:
                        raise TypeError(f'En la fila {index} la(s) columna(s) {errs} no coincide(n) con los tipos \n {row}')
                self.dict[row[0]] = row[1:]

    def write(self):
        with open(self.file_name, mode = 'w') as file:
            writer = csv.writer(file)
            rows:List[List[str]] = []

            if self.header:
                writer.writerow(self.header)

            for i,j in self.dict.items():
                j.insert(0, i)
                rows.append(j)

            writer.writerows(rows)

    def check_row(self, row:List[str]) -> List[int]:
        result:List[int] = [] 
        if len(self.types) != len(row):
            return [-1]

        for index, (typ, item) in enumerate(zip(self.types, row)):
            try:
                typ(item)
            except:
                result.append(index)
        return result
        
    def add_row(self, row:List[str]):
        errs = self.check_row(row)
        if len(errs) > 0:
            if errs[0] == -1:
                raise TypeError(f'La fila a agregar no tiene el numero correcto de columnas \n {row}')
            else:
                raise TypeError(f'La fila a agregar difiere de los tipos requeridos en la(s) columna(s) {errs} \n {row}')
                
        self.dict[row[0]] = row[1:]

    def __getitem__(self, key:str):
        return self.dict[key]