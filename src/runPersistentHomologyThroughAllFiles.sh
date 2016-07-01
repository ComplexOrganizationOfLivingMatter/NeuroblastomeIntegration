#usr/bin/sh

javac -classpath javaplex.jar persistentHomology.java 

ls 'Data/' | grep .csv | while read f; do echo "$f"; java -classpath .:javaplex.jar -Xmx60000M persistentHomology "Data/$f"; done