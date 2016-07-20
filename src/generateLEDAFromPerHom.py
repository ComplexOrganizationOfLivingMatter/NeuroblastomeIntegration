#Developed by Pablo Vicente-Munuera
import os
from os import path
import re
import numpy

directory_path = 'E:/Pablo/Neuroblastoma/Results/PersistentHomology'
directories = [x for x in os.listdir(directory_path) if path.isdir(directory_path+os.sep+x)]

for directory in directories:
	files = [x for x in os.listdir(directory_path + os.sep + directory) if path.isfile(directory_path + os.sep + directory + os.sep + x) and x.endswith('.perHom')]

	for file in files:
		
		verticesArray = []
		edgesArray = []
		timeStamp = []
		with open(directory_path + os.sep + directory + os.sep + file, 'r') as fileIn:
			for line in fileIn:
				fields = line.strip('\r\n').split(' ; ')
				vertices = fields[0].strip('[').strip(']').split(',')
				if len(vertices) == 1:
					verticesArray = verticesArray + vertices
				elif len(vertices) == 2:
					timeStamp.append(int(float(fields[1])))
					edgesArray = edgesArray + vertices

			times = list(set(timeStamp))

			for time in times:
				nameOutputFile = file.strip('.perHom') + 'It' + str(time).replace('.', '_') + '.gw'
				print nameOutputFile
				with open(directory_path + os.sep + directory + os.sep + nameOutputFile, 'w') as fileOut:
					fileOut.write('LEDA.GRAPH\n')
					fileOut.write('void\n')
					fileOut.write('void\n')
					fileOut.write('-2\n')
					fileOut.write(str(len(verticesArray)) + '\n')
					for vertex in verticesArray:
						fileOut.write('|{}|\n')

					timeLessThanActual = [x for x in timeStamp if x <= time]
					fileOut.write(str(len(timeLessThanActual)) + '\n')
					numEdge = 0
					while True:
						fileOut.write(str(int(edgesArray[numEdge])+1) + ' ' + str(int(edgesArray[numEdge+1])+1) + ' 0 |{}|\n')
						numEdge = numEdge + 2
						if len(timeLessThanActual) <= numEdge/2:
							break