import csv
from typing import Callable, List, Dict, Any, Tuple, Union
import os

class CSVManager:

    def __init__(self, file_name: str, types:List[Callable[[str], Any]], has_header:bool = True, keys:int = 1):
        self.file_name = file_name
        self.dict:Dict[Union[str, Tuple[str, str]], List[str]] = {}
        self.types = types
        self.keys = keys
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
                if self.keys == 1:
                    self.dict[row[0]] = row[1:]
                else:
                    self.dict[(row[0], row[1])] = row[2:]

    def write(self):
        with open(self.file_name, mode = 'w') as file:
            writer = csv.writer(file)

            if self.header:
                writer.writerow(self.header)

            for key,lst in self.dict.items():
                if type(key) == str:
                    key = [key]
                writer.writerow([*key, *lst])

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
                
        if self.keys == 1:
            self.dict[row[0]] = row[1:]
        else:
            self.dict[(row[0], row[1])] = row[2:]
    
    def delete_row(self, key:Union[str, Tuple[str,str]]):
        if not key in self.dict:
            raise KeyError(f'No existe una columna con llave {key}')
        del self.dict[key]
    
    def modify_row(self, key: Union[str, Tuple[str, str]], row:List[str]):
        if not key in self.dict:
            raise KeyError(f'No existe una columna con llave {key}')

        errs = []
        if type(key) == str:
           errs = self.check_row([key, *row]) #type: ignore
           #Type checking can be ignored here because the type checker is dumb
           #and doesn't realize we are checking for the right type in the if condition
        else:
            errs = self.check_row([*key, *row])
        if len(errs) > 0:
            if errs[0] == -1:
                raise TypeError(f'La fila modificada no tiene el numero correcto de columnas \n {row}')
            else:
                raise TypeError(f'La fila modificada difiere de los tipos requeridos en la(s) columna(s) {errs} \n {row}')
        self.dict[key] = row 

    def __getitem__(self, key:Union[str, Tuple[str, str]]):
        return self.dict[key]