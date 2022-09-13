import csv

class CSVManager:

    def __init__(self, file_name: str = '/home/ianpineda/projects/FBD-2023-1/test.csv'):
        self.file_name = file_name
        self.dict = {}
        pass

    def read(self):
        with open(self.file_name, mode = 'r') as file:
            reader = csv.reader(file)
            self.dict = {rows[0] : rows[1:] for rows in reader}

    def write(self):
        with open(self.file_name, mode = 'w') as file:
            writer = csv.writer(file)
            writer.writerows(list(self.dict))
            

xd = CSVManager()
xd.read()
xd.write()