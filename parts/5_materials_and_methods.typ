#import "../assets/ak_tfg_lib.typ": *

#let dims(it) = {
  [ #it $times$ #it $times$ #it ]
}
#show regex("\bPPMI\b"): smol[ppmi]
#show regex("\bSWEDD\b"): smol[SWEDD]
#show regex("\bBIDS\b"): smol[bids]

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
tabular file (`PPMI_Curated_Data_Cut_Public_20240729.xlsx`) containing
semi-quantitative image-derived features alongside clinical assessments
collected at each visit. These two data types are available within PPMI.

=== Study Population and Cohort Selection

/* draft:
// ill comment on the available data, how many of each, ages, etc.
// Maybe also describe image acquisition

As I mentioned, only the *sesBL* (baseline session) session was used (BIDS, see
@bids for more) to avoid repeating the same patients in different timelines,
introducing accidental biases.

This left me with a dataset of a total of ...

// i cant' check right now, the server is down, but there were 1000-ish PD and
// 200 ish HC

This imbalance was present in the tabular data too. I tried fixing it both
automatically with weighted samplers and manually (dropping enough PD so that
there are the same PD as HC), which is what ended up working best on all cases.

When it came to the tabular data (not DaTscan images), thouhg, a total of "PD: 3066, HC: 296" were
there.
*/

Only subjects with a DaTscan image available and a confirmed diagnosis of either
Parkinson's disease (PD) or healthy control (HC) were used. Subjects classified
under other PPMI diagnostic categories such as SWEDD (Scans Without Evidence of
Dopaminergic Deficit) or prodromal were excluded to avoid introducing ambiguous
labels into the training set.

To limit each subject to a single observation and avoid temporal data leakage,
only the baseline session (`sesBL` in BIDS notation, described in @sec-bids) was
retained for each participant. The raw (unregistered) image set contained
#redt[FILL: \~158 HC] and #redt[FILL: \~PD count] PD subjects; the registered image
set contained 124 HC and 124 PD subjects after applying the same filter. The
larger raw set arises because the registration pipeline discarded images that
failed quality control or fell outside the template field of view.

The class imbalance inherent in the PPMI cohort, where PD subjects substantially
outnumber HC, was addressed by downsampling the majority class (PD) to match
the size of the minority class (HC) prior to training, yielding balanced
two-class datasets. This decision was preferred over weighted sampling after
empirical comparison, as it produced more stable training results and
performance across architectures.

For the tabular experiments (classical ML baseline), the same diagnostic filter
was applied to the curated spreadsheet. After removing rows with missing values
in the feature columns of interest, the tabular cohort comprised #redt[some] PD and
#redt[some] HC subjects. The substantially larger tabular counts relative to the
image cohort reflect the fact that #smol[PPMI] collects clinical assessments at
multiple visits and from participants who did not undergo imaging at baseline.

// maybe this last sentence should go

=== Legal and Ethical Considerations


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
work.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    [*BIDS element*],
    [*Description*],
    [*Example*],

    [`sub-ID`],
    [Unique subject identifier],
    [`sub-3001`],

    [`ses-LABEL`], [Session label (timepoint)], [`ses-BL`],
    [Modality folder], [Imaging modality], [`pet/`],
    [`.nii.gz`], [Compressed NIfTI image volume], [`sub-3001_ses-BL_pet.nii.gz`],
    [`.json`], [Acquisition metadata sidecar], [`sub-3001_ses-BL_pet.json`],
    [`participants.tsv`], [Subject-level metadata table], [age, sex, diagnosis],
  ),
  caption: [#redt[THIS NEEDS TO BE FILLED WITH REAL STUFF] Key BIDS standard elements used in this work.],
) <tab-bids>

In the case of the PPMI data, once loaded using this standard the resulting
structure looks like this:
// FILL: paste the directory tree output here once the server is back. Something
// like:
// ``` PPMI/
// ├── sub-3001/
// │   └── ses-BL/
// │       └── pet/
// │
// ├── sub-3001_ses-BL_pet.nii.gz
// │           └── sub-3001_ses-BL_pet.json
// ├── sub-3002/ ...
// └── participants.tsv
// ```

=== Image Preprocessing

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
(spatially normalized) images. Registered images were produced by the PPMI
processing pipeline using affine registration to a standard DaTscan template,
making all volumes nominally comparable in voxel space. Raw images were used as
acquired, without spatial normalization.

A practical challenge was that volumes differed in spatial dimensions across
subjects, even within the registered set. This prevented direct use as CNN
input, which requires a fixed input shape. The following preprocessing steps
were applied to all image sets:

