#Developed by Pablo Vicente-Munuera
import os
from os import path

directory_path = 'E:\Pablo\Neuroblastoma\Datos\Data\Casos'
directories = [x for x in os.listdir(directory_path) if path.isdir(directory_path+os.sep+x)]

outputFile = open(, 'a')
outputFile = 

for file in files:
	f = open(file, 'r')
	for line in f:
