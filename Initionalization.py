import csv
import pandas

print("Hello Iris")

fileName = "iris_csv.csv"

with open(fileName, "r") as csvFile:
    for line in csvFile:
        print(line)

print("New update")