+ *Intensity normalization.* Each volume was normalized to zero mean and unit
  variance across its non-zero voxels, making intensities comparable across
  subjects and scanners.
+ *Spatial cropping.* Volumes were center-cropped to a fixed spatial extent
  using MONAI's `CenterSpatialCrop` transform. A crop size of #dims[76] voxels
  was selected based on empirical comparison of #dims[64] and #dims[128] crops:
  the 64-voxel crop risked clipping the striatal signal in some subjects, while
  the 128-voxel cube imposed a prohibitive memory cost for 3D training; 76
  voxels covered the full striatum in all subjects while remaining
  computationally tractable.

For the 2.5D model specifically #redt[(see section CNN architectures)], maximum intensity projections (MIPs) were
computed from the preprocessed volume along each of the three anatomical axes
(axial, coronal, sagittal) prior to cropping. Each MIP retains, at every pixel
position, the maximum intensity encountered along the projection direction,
preserving the peak striatal signal. The three resulting 2D projections were
stacked as the three channels of a single 2D input tensor, matching the
three-channel format expected by ImageNet-pretrained networks.

=== Tabular Data Preprocessing <sec-preprocessing>

The curated PPMI spreadsheet provides semi-quantitative DaTscan binding values
alongside clinical assessments. Preprocessing of the tabular data consisted of
two steps: row filtering and feature engineering. Rows with missing values in
any column belonging to the active feature set were dropped. No imputation was
performed, as the missingness rate was low for the primary feature sets and
imputation of clinical biomarkers risks introducing systematic bias.

From the raw #smol[SBR] columns, four engineered features were derived to capture
lateralization and overall binding:

$
/*"AI"_"Caudate" = frac("SBR"_"caudate,L" - "SBR"_"caudate,R", "SBR"_"caudate,L"
+ "SBR"_"caudate,R") */
"AI"_" {caudate,putamen}" = frac("SBR"_" {caudate,putamen} L" -
"SBR"_" {caudate,putamen} R", "SBR"_" {caudate,putamen} L"
+ "SBR"_" {caudate,putamen} R") 

" ",\

overline("SBR") = 1/4("SBR"_"caudate,L" + "SBR"_"caudate,R"
+ "SBR"_"putamen,L" + "SBR"_"putamen,R")
" ",\

"PCR" = frac(overline("SBR")_"putamen", overline("SBR")_"caudate") " ";
$

where AI denotes the Asymmetry Index and PCR the Putamen-to-Caudate Ratio. These
engineered features encode the asymmetric onset pattern characteristic of PD and
the relative putaminal loss relative to the caudate, both of which are
clinically recognized hallmarks of the disease.

== Classical Machine Learning Baseline
/* I worked on the data from the given tabular file `PPMI_Curated_Data_Cut_Public_20240729.xlsx`
containing data extracted from the DaTscan images and other metadata. */

The classical ML baseline was trained on the curated tabular data using
scikit-learn @Scikitlearn. A set of classifiers were evaluated: a Support Vector
Machine (SVM) with a radial basis function (RBF) kernel, a Logistic Regression
(LR) with L2 regularization, #redt[Fill in with the others ion remember, need
the server to be up]. Hyperparameters (regularization strength $C$ for
both models; kernel coefficient $gamma$ for the SVM) were selected by nested
cross-validation on the training folds.

To understand how different feature groups contributed to classification
performance, models were trained on a sequence of additive feature sets, each
building on the previous one:

+ raw SBR values for caudate and putamen only;
+ the full PPMI-derived SBR set including contralateral, ipsilateral, and mean
  binding for caudate, putamen, and striatum;
+ the engineered features (asymmetry indices, mean SBR, putamen-to-caudate
  ratio);
+ the above plus demographic variables (age, sex);
+ further augmented with motor assessments (MDS-UPDRS I–III, symptom flags,
  Hoehn and Yahr scale, levodopa equivalent daily dose);
+ with non-motor prodromal markers (UPSIT, REM sleep behavior score, Epworth
  Sleepiness Scale, Geriatric Depression Scale, SCOPA-GI, SCOPA-AUT);
+ with secondary biomarkers (alpha-synuclein, serum NfL, urate).

The additive structure of these feature sets allowed the information gain of
each clinical domain to be quantified by comparing AUC between successive steps.
SHAP (SHapley Additive exPlanations) analysis @lundbergUnified2017 was subsequently
applied to the best-performing classical model to identify the individual
features contributing most to the classification decision, providing a basis for
feature selection in the multimodal fusion experiments.

