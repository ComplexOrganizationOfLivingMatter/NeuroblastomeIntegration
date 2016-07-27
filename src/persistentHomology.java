import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Iterator;

import edu.stanford.math.plex4.api.Plex4;
import edu.stanford.math.plex4.homology.barcodes.BarcodeCollection;
import edu.stanford.math.plex4.homology.chain_basis.Simplex;
import edu.stanford.math.plex4.homology.interfaces.AbstractPersistenceAlgorithm;
import edu.stanford.math.plex4.streams.impl.VietorisRipsStream;
import edu.stanford.math.plex4.streams.interfaces.PrimitiveStream;

public class persistentHomology {

    public static void main(String[] args) {

    	ArrayList<ArrayList<Double>> arrayListCentroids = new ArrayList<ArrayList<Double>>();
    	
    	
    	String csvFile = args[0];
    	BufferedReader br = null;
    	String line = "";
    	String cvsSplitBy = ",";
    	
    	try {
    		br = new BufferedReader(new FileReader(csvFile));
    		while ((line = br.readLine()) != null) {
    		    // use comma as separator
    			String[] centroid = line.split(cvsSplitBy);
    			ArrayList<Double> auxCentroid = new ArrayList<Double>();
    			auxCentroid.add(Double.parseDouble(centroid[0]));
    			auxCentroid.add(Double.parseDouble(centroid[1]));
    			arrayListCentroids.add(auxCentroid);
    		}
    	} catch (FileNotFoundException e) {
    		e.printStackTrace();
    	} catch (IOException e) {
    		e.printStackTrace();
    	} finally {
    		if (br != null) {
    			try {
    				br.close();
    			} catch (IOException e) {
    				e.printStackTrace();
    			}
    		}
    	}
    	
    	double[][] centroids = new double[arrayListCentroids.size()][2];
    	int numObject = 0;
    	for(Iterator<ArrayList<Double>> i = arrayListCentroids.iterator(); i.hasNext(); ) {
    	    ArrayList<Double> item = i.next();
    	    centroids[numObject][0] = item.get(0);
    	    centroids[numObject][1] = item.get(1);
    	    
    	    numObject++;
    	}
    	
        double maxDistance = 3000;
        int maxDimension = 2;
        int numDivisions = 200;
        
        //double[] filtrationValues = {5, 10, 15, 20, 30, 50, 70, 110, 170, 230, 290, 370, 500, 750, 1000, 1250, 1500, 2000, 2500, 3000, 3500};
		VietorisRipsStream<double[]> stream = Plex4.createVietorisRipsStream(centroids, maxDimension, maxDistance, numDivisions);
        //Then it calculates the simplicial complexes of dimension 'max_dimension'.
        AbstractPersistenceAlgorithm<Simplex> persistence = Plex4.getModularSimplicialAlgorithm(maxDimension, 2);
        //And finally, we get the intervals of connected components, and holes. Persistent homology.
        BarcodeCollection<Double> intervals = persistence.computeIntervals(stream);
        
        //stream.finalizeStream();
        
        
        try {
        	String fileName = args[0];
        	fileName = fileName.replace(".csv", ".betti");
			PrintWriter writer = new PrintWriter(fileName, "UTF-8");
			writer.println("Number of simpleces in complex: " + stream.getSize());

	        writer.println("\nBarcodes:");
	        writer.println(intervals.getBettiNumbers());
	        writer.println(intervals);
	        writer.close();
	        
	        fileName = fileName.replace(".betti", ".perHom");
			PrintWriter writer2 = new PrintWriter(fileName, "UTF-8");
			Iterator<Simplex> iter = stream.iterator();
			while (iter.hasNext()){
				 Simplex simplex = (Simplex) iter.next();
				 double filtration_value = stream.getFiltrationValue(simplex);
				writer2.print(simplex);
				writer2.print(" ; ");
				writer2.println(filtration_value);
			}
	        writer2.close();
	        
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
    }
}