#import "../assets/ak_tfg_lib.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let dims(it) = {
  [ #it $times$ #it $times$ #it ]
}
#show regex("\bPPMI\b"): smol[PPMI]
#show regex("\bSWEDD\b"): smol[SWEDD]
#show regex("\bBIDS\b"): smol[BIDS]

= Materials and Methods

== Dataset and Cohort

All data used in this study were obtained from the Parkinson's Progression
Markers Initiative (PPMI) @marekParkinson2011, a large-scale, longitudinal,
multicenter observational study launched in 2010 by the Michael J. Fox
Foundation. PPMI collects multimodal data (neuroimaging, biospecimens, and
clinical assessments) from participants across more than 30 international sites
under a standardized acquisition protocol. The dataset is openly accessible to
qualified researchers at #link("www.ppmi-info.org").

This work makes use of the three-dimensional DaTscan SPECT volumes and a curated
tabular file containing semi-quantitative image-derived features alongside
clinical assessments collected at each visit. These two data types are available
within PPMI.

=== Study Population and Cohort Selection

/* draft:
// ill comment on the available data, how many of each, ages, etc.
// Maybe also describe image acquisition

As I mentioned, only the *sesBL* (baseline session) session was used (BIDS, see
@bids for more) to avoid repeating the same patients in different timelines,
introducing accidental biases.

This left me with a dataset of a total of ... nanana

This imbalance was present in the tabular data too. I tried fixing it both
automatically with weighted samplers and manually (dropping enough PD so that
there are the same PD as HC), which is what ended up working best on all cases.

When it came to the tabular data (not DaTscan images), thouhg, a total of "PD: 3066, HC: 296" were
there.
*/

Only subjects with a DaTscan image available and a confirmed diagnosis of either
Parkinson's disease (PD) or healthy control (HC) were used. Subjects with
Parkinson's symptoms at prodromal stages  were excluded from the analysis to
avoid introducing ambiguous labels into the training set. SWEDD (Scans Without
Evidence of Dopaminergic Deficit) patients were excluded from training as well
but retained for later inference evaluation.

To limit each subject to a single observation and avoid temporal data leakage,
only the baseline session (`ses-BL` in BIDS notation, described in @sec-bids) was
retained for each participant. As seen in @tab-dataset, the raw (unregistered)
image set contained 158 HC and 618 PD subjects; the registered image set
contained 124 HC and 561 PD subjects after applying the same filter. The
reduction in sample size associated with registration should be considered when
interpreting the comparative performance of raw and registered datasets in later
experiments.

#figure(
  tablef(
    columns: (auto, 3em, 3em),
    //columns: (auto, auto, auto),
    align: right,
    [Dataset], [HC], [PD],
    [rawdata], [158], [618],
    [registered], [124], [561],
    [tabular], [296], [3066],
  ),
  caption: [Distribution of patients in selected datasets.]
)<tab-dataset>

The class imbalance inherent in the PPMI cohort, where PD subjects substantially
outnumber HC, was addressed by downsampling the majority class (PD) to match
the size of the minority class (HC) prior to training, yielding balanced
two-class datasets. This decision was preferred over weighted sampling after
empirical comparison, as it produced more stable training results and
performance across architectures.

For the tabular experiments (classical ML baseline, tabular row in @tab-dataset), the same diagnostic filter
was applied to the curated spreadsheet. After removing rows with missing values
in the feature columns of interest, the tabular cohort comprised 3066 PD and
296 HC subjects. The substantially larger tabular counts relative to the
image cohort reflect the fact that #smol[PPMI] collects clinical assessments at
multiple visits and from participants who did not undergo imaging at baseline.

// maybe this last sentence should go


=== Legal and Ethical Considerations

// This section is a requirement

Access to PPMI data was requested and granted through the official PPMI data use
agreement, which restricts use to research purposes and prohibits
re-identification of participants. The PPMI study itself received ethical
approval from the institutional review boards of all participating sites, and
all participants provided written informed consent prior to enrolment. Further
details are provided in @app_ethics.

