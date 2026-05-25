#import "../assets/ak_tfg_lib.typ": *

#let dims(it) = {
  [ #it $times$ #it $times$ #it ]
}

= Materials and Methods

== Dataset and Cohort

All data used in this study were obtained from the Parkinson's Progression
Markers Initiative (PPMI) @marekParkinson2011, a large-scale, longitudinal,
multicenter observational study launched in 2010 by the Michael J. Fox
Foundation. PPMI collects multimodal data (neuroimaging, biospecimens, and
clinical assessments) from participants across more than 30 international sites
under a standardized acquisition protocol. The dataset is openly accessible to
qualified researchers at #link("www.ppmi-info.org").

This work makes use of two data types available within #smol[PPMI]:
three-dimensional DaTscan SPECT volumes and a curated tabular file
(`PPMI_Curated_Data_Cut_Public_20240729.xlsx`) containing semi-quantitative
image-derived features alongside clinical assessments collected at each visit.



=== Study population

// ill comment on the available data, how many of each, ages, etc.
// Maybe also describe image acquisition

As I mentioned, only the *sesBL* (baseline session) session was used (BIDS, see
@bids for more) to avoid repeating the same patients in different timelines,
introducing accidental biases.

This left me with a dataset of a total of ... /* i cant' check right now, the
server is down, but there were 1000-ish PD and 200 ish HC*/

This imbalance was present in the tabular data too. I tried fixing it both
automatically with weighted samplers and manually (dropping enough PD so that
there are the same PD as HC), which is what ended up working best on all cases.

When it came to the tabular data (not DaTscan images), thouhg, a total of "PD: 3066, HC: 296" were
there.

=== Legal and Ethical Considerations

The use of medical imaging data and associated clinical information requires
strict compliance with ethical and legal regulations to ensure the privacy and
protection of individuals. In this project, the following guidelines have been
followed:
- Ethical approval: The PPMI dataset has ethical approval from the foundation and
  was collected following established ethical protocols.36, 37, 37 As a user of
  these data, access was requested through the official procedure, ensuring that
  the use of the  is within the permitted research purposes. For more details
  on the original ethical approval, see @app_ethics
- Regulatory Compliance: The processing of the data has been conducted in
  accordance with the General Data Protection Regulation (GDPR) and Organic Law
  3/2018 on the Protection of Personal Data and Guarantee of Digital Rights.
  This includes the anonymization of the data (by removing direct identifiers)
  and storage in secure, restricted-access environments.
- Data Quality: The PPMI data are of high quality, with standardized
  acquisitions and complete metadata.
  - Privacy and data protection: The images and metadata have been used
    exclusively for the purposes of this thesis. They have not been shared with
    third parties or stored on unauthorized servers. Anonymized data may be
    shared for research purposes, always within the framework of the PPMI
    terms of use (see @app_ethics). For more detailed information about the
    ethical and legal aspects, including communication with the PPMI
    administrators.

== Data Preprocessing

As mentioned, the data I'll be using from the PPMI dataset consists of 3d
volumetric DaTscan images and, later on, numeric indicators.

In my case, the PPMI dataset was already loaded into the server where I ran my
code, the structure being:

```
paste tree output when the server is up again
The niigz files and alladat
```

// From another TFG (thesis) I gathered that the protocol this data uses is the
// BIDS standard (Brain Imaging Data Structure). 
// The other thesis also included a table with info on what each element of the
// standard represents

=== Bids <bids>
// És un marc organitzatiu per a dades de neuroimatge que assegura reproductibilitat, permet automatització
// de fluxos i ens facilita la compartició de dades. Hi ha varis components principals d’aquest estàndard, que
// es poden trobar a la Taula 2.
// Element BIDS Descripció
//  Exemple
// ID Subjecte
//  Identificador Únic
//  sub-001
// Sessió
//  Punt temporal en estudis longitudinals
//  ses-01
// Modalitat
//  Tipus d’escaneig
//  anat (anatòmic), func (funcional)
// Fitxers de Metadades
//  Descriptors estructurats
//  participants.tsv, *.json
// Taula 2: Elements de l’estàndard BIDS


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

== Classical Machine Learning Baseline

