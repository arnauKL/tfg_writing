#import "../assets/ak_tfg_lib.typ": *

// notes from the thesis guide:
/*
The "state of the art" refers to studying what has already been developed (what
exists in the world) at the most advanced level achieved to date in relation to
the TFG to be carried out. It is necessary to identify the literature that
relates to the device, technique, or method most closely related to what is
intended to be tested in the TFG. 
*/

= State of the art

/* draft index:
*
* == Clinical interpretation of DaTscan
* == Deep Learning for DaTscan
* === From classical ML to CNNs
* === 2D, 2.5D, and 3D Architectures
* === Transfer learning
* == Multimodal Fusion with Clinical Variables
* == Research gap
*/

The application of machine learning to DaTscan neuroimaging for Parkinson's
disease diagnosis draws on three intersecting research areas: clinical nuclear
medicine /*subsect 1*/, which has established DaTscan as a validated diagnostic biomarker;
deep learning /*subsect 2*/, which provides the architectures and training strategies used to
process imaging data; and multimodal learning /*subsect 3*/, which investigates the
principled combination of heterogeneous data sources. This section reviews
relevant prior work across these areas and positions the present project within
them.


== Clinical Interpretation of DaTscan

Visual interpretation of DaTscan is performed by trained nuclear medicine
specialists, who classify scans as normal or abnormal based on the shape and
symmetry of striatal tracer uptake. While this approach is clinically
established, it is inherently subjective: studies evaluating inter-rater
agreement report meaningful variability, particularly in early-stage
presentations where putaminal thinning produces only subtle deviations from the
normal bilateral comma-shaped pattern @jakobsonmoAccuracy2015. A 2021 systematic
review confirmed that DaTscan led to a change in clinical management in
approximately half of patients tested and altered the final diagnosis in roughly
one third @begaClinical2021, showing evidence of its practical impact and the
uncertainty inherent
in current practice.