Data handling in this project complied with the General Data Protection
Regulation (GDPR) and Organic Law 3/2018 on the Protection of Personal Data and
Guarantee of Digital Rights. Images and metadata were processed exclusively for
the purposes of this thesis, stored on the password-protected servers of the
VICOROB research group, and were not transferred to unauthorized systems or
shared with third parties.

== Data Preprocessing

=== BIDS Data Organisation <sec-bids>

/*
As mentioned, the data I'll be using from the PPMI dataset consists of 3d
volumetric DaTscan images and, later on, numeric indicators.

In my case, the PPMI dataset was already loaded into the server where I ran my
code, the structure being:

```
paste tree output when the server is up again
The niigz files and alladat
```

// BIDS: This is mentioned in Reglà's TFG: the protocol this data uses is the BIDS
// standard (Brain Imaging Data Structure). He also included a table with info
// on what each element of the standard represents, I might add that too.
*/

The PPMI neuroimaging data are organized according to the Brain Imaging Data
Structure (BIDS) standard @gorgolewskiBrain2016 /* the paper of the creators of bids */, a community convention for structuring neuroimaging datasets that
ensures reproducibility and facilitates automated processing. Under BIDS, each
subject is identified by a unique prefix (`sub-XXXX`), sessions by `ses-LABEL`,
and files follow a standardized naming scheme encoding the subject, session, and
imaging modality. @tab-bids summarizes the key BIDS elements relevant to this
work and @BIDS_ppmi shows this structure in the server itself.


#figure(
  text(0.9em,
  tablef(
    columns: (auto, auto, auto),
    align: (left, left, left),
    [BIDS element], [Description], [Example],

    [`sub-ID`], [Unique subject identifier], [`sub-3001`],
    [`ses-LABEL`], [Session label (timepoint)], [`ses-BL`],
    [Modality folder], [Imaging modality], [`pet/`],
    [`.nii.gz`], [Compressed NIfTI image volume], [`sub-3001_ses-BL_pet.nii.gz`],
    [`.json`], [Acquisition metadata sidecar], [`sub-3001_ses-BL_pet.json`],
    [`participants.tsv`/`.json`], [Subject-level metadata table], [age, sex, diagnosis],
  )),
  caption: [Key BIDS standard elements used in this work.],
) <tab-bids>

The use of BIDS enabled automated subject discovery, metadata extraction, and
reproducible preprocessing across the full cohort.

#figure(
  ```sh
  (mic) PPMI $ tree rawdata/ | head -n 20
  rawdata/
  ├── dataset_description.json
  ├── participants.json
  ├── participants.tsv  # metadata
  ├── sub-PPMI100001  # patient
  │   ├── ses-BL  # session
  │   │   ├── anat  # modality 
  │   │   │   ├── sub-PPMI100001_ses-BL_T1w.json  # acquisition metadata
  │   │   │   └── sub-PPMI100001_ses-BL_T1w.nii.gz  # compressed image
  │   │   └── spect  # different modality (DaTscan)
  │   │       ├── sub-PPMI100001_ses-BL_DaTSCAN.json
  │   │       └── sub-PPMI100001_ses-BL_DaTSCAN.nii.gz
  │   ├── ses-V02 # next session
  │   │   └── spect
  │   │       ├── sub-PPMI100001_ses-V02_DaTSCAN.json
  │   │       └── sub-PPMI100001_ses-V02_DaTSCAN.nii.gz
      ...
  ...
  ```,
  caption: [Directory structure using BIDS standard in VICOROB's server. The
  registered directory is shown.]
)<BIDS_ppmi>

=== Image Preprocessing <sec-preprocessing>

/*
First, I focused on the

In the case of the images (3d DaTscan images), I experimented with different
transformations to see how models trained with them would perform. To do so, I
used the monai library (@Project). It provides many predefined pre-processing
transformations.

// I did no preprocessing other than dropping N/A rows for the classic ML
// section of the thesis. How should I phrase that?

One of the issues I had when training using the 3d images is that even the
registered images had different dimensions "met elkaar" between each other. This
meant they could not directly be used as the input to the CNNs, needing some
transformation first.

I first attempted to crop the images to a small size, using `monai`'s
`Crop` to try and have all images be #dims[64]. In fear of this interfering
with where the model ends up looking at, I ended up increasing the size to
#dims[76], given that this gave me the best performance when comparing models
trained on different sizes.

#redt[This probably needs its own graph in the results section?]
*/

