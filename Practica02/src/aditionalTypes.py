def telephone(input:str):
    input = input.strip().replace(' ', '')
    if len(input) != 10:
        raise TypeError
    return 