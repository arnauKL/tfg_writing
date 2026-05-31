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

The application of machine learning to DaTscan neuroimaging for Parkinson's
disease diagnosis draws on three intersecting research areas: clinical nuclear
medicine, which has established DaTscan as a validated diagnostic biomarker;
deep learning, which provides the architectures and training strategies used to
process imaging data; and multimodal learning, which investigates the principled
combination of heterogeneous data sources. This section reviews relevant prior
work across these areas and positions the present project within them.


== Clinical Interpretation of DaTscan

/* rewritten according to the feedback:
This has already been commented previously. I'd rather mention the problems of
visual assessment: inter-rate variability, not generalizable, etc.

And also problems with semi-quantitative: ad-hoc rules, some methods need
registration to a template, not subject-specific, etc.

Some of the methods used need to be referenced: DatQUANT (GE Healthcare, paid)
and BasGANv2 (not available at this time), for example. Mention that they are
not public currently and, as such, canoot be used freely to process data.
*/

Visual interpretation of DaTscan is performed by trained nuclear medicine
specialists, who classify scans as normal or abnormal based on the shape and
symmetry of striatal tracer uptake. Despite being the established clinical
standard, visual assessment is inherently subjective and suffers from
well-documented limitations. Inter-rater variability is a primary concern:
agreement between readers degrades considerably in early-stage presentations,
where putaminal thinning produces only subtle deviations from the normal
bilateral comma-shaped pattern @jakobsonmoAccuracy2015. Beyond reproducibility,
visual reads are not easily generalizable across sites and reader experience
levels, and provide no structured numerical output that can be tracked
longitudinally or compared across cohorts. A 2021 systematic review confirmed
that DaTscan led to a change in clinical management in approximately half of
patients tested and altered the final diagnosis in roughly one third
@begaClinical2021, underscoring both its practical impact and the uncertainty
inherent in current interpretive practice.

/*problems w/ semiquantitative*/
Semi-quantitative analysis through the Striatal Binding Ratio (SBR) was
introduced to address the reproducibility shortcomings of visual reads,
providing a numerical summary by comparing tracer uptake in predefined
striatal regions against a background reference @tinazSemiquantitative2018.
However, this approach carries its own set of limitations. The SBR thresholds
applied in practice are ad-hoc: they were derived predominantly from cohorts
with advanced disease, which reduces their sensitivity at earlier stages
@palermoDopamine2021. Many semi-quantitative pipelines additionally require
spatial registration of the patient volume to a standard template, introducing
dependence on registration quality and making results less subject-specific.
Moreover, compressing a full three-dimensional SPECT volume into a handful of
regional means discards spatial information about the distribution of uptake
within regions, asymmetry texture, and subtle intensity patterns that may carry
diagnostic value @tinazSemiquantitative2018.

/* this mentions the state of datquant & basgan*/
Commercial implementations of semi-quantitative analysis, such as DaTQUANT
@brogleyDaTQUANT2019 and BasGANv2, automate parts of this pipeline but are not
publicly available: DaTQUANT is a paid proprietary tool, and BasGANv2 is not
currently accessible for independent research use. This limits their utility for
open, reproducible research and precludes their free application to datasets
such as PPMI.

Both limitations are most consequential where automated tools would have the
greatest clinical impact: in borderline and early-stage presentations where
these assessments are least reliable. These considerations motivate data-driven
approaches that operate directly on the full image volume rather than on derived
scalar summaries.

// done up to here

== Deep Learning for neuroimaging classification

/*
* here just talk about classifying anything using neuroimaging
*
* === Transfer Learning
* ...
* === Explainability
* ...
*
* */


== Deep Learning for DaTscan Classification
/* and this section (ignore its current contents) should be for DaTscan
* classification and needs specific works to be cited, it's sota in the end, not
* just previous concepts
* */

Prior to the widespread adoption of deep learning, automated DaTscan analysis
typically combined the aforementioned handcrafted features alongside derived
lateralization and asymmetry indices with classical classifiers such as Support
Vector Machines or Random Forests. While these pipelines demonstrated reasonable
performance on well-separated cohorts, their reliance on predefined features
limits their capacity to capture novel spatial patterns not available in the
chosen summary statistics. The demonstrated effectiveness of CNNs across
a broad range of medical imaging tasks @litjensSurvey2017 prompted their
adaptation to DaTscan classification, with the public availability of the
PPMI dataset @marekParkinson2011 providing the primary training resource.

In fact, most published DaTscan deep-learning studies rely on the publicly
available PPMI cohort, making it the de facto benchmark dataset for
methodological comparisons.

/* reference some papers/works here, there have to be some that you have not
* found, this section needs some more references. */

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
SPECT volumes, offering feature representations more semantically aligned
with the target task than ImageNet features.

=== Explainability

A recurring limitation of deep learning models in clinical settings is their
opacity: a model may achieve high classification accuracy without providing
any explanation of which image regions or features drove its decision, which
is a significant barrier to clinical adoption. Two complementary techniques
dominate the interpretability literature in this context.

- Gradient-weighted Class Activation Mapping (Grad-CAM) computes a coarse
  spatial map highlighting the image regions that most influenced a specific
  prediction, by weighting the feature maps of a convolutional layer by the
  gradient of the class score with respect to those maps @selvarajuGradCAM2017.

- SHAP (SHapley Additive exPlanations) provides complementary
  feature-level explanations for both classical and deep models by assigning
  each input feature a contribution score derived from cooperative game theory
  @lundbergUnified2017.

In the DaTscan context, Grad-CAM can reveal whether a CNN attends to
anatomically plausible regions, such as the posterior putamen, while SHAP
can identify which tabular clinical variables carry the most predictive weight.
Incorporating these tools alongside classification performance metrics is
increasingly expected in clinical machine learning work, and both are applied in
this thesis.


== Multimodal Neuroimaging with Clinical Variables

/* 
* previously 'Multimodal Fusion with Clinical Variables'
* TODO: change contents. Feeback:
* this needs more works to be cited, not just PPMI and another. If not enough
* papers/references can be found, then this subsection should be removed
* */

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
literature, where combining structural MRI with cognitive test scores and
genetic risk factors has consistently outperformed single-modality approaches
@youngAccurate2013. For Parkinson's disease, the PPMI dataset
@marekParkinson2011 provides a uniquely rich resource for multimodal
experiments: alongside DaTscan SPECT volumes, it collects motor
assessments (MDS-UPDRS), olfactory testing (UPSIT), cognitive
screening, and biospecimen markers from a standardized longitudinal cohort.
Despite this richness, the added diagnostic value of combining imaging with
clinical variables for binary PD classification remains incompletely
characterized in the literature.

== Research Gap
// this section is ok

The present work addresses two specific gaps in the existing literature. First,
direct comparisons of 2D projection-based, 2.5D multi-axis, and 3D volumetric
CNN architectures under identical preprocessing and evaluation conditions
remain relatively uncommon in the DaTscan literature. Second, the complementary
diagnostic value of tabular clinical variables (motor function, olfactory
sensitivity, and demographics) combined with DaTscan-derived image features has
not been rigorously quantified for binary healthy control versus manifest
PD classification. This project contributes both evaluations using
PPMI as a standardized benchmark.
