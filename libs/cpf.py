import random

def digits(cpf):
    return [int(d) for d in cpf if d.isdigit()]

def gen():
    # Gera CPF válido (11 dígitos) com DV corretos para evitar rejeição por "formato inválido".
    n = [random.randint(0,9) for _ in range(9)]
    for _ in range(2):
        s = sum((len(n)+1-i)*v for i, v in enumerate(n))
        d = 11 - s % 11
        n.append(0 if d > 9 else d)
    return ''.join(map(str, n))

def is_valid(cpf):
    ds = digits(cpf)
    if len(ds) != 11 or len(set(ds)) == 1:
        return False
    n = ds[:9]
    for i in range(2):
        s = sum((len(n)+1-j)*v for j, v in enumerate(n))
        d = 11 - s % 11
        n.append(0 if d > 9 else d)
    return n == ds
