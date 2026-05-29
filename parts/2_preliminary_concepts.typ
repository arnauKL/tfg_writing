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
// mechanism (DAT transporter binding, SPECT imaging)
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

Parkinson's disease (PD) is the second most common neurodegenerative disorder
after Alzheimer's disease, affecting more than 10 million people worldwide. Its
prevalence increases markedly with age, with onset typically occurring after 60
years of age, although earlier forms also exist. Epidemiological studies
consistently report a higher incidence in men than in women, with a
male-to-female ratio of approximately 1.5:1. @poeweParkinson2017

Clinically, PD is characterized by a progressive combination of motor and
non-motor symptoms resulting from degeneration of the nigrostriatal dopaminergic
system. As life expectancy increases globally, the number of individuals living
with PD is expected to continue rising, creating a growing healthcare burden and
motivating the development of objective diagnostic and monitoring tools.

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
phase by years. Hyposmia, REM sleep behavior disorder, constipation, and
affective symptoms such as depression and anxiety belong to this prodromal
syndrome and are increasingly used in research criteria for preclinical PD
@tolosaChallenges2021.

The primary diagnostic challenge is the clinical overlap with conditions that
mimic parkinsonism: essential tremor (ET), drug-induced parkinsonism 
(DIP), and atypical parkinsonian syndromes such as multiple system 
atrophy (MSA), progressive supranuclear palsy (PSP), and 
corticobasal syndrome (CBS). Consequently, the overall clinical accuracy of a 
purely symptom-based PD diagnosis remains vulnerable to initial 
misinterpretation, especially during early presentation. To resolve this diagnostic 
ambiguity, dopamine transporter (DaTscan) imaging has become a vital 
objective adjunct to confirm or rule out an underlying neurodegenerative 
syndrome associated with dopamine deficiency (NSDD).

Several studies have demonstrated that DaTscan imaging substantially influences
clinical decision-making in diagnostically uncertain cases, frequently leading
to changes in diagnosis and treatment strategy. @isaacsonImpact2021

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
(SPECT) acquisition, typically performed 3–6 hours post-injection to
allow clearance of non-specific binding, reconstructs a three-dimensional map of
tracer uptake. This map serves as a surrogate for the functional integrity of
the nigrostriatal dopaminergic projection @booijAppropriate2013.

The European Medicines Agency approved #super[123]I-ioflupane in 2000 under the
trade name DaTscan); the United States' FDA followed in 2011. It remains the
only approved in vivo imaging biomarker for parkinsonian syndromes in clinical
practice.


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
metrics. The Striatal Binding Ratio (SBR) is the most widely used
paradigm, defined as:

$
"SBR" = ("Striatal counts" - "Background counts")/"Background counts" ,
$

where background activity is typically measured in the occipital cortex, a
region demonstrating negligible DAT expression. SBR values are computed
separately for the caudate, anterior putamen, and posterior putamen within each
hemisphere, as implemented in the DaTQUANT software utiliated by the PPMI
dataset @neillPractical2021 @malyPerformance2025.

Semi-quantitative SBR provides an objective, reproducible numerical summary of
tracer binding that correlates with disease severity and disease duration.
However, it compresses the full spatial information of the three-dimensional
SPECT volume into at most a handful of regional means, inevitably discarding
information about the spatial distribution of uptake within regions, asymmetry
patterns, and subtle texture changes that may be diagnostically informative.

=== Clinical Utility and Limitations

A 2021 systematic review confirmed that DaTscan led to a change in clinical
management in approximately half of patients tested and altered the final
diagnosis in roughly one third @begaClinical2021, evidence of its practical
diagnostic impact. Nevertheless, several limitations apply. DaTscan cannot
differentiate PD from other neurodegenerative parkinsonian syndromes, all of
which reduce nigrostriatal terminal density. Furthermore, like any imaging
biomarker, DaTscan is normal in the presymptomatic phase before sufficient
neurodegeneration has accumulated, and in rare cases may be normal even in
clinically confirmed PD. These limitations motivate both automated image-based
as well as multimodal approaches including other imaging and non-imaging
biomarkers.

// pdt revisar

== Classical machine learning for PD Classification

Before the current era of deep learning, automated analysis of DaTscan images
typically followed a two-stage pipeline: extract a compact set of handcrafted
features from the image, then train a classical classifier on those features.

