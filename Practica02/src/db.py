#!/bin/env python

import sys
from CSVManager import CSVManager

# Architecture:

# Command list:
# init
# 

#Testing, delete afterwards----------------------------------------------------
prueba = CSVManager('./test.csv', [int, int, int, int, int], has_header= True)
prueba.modify_row('20', ['21', '22', '23', '24'])
prueba.add_row(['100', '101', '102', '103', '104'])
prueba.delete_row('19')
prueba.write()
#------------------------------------------------------------------------------

def main():
    "Starting point for the database"

    # parse arguments
    # check & load database
    # execute command into database
    # write changes into files
    # finish
    print(sys.argv)

main()