All image preprocessing was implemented using the MONAI library @Project /*
monai's website, zotero got a weird bib key */, which
provides a composable, GPU-compatible pipeline of medical image transforms.

Two parallel image sets were maintained throughout all experiments and never
combined: `raw` (unregistered, native acquisition space) images and `registered`
(spatially normalized) images (see @fig-compareraw-reg). Registered images were
produced by an in-house registration pipeline
@casamitjanadiazAnatomicallyaware2024 using affine registration to a standard
DaTscan template, making all volumes nominally comparable in voxel space. Raw
images were used as acquired, without spatial normalization.

#figure(
  grid(
    image("../assets/figures/methods/unregistered_images.svg", width: 100%),
    image("../assets/figures/methods/registered_images.svg", width: 100%)
  ),
  placement: auto,
  caption: [Images from the `raw` set (above, multiple different sizes) compared to registered images
  from the `derivatives` set (below, $91 times 109 times 91$ across).]
)<fig-compareraw-reg>

A practical challenge was that volumes within the raw dataset differed in
spatial dimensions across subjects, preventing their direct use as CNN input,
which requires a fixed input shape. Conversely, while volumes within the
registered set shared uniform spatial dimensions ($91 times 109 times 91$
voxels) due to standard template alignment, their large native size presented an
unnecessary computational and memory burden. Therefore, spatial standardization
and localized dimension reduction were required before feeding either image set
into the neural networks. The following preprocessing steps were applied to all
image sets, (also see @pipelinefig):

+ *Intensity normalization.* Each volume was normalized to zero mean and unit
  variance across its non-zero voxels, making intensities comparable across
  subjects and scanners.
+ *Spatial cropping.* Volumes were center-cropped using #smol[MONAI]’s
  `CenterSpatialCrop` transform. For the raw dataset, this step served to
  enforce a uniform input dimension across all subjects. For the registered
  dataset, where dimensions were already uniform, cropping functioned to isolate
  the Region of Interest (ROI) containing the striatum and discard irrelevant
  background space. A crop size of #dims[76] voxels was selected based on an
  empirical comparison of #dims[64] and #dims[128] crops: the 64-voxel crop
  risked clipping the striatal signal in some subjects, while the 128-voxel cube
  imposed a prohibitive memory cost for 3D training; 76 voxels covered the full
  striatum in all subjects while remaining computationally tractable.

For the 2.5D model specifically, maximum intensity projections (MIPs) were
computed from the preprocessed volume along each of the three anatomical axes
(axial, coronal, sagittal) prior to cropping (see @mips). Each MIP retains, at
every pixel position, the maximum intensity encountered along the projection
direction. Using projections avoids the need to select specific anatomical
slices and provides a compact representation of the full volume. This approach
was derived after seeing success on other modalities with different projections
of volumes to classify pulmonary nodules @setioPulmonary2016. The three
resulting 2D projections were stacked as the three channels of a single 2D input
tensor, matching the three-channel format expected by ImageNet-pretrained
networks.



#import fletcher.shapes: diamond
#figure(
  text(0.8em, diagram(
    node-stroke: 1pt,
    node-corner-radius: 1pt,
    // 2.5d
    node((0,0), [3#smol[D] volume]),
    edge("-|>"),
    node((1,0), [3 $times$ MIPS]),
    edge("-|>"),
    node((2,0), [Stack channels]),
    edge("-|>"),
    node((3,0), [ResNet18]),
    // 3d
    node((0,.75), [raw NIfTI]),
    edge("-|>"),
    node((1,.75), [Normalization]),
    edge("-|>"),
    node((1.8,.75), [Cropping]),
    edge("-|>"),
    node((2.4,.75), [CNN])
  )),
  caption: [Preprocessing pipelines followed for both 2.5D
  (top) and 3D CNNs (bottom).]
)<pipelinefig>

#figure(
    image("../assets/figures/methods/multi_axis_mip_rgb_concept.svg"),
    caption: [Pipeline for converting 3D DaTscan volumes into multi-axis
    pseudo-RGB representations for 2D convolutional neural networks. These three
    independent 2D views are subsequently stacked together to serve as the Red,
    Green, and Blue (RGB) input channels for a standard 2D RGB CNN architecture.]
)<mips>

