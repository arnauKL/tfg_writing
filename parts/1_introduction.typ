// Revision done

#import "../assets/ak_tfg_lib.typ": *

= Introduction

Parkinson's Disease (PD) is the world's fastest-growing neurological disorder
and the second most common neurodegenerative disease globally, affecting an
estimated 10 million people and projected to nearly double in prevalence over
the next two decades as populations age @poeweParkinson2017
@ben-shlomoEpidemiology2024. The disease also imposes an enormous economic
burden: in the United States alone, annual costs, including direct medical
expenditure, caregiving, and lost productivity, reached \$82.2 billion in 2024,
surpassing projections that had not been expected until 2037 @faulkEconomic.

This diagnostic barrier stems directly from the pathophysiology of the disease.
PD is characterized by the progressive degeneration of dopaminergic neurons in
the _substantia nigra pars compacta_ (SNpc), whose axons project to the striatum
through the nigrostriatal pathway to regulate voluntary movement. This
degeneration is slow and irreversible, meaning that by the time the motor
symptoms, such as resting tremor or rigidity, become clinically apparent,
substantial damage has already been done.

Dopamine transporter (DaT) imaging with #super[123]I-ioflupane SPECT,
commercially known as DaTscan, has become a key diagnostic tool in this effort.
By radiolabeling the dopamine transporter protein on presynaptic terminals,
DaTscan provides a direct, functional map of the integrity of the nigrostriatal
pathway in vivo. In PD patients, the image generated visualizes degeneration of
the nigrostriatal pathway (see @datscan_image_compare) @palermoDopamine2021.

Despite its value, DaTscan interpretation in clinical practice relies
predominantly on visual assessment by trained specialists, a process that is
time-consuming and inherently subjective. Inter-observer discrepancies are well
documented, particularly in borderline cases, where early-stage putaminal
thinning produces only subtle deviations form normal patterns
@jakobsonmoAccuracy2015.

The rapid maturation of deep learning offers a compelling path toward addressing
these limitations. Convolutional neural networks (CNNs), trained end-to-end on
large labeled image datasets, can learn to detect subtle spatial patterns in
medical images without relying on manually engineered features, and have
demonstrated expert-level performance across a wide range of diagnostic imaging
tasks @litjensSurvey2017. Applied to DaTscan classification, CNN-based
approaches may provide more consistent and quantitative diagnostic support,
particularly in the early and prodromal stages where visual assessment is least
reliable.

This thesis investigates deep learning-based binary classification of manifest
PD versus healthy controls utilizing DaTscan images. The data are drawn from the
Parkinson's Progression Markers Initiative (PPMI) dataset, which represents one
of the largest cohorts available @marekParkinson2011.