Several classical classifiers are commonly employed:

*Support Vector Machine (SVM).* An SVM learns a maximum-margin hyperplane in the
feature space that separates the two classes. For non-linearly separable data,
the kernel trick implicitly maps features into a higher-dimensional space where
a linear boundary suffices. SVMs generalize well in high-dimensional settings
and with limited data, making them a natural baseline for medical applications
with small cohort sizes @cortesSupportvector1995.

*Logistic Regression (LR).* LR is a linear binary classifier
that models the log-odds of class membership as a linear function of the input
features, producing calibrated probability estimates. Its simplicity and
interpretability make it a standard reference point in clinical machine
learning.

*Random Forest.* Random Forest is an ensemble learning method that combines the
predictions of multiple decision trees trained on random subsets of the data and
features. By averaging across many trees, the model reduces variance and
typically achieves better generalization than a single decision tree.

*Gradient Boosting.* Gradient Boosting constructs an ensemble sequentially, with
each new tree focusing on correcting the errors of the previous ones. This
iterative process often produces highly accurate predictive models while
remaining applicable to heterogeneous clinical data.


== Convolutional Neural Networks (CNN)

The foundational processing unit of a neural network is the perceptron: a model
that computes a weighted sum of its inputs and passes the result through a
nonlinear activation function $sigma$:

$ hat(y) = sigma(w^T x + b) " " , $

where $w$ are learnable weights, $x$ is the input vector, and $b$ is a bias
term. Stacking multiple layers of such units creates a multilayer perceptron
(MLP), which can in principle approximate any continuous function. However,
applying MLPs directly to images is impractical: a flat vector of pixel
intensities contains no spatial structure, and the number of parameters grows
exponentially with image resolution.

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
which provides translation equivariance, a filter trained to detect a feature
in one part of the image can detect it anywhere @lecunGradientbased1998. These properties
allow CNNs to learn spatial patterns efficiently from far fewer parameters than
a fully connected network would require.

In practice, a convolutional layer learns many filters in parallel, each
producing a separate feature map that highlights different local patterns. After
convolution, a pointwise nonlinearity, typically the Rectified Linear Unit,
ReLU: $sigma(x) = max(0, x)$, is applied, followed optionally by a pooling
operation (usually max-pooling) that downsamples the feature map spatially,
increasing the effective receptive field of subsequent layers and introducing
mild translation invariance @lecunGradientbased1998.

By stacking convolutional, activation, and pooling layers, a CNN progressively
transforms raw voxel intensities into increasingly abstract representations.
Early layers respond to primitive local patterns such as edges and intensity
gradients, while intermediate layers detect compound structures such as curved
surfaces or locally textured regions.

Deeper layers encode higher-level concepts relevant to the classification task:
in the DaTscan context, the shape and symmetry of the striatal uptake pattern or
the relative intensity of the putamen relative to the caudate. The final layers
are typically fully connected and produce a probability distribution over the
target classes via a sigmoid (binary case) or softmax (multiclass) output.

=== Landmark Architectures

The deep learning revolution in computer vision is conventionally dated to 2012,
when AlexNet @krizhevskyImageNet2017 @Google (an eight-layer CNN trained on 1.2 million
ImageNet images) won the ImageNet Large-Scale Visual Recognition Challenge
(ILSVRC) with a top-5 error rate that was approximately 10 percentage points
below the prior state of the art. AlexNet demonstrated conclusively that deep
end-to-end trained CNNs, given sufficient data and compute, vastly outperform
handcrafted feature pipelines.

VGGNet @simonyanVery2015 extended this insight by showing that very deep
networks (16--19 layers) built entirely from small $3 times 3$ convolutional
filters achieved strong performance, establishing architectural depth as a key
design principle.

ResNet introduced residual connections, which allow information and gradients to
bypass intermediate layers through identity shortcuts. These connections
mitigate the vanishing gradient problem and enable the successful training of
substantially deeper networks. ResNet architectures remain among the most widely
used CNN backbones in both natural-image and medical-imaging applications
@heDeep2016.

== Deep Learning in Medical Imaging

=== Adoption and Domain-Specific Challenges