=== Tabular Data Preprocessing 

The curated PPMI spreadsheet provides semi-quantitative DaTscan binding values
alongside clinical assessments. Preprocessing of the tabular data consisted of
two steps: row filtering and feature engineering. Rows with missing values in
any column belonging to the active feature set were dropped. No imputation was
performed, as the missingness rate was low for the primary feature sets and
imputation of clinical biomarkers risks introducing systematic bias.

From the raw #smol[SBR] columns, four engineered features were derived to capture
lateralization and overall binding:

#[
#set par(leading: 1em)
$
"AI"_"caudate" = frac("SBR"_"caudate,L" - "SBR"_"caudate,R", "SBR"_"caudate,L"
+ "SBR"_"caudate,R")
" ",\

"AI"_"putamen" = frac("SBR"_"putamen,L" - "SBR"_"putamen,R", "SBR"_"putamen,L"
+ "SBR"_"putamen,R")

" ",\

overline("SBR") = 1/4("SBR"_"caudate,L" + "SBR"_"caudate,R"
+ "SBR"_"putamen,L" + "SBR"_"putamen,R")
" ",\

"PCR" = frac(overline("SBR")_"putamen", overline("SBR")_"caudate") " ";
$
]

where AI denotes the Asymmetry Index and PCR the Putamen-to-Caudate Ratio. These
engineered features encode the asymmetric onset pattern characteristic of PD and
the relative putaminal loss relative to the caudate, both of which are
clinically recognized hallmarks of the disease.

== Classical Machine Learning Baseline
/* I worked on the data from the given tabular file `PPMI_Curated_Data_Cut_Public_20240729.xlsx`
containing data extracted from the DaTscan images and other metadata. */

The classical ML baseline was trained on the curated tabular data using
scikit-learn @Scikitlearn. A set of classifiers were evaluated: a Support Vector
Machine (SVM) with a radial basis function (RBF) kernel and another using a
linear kernel, a Random Forest classifier, a Gradient Boosting classifier and a
Logistic Regression (LR) with L2 regularization /*what does this mean?*/.
Hyperparameters were selected by nested cross-validation on the training
folds.

To understand how different feature groups contributed to classification
performance, an additive approach was chosen for feature engineering to mirror
the incremental nature of clinical diagnostic workflows, evaluating whether the
addition of progressively more invasive or complex clinical markers yields
marginal gains in predictive power over baseline imaging, see
@tab-incremental-sets.

#figure(
  tablef(
    columns: (auto, 10em, auto),
[Set],[ Feature Group Added ],[ Specific Features Included ],
[1],[ Baseline SBR ],[ Raw Specific Binding Ratio (SBR) values for caudate and putamen only. ],
[2],[ Full SBR Set ],[ Full PPMI-derived SBR set (contralateral, ipsilateral, and mean binding for caudate, putamen, and striatum). ],
[3],[ Engineered Features ],[ Asymmetry indices, mean SBR, and putamen-to-caudate ratio. ],
[4],[ Demographics ],[ Patient age and biological sex. ],
[5],[ Clinical Motor Assessments ],[ MDS-UPDRS Parts I to III, clinical symptom flags, and Levodopa Equivalent Daily Dose (LEDD). ],
[6],[ Non-Motor & Prodromal Markers ],[ University of Pennsylvania Smell Identification Test (UPSIT), REM Sleep Behavior Disorder (RBD) screening score, Epworth Sleepiness Scale (ESS), Geriatric Depression Scale (GDS), SCOPA-GI, and SCOPA-AUT. ],
[ 7 ],[ Secondary Biomarkers ],[ Alpha-synuclein, serum Neurofilament Light chain (NfL), and urate. ]
  ),
  caption: [Additive Feature Set Sequences]
)<tab-incremental-sets>

