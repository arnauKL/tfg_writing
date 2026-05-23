#import "../assets/ak_tfg_lib.typ": *

// From the tfg_geb_guide:
/*
## Hipòtesis i objectius

Aquest capítol ha de descriure pregunta de recerca que s’està adreçant, la
hipòtesis que li dona suport i els objectius concrets del TFG que hi donen
resposta. Al tractar-se d’un treball de recerca, cal destacar-ne l’interès
científic de la comunicat, la novetat, la rellevància, i qüestions de viabilitat
dins de l’abast del TFG.

Exemple 1:
- Pregunta de recerca: Com es compara l’ecografia polsada de baixa intensitat
  (LIPUS) amb un dispositiu placebo per gestionar els símptomes de pacients
  madurs esquelèticament amb tendinopatia rotuliana?
- Hipòtesis: Els nivells de dolor es redueixen en pacients que reben LIPUS actiu
  (tractament) durant 12 setmanes en comparació amb els individus que reben
  LIPUS inactiu (placebo).
- Objectiu: Investigar l'eficàcia clínica de LIPUS en el tractament dels
  símptomes de la tendinopatia rotular.
*/

// Other examples:
// 0.5 pages Agatha
// 2.3 pages Lisa
// 2.0 pages Rania
// .75 pages Reglà

/* Agatha's (Structural and Functional Connectivity in Alzheimer’s Patients: A
* Harmonious Approach): well... This is the whole thing:
Studies show that harmonic decomposition methods (connectome harmonics and
functional harmonics) can be used to examine brain dynamics in altered states.
This leads us to think that the same methods can be applied to analyze brain
diseases, such as Alzheimer’s, and may offer insights into how brain activity
changes in these conditions. Based on this, the objective of the present study
is to:

1. Use harmonic decomposition methods to analyze the structural and functional
   brain connectivity in a group of individuals from three categories: healthy
   controls (HC), mild cognitive impairment (MCI), and Alzheimer’s disease
   patients (AD).

2. Investigate the relationship between structural and functional connectivity
   in these groups and determine how Alzheimer’s disease affects the normal
   brain dynamics.

3. Compare the brain activity in healthy individuals and Alzheimer’s patients,
   quantifying the differences in brain network organization.

Given this, our hypothesis is that: using harmonic decomposition, we can
significantly distinguish between the brain activity patterns of healthy
controls, MCI, and Alzheimer’s disease patients. We expect to find alterations
in both the structural and functional brain networks of Alzheimer’s patients,
with specific disruptions in the normal harmonic brain patterns that may
correlate with disease progression. */


