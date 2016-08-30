

//--------------------------------------------------------------------------
/*! This function is the entry point for running the simulation in GeNN
	Autogenerated using XSLT script - Alex Cope 2013

*/
//--------------------------------------------------------------------------

#include <cuda_runtime.h>
//#include <helper_cuda.h>

#include "../../lib/include/hr_time.h"
CStopWatch timer;
#include "../../lib/include/hr_time.cpp"

#include "../../lib/include/numlib/simpleBit.h"

#include "model.cc"
#include "Untitled_Project_CODE/runner.cc"
#include <algorithm>

// helper for random numbers
#include "../GeNNHelperKrnls.cu"

#define CPU 0
#define GPU 1

// GLOBALS
float t = 0.0f;

#ifndef __RNG_FUNCS_
#define __RNG_FUNCS_

#include "utils.h"


#include "rng.h"
#include <curand.h>
#define CURAND_CALL(x) do { if((x)!=CURAND_STATUS_SUCCESS) { printf("Error at %s:%d\n",__FILE__,__LINE__); return EXIT_FAILURE;}} while(0)

// Some data for the random number generator.
RngData rngData;

float uniformRand(float min, float max) {
	return _randomUniform(&rngData)*(max-min)+min;
}
float normalRand(float mean, float std) {
	return _randomNormal(&rngData)*std+mean;
}
float poissonRand() {
	return _randomPoisson(&rngData);
}

#endif

struct conn {
	unsigned int src;
	unsigned int dst;
};
	
struct conn_with_delay : conn {
	float delay;
};

// sorting function for connections

bool sortConn (conn a,conn b) 
{ 
	if (a.src < b.src) return true;
	if (a.src == b.src && a.dst < b.dst) return true;
	return false;
}

struct prop {
	unsigned int ind;
	float val;
};

// sorting function for properties

bool sortProp (prop a,prop b) 
{ 
	if (a.ind < b.ind) return true;
	return false;
}

