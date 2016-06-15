#Developed by Pablo Vicente-Munuera
import os
from os import path
import re

directory_path = 'E:/Pablo/Neuroblastoma/Datos/Data/Casos'
directories = [x for x in os.listdir(directory_path) if path.isdir(directory_path+os.sep+x)]
print (directories)

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
		#print (nameOutputFile)
		pacient = re.compile('Y[0-2]+[A-B]?')
		case = re.compile ('[0-9][0-9][B]?[0-9]+[A-B]')
		algorithmStr = nameOutputFile[0] + nameOutputFile[len(nameOutputFile)-1]
		pacienteStr = ''
		caseStr = ''
		markerStr = ''
		for position in nameOutputFile:
			if pacient.match(position):
				pacienteStr = position
			elif case.match(position):
				caseStr = position
			elif position.startswith('RET'):
				markerStr = 'RET'
			elif position.startswith('COL'):
				markerStr = 'COL'
			elif position.startswith('GAG'):
				markerStr = 'GAG'
			elif position.startswith('CD31'):
				markerStr = 'CD31'
			elif position.startswith('CD45'):
				markerStr = 'CD45'
			elif position.startswith('CD7'):
				markerStr = 'CD7'
			elif position.startswith('CD4'):
				markerStr = 'CD4'
			elif position.startswith('CD8'):
				markerStr = 'CD8'
			elif position.startswith('CD11b'):
				markerStr = 'CD11b'
			elif position.startswith('CD11c'):
				markerStr = 'CD11c'
			elif position.startswith('CD20'):
				markerStr = 'CD20'
			elif position.startswith('CD68'):
				markerStr = 'CD68'
			elif position.startswith('CD163'):
				markerStr = 'CD163'
			elif position.startswith('OCT4'):
				markerStr = 'OCT4'
			elif position.startswith('S100A6'):
				markerStr = 'S100A6'

		#print (pacienteStr + caseStr + markerStr)
		outputFile = open(directory_path + os.sep + markerStr + 'Measures.csv' , 'a')

		f = open(directory_path + os.sep + directory + os.sep + file, 'r')
		f.readline()
		for line in f:
			#Case,Algoritmo,Type,CCUU,CCWU,Assortivity,DensityUU,Efficiency,Diameter,CharacteristicPathLength
			outputFile.write(pacienteStr + '_' +caseStr + ',' + algorithmStr + ',' + line)

		outputFile.close()
