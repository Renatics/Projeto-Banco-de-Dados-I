import csv

with open('produtos.csv','r') as file:
    produtos = csv.reader(file)

print(produtos)  