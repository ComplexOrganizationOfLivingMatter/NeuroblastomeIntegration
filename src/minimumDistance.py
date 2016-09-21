import networkx as nx
import scipy.io
import h5py
import numpy as np
import time
from time import gmtime, strftime
from os import listdir
from os.path import isfile, join
import os.path


mypaths = []
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 1. Y01_01B16459B/CoreA/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 1. Y01_01B16459B/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 2. Y02A_02B03119A/CoreA/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 2. Y02A_02B03119A/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 3. Y02A_02B13320A/CoreA/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 4. Y03A_03B12888B/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 5. Y03A_03B17300B/CoreA/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 5. Y03A_03B17300B/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 6. Y03B_03B03346B/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 7. Y03B_03B07423A/CoreA/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 7. Y03B_03B07423A/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 8. Y03B_03B08572A/CoreA/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 8. Y03B_03B08572A/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 9. Y2_333688B/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 10. Y2_99B00646B/CoreB/Adjacency/')
# mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/Casos/CASO 11. Y2_99B13169A/CoreA/Adjacency/')
mypaths.append('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/NuevosCasos160/Casos/Networks/DistanceMatrix/')

for mypath in mypaths:
	onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

	for fileName in onlyfiles:
		outputFileName = fileName.split('.')
		#print outputFileName[0][:-14]
		if "DistanceMatrix.mat" in fileName and os.path.isfile(mypath + outputFileName[0][:-14] + 'It' + '1' + '.mat') == 0:
			start = time.time()
			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			#print start
			#print mypath + fileName
			mat = scipy.io.loadmat(mypath + fileName)
			#fileName = 'minimumDistanceClasses5_Y2_99B00646B_CD45_Negativas_IPPDistanceMatrix.mat'
			distanceMatrix = np.matrix(mat['distanceBetweenObjects'])
			distanceMatrixAux = distanceMatrix;
			adjacencyMatrix = np.zeros((len(distanceMatrix), len(distanceMatrix)))
			#print np.triu(distanceMatrix)
			
			print len(distanceMatrix)
			if len(distanceMatrix) > 15:
				#Creating network
				G = nx.Graph()
				#With an initial number of nodes
				G.add_nodes_from(np.arange(len(distanceMatrix)))

				iteration = 1
				while True:
					
					maxDistanceIteration = 0;
					indicesMaxDistanceIteration = 0
					numRow = 0;
					#distanceMatrixAux will be the matrix in which we will add remove the minimum closest
					#vertex of the row.
					for row in distanceMatrixAux:
						try:
							#minimum except zeros
							minValue = row[row != 0].min()
							#print minValue
							#indices of the min value
							indices = np.where(row == minValue)
							#first of indice's array is 0 always. Then it should be 'row', the real row.
							distanceMatrixAux[numRow, indices[1][0]] = 0
							#distanceMatrixAux[indices[1][0], row] = 0

							if minValue > maxDistanceIteration:
								maxDistanceIteration = minValue
						except Exception, e:
							pass

						numRow = numRow + 1
					
					#print distanceMatrix[1532][distanceMatrix[1532] != 0].min()
					#print maxDistanceIteration
					indices = np.where(distanceMatrix <= maxDistanceIteration)
					#print len(indices[0])
					#print len(distanceMatrix)
					#print maxDistanceIteration
					#Remove edges
					#print indices
					for index in range(len(indices[0])):
						if distanceMatrix[indices[0][index], indices[1][index]] != 0 and distanceMatrix[indices[1][index], indices[0][index]] != 0:
							distanceMatrix[indices[0][index], indices[1][index]] = 0
							distanceMatrix[indices[1][index], indices[0][index]] = 0
							#Add the edge
							edge = (indices[0][index], indices[1][index])
							G.add_edge(*edge)

							adjacencyMatrix[indices[0][index], indices[1][index]] = 1
							adjacencyMatrix[indices[1][index], indices[0][index]] = 1


					#Last edge
					# distanceMatrixAux[indicesMaxDistanceIteration[0][0], indicesMaxDistanceIteration[1][0]] = 0.0
					# edge = (indicesMaxDistanceIteration[0][0], indicesMaxDistanceIteration[1][0])
					# G.add_edge(*edge)

					# ----------- iteration is over! ------------#

					#Output files of the network
					#outputFileName = fileName.split('/')
					#outputFileName = outputFileName[11].split('.')
					#outputFileName = fileName.split('.')
					adjacencyMatrixOut = nx.adjacency_matrix(G)
					print outputFileName[0][:-14] + 'It' + str(iteration) + '.mat'
					scipy.io.savemat('/home/pablo/vboxshare/Neuroblastoma/Datos/Data/NuevosCasos160/Casos/Networks/SortingAlgorithm/' + outputFileName[0][:-14] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
					iteration = iteration + 1
					# print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
					#ccomp = sorted(nx.connected_components(G), key = len, reverse=True)
					# #print len(ccomp)
					# print ccomp
					# print len(ccomp)
					# print len(distanceMatrix)
					#print min(sum(adjacencyMatrix))
					#print np.where(sum(adjacencyMatrix) == min(sum(adjacencyMatrix)))
					#print sum(adjacencyMatrixOut.todense()).min()
					#print np.where(sum(adjacencyMatrixOut.todense()) == sum(adjacencyMatrixOut.todense()).min())

					#If the iteration goes over 300, it has to be an error
					if iteration > 300:
						print 'Error!'
						break

					#if the graph is connected, we finish the algorithm
					if nx.is_connected(G):
						#if len(ccomp) == 1:
						break


			print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
			end = time.time()
			print (end - start)
			print ('------------------------------------------------')
