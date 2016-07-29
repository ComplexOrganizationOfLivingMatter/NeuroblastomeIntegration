from __future__ import division
import os

path = "Results/S100A6/"
dirList = sorted(os.listdir(path))

with open(path + 'totalGraphlets.txt', 'w') as fileOut:
	with open(path + 'totalGraphletsPercentage.csv', 'w') as fileOutPercentage:
		for fname in dirList:
			#Input file will consist of n lines, one for each node in a graph from 0 to n-1.
			#Every line will contain 15 or 73 space-separated orbit counts depending on the specified graphlet size.
		    if fname.endswith('.ndump2'):
		    	with open(path + fname, 'r') as fileIn:
		    		graphlets = [0] * 72
		    		numLine = 0
		    		for line in fileIn:
		    			line = line.lstrip(' ')
		    			line = line.rstrip('\n')
		    			numLine = numLine + 1;
		    			graphletsAux = line.split(' ')
		    			for i in range(len(graphletsAux)):
		    				graphlets[i] = graphlets[i] + int(graphletsAux[i])

		    		graphletsPercentage = [0] * 72
		    		total = sum(graphlets)
					if total != 0:
						numGraphletsVector = [2] * 1 + [3] * 3 + [4] * 11 + [5] * 57
			    		for j in range(len(graphletsPercentage)):
			    			graphlets[j] = graphlets[j] / numGraphletsVector[j]
			    			graphletsPercentage[j] = graphlets[j] / total
							#print graphlets[j]

		    		
		    		fileOut.write(fname + '\n')
		    		fileOut.write(str(graphlets).strip('[]').strip(',') + '\n')
		    		fileOut.write('-----------------------------------' + '\n')
					fileOutPercentage.write(fname + ', ')
		    		fileOutPercentage.write(str(graphletsPercentage).strip('[]') + '\n')
