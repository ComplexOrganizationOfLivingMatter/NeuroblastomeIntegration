#Developed by Pablo Vicente-Munuera
import os
from os import path
import re

directory_path = 'E:/Pablo/Neuroblastoma/Results/PersistentHomology'
directories = [x for x in os.listdir(directory_path) if path.isdir(directory_path+os.sep+x)]

for directory in directories:
	files = [x for x in os.listdir(directory_path + os.sep + directory) if path.isfile(directory_path + os.sep + directory + os.sep + x) and x.endswith('.perHom')]

	for file in files:
		nameOutputFile = file.strip('.perHom') + '.gw'
		verticesArray = []
		edgesArray = []
		with open(directory_path + os.sep + directory + os.sep + file, 'r') as fileIn:
			with open(directory_path + os.sep + directory + os.sep + nameOutputFile, 'w') as fileOut:
				fileOut.write('LEDA.GRAPH\n')
				fileOut.write('void\n')
				fileOut.write('void\n')
				fileOut.write('-2\n')
				for line in fileIn:
					fields = line.split(' ; ')
					vertices = fields[0].strip('[').strip(']').split(',')
					if len(vertices) == 1:
						verticesArray = verticesArray + vertices
					elif len(vertices) == 2:
						edgesArray = edgesArray + vertices

				fileOut.write(str(len(verticesArray)) + '\n')
				for vertex in verticesArray:
					fileOut.write('|{}|\n')

				fileOut.write(str(len(edgesArray)/2) + '\n')
				numEdge = 0
				while True:
					fileOut.write(edgesArray[numEdge] + ' ' + edgesArray[numEdge+1] + ' 0 |{}|\n')
					numEdge = numEdge + 2
					if len(edgesArray)-1 < numEdge:
						break