I worked on the data from the given tabular file `PPMI_Curated_Data_Cut_Public_20240729.xlsx`
containing data extracted from the DaTscan images and other metadata.


== Deep Learning strategies

// idk what to explain here

=== CNN Architectures

// I don't know if I should talk about this section as if it were some sort of
// stotytelling or what

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


=== Training Protocol

I'd like to mention the `train.py` script I have created.

This script manages all the trainings I've ran on #smol[CNN]s. It loads the
corresponding dataset (either unaltered images or registered), the adequate CNN
architecture (med3d, imagenet, etc) and runs for the specified amount of folds. 

I originally trained on 2 folds to get a feel for the performance of the model
and on the best performing ones, a final run of 5 folds was conducted in order
to verify that the results were not down to a lucky train-test split.


== Multimodal Fusion

// I have not yet finished this

Multimodal classification was done on both CNNs and the classical ML. 

In the classical classifiers, the addition was simply adding sets of tables to
the originally tabular data. I did add them all one atop of the previous group:


#redt[This code block in multimodal fusion should not appear verbatim in the
thesis mayb describe the feature sets in prose/table instead.]

```py
# Feature set definitions
# All sets are additive: each builds on the previous one

# DaTscan raw (current baseline)
FEATS_DATSCAN_RAW = ['DATSCAN_CAUDATE_L', 'DATSCAN_CAUDATE_R', 'DATSCAN_PUTAMEN_L', 'DATSCAN_PUTAMEN_R']

# DaTscan raw + PPMI-derived SBR columns (lateralisation info)
FEATS_DATSCAN_FULL = FEATS_DATSCAN_RAW + [
    "con_caudate", "ips_caudate", "mean_caudate",
    "con_putamen", "ips_putamen", "mean_putamen",
    "con_striatum", "ips_striatum", "mean_striatum"
]

# Engineered features
FEATURE_COLS_ENG = FEATURE_COLS + [ "AI_Caudate", "AI_Putamen", "Mean_SBR", "Putamen_Caudate_Ratio"]

# Engineered asymmetry features
FEATS_DATSCAN_ENG = FEATS_DATSCAN_FULL + [
    "AI_Caudate", "AI_Putamen", "Mean_SBR", "Putamen_Caudate_Ratio"
]

# + Demographics (age and sex, known to affect DaTscan values)
FEATS_DEMO = FEATS_DATSCAN_ENG + ["age_at_visit", "SEX"]

# + Motor (UPDRS3, symptom flags less leaky)
FEATS_MOTOR = FEATS_DEMO + [
    "updrs3_score", "updrs1_score", "updrs2_score",
    "sym_tremor", "sym_rigid", "sym_brady", "sym_posins",
    "hy", "LEDD"
]

# + Non-motor prodromal markers (UPSIT)
FEATS_NONMOTOR = FEATS_MOTOR + [
    "upsit", "rem", "ess", "gds", "scopa_gi", "scopa_ur"
]

# + Secondary biomarkers (sparse: more missing data here)
FEATS_BIO = FEATS_NONMOTOR + ["asyn", "nfl_serum", "urate"]

# Resum:
feature_sets = {
    "DaTscan raw":         FEATS_DATSCAN_RAW,
    "DaTscan full SBR":    FEATS_DATSCAN_FULL,
    "DaTscan engineered":  FEATS_DATSCAN_ENG,
    "+ Demographics":      FEATS_DEMO,
    "+ Motor (UPDRS)":     FEATS_MOTOR,
    "+ Non-motor (UPSIT)": FEATS_NONMOTOR,
    "+ Biomarkers":        FEATS_BIO,
}
```

// I have an information gain graph that visualizes how the performance of all
// models improved with what datasets. I also did a shap test to see which
// fields added the most info.

// I do still have time to run this if you thin it'd be necessary, my tutor
// mentioned it but since the server is not working, idk.

Then, on the CNN side, models were trained using bot early-stage and late-stage
fusion

== Evaluation Metrics

/*
TO FILL in:
- Raw cohort subject counts (confirm exact numbers)
- Tabular cohort counts after dropna()
- Maximum epochs
- Which architectures 5-fold-ed (confirm it's at minimum `25d_resnet` raw)
- Whether fusion experiments completed 5-fold (they did not, right?)
- The BIDS directory tree (once the server is back)
*/
