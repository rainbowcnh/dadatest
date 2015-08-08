function First(DirectName)
{
var dir = new QDir(DirectName);
var list = dir.entryList(["*00001.dcm"]);
BrainVoyagerQX.PrintToLog(list[0]);
return list[0];
}

  var root = "D:/noiseMPL_2/wtt/day1/";
  var TotalRuns =10;
  
  var fileFolder = new Array(TotalRuns);
fileFolder[0]="wedge1/";  
fileFolder[1]="wedge2/";
  fileFolder[2]="MT/";
  fileFolder[3]="loc1/";
  fileFolder[4]="loc2/";
  vmrName = "E:/noiseMPL/fMRI/dn/roi/struc/dn_ISO_SAG_ACPC.vmr"; 
  tranFolder = root + "struc/"; 
     
  
   var filename = new Array(TotalRuns);
  
   for (j=0;j<TotalRuns;j++)
  {
  filename[j] = First(root+fileFolder[j]);
}              
  var fmriname = new Array(TotalRuns);
fmriname[0] = "wedge1";  
fmriname[1] = "wedge2";
  fmriname[2] = "MT1";
  fmriname[3]="loc1";
  fmriname[4]="loc2";
  var numTRs = [156,156,102,180, 180];
  var skipTRs = [6, 6,6,6,6];
  var protocol = new Array(TotalRuns);
  var target = "wedge1/wedge1_3DMCT_LTR_THP0.0150Hz.fmr";
  var fileType = "DICOM";

  var numSlices = 42; 
  var sliceThick = 3; 
  var gapThick = 0; 
  var createAMR= false; 
  var byteSwap = false; 
  var bytePerPixel =2; 
  var nrVolsInImg = 1; 
  var SizeX=64; 
  var SizeY=64; 
  var tr = 2000; 
  var motionCorr = 1; 
  var temporalHighPass = 0.015; //3;                //for temporal smoothing, you can use a 
  var tempHighPassUnit = "Hz"; 

  for (i=0;i<TotalRuns;i++) 
  {  //loop over number of runs.      
 
  inFile = root + fileFolder[i] + filename[i];  
      outFolder = root + fileFolder[i];  
      fmrFileName = root + fileFolder[i] + fmriname[i] + ".fmr";  
	  var docFMR = BrainVoyagerQX.CreateProjectFMR(fileType, inFile, numTRs[i], skipTRs[i], createAMR, numSlices, fmriname[i], byteSwap, SizeX, SizeY, bytePerPixel, outFolder);
	  docFMR.SaveAs(fmrFileName);  
      docFMR.SliceThickness = sliceThick;  
      docFMR.GapThickness = gapThick;  
      docFMR.TR = tr;  
      docFMR.Save();  
      docFMR.Close();  
          
      if (motionCorr)  
      {  
        docFMR = BrainVoyagerQX.OpenDocument(fmrFileName);  
docFMR.CorrectMotionTargetVolumeInOtherRunEx(root + target,1,1,false,100,0,1);

      newFMR = docFMR.FileNameOfPreprocessdFMR;  
     docFMR.Remove();   
      }  
      if (temporalHighPass)  
      {  
        docFMR = BrainVoyagerQX.OpenDocument(newFMR);  
        docFMR.TemporalHighPassFilter(temporalHighPass, tempHighPassUnit);  
        newFMR = docFMR.FileNameOfPreprocessdFMR;  
        docFMR.Remove();  
      }  

 docVMR = BrainVoyagerQX.OpenDocument(vmrName); 
      fmrName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.01Hz.fmr";
   if (i==0)  {
fmrName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.0150Hz.fmr";  
}  
      vtcName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.01Hz.vtc"; 
      docVMR.CreateVTCInACPCSpace(fmrName, tranFolder+"wedge1_3DMCT_LTR_THP0.0150Hz-TO-yf_ISO_SAG_IIHC_IIHC_IA.trf", tranFolder+"wedge1_3DMCT_LTR_THP0.0150Hz-TO-yf_ISO_SAG_IIHC_IIHC_FA.trf", tranFolder+"yf_ISO_SAG_IIHC_IIHC_ACPC.trf", vtcName,1,3,1,100); 
   docVMR.Close();    
}  
