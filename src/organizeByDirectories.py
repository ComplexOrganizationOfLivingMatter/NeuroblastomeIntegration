#Developed by Pablo Vicente-Munuera
import os
from os.path import isfile, join
import sys

if len(sys.argv) > 1:
	onlyfiles = [f for f in os.listdir(sys.argv[1]) if isfile(join(sys.argv[1], f))]
else:
	onlyfiles = [f for f in os.listdir('.') if isfile(join('.', f))]

for file in onlyfiles:
	if file != 'organizeByDirectories.py':
		
		file = str.trim('centroids')
		
		if file.startswith('_'):
			fileSplitted = str.split(file[1:], '_')
		else:
			fileSplitted = str.split(file, '_')

		if fileSplitted[2].startswith('Y0'):
			directoryName = fileSplitted[0] + '_' + fileSplitted[1] + '_' + fileSplitted[2]
		else:
			directoryName = fileSplitted[0][:-1] + '_' + fileSplitted[0][-1:] +  '_' + fileSplitted[1]

		if not os.path.exists(directoryName):
			os.makedirs(directoryName)	

		os.rename(file, directoryName + os.sep + file)