Following AlexNet's breakthrough, CNN-based methods rapidly displaced
handcrafted feature pipelines across virtually every domain of medical image
analysis /*source for this???*/. By the mid-2010s, deep learning was delivering
state-of-the-art performance in chest X-ray classification, skin lesion grading,
retinal disease detection, and neuroimaging analysis @litjensSurvey2017. Applied
to DaTscan specifically, CNN classifiers trained on PPMI data have achieved AUC
values above 0.95 across several published studies @kurmiEnsemble2022.

However, medical imaging differs from conventional computer vision in several
important respects. Datasets are typically smaller, annotations require expert
clinicians, and images are frequently three-dimensional rather than
two-dimensional. These constraints increase the risk of overfitting and make
transfer learning particularly attractive.

=== 2D, 2.5D, and 3D Architectures

The most common approach in the literature converts the 3D SPECT volume
into a 2D representation and applies architectures pretrained on ImageNet
@dengImageNet2009. Variants include selecting axial slices that prominently
display the striatum, computing maximum intensity projections (MIPs)
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

Volumetric 3D CNNs process the full SPECT volume directly and
preserve all spatial context, which is in principle better suited to capture the
pattern of striatal degeneration. In practice, however, 3D models lead to
substantially higher memory usage and computational costs while requiring larger
training sets to avoid overfitting.

== Transfer Learning

=== Motivation

Training a deep CNN from scratch requires large quantities of labeled data to
achieve robust generalization. When labeled data are scarce the model can easily
memorize the training set without learning generalizable representations.
Transfer learning addresses this by initializing the network with weights
learned on a large auxiliary dataset, rather than randomly, before fine-tuning
on the target task @panSurvey2010.

The early and intermediate layers of a CNN trained on any large visual dataset
learn to detect general patterns that are useful across diverse image domains.
Only the deeper layers need adaptation. Beginning training from a done
initialization rather than random weights reduces the optimization problem to
learning a correction to an already informative representation.

=== Transfer from ImageNet

The de facto source dataset for transfer learning is ImageNet @dengImageNet2009, a
corpus of approximately 1.3 million natural images across 1,000 object
categories. Pretrained weights for ResNet, VGG, InceptionNet, and related
architectures are freely available and have been shown in numerous studies to
improve performance in data-limited medical imaging regimes
@raghuTransfusion2019. The
domain gap between natural RGB photographs and medical scans is present 
but low-level features such as edge detectors transfer across this gap.

=== Transfer from Medical Imaging Data: MedicalNet

An alternative is to pretrain on medical imaging data directly, eliminating the
domain gap. MedicalNet is a ResNet-10 backbone pretrained on 23 heterogeneous
medical image segmentation datasets, including SPECT, MRI, and CT data
@chenMed3D2019. Pretraining on in-domain data is expected to provide
representations that are more semantically aligned with the target task than
ImageNet features.

== Multimodal Learning

=== Rationale

A DaTscan image captures a single modality of a fundamentally multidimensional
clinical picture. The neurologist diagnosing PD synthesizes imaging findings
with the motor examination, olfactory testing, cognitive screening, patient
history, and demographic context. Multimodal machine learning formalizes this
integration by combining representations from multiple data streams within a
single predictive model, aiming to capture complementary information that no
individual modality fully provides @doanBridging2026.

=== Fusion Strategies

Three main fusion paradigms are recognized in the literature @liReview2024:

*Early fusion* concatenates raw features from all modalities into a single input
before any processing. In the image-plus-tabular setting this is rarely
practical because the image and tabular representations live in very different
spaces.

*Late fusion* trains independent models for each modality and combines their
output predictions, for example, by averaging predicted probabilities or
learning a meta-classifier on the combined outputs. This approach is modular and
computationally inexpensive: existing single-modality models can be reused
without retraining. 

// this is the guillem mode:
*Intermediate (feature-level) fusion* extracts learned representations from each
modality and merges them before the classification head. The image branch
produces a compact embedding vector from the CNN backbone; the tabular branch
transforms clinical variables through a small MLP; the two embeddings are
concatenated and passed through a joint classification head. This Y-shaped
architecture allows each branch to learn a suitable representation of its
modality before integration. The CNN backbone is frozen during fusion training,
which limits overfitting on the small labeled dataset.
