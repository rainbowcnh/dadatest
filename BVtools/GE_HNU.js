function First(DirectName)
{
var dir = new QDir(DirectName);
var list = dir.entryList(["*0001.dcm"]);
BrainVoyagerQX.PrintToLog(list[0]);
return list[0];
}

  var root = "D:/noiseMPL_2/wtt/day6/";
  var TotalRuns =10;
  var target = "run1/run1.fmr";
  var fileFolder = new Array(TotalRuns);
  fileFolder[0]="run1/";
  fileFolder[1]="run2/";
  fileFolder[2]="run3/";
  fileFolder[3]="run4/";
fileFolder[4]="run5/";
fileFolder[5]="run6/";
fileFolder[6]="run7/";
fileFolder[7]="run8/";
fileFolder[8]="run9/";
fileFolder[9]="run10/";
fileFolder[10]="run11/";
fileFolder[11]="run12/";
fileFolder[12]="run13/";
fileFolder[13]="run14/";
fileFolder[14]="run15/";
fileFolder[15]="run16/";
  vmrName = "E:/noiseMPL/fMRI/zx/roi/struc/zx_ISO_SAG_IIHC_ACPC.vmr"; 
  docVMR = BrainVoyagerQX.OpenDocument(vmrName); 
  tranFolder = root + "struc/"; 
    docVMR.UseBoundingBoxForVTCCreation=true;


// all noise new

//docVMR.TargetVTCBoundingBoxXStart = 35;
//docVMR.TargetVTCBoundingBoxXEnd = 220;
//docVMR.TargetVTCBoundingBoxYStart = 45;
//docVMR.TargetVTCBoundingBoxYEnd = 250;
//docVMR.TargetVTCBoundingBoxZStart =35;
//docVMR.TargetVTCBoundingBoxZEnd = 185;

docVMR.TargetVTCBoundingBoxXStart = 46;
docVMR.TargetVTCBoundingBoxXEnd = 208;
docVMR.TargetVTCBoundingBoxYStart = 56;
docVMR.TargetVTCBoundingBoxYEnd = 233;
docVMR.TargetVTCBoundingBoxZStart =50;
docVMR.TargetVTCBoundingBoxZEnd = 191;
   var filename = new Array(TotalRuns);
  
   for (j=0;j<TotalRuns;j++)
  {
  filename[j] = First(root+fileFolder[j]);
}              
  var fmriname = new Array(TotalRuns);
  fmriname[0] = "run1";
  fmriname[1] = "run2";
  fmriname[2]="run3";
  fmriname[3]="run4";
fmriname[4]="run5";
fmriname[5]="run6";
fmriname[6]="run7";
fmriname[7]="run8";
fmriname[8]="run9";
fmriname[9]="run10";
fmriname[10]="run11";
fmriname[11]="run12";
fmriname[12]="run13";
fmriname[13]="run14";
fmriname[14]="run15";
fmriname[15]="run16";
  var numTRs = [126, 126, 126, 126, 126, 126,126, 126, 126, 126, 126, 126, 126, 126, 126, 126, 126];
  var skipTRs = [ 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6];
  var protocol = new Array(TotalRuns);

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

 // if (i>0)
//{
//   inFile = root + fileFolder[i] + filename[i];  
//      outFolder = root + fileFolder[i];  
 //     fmrFileName = root + fileFolder[i] + fmriname[i] + ".fmr";  
//	  var docFMR = BrainVoyagerQX.CreateProjectFMR(fileType, inFile, numTRs[i], skipTRs[i], createAMR, numSlices, fmriname[i], byteSwap, SizeX, SizeY, bytePerPixel, outFolder);
//	  docFMR.SaveAs(fmrFileName);  
 //   docFMR.SliceThickness = sliceThick;  
 //   docFMR.GapThickness = gapThick;  
 //   docFMR.TR = tr;  
//      docFMR.Save();  
//      docFMR.Close();  
          
 //     if (motionCorr)  
 //    {  
//        docFMR = BrainVoyagerQX.OpenDocument(fmrFileName);  
//docFMR.CorrectMotionTargetVolumeInOtherRunEx(root + target,1,1,false,100,0,1);

//      newFMR = docFMR.FileNameOfPreprocessdFMR;   
//      }  
//      if (temporalHighPass)  
//      {  
//        docFMR = BrainVoyagerQX.OpenDocument(newFMR);  
 //       docFMR.TemporalHighPassFilter(temporalHighPass, tempHighPassUnit);  
  //      newFMR = docFMR.FileNameOfPreprocessdFMR;  
  //      docFMR.Remove();  
//      }  
//}


      fmrName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.01Hz.fmr";  
   if (i==0)  {
fmrName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.0150Hz.fmr";  
}
      vtcName = root + fileFolder[i] + fmriname[i] + ".vtc"; 
     docVMR.CreateVTCInACPCSpace(fmrName, tranFolder+"run1_3DMCT_LTR_THP0.0150Hz-TO-day6_ISO_SAG_IIHC_IA.trf", tranFolder+"run1_3DMCT_LTR_THP0.0150Hz-TO-day6_ISO_SAG_IIHC_FA.trf", tranFolder+"day6_ISO_SAG-TO-wtt_ISO_SAG_ACPC.trf",vtcName,1,3,1,100);       
        
}  
 