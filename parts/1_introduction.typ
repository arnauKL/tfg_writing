#import "../assets/ak_tfg_lib.typ": *

// Requirements (from guia_geb_tfg.pdf)
// The introduction is used to situate 'el marc', the context (?) of this thesis. This means:
// - Establishing the reasons that justify the development of the thesis and what I expect to obtain.
// - It must include the motivation within the areas (Health Sciences, Engineering) that it is developed.
// - It can include a description of the environment within which the thesis is developed, and/or an explanation of the starting point of the thesis.
// - I must specify what  the contribution of the thesis is in relation to the

// this section should be around 1--2 pages max.
// Agatha does 1, Reglà: 1, and Lisa, 1.8-ish

// Mine is about .5
// Tbh it's quite short but I like it, it checks all the requirements

// - Establishing the reasons that justify the development of the thesis and what I expect to obtain.
// DaTscan not being very reliable on early-stage patients
// - It must include the motivation within the areas (Health Sciences, Engineering) that it is developed.
//
// - It can include a description of the environment within which the thesis is developed, and/or an explanation of the starting point of the thesis.
// - I must specify what  the contribution of the thesis is in relation to the


= Introduction

// Old intro:
//
//Parkinson’s Disease (PD) is the second most common neurodegenerative disorder
//globally, characterized by the progressive loss of dopaminergic neurons in the
//substantia nigra pars compacta. While clinical diagnosis relies on motor
//symptoms (tremor, bradykinesia, and rigidity), these often appear only after a
//significant percentage of dopaminergic neurons have already been lost.
//
//Dopamine transporter imaging (DaTscan) has emerged as a tool for visualizing
//this depletion. However, in clinical practice, the interpretation of these scans
//is often qualitative and prone to inter-observer variability, especially in
//early or prodromal stages where the "comma-shaped" striatum only shows subtle
//thinning. This thesis explores the transition from subjective radiological
//assessment to objective, Deep Learning-based quantification, aiming to leverage
//the Parkinson’s Progression Markers Initiative (PPMI) dataset to improve
//diagnostic sensitivity through multimodal data fusion.


Parkinson's Disease (PD) is the world's fastest growing neurological disorder
and the second most common neurodegenerative disease globally, affecting an
estimated 10 million people and projected to nearly double in prevalence
over the next two decades as populations age @poeweParkinson2017
@ben-shlomoEpidemiology2024.
Beyond its human toll, the disease imposes an enormous economic burden: in the
United States alone, annual costs including direct medical expenditure,
caregiving and lost productivity reached \$82.2 billion in 2024, surpassing
projections that had not been expected until 2037 @faulkEconomic.
In Europe, where an ageing demographic accelerates incidence, the situation is
similar. Effective management of #smol[pd] depends critically on early and
accurate diagnosis, yet this remains one of the most persistent challenges in
clinical neurology.


This difficulty is rooted in the biology of the disease. // I don't like this
sentence. PD is characterized by the progressive degeneration of dopaminergic
neurons in the _substantia nigra pars compacta_ (SNpc), whose axons project to
the striatum through the nigrostriatal pathway to regulate voluntary movement.
This degeneration is slow and irreversible, meaning that by the time the motor
symptoms such as resting tremor or rigidity become clinically apparent,
substantial damage has already been done.


// The intro is on the importance of diagnosing prodromal patients even though I
// have changed a bit
A presymptomatic window of years exists during which neurodegeneration is
underway but patients are unaware and untreated. Identifying patients in this
window is a central objective of current PD research, as any future
neuroprotective therapy is likely to be most effective before irreversible
damage is established.

Dopamine transporter (DaT) imaging with #super[123]I-ioflupane
#smol[SPECT],
commercially known as DaTscan, has become a key diagnostic tool in this effort.
By radiolabeling the dopamine transporter protein on presynaptic terminals,
DaTscan provides a direct, functional map of the integreity of the nigrostriatal
pathway in vivo.
In healthy individuals, the resulting image shows a characteristic bilateral
"comma" pattern of high tracer uptake #redt[mention image?] in the caudate and
putamen; in PD, progressive putaminal denervation erodes this pattern, producing
an asymmetric reduction colloquially described as a "period" or "dot"
@palermoDopamine2021.

The technique was approved by the European Medicines Agency
(#smol[EMA]) in 2000 and by the
U.S. Food and Drug Administration (#smol[FDA]) in 2011, and has since become the only approved imaging biomarker for
suspected parkinsonian syndromes in routine clinical practice
@booijAppropriate2013.

Despite its value, DaTscan interpretation in clinical practice relies
predomininantly on visual assesment by trained specialists, a process that is
time-consuming and inherently subjective. Inter-observer discrepancies are well
documented, particularly in borderline cases, where early-stage putaminal
thinning produces only subtle deviations form normal patterns
@jakobsonmoAccuracy2015.

Semi-quantitative tools such as the Striatal Binding Ratio (#smol[SBR]), which measures
the reatio of specific striatal uptake to non-specifi background uptake,
provide a more objective scalar summary of tracer binding, but they compress
the rich spatial information of the scan into a small number of regional
averages, potentially discardig diagnostically relevant texture and assymmetry
patterns that a more expressive model could exploit
@jakobsonmoAccuracy2015 @tinazSemiquantitative2018.

The rapid maturation of deep learning offers a compelling path toward addressing these
limitations. Convolutional neural networks (#smol[CNN]s), trained end-to-end on large labeled
image datasets, can learn to detect subtle spatial patterns in medical images without
relying on manually engineered features, and have demonstrated expert-level performance
across a wide range of diagnostic imaging tasks @litjensSurvey2017. Applied to DaTscan
classification, #smol[CNN]-based approaches hold the potential to provide consistent
and quantitative diagnostic support, particularly in the early and prodromal
stages where visual assessment is least reliable.

// This might need to change bcs of the prodromal change
This thesis investigates deep learning-based classification of PD versus healthy controls
from DaTscan #smol[SPECT] images drawn from the Parkinson's Progression Markers Initiative
(#smol[PPMI]) dataset, one of the largest and most carefully standardized public PD cohorts
available @marekParkinson2011.

// This gives 1.25 pages, leaving .75 empty