int main(int argc, char *argv[])
{

	zigset(&rngData,123);

// safety first:
if (sizeof(conn) != 8) {
	cerr << "Error: Expected a structure of 2 unsigned ints to be 8 bytes - this is not the case\n\n";
	exit(-1);
}
if (sizeof(conn_with_delay) != 12) {
	cerr << "Error: Expected a structure of 2 unsigned ints and a float to be 12 bytes - this is not the case\n\n";
	exit(-1);
}

printf("Size checks successful\n");

// for now....
	int which = GPU;

// DEFINES
  NNmodel model;

// SOME SETUP
  modelDefinition(model);
  allocateMem();
  initialize();

  //-----------------------------------------------------------------
  
 
// ALLOCATE THE SPARSE CONNECTIVITY

// GENERATE CONNECTIVITY

// ALLOCATE THE SPARSE CONNECTIVITY

// GENERATE CONNECTIVITY
	vector < conn > tempConnsInput1_Population_to_PopulationS1;
	{conn newConn; 
	// mind bogglingly silly way of setting up the vector!
	newConn.src = 0; newConn.dst = 0;
	tempConnsInput1_Population_to_PopulationS1.push_back(newConn);
	newConn.src = 1; newConn.dst = 1;
	tempConnsInput1_Population_to_PopulationS1.push_back(newConn);
	newConn.src = 2; newConn.dst = 2;
	tempConnsInput1_Population_to_PopulationS1.push_back(newConn);
	}
				//memset(gInput1_Population_to_PopulationS1,0,sizeof(float)*3*3);
	//for (int ind = 0; ind < tempConnsInput1_Population_to_PopulationS1.size(); ++ind) {
		//gInput1_Population_to_PopulationS1[tempConnsInput1_Population_to_PopulationS1[ind].dst*3+tempConnsInput1_Population_to_PopulationS1[ind].src] = 1.0;
	//}			
			 


initializeAllSparseArrays();


// ALLOCATE MEMORY FOR POISSON
	
	

  
// INIT CODE
  //initGRaw();
  if (which == CPU) {
    //theRates= baserates;
  }
  if (which == GPU) {
    copyStateToDevice();
    //theRates= d_baserates;
  }

  fprintf(stderr, "# neuronal circuitry built, start computation ... \n\n");

  //------------------------------------------------------------------
  // output general parameters to output file and start the simulation

  fprintf(stderr, "# We are running with fixed time step %f \n", DT);
  fprintf(stderr, "# initial wait time execution ... \n");

 t= 0.0;
 unsigned int offset = 0;
 float output [10];
 void *devPtr;
 
 FILE * time_file = fopen("/Users/alex/outtemp/temp/model//time.txt","w");
 
 // Init for logs
 
 	
 	FILE * Population_out_logFILE = fopen("/Users/alex/outtemp/temp/log/Population_out_log.bin","wb");
	if (!Population_out_logFILE) {
		cerr << "Could not open file for logging: " << "/Users/alex/outtemp/temp/log/Population_out_log.bin";
		exit(-1);
	}
 	
 	
 	FILE * Population_1_out_logFILE = fopen("/Users/alex/outtemp/temp/log/Population_1_out_log.bin","wb");
	if (!Population_1_out_logFILE) {
		cerr << "Could not open file for logging: " << "/Users/alex/outtemp/temp/log/Population_1_out_log.bin";
		exit(-1);
	}
 	
 
 curandGenerator_t gen;
 if (which == GPU) {
         
 // Init for randomNormal
 /* Create pseudo-random number generator */ 
 CURAND_CALL(curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT));
 /* Set seed */ 
 CURAND_CALL(curandSetPseudoRandomGeneratorSeed(gen, 1234ULL));
 }
 rngData.seed = 123;
 
 timer.startTimer();	
 for (int i= 0; i < 10000; i++) {
      
    if (which == GPU) {
    
    	
    	
    	// sync
    	CHECK_CUDA_ERRORS(cudaThreadSynchronize());
    	    
       stepTimeGPU( t);      
       
       // Logging...
       
       
       
       // Fetch variable from the device to the local array
       CHECK_CUDA_ERRORS(cudaMemcpy(out_NBPopulation, d_out_NBPopulation, 3*sizeof(float), cudaMemcpyDeviceToHost));
        
 		// write all to disk
		fwrite(out_NBPopulation, sizeof(float),3,Population_out_logFILE);			
 		
       
       // Fetch variable from the device to the local array
       CHECK_CUDA_ERRORS(cudaMemcpy(out_NBPopulationS1, d_out_NBPopulationS1, 3*sizeof(float), cudaMemcpyDeviceToHost));
        
 		// write all to disk
		fwrite(out_NBPopulationS1, sizeof(float),3,Population_1_out_logFILE);			
 		

      	// write out time to the GUI and check for the stop command
      	if (time_file) {
			// rewind the file and print the time
			fseek(time_file,0,SEEK_SET);
			fprintf(time_file, "%f", t);
		}
		
		FILE * stop_file = fopen("/Users/alex/outtemp/temp/model//stop.txt","r");
 		if (stop_file) break;
      	
      	//
	}
    if (which == CPU) {
      
    
       stepTimeCPU( t);

	// Logging...
       
       
 		// write all to disk
		fwrite(out_NBPopulation, sizeof(float),3,Population_out_logFILE);			
 		
 		// write all to disk
		fwrite(out_NBPopulationS1, sizeof(float),3,Population_1_out_logFILE);			
 		

      	// write out time to the GUI and check for the stop command
      	if (time_file) {
			// rewind the file and print the time
			fseek(time_file,0,SEEK_SET);
			fprintf(time_file, "%f", t);
		}
		
		FILE * stop_file = fopen("/Users/alex/outtemp/temp/model//stop.txt","r");
 		if (stop_file) break;
      
	}
    t+= DT;
    //fprintf(stderr, "# one time step complete ... \n\n");
    
    
  }
  timer.stopTimer();
  fprintf(stderr, "Time taken = %f \n", timer.getElapsedTime());
  
  if (which == GPU) {
  // Clean up RNG
  CURAND_CALL(curandDestroyGenerator(gen));
  }
  
  /// WRITE LOG XML
  
  
	{
	
	FILE * outLOGREPORT;
	string logFileName = "/Users/alex/outtemp/temp/log/";
	logFileName.append("Population_out_logrep.xml");
	outLOGREPORT = fopen(logFileName.c_str(),"w");
	fprintf(outLOGREPORT, "<LogReport>\n");
	fprintf(outLOGREPORT, "	<AnalogLog>\n");
	fprintf(outLOGREPORT, "		<LogFile>Population_out_log.bin</LogFile>\n");
	fprintf(outLOGREPORT, "		<LogFileType>binary</LogFileType>\n");
	fprintf(outLOGREPORT, "		<LogEndTime>%f</LogEndTime>\n",t);
	
		fprintf(outLOGREPORT, "		<LogAll size=\"%d\" headings=\"New Output\" type=\"float\" dims=\"\"/>\n",3);	
	
	fprintf(outLOGREPORT,"		<TimeStep dt=\"%f\"/>\n", DT);
	fprintf(outLOGREPORT, "	</AnalogLog>\n");
	fprintf(outLOGREPORT, "</LogReport>\n");

	fclose(outLOGREPORT);
	}
   
	{
	
	FILE * outLOGREPORT;
	string logFileName = "/Users/alex/outtemp/temp/log/";
	logFileName.append("Population_1_out_logrep.xml");
	outLOGREPORT = fopen(logFileName.c_str(),"w");
	fprintf(outLOGREPORT, "<LogReport>\n");
	fprintf(outLOGREPORT, "	<AnalogLog>\n");
	fprintf(outLOGREPORT, "		<LogFile>Population_1_out_log.bin</LogFile>\n");
	fprintf(outLOGREPORT, "		<LogFileType>binary</LogFileType>\n");
	fprintf(outLOGREPORT, "		<LogEndTime>%f</LogEndTime>\n",t);
	
		fprintf(outLOGREPORT, "		<LogAll size=\"%d\" headings=\"New Output\" type=\"float\" dims=\"\"/>\n",3);	
	
	fprintf(outLOGREPORT,"		<TimeStep dt=\"%f\"/>\n", DT);
	fprintf(outLOGREPORT, "	</AnalogLog>\n");
	fprintf(outLOGREPORT, "</LogReport>\n");

	fclose(outLOGREPORT);
	}
   

  return 0;
}
