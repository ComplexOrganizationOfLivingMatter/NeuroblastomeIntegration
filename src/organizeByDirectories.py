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
		print file
		if file.startswith('_'):
			fileSplitted = str.split(file[1:], '_')
		else:
			fileSplitted = str.split(file, '_')

		directoryName = 'p';
		if file.startswith('centroids'):
			if fileSplitted[1].startswith('Y'):
				directoryName = sys.argv[1] + fileSplitted[1] + '_' + fileSplitted[2]
		else:
			directoryName = sys.argv[1] + fileSplitted[1];
		# 	if fileSplitted[2].startswith('Y0'):
		# 		directoryName = fileSplitted[0] + '_' + fileSplitted[1] + '_' + fileSplitted[2]
		# 	else:
		# 		directoryName = fileSplitted[0][:-1] + '_' + fileSplitted[0][-1:] +  '_' + fileSplitted[1]


		if len(directoryName) > 2:
			if not os.path.exists(directoryName):
				os.makedirs(directoryName)
			if len(sys.argv) > 1:
				os.rename(sys.argv[1] + file, directoryName + os.sep + file)
			else:
				os.rename(file, directoryName + os.sep + file)
		