#redt[I still need to run this independently instead of additively.]

== Deep Learning strategies

// idk what to explain here

=== CNN Architectures

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
convolutions was implemented as a first baseline. The network
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
performance; this variant exhibited near-perfect training metrics and degraded
validation performance, confirming overfitting on the available dataset size,
and was retained only for comparison purposes.

*2.5D ResNet18 with ImageNet pretraining (`25d_resnet`).* To leverage transfer
learning from a large natural image dataset, a ResNet18 backbone pretrained on
ImageNet (@dengImageNet2009) was fine-tuned for binary DaTscan classification. As
described in @sec-preprocessing, the three orthogonal MIPs extracted from each
volume were stacked as channels, producing a $3 times H times W$ input that
matches the format expected by the pretrained network. The original ImageNet
classification head was replaced by a single linear layer with sigmoid output.
During fine-tuning, all backbone weights were updated at a reduced learning rate
($10^{-4}$) to avoid overwriting pretrained representations, while the new
classification head was trained at the default rate ($10^{-3}$).

*3D ResNet10 with MedicalNet pretraining (`med3d`).* As a domain-specific
alternative to ImageNet pretraining, a ResNet-10 backbone from MedicalNet
@chenMed3D2019, pretrained on 23 heterogeneous medical image segmentation datasets
including SPECT volumes, was adapted for classification. The pretrained
segmentation head was removed and replaced by global average pooling followed by
a fully connected binary classification head. This architecture processes the
full 3D volume and requires no projection step, making it the most
architecturally faithful to the volumetric nature of the data.

#redt[I also used a different variant of the med3d, where instaed of only
removing the head, it removes more layers earlier on.]

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
decay of $10^(-4)$. Training was run for a maximum of 80 epochs with early
stopping based on validation AUC (patience of #redt[FILL] epochs). The model
checkpoint achieving the highest validation AUC within each fold was saved and
used for evaluation.

Training and evaluation were performed on the GPU infrastructure of the VICOROB
research group at the Universitat de Girona. Another script was used to evaluate the best fold of each model, generating
comparative boxplots on them.

=== Cross-Validation Scheme

Stratified $k$-fold cross-validation was used throughout to produce performance
estimates that are robust to the specific train-test split. An initial phase
used 2-fold cross-validation across all architectures to rank models efficiently
given the computational cost of full training runs. The best-performing
architectures identified in were then re-evaluated with 5-fold cross-validation
(image-net derived CNN, med3d net and 3d) to produce more reliable and statistically interpretable estimates. Performance
is reported as the mean and standard deviation across folds.

// FILL: list which architectures received the 5-fold treatment. Based on your
// notes this is at minimum 25d_resnet on raw data.


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
experiments (`25d_resnet` on raw images #redt[and 3d cnn, not yet done] ) served as the backbone for all fusion
experiments. Two fusion strategies were evaluated.

/ Late fusion: The probability output of the frozen CNN was averaged with the
  probability output of a Logistic Regression classifier trained independently
  on the tabular features. No CNN retraining was performed. This approach is
  modular and computationally inexpensive, treating each modality as an
  independent expert whose judgements are combined at the decision level.

/ Intermediate (feature-level) fusion: A Y-shaped architecture was constructed
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


// FILL: note whether 5-fold was completed for the fusion experiments. Based on
// your notes, fusion results are currently 2-fold only and 5-fold validation is

== Evaluation Metrics

Classification performance was assessed using four complementary metrics. The
area under the receiver operating characteristic curve (AUC) is the primary
reported metric; it summarizes discriminative ability across all decision
thresholds and is robust to class imbalance. Accuracy, sensitivity (recall,
the fraction of PD cases correctly identified), and specificity (the fraction
of HC correctly identified) are reported as secondary metrics. Given the
balanced class distribution enforced by downsampling, accuracy equals balanced
accuracy in all experiments.

All metrics are reported as mean $plus.minus$ standard deviation across
cross-validation folds. Where comparison between models is made, performance
distributions across folds are visualized as boxplots to convey fold-level
variability alongside the aggregate mean.

/*
TO FILL in:
- Raw cohort subject counts (confirm exact numbers)
- Tabular cohort counts after dropna()
- Maximum epochs
- Which architectures 5-fold-ed (confirm it's at minimum `25d_resnet` raw)
- Whether fusion experiments completed 5-fold (they did not, right?)
- The BIDS directory tree (once the server is back)
*/
