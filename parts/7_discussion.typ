#import "../assets/ak_tfg_lib.typ": *

/*
En aquest capítol s’explicaran els resultats obtinguts respecte als objectius del projecte 
(beneficis).  
 
Caldrà incloure dues seccions:  

- Limitacions: es descriuran les limitacions dels resultats obtinguts, com ara per 
exemple, la generalitat dels resultats respecte a l’abast de l’experimentació 
(i.e. s’han fet proves amb persones sanes, i no es poden extrapolar els 
resultats a tota la població).   
 
- Contribucions als objectius de desenvolupament sostenible (ODS) de les 
Nacions Unides: identificació d’almenys un ODS i com el TFG està contribuint-
hi.

Contibutions to SDG
#link("https://www.un.org/sustainabledevelopment/", "SDG")
3 and 9
*/

= Discussion

== UPDRS jump in classical multimodal:

motor severity is almost perfectly correlated with diagnosis label --- discuss
whether this is a useful clinical addition or circularity.

== Transfer Learning vs tailored networks

The Failure of Transfer Learning Baselines:

Models leveraging the foundational
med3d weights demonstrated the poorest overall performance and widest metric
instability. The baseline med3d (registered) model collapsed to a median
F1-score of 0.851. Even when freezing the encoder layers (medencoder) to
preserve pre-trained features, the model failed to match the custom networks,
showing wide, volatile performance boxes across cross-validation splits.

The underperformance of med3d architectures highlights a classic domain-mismatch
challenge in medical deep learning. The weights for med3d were pre-trained on
the Medical Segmentation Decathlon, a dataset dominated by high-resolution,
structural macro-anatomy from CT and MRI scans (e.g., organ boundaries, tumors).

When these heavy filters are transferred to a highly specialized, functional
nuclear medicine modality like DaTscan, the pre-trained features fail to
generalize. The over-parameterization of deep ResNet-3D blocks overfits to
non-clinical noise within small-sample cohorts, whereas custom architectures
like 3d_crop_deeper maintain a compact parameter footprint that enforces strict
regularization.

== Raw vs registered:

In traditional neuroimaging, spatial registration is essential to ensure
voxel-wise alignment across heterogeneous subjects for statistical parametric
mapping. However, for deep convolutional neural networks, the interpolation,
spatial warping, and intensity smoothing inherent to non-rigid registration
pipelines introduce distinct morphological degradations.

DaTscan images are highly functional rather than purely structural; the primary
diagnostic signal is a sharp, localized intensity gradient within the striatum
relative to a dark background. Spatial warping smooths these high-frequency
contrast boundaries and dilutes localized voxel densities. Because the networks
rely precisely on these raw, pixel-level intensity gradients to quantify
dopaminergic transporter uptake, the unaltered, raw bounding-box extractions
preserve a cleaner, unadulterated optimization landscape for gradient descent.

== GradCAM putamen activation:

connect to the SHAP finding that Mean_SBR and PCR dominate --- both methods
point to the same anatomical signal.

== Multimodal CNNs

The flatness in figures shown in the prev section #redt[pdt posar-les] is great.
It demonstrates extreme architectural stability. It proves that the model's
performance isn't fluctuating wildly depending on how the data is split; rather,
it is performing with identical, predictable accuracy across the entire cohort.

Also comment on the late-stage fusion performing better than feature-fusion

=== ALL being outscored by motor-only in mutlimodal CNN fusion

the fact that ALL underperforms motor-only is a meaningful finding — it suggests
the fusion head does not successfully learn to discount the noisier features
when the cohort is small. This is worth one paragraph in Section 7. Also, since
you changed from 2-fold to 5-fold, double-check the introductory paragraph of
Section 6.4 (the one mentioning the CV scheme) and update that too — in the
version I wrote yesterday it still says 2-fold.

== Why SWEDD clusters with HC:

dopamine transporter integrity is normal in SWEDD by definition, so a model
trained on DaTscan signal correctly separates them.

== The 10.5% SWEDD classified as PD:

possible genuine DAT deficit in a subset, misdiagnosed SWEDD, or model
uncertainty at the boundary.

== Contributions to the Unitaed Nations' SDGs

This thesis primarily contributes to *SDG 3*: Good Health and Well-being, 
which seeks to ensure healthy lives and promote well-being for people of all ages. By 
advancing research into ..., this work aligns with efforts to improve 
diagnostic accuracy and facilitate timely intervention strategies. 