The additive structure of these feature sets allowed the information gain of
each clinical domain to be quantified by comparing AUC between successive steps.
SHAP (SHapley Additive exPlanations) analysis @lundbergUnified2017 was subsequently
applied to the best-performing classical model to identify the individual
features contributing most to the classification decision, providing a basis for
feature selection in the multimodal fusion experiments.

== Deep Learning strategies

=== CNN Architectures <sec-deep-learning-strategies>
/*
// Tried approaches: 2d, 3D, 3D-deeper (more layers), mednet3d, imagenet
// (2.5d)
// I have graphs comparing them all, on both registered and non-registered data.


To try and get something working at the start I created a simple 2d network
based loosely on a VGGNet /* should I cite anything here? */. The
images passed to it would be the MIP #redt[explain MIP and make sure this is
  what I used], which reduces the volumes into 2D images.

Once that was working and I had `pytorch` setup on the server, I constructed
a 3d architecture, based off of the 2d network I had but extending it into 3d.
As previously mentioned, transformations were applied to try and have them all
be the same size and then training was done on both #dims[128] and #dims[76].

I ran some models on these 2d CNNs and then on the equivalent 3d CNNs

Then, onto transfer learning

I tried using pretrained networks because given the small dataset I was working
with, I believed the best performance would come from networks that could start
with some pretrained weights and not complete randomness.

To this quest I tried first using the ImageNet.
Despite it not being a net trained specifically to work on medical images, it
was provided inside `pytorch` itself and it had been proven to work on many
different tasks.
The issue I ran into is that this model classifies 3-channel RGB (red, green, blue)
images, whereas my DaTscan volumes were 3d volumes.
I experimented with creating a 3-channel image from the volume by creating one
2d slice for each axis, and then feeding this to the ImageNet.
*/

Four CNN families were implemented and compared. The progression follows the
logic of the thesis: start with a simple custom architecture to establish a deep
learning baseline, extend it to three dimensions to exploit volumetric
information, and then explore transfer learning as a strategy to compensate for
the limited training set size.

*2D CNN (`2d_sum`).* A lightweight 2D CNN inspired by VGG-style stacked
convolutions was implemented as a first baseline @simonyanVery2015. The network
comprises three convolutional blocks (16, 32, and 64 filters respectively, each
with a $3 times 3$ kernel, batch normalization, and ReLU activation) followed by
global average pooling and a fully connected classification head. The input is a
single 2D image obtained by summing the preprocessed volume along the depth
axis, producing a projection that preserves the gross spatial layout of striatal
uptake while reducing memory and parameter count.

*3D CNN (`3d_crop`).* The 2D architecture was extended to three spatial
dimensions by replacing all 2D convolutional operators with their 3D
equivalents. The filter sequence (16 $arrow.r$ 32 $arrow.r$ 64) and the downstream
classification head were kept identical to the 2D baseline to isolate the effect
of dimensionality. A deeper variant (`3d_crop_deeper`) added a fourth
convolutional block (128 filters) to probe whether increased depth improved
performance.

*2.5D ResNet18 with ImageNet pretraining (`25d_resnet`).* To leverage transfer
learning from a large natural image dataset, a ResNet18 backbone pretrained on
ImageNet @dengImageNet2009 was fine-tuned for binary DaTscan classification. As
described in @sec-preprocessing, the three orthogonal MIPs extracted from each
volume were stacked as channels, producing a $3 times H times W$ input that
matches the format expected by the pretrained network (refer to @mips for a
visualization). The original ImageNet
classification head was replaced by a single linear layer with sigmoid output.
During fine-tuning, all backbone weights were updated at a reduced learning rate
($10^(-4)$) to avoid overwriting pretrained representations, while the new
classification head was trained at the default rate ($10^(-3)$).

*3D ResNet10 with MedicalNet pretraining (`med3d`).* As a domain-specific
alternative to ImageNet pretraining, a ResNet-10 backbone from MedicalNet
@chenMed3D2019, pretrained on 23 heterogeneous medical image segmentation datasets
including SPECT volumes, was adapted for classification.

