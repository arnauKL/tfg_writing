#import "../ak_tfg_lib.typ": *

= State of the Art

The application of machine learning to neuroimaging for Parkinson's disease (PD)
diagnosis sits at the intersection of three relatively independent research
communities: clinical nuclear medicine, which has developed and validated
DaTscan as a diagnostic tool; computer vision and deep learning, which has
produced the architectures and training strategies used to process imaging data;
and multimodal learning, which studies how to combine heterogeneous data sources
to improve predictive performance. This section reviews the relevant prior work
across these three areas, and situates the present project within them.

== DaTscan as a Clinical Diagnostic Tool

DaTscan (#super[123]I-FP-CIT #caps[SPECT]) is a nuclear medicine imaging technique that
quantifies the density of dopamine transporters (#caps[DAT]) in the striatum,
specifically in the caudate nucleus and putamen. Because dopaminergic neurons
projecting to these structures progressively degenerate in Parkinson's disease,
a reduction in DAT binding provides a functional correlate of neurodegeneration
that is detectable before motor symptoms become clinically apparent
#text(red)[booij1997].
The tracer, ioflupane (#super[123]I), binds selectively to DAT proteins on presynaptic
terminals; the resulting SPECT images display the characteristic comma- or
crescent-shaped binding pattern of the healthy striatum, which progressively
loses asymmetry and ultimately collapses toward a rounded, faint signal in
advanced disease #text(red)[djang2012].

In clinical practice, DaTscan interpretation follows two complementary
approaches. The first is visual analysis, in which a trained nuclear medicine
physician or radiologist classifies the scan as normal or abnormal based on
shape and intensity of striatal uptake. The second is semi-quantitative
analysis, which computes a striatal binding ratio (SBR) by comparing tracer
uptake in the striatum to a reference region — typically the occipital cortex —
using automated software such as DaTQUANT #text(red)[djang2012]. Both approaches have
well-documented limitations. Visual reads are inherently subjective and exhibit
meaningful inter-rater variability, particularly for borderline cases
#text(red)[vlaar2007]. SBR quantification, while more reproducible, depends on atlas
registration and template assumptions, and its thresholds were established
primarily on advanced-stage cohorts, reducing its sensitivity in earlier disease
windows #text(red)[kagi2010].

These limitations are most acute precisely where they matter most: in the early
and prodromal stages of PD, when interventions would have the greatest
neuroprotective potential. Studies evaluating DaTscan sensitivity across disease
stages consistently report higher classification accuracy in established PD
compared to early or prodromal presentations #text(red)[vlaar2007]. This diagnostic gap
between clinical utility and clinical need provides the primary motivation for
developing automated, data-driven approaches capable of detecting subtler
patterns in DaTscan images.


== Deep Learning Applied to DaTscan

The use of deep learning for automated DaTscan classification has grown
substantially since 2019, driven primarily by the public availability of the
PPMI dataset #text(red)[marek2011 marek2018]. The existing literature can be broadly
organised by the dimensionality of the input representation (2D slice-based
versus full 3#smallcaps[D] volumes) and by the source of the learned features (training from
scratch versus transfer learning from natural image datasets).

=== 2D and Slice-Based Approaches

The earliest and most common approach in the literature converts the 3D SPECT
volume into a 2D representation and applies standard convolutional architectures
pretrained on ImageNet. Quan et al. #text(red)[quan2019] provided one of the first
systematic implementations of this paradigm, using InceptionV3 as a feature
extractor on a three-channel image constructed by concatenating the three axial
slices (indices 40–42) that most prominently display the striatal uptake region.
Applied to 659 PPMI subjects (449 PD, 210 non-PD) with ten-fold
cross-validation, the model achieved a weighted mean validation accuracy of
#lin[96.45%]. Crucially, the authors noted substantial overfitting: training accuracy
was near 100% while validation loss remained notably higher, a pattern
consistent with the small effective sample size once a single fold is held out.

Subsequent work extended this template in a number of directions. Kurmi et al.
#text(red)[kurmi2022] trained an ensemble of four ImageNet-pretrained architectures —
VGG16, ResNet50, InceptionV3 and Xception — and combined their output scores via
a fuzzy fusion rule on the same PPMI data, reporting an ensemble accuracy of
98.45%. While the reported figures are high, the validation methodology in this
and similar papers merits scrutiny: several works in this space do not enforce
strict subject-level data splits across folds, meaning that longitudinal
follow-up scans from the same patient can appear in both training and evaluation
sets, substantially inflating reported performance. A more methodologically
careful reading of such results is warranted when drawing comparisons.

A related direction concerns explainability. Using VGG16 on DaTscan images from
PPMI, Mridha et al. #text(red)[mridha2020] complemented binary classification with LIME
(Local Interpretable Model-Agnostic Explanations) to produce heatmaps
highlighting the image regions most influential in the model's decision. Such
approaches are important for clinical credibility, even if they do not yet
address the core limitation of 2D representations: by selecting a small number
of axial slices, they discard the majority of volumetric information present in
the SPECT acquisition.

=== 3D and Volumetric Approaches

The natural alternative is to process the full 3D volume directly. Ramirez et
al. #text(red)[ramirez2020] applied 3D CNNs to SPECT images for joint classification of
Alzheimer's disease and PD, demonstrating that volumetric models can extract
discriminative features that slice-based methods miss, particularly in
subcortical structures that are spatially distributed across many slices. More
recently, a dedicated 3D-CNN pipeline for DaTscan #text(red)[yasaka2025] applied rigorous
preprocessing — background intensity removal, patch-wise denoising, and
striatum-centred cropping — before training on PPMI volumes, arguing that
careful preprocessing is at least as important as architectural choice when
working with nuclear medicine images. A parallel line of work
#text(red)[cai2024]
approached PD stage prediction as a multiclass problem using both
2D-slice-sequence models (treating axial slices as frames in a temporal sequence
fed to 2D CNNs pretrained on ImageNet) and 3D CNNs pretrained on Kinetics-400.
Incorporating an attention mechanism to weight slices by their diagnostic
informativeness, and training across two independent SPECT cohorts
simultaneously via weight sharing, they demonstrated that the 2D-sequence
approach with attention was competitive with full 3D models while requiring
substantially less memory.

This architectural diversity in the literature underscores an unresolved
question: whether the spatial context captured by 3D convolutions justifies the
increased computational cost and data requirements relative to well-designed 2D
projections. The present work contributes empirical evidence to this question by
systematically comparing from-scratch 3D CNNs, 2D projection-based models, and a
2.5D architecture on the same PPMI cohort under identical evaluation conditions.

=== Common Limitations

Across the DaTscan deep learning literature, several recurring limitations are
worth noting. First, the vast majority of studies frame the problem as binary
classification between manifest PD and healthy controls — a setting where the
clinical question is already largely resolved by conventional methods. The
harder and more clinically relevant problem of distinguishing prodromal or
early-stage subjects from controls, or of performing multiclass staging across
prodromal, manifest PD, and healthy cohorts, remains largely unaddressed.
Second, most published models rely on subject cohorts drawn exclusively from
PPMI without systematic cross-dataset validation, raising questions about
generalisability. Third, imaging data alone is rarely sufficient in a clinical
context: a patient presenting for DaTscan evaluation arrives with a full
clinical history, motor assessments, olfactory test results, and demographic
information — yet the literature almost uniformly discards this context. The
question of whether integrating such non-imaging information can improve or
complement imaging-based classification is the subject of the following section.


== Multimodal Fusion in Neuroimaging

The recognition that neurological diseases manifest across multiple biological
levels — structural, functional, genetic, and clinical — has driven considerable
interest in multimodal learning frameworks that combine complementary data
sources. The fusion of imaging with tabular clinical or biomarker data is
particularly relevant here, and has been explored most extensively in the
Alzheimer's disease literature, from which methodological insights transfer
naturally to Parkinson's disease.

=== Fusion Strategies

Multimodal fusion approaches are commonly categorised by the stage at which
modalities are combined. In early (or feature-level) fusion, representations
from different modalities are merged before the final classification step,
typically by concatenating feature vectors extracted from each modality
#text(red)[spasov2019]. This allows the model to learn joint representations, but requires
careful normalisation and imposes a strong assumption that the feature spaces
are compatible. In late (or decision-level) fusion, each modality produces an
independent prediction, and these predictions are then combined — typically by
averaging, voting, or a trained meta-classifier #text(red)[xu2020]. Late fusion is simpler
to implement and more robust to missing modalities at inference time, which is a
practically important property in clinical settings where not every patient will
have every data type. Intermediate fusion strategies, which combine
modality-specific feature extractors with shared layers, offer a middle ground
but require careful architectural design to prevent one modality from dominating
the learned representation.

=== Alzheimer's Disease as a Template

The Alzheimer's disease field provides a mature body of work on
imaging-plus-clinical multimodal fusion. Spasov et al. #text(red)[spasov2019] combined
structural MRI features with tabular clinical variables including cognitive test
scores, genetic risk factors (APOE), and demographic data in a
parameter-efficient architecture for predicting conversion from mild cognitive
impairment (MCI) to AD. Their work demonstrated that even simple feature-level
concatenation of imaging and tabular features consistently outperformed either
modality alone, and that the clinical variables contributed most strongly in
borderline cases where imaging alone was ambiguous. This observation is
particularly relevant to the present project, where the prodromal PD stage is
precisely such a borderline setting.

=== Multimodal PD Classification from PPMI

Within the PD literature, Dentamaro et al. #text(red)[dentamaro2024] conducted the most
directly comparable multimodal study to the present work. Using the PPMI
database, they investigated prodromal PD detection by combining 3D brain MRI
with clinical variables via a joint co-learning fusion approach — end-to-end
training of separate imaging and clinical sub-networks whose representations are
merged before the classification head. Testing several 3D architectures (ResNet,
DenseNet, Vision Transformer), they found that DenseNet augmented with an
Excitation Network module achieved the highest accuracy, and that adding
clinical data produced a substantial and consistent performance gain over the
imaging-only baseline. Explainability analysis confirmed that the fusion model
attended to brain regions consistent with known prodromal pathophysiology,
lending biological plausibility to the results.

A complementary line of work #text(red)[xia2024] investigated feature-level and
decision-level fusion of MRI with genetic SNP profiles from PPMI, finding that
decision-level fusion was more robust when the two modalities had different
effective dimensionalities — a practical consideration that informs the choice
of fusion strategy in the present work. More broadly, a systematic review of
machine learning applied to PPMI data #text(red)[llano2023] concluded that
multimodal and
longitudinal data, which constitute the dataset's unique strength, remain
underutilised in the majority of published studies, and that future work should
prioritise principled fusion strategies over single-modality approaches.

The present project directly addresses this gap: by combining DaTscan-based CNN
features with tabular clinical variables from PPMI — motor assessments (UPDRS),
olfactory testing (UPSIT), and demographic factors — and by evaluating fusion
across three classification settings (binary HC vs. PD, binary HC vs. prodromal,
and multiclass staging), it seeks to characterise both the independent and
complementary contributions of imaging and non-imaging data.


== The PPMI Dataset

The Parkinson's Progression Markers Initiative (PPMI) is a longitudinal,
observational, multicentre study initiated in 2010 by the Michael J. Fox
Foundation, with the primary objective of identifying biomarkers of PD
progression across clinical, imaging, biospecimen, and genetic domains
#text(red)[marek2011]. The original cohort comprised approximately 400 recently diagnosed
PD patients and 200 healthy controls followed across 21 clinical sites, with
standardised data acquisition protocols designed to enable cross-site
comparability #text(red)[marek2011].

Since its inception, PPMI has expanded substantially. The 2018 update
#text(red)[marek2018]
described an enlarged cohort that introduced genetically defined and prodromal
subgroups alongside the original symptomatic PD and healthy control arms, making
PPMI one of the few publicly available datasets with a meaningful number of
prodromal subjects. This expansion is critical for the present project, which
targets the prodromal stage as its most clinically challenging classification
setting. For the imaging component, all DaTscan acquisitions were performed with
¹²³I-FP-CIT following a standardised protocol, with images reconstructed and
registered to MNI space, yielding 3D volumes of 91 $times$  109 $times$ 91 voxels.

Non-imaging variables available in PPMI include the MDS-UPDRS motor scale, the
University of Pennsylvania Smell Identification Test (UPSIT), cognitive
assessments, biospecimen markers, and demographic and genetic information.

The richness of the PPMI dataset has attracted substantial machine learning
research over the past decade, comprehensively reviewed by Llano et al.
#text(red)[llano2023]. Importantly, that review highlighted that most published work uses
only a subset of available modalities and that the multimodal depth of the
dataset has rarely been fully exploited. The present project uses the PPMI
cohort in the configuration described in Section~[Materials and Methods],
comprising healthy controls (HC, N=336), manifest PD patients (PD, N=1475), and
prodromal PD subjects (pPD, N=2456).


== Summary and Research Gap

The literature reviewed above reveals a consistent pattern: deep learning
applied to DaTscan has progressed from simple 2D slice-based transfer learning
toward volumetric 3D models and, more recently, multimodal fusion with clinical
variables. However, several important gaps remain. Binary HC-vs.-PD
classification dominates the published landscape, even though this is the least
demanding clinical scenario; the prodromal stage, where automated tools would
add most clinical value, has received far less attention. Systematic comparison
of 2D, 3D, and intermediate (2.5D) architectures under controlled conditions is
largely absent. And while multimodal fusion with clinical data has been shown to
improve performance #text(red)[dentamaro2024], the specific contribution of DaTscan imaging
— as opposed to MRI — in a multimodal pipeline has not been characterised on
this scale. The present work is designed to address these gaps directly.
