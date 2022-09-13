import csv
from typing import List
import os

class CSVManager:

    def __init__(self, file_name: str, types:List[type], has_header:bool = True):
        self.file_name = file_name
        self.dict = {}
        self.types = types
        if not os.path.exists(file_name):
            raise FileNotFoundError('No existe el archivo')

        with open(self.file_name, mode = 'r') as file:
            reader = csv.reader(file)
            if has_header:
                self.header = next(reader, None)
            else:
                self.header = None
            
            fst_row = next(reader, None)

            if not fst_row:
                return

            for index, (typ, item) in enumerate(zip(types, fst_row)):
                try:
                    typ(item)
                except:
                    raise TypeError('El tipo no coincide en la columna ' + str(index))

            self.dict = {row[0] : row[1:] for row in reader}

            self.dict[fst_row[0]] = fst_row[1:]

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
        
    def add_row(self, row:List[str]):
        pass

    def __getitem__(self, key:str):
        return self.dict[key]