Two adaptation strategies were evaluated. The first retained the original
network structure and replaced the segmentation head with a binary
classification head /*el meu primer intento*/. The second used only the pretrained encoder as a generic
volumetric feature extractor, discarding the decoder and attaching a lightweight
custom classification head /*Adrià's way*/. The latter approach reduces parameter count and
allows greater flexibility in the design of the classification stage while
preserving the pretrained feature representations.

=== Training Protocol <sec-training>

/*
I'd like to mention the `train.py` script I have created.

This script manages all the trainings I've ran on #smol[CNN]s. It loads the
corresponding dataset (either unaltered images or registered), the adequate CNN
architecture (med3d, imagenet, etc) and runs for the specified amount of folds.

I originally trained on 2 folds to get a feel for the performance of the model
and on the best performing ones, a final run of 5 folds was conducted in order
to verify that the results were not down to a lucky train-test split.
*/

All CNN models were trained using the same script (`train.py`, see @app_code)
and configuration to ensure comparability. The binary cross-entropy with logits
loss (`BCEWithLogitsLoss`) was used throughout. The Adam optimizer was employed
with default momentum parameters ($beta_1 = 0.9$, $beta_2 = 0.999$) and weight
decay of $10^(-4)$. Training was run for a maximum of 100 epochs. The model
checkpoint achieving the highest validation AUC within each fold was saved and
used for evaluation.

Training and evaluation were performed on the GPU infrastructure of the
#smol[VICOROB] research group. A separate evaluation script loaded the saved
checkpoints from each fold and computed aggregate metrics and boxplot
visualizations across the cross-validation runs.

All experiments used a batch size of 2. This small value was imposed by the
memory constraints of the available hardware (NVIDIA GeForce GTX 1060), which
limits the number of volumetric tensors that can reside in GPU memory
simultaneously during a forward pass. The model checkpoint achieving the highest
validation AUC within each fold was saved and used for final evaluation.

For models with pretrained weights (the 25d_resnet and med3d variants), a
differential learning rate schedule was applied: backbone parameters were
updated at a rate of $10^(-5)$ (one tenth of the base rate) to avoid
overwriting pretrained representations, while the newly initialized
classification head was trained at the base rate of $10^(-4)$. All remaining
architectures (2d_sum, 3d_crop, and 3d_crop_deeper) used a uniform learning
rate of $10^(-4)$ throughout.

=== Cross-Validation Scheme

Stratified $k$-fold cross-validation was used throughout to produce performance
estimates that are robust to the specific train-test split. An initial phase
used 2-fold cross-validation across all architectures to rank models efficiently
given the computational cost of full training runs. The best-performing
architectures identified were then re-evaluated with 5-fold cross-validation
to produce more reliable and statistically interpretable estimates. Performance
is reported as the mean and standard deviation across folds.

=== Reproducibility and Experiment Management

To facilitate reproducibility, all experiments were managed through a unified
training pipeline (`train.py`). Model configurations, preprocessing parameters,
and hyperparameters were stored in `json` configuration files, and the global
random seed for both numpy and PyTorch was set to 42 on all runs. Trained model
weights were serialized as `.pth` checkpoints, while performance metrics were
exported to `csv` files for subsequent statistical analysis and visualization.

Source code was maintained under Git version control and is publicly available
through the repository described in @app_code.

== Multimodal Fusion

/*
// I have not yet finished this

Multimodal classification was done on both CNNs and the classical ML.
In the classical classifiers, the addition was simply adding sets of tables to
the originally tabular data. I did add them all one atop of the previous group:

// I have an information gain graph that visualizes how the performance of all
// models improved with what datasets. I also did a shap test to see which
// fields added the most info.

// I do still have time to run this if you thin it'd be necessary, my tutor
// mentioned it but since the server is not working, idk.

Then, on the CNN side, models were trained using bot early-stage and late-stage
fusion
*/

Multimodal experiments combined DaTscan-derived information with tabular
clinical features, following two different strategies depending on the modality.

