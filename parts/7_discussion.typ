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

== classical ML results prior to multimodal

SVM with non-linear kernel seems to do best.

== CNNs

They were able to learn to predict with very high precisions. The issue was once
the Grad-CAM showed that they were pretty much just looking at random noise or
features on the edges or background of the images instead of learning about the
DaT differences in different patients and its relationship with Parkinson's.

=== Transfer Learning vs tailored networks

ImageNet performed best.

MedNet, which I had high hopes for since it's seen a lot of medical data, which
I lacked (the dataset I worked with during the thesis had a relatively low
number of 3d DaTscans). Maybe that was the issue, too little images for it to
effectively transfer its knowledge.

Since the ImageNet has seen all sorts of images it is possible that the fact
that it was the best performant one (while retaining the attention where it
mattered, see #redt[figure of 2.5D Grad-CAM].

On the mednet:
Models leveraging the foundational med3d weights demonstrated the poorest
overall performance and widest metric instability. The baseline med3d
(registered) model collapsed to a median F1-score of 0.851. Even when freezing
the encoder layers (`medencoder`) to preserve pre-trained features, the model
failed to match the custom networks, showing wide, volatile performance boxes
across cross-validation splits.

The underperformance of MedNet architectures highlights a classic domain-mismatch
challenge in medical deep learning. The weights for med3d were pre-trained on
the Medical Segmentation Decathlon, a dataset dominated by high-resolution,
structural macro-anatomy from CT and MRI scans (e.g., organ boundaries, tumors).

When these heavy filters are transferred to a highly specialized, functional
nuclear medicine modality like DaTscan, the pre-trained features fail to
generalize. The over-parameterization of deep ResNet-3D blocks overfits to
non-clinical noise within small-sample cohorts, whereas custom architectures
like 3d_crop_deeper maintain a compact parameter footprint that enforces strict
regularization.

== Raw vs registered data:

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

If we refer to the left-most registered slice in @fig-compareraw-reg, it seems
like there could be some artifact of registration, which manifests in this kind
of _streaks_ artifact. This could be both introducing false signal and smearing
real information away.

// the registration process was made by adrià (my tutor) himself so maybe not dis too much
// on the techniques used

This could be beneficial if studied in a more in-depth study. If models were
found to perform better on images that require less manual work to prepare then
that could lead to cost and compute savings.

== GradCAM putamen activation:

connect to the SHAP finding that Mean_SBR and PCR dominate --- both methods
point to the same anatomical signal.

== classical multimodal: UPDRS jump 

motor severity is almost perfectly correlated with diagnosis label --- discuss
whether this is a useful clinical addition or circularity.

== Multimodal CNNs

The flatness in figures shown in the prev section #redt[pdt posar-les] is great.
It demonstrates extreme architectural stability. It proves that the model's
performance isn't fluctuating wildly depending on how the data is split; rather,
it is performing with identical, predictable accuracy across the entire cohort.

Now, this is only meaningful on the nets where the DaTscan shows real attention
rather than finding cheats

=== Different fusion modalities

Also comment on the late-stage fusion performing better than feature-fusion

Why could this be?

=== ALL being outscored by motor-only in mutlimodal CNN fusion

the fact that ALL underperforms motor-only is a meaningful finding, it suggests
the fusion head does not successfully learn to discount the noisier features
when the cohort is small. 

== On SWEDDs inference

Dopamine transporter integrity is normal in SWEDD by definition, so a model
trained on DaTscan signal correctly separates them.

=== The 10.5% SWEDD classified as PD:

Possible genuine DAT deficit in a subset, misdiagnosed SWEDD, or model
uncertainty at the boundary.

== Contributions to the Unitaed Nations' SDGs

This thesis primarily contributes to *SDG 3*: Good Health and Well-being, 
which seeks to ensure healthy lives and promote well-being for people of all ages. By 
advancing research into ..., this work aligns with efforts to improve 
diagnostic accuracy and facilitate timely intervention strategies. 


#figure(
  box(width: 50%,grid(columns: 2,
  column-gutter: 1em,
    image("../assets/figures/ods/E_WEB_03.png"),
    image("../assets/figures/ods/E_WEB_09.png")
  )),
  caption: [SDGs this thesis is contributing towards. Obtained from @martinCommunications.]
)