/* Lisa's (The Role of Rare long-Range Cortical Connections in Alzheimer's
* Disease: Simulatoin and analysis):
## Research Question

Can turbulence-informed brain models incorporating long-range coupling detect
functional alterations between healthy controls, individuals with mild cognitive
impairment (MCI), and Alzheimer’s disease (AD)?

## Hypothesis
The functional brain dynamics of individuals with AD will show signiﬁcantly
reduced turbulence and long-range coordination compared to healthy controls.
This loss of dynamical complexity will also be observable --- although to a lesser
degree ---  in MCI subjects, potentially enabling early-stage di erentiation. More
speciﬁcally:
- H1: The inclusion of long-range structural connections in whole-brain models
  increases sensitivity to functional alterations in AD.
- H2: Turbulence-related metrics (e.g., metastability, local/global synchrony,
  complexity) are signiﬁcantly lower in AD compared to HC and MCI.
- H3: These turbulence-based measures can discriminate between groups,
  potentially serving as early indicators of neurodegeneration.

## Objectives
**General Objective**:
To assess whether turbulence-based whole-brain models incorporating long-range
structural coupling can detect altered brain dynamics in Alzheimer’s disease.

**Speciﬁc Objectives**:
1. Implement and validate a distance-based connectivity model that integrates
   long-range projections into whole-brain simulations using ADNI data.
2. Compute turbulence metrics (metastability, synchrony, entropy) from simulated
   BOLD signals for each subject.
3. Compare these metrics across diagnostic groups (HC, MCI, AD) to identify
   statistically signiﬁcant di erences.
4. Evaluate the potential of turbulence-informed measures as early functional
   biomarkers for AD.

## Scientiﬁc Interest and Relevance
This research investigates a promising intersection between dynamical systems
theory and clinical neuroscience, aiming to better understand how Alzheimer’s
disease impacts the brain’s functional dynamics. Unlike many traditional studies
that focus mainly on structural atrophy or average functional connectivity
reductions, this project highlights the potential of turbulence-inspired metrics
derived from whole-brain computational models. These models, grounded in
structural connectivity data and enhanced by incorporating long-range coupling,
enable the simulation of rich, complex brain dynamics that closely mimic
resting- state activity observed empirically.

The scientiﬁc signiﬁcance of this approach lies in its ability to detect early
disruptions in large-scale brain coordination—changes that may precede visible
structural damage on conventional imaging. By using turbulence-based metrics
such as metastability, entropy, and synchrony, the analysis captures a
multidimensional and time-resolved portrait of brain function, revealing
transient and subtle alterations in network dynamics. If validated, this
methodology could contribute to earlier diagnosis, better monitoring of disease
progression, and the design of personalized interventions focused on restoring
the brain’s dynamical ﬂexibility. Additionally, it adds to the expanding ﬁeld
that seeks to connect theoretical neuroscience models with practical clinical
applications.

## Feasibility

This project is well within the scope of a ﬁnal-year undergraduate thesis,
primarily thanks to the availability of high-quality, preprocessed data and
mature computational tools. The analysis utilizes a subset of subjects from the
Alzheimer’s Disease Neuroimaging Initiative (ADNI)- a widely respected, openly
accessible dataset that includes di usion-weighted MRI and resting-state fMRI
data paired with clinical diagnoses. The chosen subset, ADNI_A, categorizes
individuals into healthy controls (HC), mild cognitive impairment (MCI), and
Alzheimer’s disease (AD), allowing for systematic comparison across these
clinical groups. Methodologically, the project relies on existing software
frameworks like WholeBrain and NeuroNumba, which o er ready-made capabilities
for whole-brain modeling, integration of structural connectivity, and
computation of turbulence metrics. Simulations and analyses can be run on a
standard personal computer, and no additional data acquisition is necessary. The
novelty lies in how these tools are applied and adapted to explore this speciﬁc
question rather than developing new software from scratch. Overall, the project
is both technically and logistically feasible within the timeline and academic
requirements of the thesis.
*/

/* Rania's (Segmentació del Nucli Estriat en Imatges de Datscan i
MRI per Optimitzar el Diagnòstic del Parkinson):
## Pregunta de recerca
Com podem millorar la precisió i la fiabilitat del diagnòstic precoç de la malaltia de Parkinson a través de
la integració de la ressonància magnètica (RM) i la tecnologia Datscan cerebral, amb el suport de tècniques
avançades d’intel·ligència artificial i visió per computador?

## Hipòtesi
La integració de la informació estructural procedent de la ressonància magnètica (RM) i el Datscan cerebral,
combinada amb l’ús de tècniques d’intel·ligència artificial, permetrà una millor detecció i caracterització
del nucli estriat, millorant l’estratificació dels pacients amb Parkinson, facilitant un diagnòstic més precoç i
precís.

## Objectius
- Estudi de l’anatomia del nucli estriat: Analitzar en detall l’estructura
  anatòmica del nucli estriat, centrar-se en els seus components principals: el
  putamen i el caudat.
- Familiarització amb l’eina FSL (FMRIB Software Library): Adquirir coneixements
  sobre el funcionalment i aplicacions del software FSL per a l’anàlisi
  d’imatges cerebrals.
- Segmentació d’imatges de ressonància magnètica (MRI) amb First FSL: Utilitzar
  First FSL per segmentar imatges de MRI per estudiar les característiques
  estructurals del nucli estriat.
- Segmentació d’imatges de Datscan utilitzant segmentació no supervisada:
  Aplicar tècniques de segmentació no supervisada, incloent-hi K-means,
  Thresholding, i el mètode d’Otsu, per processar imatges de Datscan.
- Registre d’imatges de Datscan i MRI: Implementar tècniques de registre
  d’imatges per alinear les imatges de Datscan amb les de MRI i facilitar
  anàlisis comparatives.
- Anàlisi de l’àrea d’intersecció entre les màscares de MRI i Datscan: Examinar
  l’àrea on coincideixen les màscares obtingudes de la segmentació de MRI i
  Datscan per determinar la consistència i la precisió de les tècniques de
  segmentació usades.
- Mesura de la intensitat en la intersecció de les màscares de MRI i Datscan:
  Quantificar la intensitat de la captació en l’àrea on coincideixen les
  màscares obtingudes de la segmentació de MRI i Datscan per avaluar la
  rellevància i la precisió de la captació observada en les tècniques de
  segmentació aplicades.

// Esquema desenvolupament de treball
// Here she just pasted a random image of the segmentation pipeline and called
// it done.
*/

