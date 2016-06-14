#Developed by Pablo Vicente-Munuera
import os
from os import path

directory_path = 'E:/Pablo/Neuroblastoma/Datos/Data/Casos'
directories = [x for x in os.listdir(directory_path) if path.isdir(directory_path+os.sep+x)]

f = open(directory_path + '/RETMeasures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/COLMeasures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/GAGMeasures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD31Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD45Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD4Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD7Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD8Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD11bMeasures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD11cMeasures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD20Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD68Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/CD163Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/OCT4Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

f = open(directory_path + '/S100A6Measures.csv', 'w')
f.write('Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength\r\n')
f.close()

for directory in directories:
	files = [x for x in os.listdir(directory_path + os.sep + directory) if path.isfile(directory_path + os.sep + directory + os.sep + x)]

	for file in files:
		#Parse name of file

		nameOutputFile = file.strip('stats').strip('.csv').split('_')
		caseInfo = ''
		print (nameOutputFile)
		if nameOutputFile[4].startswith('RET'): #Check all, and positivo, phototoshop and other shit
			caseInfo = nameOutputFile [1] + nameOutputFile[2]

		# outputFile = open(nameOutputFile, 'a')

		# f = open(file, 'r')
		# f.readline()
		# for line in f:
		# 	#Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength
		# 	outputFile.write(caseInfo + line)

		# outputFile.close()
