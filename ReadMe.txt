Proto-Object Based Visual Saliency Model with Disparity Channels(MATLAB code)

Takeshi Uejima, uejima.takeshi@gmail.com / tuejima1@jhu.edu
Johns Hopkins University

This model is based on Russell et al. model but modified to incorporate disparity channels.
The detail is written in T. Uejima, E. Mancinelli, E. Niebur, and R. Etienne-Cummings. "The influence of stereopsis on visual saliency in a proto-object based model of selective attention." 

===============================================================================
Main Programs

- Calculate Disparity Confidence Map
  runSoftmax_Shift_ND_Ori1_SepLv(filenameR,filenameL,dPercent,LR,octave,aspect,shift)
  runSoftmax_Shift_ND_Ori1Col_SepLv(filenameR,filenameL,dPercent,LR,octave,aspect,shift)
  runSoftmax_Shift_ND_Ori4_SepLv(filenameR,filenameL,dPercent,LR,octave,aspect,shift)
  runSoftmax_Shift_ND_Ori4Col_SepLv(filenameR,filenameL,dPercent,LR,octave,aspect,shift)
These codes calculate the disparity confidence map and save it to a .mat file.
"Ori1" uses only the vertical Gabor filter and intensity information, called Model A in the paper.
"Ori4" uses four types of the Gabor filters and intensity information, called Model B in the paper.
"Ori1Col" and "Ori4Col" use intensity and color informaiton called Model C and D in the paper, respectively.
  filenameR: Right input image filename
  filenameL: Left input image filename
  dPercent: The range of the disparity in percent of input image width
  LR: 'L' or 'R' to direct which side is used for fixationy map
  octave: 'full' or 'half' to direct how to scale input image when calculating disarity. The paper used full octave.
  aspect: gamma of the Gabor filter. 5 is used in the paper.
  shift: The Gaze-3D dataset is shifted to calculate disparity. For the NCTU-3D dataset, 0 should be used.

- Calculate Saliency Map from the Disparity Confidence Map
  runProtoSalDisparity_SoftMaxPanum(filename,filenameOut,panumPix)
This code calculates a salilency map from the disparity confidence map.
The output map is computed from only the depth informaitno and needed to be summed with 2D saliency map which can be computed by the proto-object based saliency model with texture channel.
  filename: Input disparity confidence map filename.
  filenameOut: Output filename.
  panumPix: Direct Panum's fusional area in pixels. It is used to determine the Zero dispariy range. 

===============================================================================
How to Use

(1) Add the folder of "ProtoObjectSaliencyDisparityPaper" and its subfolders to your MATLAB path.
(2) Run "runSoftmax_Shift_ND_Ori1_SepLv(filenameR,filenameL,dPercent,LR,octave,aspect,shift)"
    The disparity confidence map is save as .mat file.
(3) Run "runProtoSalDisparity_SoftMaxPanum(filename,filenameOut,panumPix)"   
    The saliency map is saved as .mat file. This map is computed from only the disparity information and should be summed with 2D saliency map.

===============================================================================
References

1. Uejima, T., Niebur, E., and Etienne-Cummings, R. (2020). Proto-Object Based Saliency Model With Texture Detection Channel. Front. Comput. Neurosci. 14, 84.
2. Russell, A. F., Mihalaş, S., von der Heydt, R., Niebur, E., and Etienne-Cummings, R. (2014). A model of proto-object based saliency. Vision Res. 94, 1–15.