/* Reglà (Disseny i Implementació d'un Model per a la Millora de la Segmentació
* de Teixits Cerebrals en Imatges MRI amb Informació Longitudinal per a l'Estudi
* de l'Alzheimer):
## Pregunta de recerca
Com pot un model d’aprenentatge profund, que integri informació cross-seccional i longitudinal, millorar la
robustesa i precisió de la segmentació cerebral en imatges MRI T1w, facilitant la comparació entre
pacients amb Alzheimer i controls sans?

## Hipòtesi
La incorporació d’un mòdul subjecte-específic i l’ús de dades basals i de seguiment en una arquitectura
U-Net 3D millorarà significativament la consistència temporal de les segmentacions cerebrals, superant en
precisió i eficiència a l’estat de l’art (12, 13).

## Objectius
1. Explorar models existents de segmentació longitudinal i identificar els
   beneficis i limitacions que tenen.
2. Dissenyar i implementar un model d’aprenentatge profund.
  a. Disseny: Integrar dades basals i de seguiment.
  b. Crear i utilitzar dades sintètiques per entrenar el model.
3. Validar el model amb dades reals i avaluar-ne la robustesa.
4. Comparar el model amb mètodes d’estat de l’art.
5. Desenvolupar un pipeline automatitzat per a inferència.
6. Garantir un ús ètic de les dades.

## Rellevància i impacte esperat
*/

/* Mine:
= Hypothesis and Goals
// no clue

== Research question
Is it feasible to incorporate CNNs into medical processes to improve
diagnostic accuracy, reduce visual diagnostic subjectivity on diagnosis based on
DaTscan images.
// maybe?

== Hypotehsis
CNNs can be used to accurately classify healthy from Parkinson's patients using
DaTscan only.
Multimodal data can improve this even further if available.
// Tbh I don't even know what's my hypothesis

== Objectives (or should I translate this as 'goals'?)
- Guarantee an ethical use of data.
*/

= Hypothesis and Objectives

== Research Question

Current clinical interpretation of DaTscan images relies on subjective visual
assessment by nuclear medicine specialists, supplemented in research settings by
semi-quantitative metrics such as the Striatal Binding Ratio (#smol[SBR])
computed from predefined regions of interest. The issue, as mentioned, is that
traditional semi-quantitative metrics may discard diagnostically relevant
spatial information. This thesis addresses the following research question:

#quote[
  Can end-to-end #smol[CNN]s operating on the complete DaTscan image volume
  perform better than traditional machine learning methods that use manually
  crafted semi-quantitative features for the binary classification of
  Parkinson's disease compared to healthy controls? Additionally, does
  incorporating multimodal clinical variables offer a significant diagnostic
  advantage over imaging alone?
]

== Hypothesis

