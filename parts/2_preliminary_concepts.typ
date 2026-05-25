#import "../assets/ak_tfg_lib.typ": *

= Preliminary Concepts

// Rough outline:
// 
//== Parkinson's Disease
// Epidemiology: prevalence, age of onset
// Pathophysiology: focus on neurodegeneration in the substantia nigra and its
// projection to the striatum. Explain why dopamine loss in the striatum is
// what DaTscan measures
//== DaTscan (#super[123]Ioflupane)
// Explain the mechanism (DAT transporter binding, SPECT imaging)
// what the resulting images look like (comma vs period visual)
// why it produces the image pattern the CNN will learn to classify
// The PPMI protocol docs and original validation papers are adequate here
//== Convolutional Neural Networks (CNNs)
// X n Adrià: Should I explain basics like perceptrons and connections?
// Start with convolutional layers and explain the inductive bias that makes
// them suited to images (local feature detection, translation invariance,
// hierarchical features.
// Show the convolution equation, but frame it in terms of what it does rather
// than what it is (whatever that means).
// Then pooling, activation functions and the overall architecture concept
//== Evolution of CNNs in Medical Imaging
// Cover LeNet -> AlexNet, then talk about the shift to deeper architectures
// (VGG, ResNet with its residual connections), and then the specific adoption
// in medical imaging.
// The Litjens et al. 2017 survey "A survey on deep learning in medical image
// analysis" is the canonical citation here and covers everything you need.
//== Clasical Machine learning
// SVM, logistic regression

== Parkinson's Disease

=== Overview and Epidemiology

// This paragraph is shit
While the global scaling of Parkinson's disease presents a clear macroeconomic 
crisis, its clinical footprint is highly dependent on demographic vectors. The 
disorder exhibits a stark age-dependent incidence profile, with a median age of 
onset centered around 60 years, though young-onset cases present distinct 
clinical challenges. Furthermore, epidemiological data consistently reveal a 
sex-based divergence, with men affected at an approximate ratio of 1.5:1
compared to women @poeweParkinson2017. 

The structural burden of PD is characterized not only by healthcare-related 
expenditures but also by the hidden economic toll of informal caregiving and 
premature labor force departure. Because the clinical diagnosis is preceded by an 
extended prodromal phase, patients frequently navigate a costly diagnostic
journey before arriving at a confirmed classification @faulkEconomic. Developing
highly objective, automated screening tools is therefore essential to alleviate
both the clinical bottlenecks and the compounding economic strains on healthcare
infrastructure.


=== Pathophysiology: The Nigrostriatal Dopaminergic System

The central pathological event in PD is the progressive degeneration of
dopaminergic neurons in the _substantia nigra pars compacta_ (SNpc), a pigmented
region of the midbrain named for the dark neuromelanin granules visible on gross
anatomy (see @dauer_pathway_fig). These neurons form the nigrostriatal pathway,
projecting their axons to terminate in the striatum, a subcortical structure
composed of the caudate nucleus and the putamen, where they release dopamine as
a neuromodulatory signal within the basal ganglia motor circuit
@dauerParkinsons2003.

#figure(
  //image("../assets/figures/preliminary_concepts/Nigrostriatal_pathway.svg",
  image("../assets/figures/preliminary_concepts/Nigrostriatalpathway.svg",
  width: 50%),
  caption: [
    Coronal schematic comparison of the nigrostriatal pathway under normal conditions 
    and in Parkinson's disease, illustrating the preferential loss of dopaminergic projections 
    to the putamen and caudate nucleus (dashed lines). Adapted from
    @dauerParkinsons2003 (pg. 891). 
  ]
) <dauer_pathway_fig>

Within the basal ganglia, dopamine modulates two antagonistic pathways: a
"direct" or "go" pathway that facilitates movement by disinhibiting the
thalamus, and an "indirect" or "stop" pathway that suppresses competing motor
programs. Adequate dopamine levels maintain a functional balance between these
pathways, enabling smooth, voluntary motion. As SNpc neurons progressively
degenerate and striatal dopamine falls, this balance shifts toward inhibition,
resulting in the motor deficits characteristic of PD @dauerParkinsons2003.

