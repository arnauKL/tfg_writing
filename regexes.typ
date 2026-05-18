#import "ak_tfg_lib.typ": *

// regex to catch some acronyms
#show regex("\b2D\b"): smol[2d]
#show regex("\b2.5D\b"): smol[2.5d]
#show regex("\b3D\b"): smol[3d]
#show regex("\bPD\b"): smol[pd]
#show regex("\bCNN\b"): smol[cnn]
#show regex("\bCNNs\b"): [#smol[cnn]s]
#show regex("\bML\b"): smol[ml]
#show regex("\bPPMI\b"): smol[ppmi]
#show regex("\bSPECT\b"): smol[spect]
#show regex("\bDAT\b"): smol[dat]