The central hypothesis is that a #smol[CNN] trained end-to-end on DaTscan images
will learn richer and more discriminative spatial representations than those
captured by semi-quantitative #smol[SBR] features, and that performance can be
further improved by incorporating complementary clinical information that is
not visible in the image. This is operationalized through the following
specific hypotheses:

/ H1: #smol[CNN] superiority over classical baselines. A #smol[CNN] classifier
  operating on the raw DaTscan volume will achieve higher AUC and
  classification accuracy than classical machine learning models (SVM, Logistic
  Regression) trained on #smol[SBR]-derived features.

/ H2: Transfer learning compensates for data scarcity. In a data-limited
  regime (\~250 subjects), leveraging pretrained weights will improve
  generalization relative to training a 3D #smol[CNN] from scratch, since
  pretrained representations provide r better initialization than random
  weights.
  
/ H3: Raw images are more informative than registered images. DaTscan images
  in native acquisition space (unregistered) will yield equal or better
  classification performance than spatially normalized images.
  // ni idea, per afegir algo

/ H4: Multimodal fusion improves upon imaging alone. Combining DaTscan-derived
  image embeddings with tabular clinical variables --- motor function
  (MDS-UPDRS III), olfactory sensitivity (UPSIT), cognitive screening (MoCA),
  and demographics (age, sex) --- will yield higher classification performance
  than either modality alone.

== Objectives

=== General Objective

To systematically evaluate deep learning-based approaches for automated
classification of Parkinson's disease from DaTscan #smol[SPECT] images, and to
quantify the diagnostic information gain achievable through multimodal fusion
with clinical variables, using the PPMI dataset as a standardized benchmark.

=== Specific Objectives

+ *Establish a classical ML baseline.* Train and evaluate SVM and Logistic
  Regression classifiers on semi-quantitative DaTscan features (#smol[SBR]
  values) and multimodal clinical variables from the PPMI dataset.

+ *Compare #smol[CNN] architectures of different dimensionality and pretraining
  strategy.* Implement and evaluate multiple #smol[CNN] variants. Identify
  which combination of dimensionality and pretraining strategy best suits the
  available data size.

+ *Assess the effect of spatial registration.* Compare classification
  performance on registered (spatially normalized) versus raw (native space)
  DaTscan images to determine whether spatial normalization is beneficial or
  detrimental in this context.

+ *Evaluate multimodal fusion strategies.* Implement and compare fusion
  strategies to quantify the marginal diagnostic value of each clinical
  modality.

+ *Ensure ethical and reproducible use of data.* Conduct all experiments in
  accordance with the PPMI data use agreement, using stratified cross-validation to avoid data leakage,


== Scientific Relevance and Expected Impact

The clinical motivation for this work is immediate. DaTscan is currently
interpreted by visual assessment in most clinical centres, a process that is
time-intensive, requires specialized expertise, and produces non-negligible
inter-reader disagreement — particularly for borderline cases in early
disease. An automated, objective classifier that operates directly on the full
image volume could serve as a consistent second reader, reducing diagnostic
uncertainty and standardizing reporting across sites. In the longer term,
such tools could lower the expertise threshold required to interpret
dopamine transporter scans, broadening their clinical utility.

From a methodological standpoint, this thesis contributes to the growing
literature on #smol[CNN]-based DaTscan analysis in several ways. The systematic
comparison of 2D, 2.5D, and 3D approaches under controlled conditions — same
dataset, same cross-validation scheme, same evaluation metrics — provides
evidence that is directly actionable for practitioners designing similar
systems. The finding that a 2.5D ImageNet-pretrained approach can outperform
a purpose-built 3D medical network is counterintuitive and speaks to the
critical role of dataset size in architecture selection: strong priors from
large-scale pretraining may outweigh domain specificity when labeled medical
data are scarce. The comparison of registered versus raw images similarly
challenges a common preprocessing assumption in neuroimaging pipelines. And
the systematic decomposition of multimodal gains by clinical feature group
provides quantitative evidence for the relative diagnostic contribution of
motor, olfactory, cognitive, and demographic variables — information that is
clinically interpretable and actionable.