A clinically critical feature of this process is that motor symptoms do not show
until the neurodegenerative process is already advanced. This means there is a
substantial presymptomatic period during which pathology is actively progressing
but patients are asymptomatic and diagnosis is not possible with current
clinical criteria alone.

At the cellular level, the hallmark histopathological finding is the
accumulation of Lewy bodies: intraneuronal protein aggregates composed primarily
of misfolded alpha-synuclein (aSyn). 

=== Clinical Presentation and Diagnosis

The cardinal motor features of PD: bradykinesia (obligatory for diagnosis under
MDS criteria), resting tremor, rigidity, and postural instability, form the
basis of clinical evaluation @tolosaChallenges2021. In early disease, motor
signs are typically asymmetric, reflecting the asymmetric onset of nigrostriatal
degeneration, and a clear positive response to levodopa replacement therapy
provides additional diagnostic support.
// onset is such a cool word

PD also produces a range of non-motor symptoms that frequently predate the motor
phase by years. Hyposmia (reduced olfactory sensitivity, assessed in this thesis
using the UPSIT score), 
// Should I explain UPSIT here or later
REM sleep behavior disorder, constipation, and affective
symptoms such as depression and anxiety belong to this prodromal syndrome and
are increasingly used in research criteria for preclinical PD
@tolosaChallenges2021. The presence of these markers in subjects without motor
symptoms is of direct relevance to the #smol[PPMI] cohort structure and to the
multimodal features used in this thesis (see #redt[_próximamente en cines_]).

The primary diagnostic challenge is the clinical overlap with conditions that
mimic parkinsonism: essential tremor (#smol[ET]), drug-induced parkinsonism 
(#smol[DIP]), and atypical parkinsonian syndromes such as multiple system 
atrophy (#smol[MSA]), progressive supranuclear palsy (#smol[PSP]), and 
corticobasal syndrome (#smol[CBS]). Consequently, the overall clinical accuracy of a 
purely symptom-based PD diagnosis remains vulnerable to initial 
misinterpretation, especially during early presentation. To resolve this diagnostic 
ambiguity, dopamine transporter (DaTscan) imaging has become a vital 
objective adjunct to confirm or rule out an underlying neurodegenerative 
syndrome associated with dopamine deficiency (#smol[NSDD]).

The real-world impact of this modality on clinical management was demonstrated
by Isaacson et al., who examined a cohort of 201 consecutive patients
presenting with clinically questionable #smol[NSDD]. The investigators
identified that DaTscan imaging provides crucial clarity across an array of
ambiguous clinical scenarios, including patients with subtle early symptoms,
prominent action tremors, suspected #smol[DIP], or a suboptimal response to
levodopa. Notably, imaging also unmasked misdiagnoses in individuals who had
carried a PD label for three to five years but failed to show the expected
clinical progression or motor fluctuations. Within this uncertain cohort,
DaTscan categorized 58.7% of the cases as abnormal, 37.8% as normal, and only
3.5% as inconclusive. Crucially, these objective findings reoriented clinical
directions, altering the definitive diagnosis in 39.8% of patients and
directly driving medication therapy modifications in 70.1% of cases @isaacsonImpact2021.


== DaTscan: Imaging the Dopamine Transporter

=== Mechanism

The dopamine transporter (DAT) is a membrane-bound monoamine transporter
expressed exclusively on the terminals of presynaptic dopaminergic neurons. Its
physiological role is to recycle released dopamine back into the neuron; its
density in the striatum therefore directly reflects the density of viable
nigrostriatal terminals and, by extension, the degree to which the pathway has
been preserved or destroyed @palermoDopamine2021.

DaTscan uses #super[123]I-ioflupane (#super[123]I-FP-CIT), a radiolabeled
cocaine analogue with high affinity for the DAT. Following intravenous
injection, the tracer crosses the blood-brain barrier and binds preferentially
to DAT in the striatum. Single Photon Emission Computed Tomography
(#smol[SPECT]) acquisition, typically performed 3–6 hours post-injection to
allow clearance of non-specific binding, reconstructs a three-dimensional map of
tracer uptake. This map serves as a surrogate for the functional integrity of
the nigrostriatal dopaminergic projection @booijAppropriate2013.

The European Medicines Agency approved #super[123]I-ioflupane in 2000 (trade
name DaTscan); the U.S. FDA followed in 2011 (trade name DaTscan). It remains
the only approved in vivo imaging biomarker for parkinsonian syndromes in
clinical practice.


=== Image Characteristics

In a healthy brain, DaTscan produces a characteristic pattern of high bilateral
tracer uptake forming "comma" shapes: the dense head of each comma corresponds
to the caudate nucleus, and the tapered body to the posterior putamen. In PD,
because neurodegeneration begins predominantly in the posterior putamen (the
subregion receiving projections from the motor cortex) the comma loses its tail
before it loses its head, resulting in an asymmetric pattern progressively
reduced to isolated caudate @booijAppropriate2013. In advanced disease, uptake
is globally and bilaterally diminished. This topographic progression is the
visual basis on which clinical readers classify scans.

#figure(
  box(
    width: 80%,
    grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    image("../assets/figures/preliminary_concepts/HC_example_41.svg"),
    image("../assets/figures/preliminary_concepts/PD_example_33.svg")
  )),
  caption: [side-by-side DaTscan axial slices showing normal bilateral
_comma_ pattern (left, healthy patient) vs. asymmetric _period_ pattern of PD
(right, diagnosed patient).]
) <datscan_image_compare>

// is spare ok here or have I gone too fansi
Conditions that spare the presynaptic dopaminergic terminal, notably essential
tremor and drug-induced parkinsonism, produce normal DaTscan images, making the
scan a powerful discriminator between dopamine-deficiency and non-deficiency
parkinsonism, even when clinical features are indistinguishable.


// Add sentence explaining why posterior putamen is affected first clinically

=== Semi-Quantitative Analysis

The spatial complexity of DaTscan images is commonly reduced to a set of scalar
metrics. The Striatal Binding Ratio (#smol[SBR]) is the most widely used
paradigm, defined as:

$
"SBR" = ("Striatal counts" - "Background counts")/"Background counts" ,
$

where background activity is typically measured in the occipital cortex, a
region demonstrating negligible #smol[DAT] expression. #smol[SBR] values are
computed separately for the caudate, anterior putamen, and posterior putamen
within each hemisphere, as implemented in the DaTQUANT software utiliated by the
#smol[PPMI] dataset @neillPractical2021 @malyPerformance2025.

Semi-quantitative #smol[SBR] provides an objective, reproducible numerical
summary of tracer binding that correlates with disease severity and disease
duration, and forms the basis of the classical machine learning baseline in this
thesis. However, it compresses the full spatial information of the
three-dimensional #smol[SPECT] volume into at most a handful of regional means,
inevitably discarding information about the spatial distribution of uptake
within regions, asymmetry patterns, and subtle texture changes that may be
diagnostically informative.

These SBR-derived features constitute the basis of the classical ML baselines evaluated in this thesis.

=== Clinical Utility and Limitations

A 2021 systematic review confirmed that DaTscan led to a change in clinical
management in approximately half of patients tested and altered the final
diagnosis in roughly one third @begaClinical2021, evidence of its practical
diagnostic impact. Nevertheless, several limitations apply. DaTscan cannot
differentiate PD from other neurodegenerative parkinsonian syndromes, all of
which reduce nigrostriatal terminal density. Furthermore, like any imaging
biomarker, DaTscan is normal in the presymptomatic phase before sufficient
neurodegeneration has accumulated, and in rare cases may be normal even in
clinically confirmed PD. These limitations motivate automated image-based
approaches.

// pdt revisar

/*

== Classical ML for Parkinson's Classification

Before the current era of deep learning, automated analysis of DaTscan images
typically followed a two-stage pipeline: extract a compact set of handcrafted
features from the image, then train a classical classifier on those features. In
this thesis, the classical baseline operates on the semi-quantitative SBR
features derived by DaTQUANT, putamen and caudate binding ratios and their
hemispheric asymmetries, combined with multimodal clinical variables including
MDS-UPDRS III (motor severity), UPSIT (olfaction), MoCA (cognition), age, and
sex.

Three classical classifiers are employed:

*Support Vector Machine (SVM).* An SVM learns a maximum-margin hyperplane in the
feature space that separates the two classes. For non-linearly separable data,
the kernel trick implicitly maps features into a higher-dimensional space where
a linear boundary suffices. SVMs generalize well in high-dimensional settings
and with limited data, making them a natural baseline for medical applications
//with small cohort sizes @cortes1995.

*Logistic Regression (LR).* LR is a linear binary classifier
that models the log-odds of class membership as a linear function of the input
features, producing calibrated probability estimates. Its simplicity and
interpretability make it a standard reference point in clinical machine
learning.

These classical baselines serve a dual purpose: they establish the diagnostic
information available from the handcrafted SBR features alone, and they provide
the comparison against which the added complexity of end-to-end CNN learning
must be justified. SHAP (SHapley Additive exPlanations) analysis applied to the
trained classical models further quantifies the relative contribution of each
feature to the classification decision, informing the feature selection strategy
for the multimodal fusion experiments.

== Convolutional Neural Networks

=== From Perceptron to Spatial Feature Learning

The foundational processing unit of a neural network is the perceptron: a model
that computes a weighted sum of its inputs and passes the result through a
nonlinear activation function $sigma$:

$ hat(y) = sigma(bold(w)^T bold(x) + b) $

where $bold(w)$ are learnable weights, $bold(x)$ is the input vector, and $b$ is
a bias term. Stacking multiple layers of such units creates a multilayer
perceptron (MLP), which can in principle approximate any continuous function.
However, applying MLPs directly to images is impractical: a flat vector of pixel
intensities contains no spatial structure, and the number of parameters grows
prohibitively with image resolution. A 128×128×128 voxel volume, such as those
processed in this thesis, would require hundreds of millions of parameters in a
single fully connected layer.

=== Convolutional Layers

Convolutional Neural Networks address this by replacing the dense weight matrix
with spatially local, shared filters (kernels). A 2D convolution of an input
feature map $X$ with a kernel $K$ of size $k times k$ is computed as:

$ (X * K)[i, j] = sum_(m=0)^(k-1) sum_(n=0)^(k-1) X[i+m, j+n] dot K[m, n] $

For volumetric data (as in 3D CNNs processing full SPECT volumes), the same
principle extends to three spatial dimensions. Two properties of this operation
encode powerful inductive biases about natural images. _Local connectivity_
means each output value depends on only a small receptive field rather than the
entire input, reflecting the fact that visual features are spatially local.
_Weight sharing_ means the same filter is applied at every spatial location,
which provides translation equivariance — a filter trained to detect a feature
//in one part of the image can detect it anywhere @lecun1998. These properties
allow CNNs to learn spatial patterns efficiently from far fewer parameters than
a fully connected network would require.

In practice, a convolutional layer learns many filters in parallel, each
producing a separate feature map that highlights different local patterns. After
convolution, a pointwise nonlinearity — typically the Rectified Linear Unit,
ReLU: $sigma(x) = max(0, x)$ — is applied, followed optionally by a pooling
operation (usually max-pooling) that downsamples the feature map spatially,
increasing the effective receptive field of subsequent layers and introducing
//mild translation invariance @lecun1998.

=== Hierarchical Feature Extraction

By stacking convolutional, activation, and pooling layers, a CNN progressively
transforms raw voxel intensities into increasingly abstract representations.
Early layers respond to primitive local patterns — edges, intensity gradients —
while intermediate layers detect compound structures such as curved surfaces or
locally textured regions. Deeper layers encode higher-level semantic concepts
relevant to the classification task: in the DaTscan context, the shape and
symmetry of the striatal uptake pattern, the relative intensity of the putamen
relative to the caudate, and the sharpness of the boundary between specific and
non-specific uptake. The final layers are typically fully connected and produce
a probability distribution over the target classes via a sigmoid (binary case)
or softmax (multiclass) output.

=== Landmark Architectures

The deep learning revolution in computer vision is conventionally dated to 2012,
//when AlexNet @krizhevsky2012 — an eight-layer CNN trained on 1.2 million
ImageNet images using GPU-accelerated backpropagation — won the ImageNet
Large-Scale Visual Recognition Challenge (ILSVRC) with a top-5 error rate that
was approximately 10 percentage points below the prior state of the art. AlexNet
demonstrated conclusively that deep end-to-end trained CNNs, given sufficient
data and compute, vastly outperform handcrafted feature pipelines.

//VGGNet @simonyan2014 extended this insight by showing that very deep networks
(16--19 layers) built entirely from small 3×3 convolutional filters achieved
strong performance, establishing architectural depth as a key design principle.

//ResNet @he2016 then resolved the fundamental obstacle to training very deep
networks: the vanishing gradient problem, in which gradients shrink
exponentially as they backpropagate through many layers, preventing early layers
from learning effectively. The ResNet solution — _residual connections_ (skip
connections) -- adds the input of a block directly to its output:

$ bold(y) = F(bold(x)) + bold(x) $

where $F(bold(x))$ represents the residual mapping learned by the stacked
layers. This identity shortcut allows gradients to flow directly to earlier
layers during backpropagation, enabling stable training of networks with 50,
//101, or 152 layers @he2016. ResNet-18 and ResNet-50 variants are used in this
thesis, both as the backbone of the
2.5D fusion model (pretrained on ImageNet) and as the architecture underlying
MedicalNet.

== Deep Learning in Medical Imaging

=== Adoption and Domain-Specific Challenges

Following AlexNet's breakthrough, CNN-based methods rapidly displaced
handcrafted feature pipelines across virtually every domain of medical image
analysis. By the mid-2010s, deep learning was delivering state-of-the-art
performance in chest X-ray classification, skin lesion grading, retinal disease
detection, and neuroimaging analysis, as comprehensively surveyed by Litjens et
//al. @litjens2017. Applied to DaTscan specifically, CNN classifiers trained on
PPMI data have achieved AUC values above
//0.95 across several published studies @kurmi2022 — motivating the present work.

However, medical imaging presents challenges that do not arise on natural image
benchmarks. The most critical is data scarcity: expert-annotated medical images
are expensive to acquire and curate, and most clinical datasets number in the
hundreds of subjects rather than the millions available in ImageNet. This makes
regularization, data augmentation, and transfer learning essential design
choices rather than optional refinements. Class imbalance, domain shift across
acquisition sites, and the three-dimensional nature of volumetric scans further
complicate the naive application of architectures designed for 2D RGB
photographs.

/*
== Transfer Learning

=== Motivation

Training a deep CNN from scratch requires large quantities of labeled data to
achieve robust generalization. When labeled data are scarce — as is inherently
the case in clinical imaging studies — the model can easily memorize the
training set without learning generalizable representations. Transfer learning
addresses this by initializing the network with weights learned on a large
auxiliary dataset, rather than randomly, before fine-tuning on the target task
@pan2010.

The justification is hierarchical feature reuse: the early and intermediate
layers of a CNN trained on any large visual dataset learn to detect general
patterns — edges, textures, color gradients — that are useful across diverse
image domains. Only the deeper, task-specific layers need substantial
adaptation. Beginning training from a good initialization rather than noise
reduces the effective optimization problem to learning a relatively small
correction to an already informative representation.

=== Transfer from ImageNet

The de facto source dataset for transfer learning is ImageNet @deng2009, a
corpus of approximately 1.3 million natural images across 1,000 object
categories. Pretrained weights for ResNet, VGG, InceptionNet, and related
architectures are freely available and have been shown in numerous studies to
improve performance in data-limited medical imaging regimes @raghu2019. The
domain gap between natural RGB photographs and medical scans is real — different
intensity statistics, different image structure, grayscale rather than color —
but low-level features such as edge detectors transfer across this gap, and the
improved initialization reliably outperforms random initialization when data is
limited @raghu2019.

In this thesis, the 2.5D model fine-tunes a ResNet18 pretrained on ImageNet. The
three MIP channels effectively mimic the RGB input format expected by the
pretrained network, allowing the pretrained convolutional filters to be applied
without architectural modification.

=== Transfer from Medical Imaging Data: MedicalNet

An alternative is to pretrain on medical imaging data directly, eliminating the
domain gap. MedicalNet (also referred to as Med3D in the implementation) is a
ResNet-10 backbone pretrained on 23 heterogeneous medical image segmentation
datasets, including SPECT, MRI, and CT data @chen2019. Pretraining on in-domain
data is expected to provide representations that are more semantically aligned
with the target task than ImageNet features.

In this thesis, a MedicalNet backbone is fine-tuned for binary DaTscan
classification by replacing the segmentation head with a global average pooling
layer followed by a fully connected classification head. Results are compared
against the ImageNet- pretrained 2.5D approach to assess whether domain-specific
pretraining compensates for the reduced dataset size used for the pretraining
backbone relative to ImageNet.
*/

== Multimodal Learning: Combining Images with Clinical Data

=== Rationale

A DaTscan image captures a single modality of a fundamentally multidimensional
clinical picture. The neurologist diagnosing PD synthesizes imaging findings
with the motor examination, olfactory testing, cognitive screening, patient
history, and demographic context — never relying on a single source of
information. Multimodal machine learning formalizes this integration by
combining representations from multiple data streams within a single predictive
model, aiming to capture complementary information that no individual modality
//fully provides @acosta2022.

In the PPMI dataset, rich tabular clinical variables are available alongside
DaTscan images for each subject. The features used in this thesis include
MDS-UPDRS III (quantitative motor function), UPSIT (olfactory sensitivity, a
well-validated prodromal PD marker), MoCA (cognitive screening), and demographic
variables (age, sex). Each captures a different biological dimension of PD:
motor, sensory, cognitive, and epidemiological.

=== Fusion Strategies

// Three main fusion paradigms are recognized in the literature @li2024:

*Early fusion* concatenates raw features from all modalities into a single input
before any processing. In the image-plus-tabular setting this is rarely
practical because the image and tabular representations live in very different
spaces.

*Late fusion* trains independent models for each modality and combines their
output predictions, for example, by averaging predicted probabilities or
learning a meta-classifier on the combined outputs. This approach is modular and
computationally inexpensive: existing single-modality models can be reused
without retraining. In this thesis, late fusion averages the probability output
of the best CNN model with that of a logistic regression trained on the tabular
features.

// this is the guillem mode:
*Intermediate (feature-level) fusion* extracts learned representations from each
modality and merges them before the classification head. The image branch
produces a compact embedding vector from the CNN backbone; the tabular branch
transforms clinical variables through a small MLP; the two embeddings are
concatenated and passed through a joint classification head. This Y-shaped
architecture allows each branch to learn a suitable representation of its
modality before integration, and is the second fusion strategy evaluated in this
thesis. The CNN backbone is frozen during fusion training, which limits
overfitting on the small labeled dataset.

potential figure here?
fusion architecture diagram of the Y-shaped intermediate fusion
network: CNN branch (frozen ResNet18 backbone) producing a 512-dim embedding,
tabular MLP branch, concatenation, and shared classification head]

== Evaluation Metrics

Given the binary classification setup (PD vs. HC) and the use of balanced
datasets, four standard metrics are reported throughout. The _Area Under the ROC
Curve_ (AUC) provides a threshold-independent summary of discriminative
performance, ranging from 0.5 (chance) to 1.0 (perfect separation); it is the
primary reported metric. _Accuracy_ measures the fraction of correctly
classified samples and is interpretable when classes are balanced. _Sensitivity_
(recall) measures the fraction of true PD cases correctly identified —
clinically the most important metric, since a missed PD diagnosis has serious
consequences for the patient. _Specificity_ measures the fraction of healthy
controls correctly classified as such. In settings where the dataset is balanced
by downsampling, accuracy and balanced accuracy coincide.

All experiments use stratified $k$-fold cross-validation (2-fold for initial
architecture screening, 5-fold for final evaluation), with the best model per
fold selected by validation AUC. Performance is reported as mean $plus.minus$ standard
deviation across folds, and boxplots are used to visualize the fold-level
distribution of each metric.
*/
