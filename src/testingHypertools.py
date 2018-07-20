import pandas as pd
import hypertools as hyp

data = pd.read_csv('/home/ubuntu/vboxshare/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_Risk_GDDUsingWeights_13_03_2017.csv')

class_labels = data["Risk"]
data = data.drop("Risk", axis=1)
data = data.drop("Casos", axis=1)

hyp.plot(data, 'o')