=== Fusion with Classical Classifiers

For the classical ML models, multimodal integration was straightforward: the
tabular feature sets described in the baseline section already include clinical
variables alongside SBR values, so the additive feature set sequence itself is
the multimodal analysis.

=== Fusion with CNNs

For the CNN-based models, the best-performing architecture from the image-only
experiments served as the backbone for all fusion experiments. Two fusion
strategies were evaluated.

/ Late fusion: The probability output of the frozen CNN was averaged with the probability output of a Logistic Regression classifier trained independently
  on the tabular features. No CNN retraining was performed. This approach is
  modular and computationally inexpensive, treating each modality as an
  independent expert whose judgements are combined at the decision level.

/ Intermediate (feature-level) fusion: A Y-shaped architecture (see @ydiag) was constructed
  in which the frozen CNN backbone produced a 512-dimensional image embedding,
  and a separate tabular branch, consisting of a fully connected layer (hidden
  size 16), ReLU activation, and dropout, produced a tabular embedding of the
  same dimension. The two embeddings were concatenated and passed through a
  shared classification head (linear layer, sigmoid output). The CNN backbone
  weights were kept frozen during fusion training; only the tabular branch and
  the joint head were trained. This configuration was adopted to prevent
  overfitting of the image branch on the small fusion training set.

Four tabular feature groups were evaluated independently and in combination:
motor function (MDS-UPDRS III), olfactory sensitivity (UPSIT), cognitive
screening (MoCA), and demographic variables (age, sex). This decomposition
allows the marginal contribution of each clinical domain to be quantified
separately from the others.

#figure(
  text(.75em, 
  box(fill: luma(245), radius: 2pt, inset: 1em, outset: (x: 2em, y: 0em),
  diagram(
    edge-stroke: .5pt,
    node-stroke: .5pt,
    node-fill: white,
    node-corner-radius: 1pt,
    node((0,0), [MIP image \ $3 times H times W$]),
    edge("->"),
    node((0,.85), [ResNet18 \ backbone]),
    edge("->"),
    node((1,.85), [Identity]), 
    edge("->"),
    node((2,.85), name: <x>, [512-dim \ vector], shape: circle),

    node((0,2), [tabular input \ $n times 1$]),
    edge("->"),
    node((0,2.85), [Linear \ (n $arrow.r$ 16)]),
    edge("->"),
    node((0.65,2.85), [ReLu]),
    edge("->"),
    node((1.35,2.85), [Dropout]),
    edge("->"),
    node((2.3,2.85), [Linear \ (16 $arrow.r$ 16)]),
    edge("->"),
    node((3.2,2.85), [ReLu]),
    edge("->"),
    node((4.2,2.85), name: <y>, [16-dim \ vector], shape: circle),

    node((5.5,1.75), name: <out>, [Concat \ 528-dim]),
    {
      let verts = ( // () means the previous vertex
        ((), "-|", (<y.east>, 50%, <out.west>)),
        ((), "|-", <out>),
        <out>
      )
      edge(<x>, ..verts, "->") // () == <x>
      edge(<y>, ..verts) // () == <y>
    }
  ))),
  caption: [Y-shaped multimodal fusion architecture. The frozen ResNet18
  backbone produces a 512-dimensional image embedding from the three-channel MIP
  input; a two-layer tabular MLP produces a 16-dimensional clinical embedding.
  The two embeddings are concatenated and passed through a shared classification
  head to produce the final PD probability.]
)<ydiag>



The two fusion strategies were intentionally designed with different levels of
model complexity. Late fusion combines the predictions of two independently
trained models and therefore introduces no additional trainable parameters.
Feature-level fusion attempts to learn a joint representation of the imaging and
clinical modalities instead.

The CNN backbone was kept frozen during feature-level fusion training. This
decision was motivated by the limited size of the multimodal cohort, which
increases the risk of overfitting when a large number of parameters are updated.
Freezing the pretrained image encoder allows the network to preserve the visual
representations learned during image-only training while restricting learning to
the newly introduced fusion layers.