Semi-quantitative analysis through the Striatal Binding Ratio (#smol[SBR])
provides a more reproducible numerical summary by comparing tracer uptake in
predefined striatal regions against a background reference, as implemented in
software such as DaTQUANT @neillPractical2021. However, this approach compresses
the full three-dimensional #smol[SPECT] volume into a handful of regional means,
discarding information about the spatial distribution of uptake within regions,
asymmetry texture, and subtle intensity patterns that may carry diagnostic
information @tinazSemiquantitative2018. Furthermore, established #smol[SBR]
thresholds were derived predominantly from cohorts with advanced disease, which
may reduce their sensitivity at earlier stages @palermoDopamine2021.

Both limitations are most consequential where automated tools would have the
greatest clinical impact: in borderline and early-stage presentations where
these assessments are least reliable. These considerations motivate data-driven
approaches that operate directly on the full image volume rather than on derived
scalar summaries.

== Deep Learning for DaTscan Classification

Prior to the widespread adoption of deep learning, automated DaTscan analysis
typically combined the aforementioned handcrafted features alongside derived
lateralization and asymmetry indices with classical classifiers such as Support
Vector Machines or Random Forests. While these pipelines demonstrated reasonable
performance on well-separated cohorts, their reliance on predefined features
limits their capacity to capture novel spatial patterns not available in the
chosen summary statistics. The demonstrated effectiveness of #smol[CNN]s across
a broad range of medical imaging tasks @litjensSurvey2017 prompted their
adaptation to DaTscan classification, with the public availability of the
#smol[PPMI] dataset @marekParkinson2011 providing the primary training resource.

In fact, most published DaTscan deep-learning studies rely on the publicly
available #smol[PPMI] cohort, making it the de facto benchmark dataset for
methodological comparisons.

=== 2D, 2.5D, and 3D Architectures

The most common approach in the literature converts the 3D #smol[SPECT] volume
into a 2D representation and applies architectures pretrained on ImageNet
@dengImageNet2009. Variants include selecting axial slices that prominently
display the striatum, computing maximum intensity projections (#smol[MIP]s)
along anatomical axes, or summing voxel intensities along the depth dimension.
These strategies enable the use of standard 2D backbones with large pretrained
weight libraries, reducing the effective number of parameters that must be
learned from limited data. The trade-off is that collapsing a 3D volume into a
2D representation necessarily discards information encoded in the full spatial
arrangement of uptake.

A practical middle ground, sometimes called a 2.5D approach, stacks projections
from multiple anatomical axes as separate input channels, supplying the network
with complementary views of the volume while retaining compatibility with
standard 2D architectures @setioPulmonary2016. An extension of this approach has
been used to train with ImageNet in this thesis.

Volumetric 3D #smol[CNN]s process the full #caps[SPECT] volume directly and
preserve all spatial context, which is in principle better suited to capture the
pattern of striatal degeneration. In practice, however, 3D models lead to
substantially higher memory usage and computational costs while requiring larger
training sets to avoid overfitting.

=== Transfer Learning

Transfer learning addresses data scarcity by initializing network weights from a
large auxiliary dataset before fine-tuning on the target task. For 2D
architectures, ImageNet @dengImageNet2009 pretrained weights (available for
ResNet, VGG, and related backbones) are the standard source, and have been shown
to improve generalization in data-limited medical imaging settings despite the
domain gap between natural photographs and medical scans.

For 3D volumetric models, domain-specific pretraining is more appropriate
@raghuTransfusion2019. MedicalNet @chenMed3D2019 provides ResNet backbones
pretrained on 23 heterogeneous medical image segmentation datasets including
#smol[SPECT] volumes, offering feature representations more semantically aligned
with the target task than ImageNet features.

=== Explainability

A recurring limitation of deep learning models in clinical settings is their
opacity: a model may achieve high classification accuracy without providing
any explanation of which image regions or features drove its decision, which
is a significant barrier to clinical adoption. Two complementary techniques
dominate the interpretability literature in this context.

- Gradient-weighted Class Activation Mapping (Grad-#smol[CAM]) computes a coarse
  spatial map highlighting the image regions that most influenced a specific
  prediction, by weighting the feature maps of a convolutional layer by the
  gradient of the class score with respect to those maps @selvarajuGradCAM2017.

- #smol[SHAP] (SHapley Additive exPlanations) provides complementary
  feature-level explanations for both classical and deep models by assigning
  each input feature a contribution score derived from cooperative game theory
  @lundbergUnified2017.

In the DaTscan context, Grad-#smol[CAM] can reveal whether a CNN attends to
anatomically plausible regions, such as the posterior putamen, while #smol[SHAP]
can identify which tabular clinical variables carry the most predictive weight.
Incorporating these tools alongside classification performance metrics is
increasingly expected in clinical machine learning work, and both are applied in
this thesis.


== Multimodal Fusion with Clinical Variables

The clinical assessment of PD integrates imaging findings with motor examination
scores, olfactory testing, demographic context, and patient history. Multimodal
machine learning combines representations from multiple data sources within a
single predictive model. Fusion strategies are broadly classified by the stage
at which modalities are combined: _early fusion_ merges raw feature
representations before any modality-specific processing; _late fusion_ combines
independent per-modality predictions at the decision level; and _intermediate
fusion_ merges learned embeddings from separate processing branches before the
classification head.

The fusion approach has been explored most thoroughly in the Alzheimer's disease
literature, where combining structural #smol[MRI] with cognitive test scores and
genetic risk factors has consistently outperformed single-modality approaches
@youngAccurate2013. For Parkinson's disease, the #smol[PPMI] dataset
@marekParkinson2011 provides a uniquely rich resource for multimodal
experiments: alongside DaTscan #smol[SPECT] volumes, it collects motor
assessments (#smol[MDS-UPDRS]), olfactory testing (#smol[UPSIT]), cognitive
screening, and biospecimen markers from a standardized longitudinal cohort.
Despite this richness, the added diagnostic value of combining imaging with
clinical variables for binary #smol[PD] classification remains incompletely
characterized in the literature.

== Research Gap

The present work addresses two specific gaps in the existing literature. First,
direct comparisons of 2D projection-based, 2.5D multi-axis, and 3D volumetric
#smol[CNN] architectures under identical preprocessing and evaluation conditions
remain relatively uncommon in the DaTscan literature. Second, the complementary
diagnostic value of tabular clinical variables (motor function, olfactory
sensitivity, and demographics) combined with DaTscan-derived image features has
not been rigorously quantified for binary healthy control versus manifest
#smol[PD] classification. This project contributes both evaluations using
#smol[PPMI] as a standardized benchmark.
