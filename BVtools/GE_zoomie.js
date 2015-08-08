function First(DirectName)
{
var dir = new QDir(DirectName);
var list = dir.entryList(["*0001.dcm"]);
BrainVoyagerQX.PrintToLog(list[0]);
return list[0];
}

  var root = "D:/TMSlearningfMRI/zq/post/";
  var TotalRuns =11;
  
  var fileFolder = new Array(TotalRuns);

  fileFolder[0]="m1/";
  fileFolder[1]="m2/";
  fileFolder[2]="m3/";
  fileFolder[3]="m4/";
fileFolder[4]="m5/";
fileFolder[5]="m6/";
fileFolder[6]="m7/";
fileFolder[7]="m8/";
fileFolder[8]="m9/";
fileFolder[9]="m10/";
fileFolder[10]="m11/";
fileFolder[11]="wed1/";
fileFolder[12]="wed2/";
  vmrName = "D:/TMSlearningfMRI/lq/pre/struc/lq_ISO_ACPC.vmr"; 
  docVMR = BrainVoyagerQX.OpenDocument(vmrName); 
  tranFolder = root + "struc/"; 
   var filename = new Array(TotalRuns);


  docVMR.UseBoundingBoxForVTCCreation=true;
  docVMR.TargetVTCBoundingBoxXStart = 52;
  docVMR.TargetVTCBoundingBoxXEnd = 211;
  docVMR.TargetVTCBoundingBoxYStart = 140;
 docVMR.TargetVTCBoundingBoxYEnd = 244;
 docVMR.TargetVTCBoundingBoxZStart = 80;
docVMR.TargetVTCBoundingBoxZEnd = 160;





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
fmriname[10] = "run11";
fmriname[11] = "wed1";
fmriname[12] = "wed2";

  var numTRs = [ 102, 102, 102, 102, 102, 102, 102, 102,102, 102, 102, 156, 156];
  var skipTRs = [ 0,0,0,0,0,0,0,0,0,0,0,0,0, 0, 0, 0, 0, 0];
  var protocol = new Array(TotalRuns);
  var target = "wed1/wed1.fmr";
  var fileType = "DICOM";

    var numSlices = 28;
  var sliceThick = 2;
  var gapThick = 0;
  var createAMR= false;
  var byteSwap = false;
  var mosaicSizeX = 456;
  var mosaicSizeY = 216;
  var bytePerPixel =2;
  var nrVolsInImg = 1;
  var sizeX=76;
  var sizeY=36;
  var tr = 2000;
  var temporalHighPass = 0.015; //3;                //for temporal smoothing, you can use a 
  var tempHighPassUnit = "Hz"; 
  var motionCorr = 1;

  for (i=0;i<TotalRuns;i++) 
  {  //loop over number of runs.      
/*

      inFile = root + fileFolder[i] + filename[i];  
      outFolder = root + fileFolder[i];  
      fmrFileName = root + fileFolder[i] + fmriname[i] + ".fmr";  
	   docFMR=BrainVoyagerQX.CreateProjectMosaicFMR(fileType, inFile, numTRs[i], skipTRs[i], createAMR, numSlices, fmriname[i], byteSwap, mosaicSizeX, mosaicSizeY, bytePerPixel, outFolder, nrVolsInImg, sizeX, sizeY);
	  docFMR.SaveAs(fmrFileName);  

     docFMR = BrainVoyagerQX.OpenDocument(fmrFileName);
    docFMR.CorrectSliceTiming( 1, 2 );
      newFMR = docFMR.FileNameOfPreprocessdFMR;   

      if (motionCorr)  
      {  
        docFMR = BrainVoyagerQX.OpenDocument(fmrFileName);  
        docFMR.CorrectMotionTargetVolumeInOtherRunEx(root + target,1,1,false,100,0,1);

      newFMR = docFMR.FileNameOfPreprocessdFMR;   
      }  
      if (temporalHighPass)  
      {  
        docFMR = BrainVoyagerQX.OpenDocument(newFMR);  
        docFMR.TemporalHighPassFilter(temporalHighPass, tempHighPassUnit);  
        newFMR = docFMR.FileNameOfPreprocessdFMR;  
        docFMR.Remove();  
      } 
*/ 
      fmrName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.01Hz.fmr";  
 //   if (i==0) fmrName=root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.0150Hz.fmr";
      vtcName = root + fileFolder[i] + fmriname[i] + "_3DMCT_LTR_THP0.01Hz.vtc"; 
      docVMR.CreateVTCInACPCSpace(fmrName, tranFolder+"run1_3DMCT_LTR_THP0.01Hz-TO-zq_post_ISO_IIHC_IA.trf", tranFolder+"run1_3DMCT_LTR_THP0.01Hz-TO-zq_post_ISO_IIHC_FA.trf", tranFolder+"zq_post_ISO_IIHC-TO-zq_ISO_IIHC_ACPC.trf", vtcName,1,2,1,100);         
  //docVMR.CreateVTCInTALSpace(fmrName, tranFolder+"wed1_3DMCT_LTR_THPFFT0.0150Hz-TO-zfj_ISO_IA.trf", tranFolder+"wed1_3DMCT_LTR_THPFFT0.0150Hz-TO-zfj_ISO_FA.trf", tranFolder+"zfj_ISO_ACPC.trf", tF+"zfj_ISO_ACPC.tal", vtcName,1,2,1,50);         
  
}  
 