Similarly, the tabular branch was deliberately kept small, consisting of a
single hidden layer followed by dropout regularization. The objective was not
to learn a complex clinical model, but rather to project the tabular variables
into a compact latent representation that could be combined with the image
embedding.

== Evaluation Metrics

To rigorously assess and validate the classification performance of the
developed models, a comprehensive suite of evaluation metrics was employed. In
binary classification tasks such as distinguishing between PD and HC cases.
Model predictions fall into four distinct categories based on the ground truth
alignment:

- _True Positives_ (TP): Positive cases (PD) correctly classified as positive.
- _True Negatives_ (TN): Negative cases (HC) correctly classified as negative.
- _False Positives_ (FP): Negative cases (HC) incorrectly classified as positive.
- _False Negatives_ (FN): Positive cases (PD) incorrectly classified as negative.

The primary metric reported in this study is the Area Under the Receiver
Operating Characteristic curve (AUC-ROC, or simply AUC). The ROC curve is a
graphical plot that illustrates the diagnostic ability of a binary classifier
system as its discrimination threshold is varied. It is generated by plotting
the True Positive Rate (TPR), or sensitivity, against the False Positive Rate
(FPR) at various threshold settings. The True Positive Rate and False Positive
Rate are defined as

$
"TPR" = "TP" / ("TP" + "FN") " " ,
\
"FPR" = "FP" / ( "TN" + "FP") = 1 - "Specifity (TPR)" " ".
$

The AUC measure provides a measure of performance across all possible
classification thresholds. An AUC value of $1.0$ indicates a perfect classifier,
whereas a value of $0.5$ signifies a performance no better than random guessing.
To provide a granular view of model performance at the default operational
threshold, accuracy, sensitivity, and specificity are reported as secondary
metrics.

- _Accuracy_ measures the proportion of total correct predictions (both positive
  and negative) among the total number of cases examined and is defined as the
  ratio of correct predictions against the total number of predictions:

$ "Accuracy" = ("TP" + "TN") / ("TP" + "TN" + "FP" + "FN") " ". $

Given the balanced class distribution enforced by the downsampling protocol in this work, the standard accuracy yields an identical value to the balanced accuracy across all experiments.

- _Sensitivity_ (also referred to as recall) measures the model's ability to correctly identify actual positive cases (the fraction of true PD cases detected):

$ "Sensitivity" = "TP" / ("TP" + "FN" ) " " . $

- _Specificity_ (or True Negative Rate) measures the model's capacity to correctly identify actual negative cases (the fraction of true HC detected):

$ "Specifity" = "TN" / ("TN" + "FP" ) " " . $


- _Precision_ measures the proportion of predicted positive cases that are truly positive:

$ "Precision" = "TP" / ("TP" + "FP") " ". $

- _F1-score_ combines precision and recall into a single metric by computing
  their harmonic mean:

$ "F1" = 2 ("precision" dot "recall") / ("precision" + "recall") = 2"TP" / (2"TP" + "FP" + "FN") $

The F1-score is particularly useful when both false positives and false
negatives are clinically relevant, as it balances the trade-off between
precision and recall. A value of $1.0$ indicates perfect classification,
whereas lower values reflect decreasing agreement between predictions and the
ground truth.


To ensure reproducibility and statistical validity, all metrics are reported as
the mean $plus.minus$ standard deviation ($sigma$) computed across the validation folds of the cross-validation architecture. Where direct performance comparisons between distinct model architectures are made, the complete performance distributions across folds are visualized using boxplots. This approach effectively conveys fold-level variability alongside the aggregate mean, offering insight into the stability and robustness of the models.

== Post-hoc SWEDD Inference <sec-swedd-inference>

To assess the specificity of the learned imaging representation, the
best-performing trained model was applied post-hoc to the SWEDD cohort (Scans
Without Evidence of Dopaminergic Deficit; $N = 57$), which was excluded from all
training and model selection procedures. Inference was performed without
retraining or fine-tuning, producing a predicted PD probability for each SWEDD
patient. The resulting probability distributions were compared across HC, PD,
and SWEDD cohorts using the Mann-Whitney U test. Statistical significance was
assessed at $alpha = 0.05$.
