import csv
from typing import List
import os

class CSVManager:

    def __init__(self, file_name: str):
        self.file_name = file_name
        self.dict = {}
        if not os.path.exists(file_name):
            raise FileNotFoundError('No existe el archivo')

    def read(self):
        with open(self.file_name, mode = 'r') as file:
            reader = csv.reader(file)
            self.dict = {rows[0] : rows[1:] for rows in reader}

    def write(self):
        with open(self.file_name, mode = 'w') as file:
            writer = csv.writer(file)
            rows:List[List[str]] = []
            for i,j in self.dict.items():
                j.insert(0, i)
                rows.append(j)

            writer.writerows(rows)

    def __getitem__(self, key:str):
        return self.dict[key]