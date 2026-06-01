// Arnau K. Deprez: source file of the summary.
#import "assets/ak_summary_lib.typ": *
#show: ak_summ.with(
  title: [A Comparative Study of Deep Learning Architectures for Parkinson's
  Disease Classification from DaTscan],
  shorttitle: [DL Classification of Parkinson's Disease (DaTscan)],
  subsubtitle: [Bachelor's Thesis],
  tutor: "Adrià Casamitjana Díaz",
  author: "Arnau K. Deprez Santamaria",
)

#set page(numbering: "i") // this forces reset on pdf viewers too

// ------- typst regexes -------
#import "assets/regex.typ": apply-regex-rules
#show: apply-regex-rules

#place(top + right, dy: +0%, { image("assets/UdG_dues_linies_centrat_blau.svg", width: 20%) })
#set par(justify: false, first-line-indent: 0em)

#box(width: 75%, text(.65em)[
  = A Comparative Study of Deep Learning Architectures for Parkinson’s Disease Classification from DaTscan: Summary
])

#{
  v(3%, weak: true)
  emph([Supervisor]) + h(.5em) + smallcaps[Adrià Casamitjana Díaz]
  v(1.25%, weak: true)
  emph([Author]) + h(.5em) + smallcaps[Arnau K. Deprez Santamaria]
}

#v(4%, weak: true)

Department of Computer Architecture and Technology \
Bachelor's Degree in Biomedical Engineering \
June 2026

#set par(justify: true, first-line-indent: 1.4em)

#v(2%, weak: true)

== Introduction

Parkinson’s disease (PD) is the second most common neurodegenerative disorder
worldwide and affects millions of individuals. It is characterized by the
progressive degeneration of dopaminergic neurons in the _substantia nigra_,
resulting in both motor symptoms and non-motor manifestations that can precede
diagnosis by many years. Because no definitive laboratory test exists,
diagnosis remains largely clinical and can be challenging, particularly during
the early stages of the disease.

Among the available imaging techniques, DaTscan SPECT imaging plays a central
role in assessing the integrity of the nigrostriatal dopaminergic pathway. By
visualizing dopamine transporter (DAT) availability in the striatum, DaTscan
provides an in vivo biomarker of dopaminergic degeneration and is widely used
to support the differential diagnosis of parkinsonian syndromes (see
@datscan_image_compare). However, scan interpretation still depends largely on
expert visual assessment, which can introduce variability and limits
accessibility in centers lacking specialized expertise.

Recent advances in deep learning have enabled automated analysis of medical
images with ever increasing performance. In neuroimaging, convolutional neural
networks (CNNs) can learn complex spatial patterns directly from image volumes,
potentially eliminating the need for handcrafted biomarkers. Nevertheless, high
classification accuracy alone is insufficient in clinical settings;
understanding whether models rely on biologically meaningful features is
equally important.

This project investigates the use of deep learning for automated Parkinson’s
disease classification from DaTscan images and explores whether integrating
clinical information through multimodal learning can further improve diagnostic
performance.

#figure(
  box(
    width: 80%,
    grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    image("assets/figures/preliminary_concepts/HC_example_41.svg"),
    image("assets/figures/preliminary_concepts/PD_example_33.svg")
  )),
  caption: [Side-by-side DaTscan axial slices showing normal bilateral _comma_
  pattern (left, healthy patient) compared with the asymmetric _period_ pattern
  of PD (right, diagnosed patient).]
) <datscan_image_compare>


== Objectives and hypotheses

The general objective of this project is to evaluate deep learning-based
approaches for automated classification of Parkinson’s disease from DaTscan
SPECT images and to quantify the diagnostic value of combining imaging with
clinical variables. The specific objectives are:

+ Establish a classical machine learning baseline using semi-quantitative
   DaTscan biomarkers.
+ Compare CNN architectures of different dimensionality and pretraining
   strategies.
+ Evaluate the effect of spatial registration on classification performance.
+ Assess multimodal fusion strategies combining imaging and clinical data.
+ Ensure ethical and reproducible use of data.
+ Analyze model trustworthiness using explainability techniques.
+ Validate learned imaging representations through inference on unseen SWEDD
   patients.

Three main hypotheses guided the work:

/ H1: CNNs operating directly on DaTscan images will outperform classical
  machine learning models based on engineered features.
/ H2: Transfer learning will improve generalization under limited data
  availability.
/ H3: Combining imaging and clinical information will improve classification
  performance compared to either modality alone.

== Methodology

All experiments were conducted using data from the Parkinson’s Progression
Markers Initiative (PPMI), a large multicenter study containing imaging and
clinical information from Parkinson’s disease patients and healthy controls.
Three-dimensional DaTscan SPECT images and clinical and semi-quantitative variables derived from imaging and patient assessments were used.

The workflow consisted of four major stages:

+ Data preprocessing. Images were intensity-normalized and center-cropped
  around the striatal region. Both raw and spatially registered image versions
  were evaluated.
+ Classical machine learning baseline. Support Vector Machines, Random Forests,
  Logistic Regression, and Gradient Boosting models were trained using Striatal
  Binding Ratio (SBR) features and engineered biomarkers.
+ Deep learning experiments. Multiple CNN architectures were implemented,
  including custom 2D, 2.5D, and 3D networks, as well as transfer learning
  approaches based on ImageNet and MedicalNet pretrained models.
+ Multimodal fusion. Clinical variables were integrated using both
  feature-level fusion and late fusion strategies.

All models were evaluated using cross-validation. Performance was assessed
through ROC-AUC, accuracy, sensitivity, specificity, precision, and F1-score.
To evaluate interpretability, Grad-CAM visualizations were generated for all
CNN architectures.

== Results

=== Classical machine learning baseline

Classical machine learning models achieved remarkably strong performance using
semi-quantitative DaTscan features alone. Feature engineering consistently
improved results across all evaluated classifiers.

The best-performing model was an SVM with a radial basis function kernel,
achieving a median ROC-AUC of $0.991$. These findings demonstrate that
semi-quantitative DaTscan biomarkers already contain highly discriminative
information for distinguishing PD from HC patients.

=== CNN architecture comparison

Several CNN architectures were compared under identical preprocessing and
evaluation conditions. The highest numerical performance was achieved by a
custom 3D CNN, reaching an average AUC of $0.991 plus.minus 0.015$. Transfer
learning approaches also performed competitively despite the relatively small
dataset size.

Contrary to expectations, CNNs did not clearly outperform the classical SVM
baseline. This result partially refutes the first hypothesis and highlights the
strong predictive value of established DaTscan biomarkers.

=== Raw versus registered images

A consistent pattern emerged across all architectures: models trained on raw
images systematically outperformed those trained on spatially registered scans.

This finding suggests that the standard registration and normalization pipeline
utilized, while a robust and fundamentally valuable preprocessing convention,
may not have been fully optimized for the distinct structural characteristics
of this specific DaTscan cohort. Rather than implying that spatial
normalization is inherently disadvantageous, this result highlights that
off-the-shelf processing configurations can introduce interpolation and
smoothing effects that require precise tailoring to prevent the loss of
fine-grained, task-specific diagnostic features.

=== Explainability analysis

Although several 3D architectures achieved excellent classification
performance, Grad-CAM analysis revealed that many of them relied on image
regions outside the striatum.

In contrast, the 2.5D ResNet architecture pretrained on ImageNet consistently
focused on the caudate and putamen, which are the anatomical structures most
affected by Parkinson’s disease. While not the highest-scoring model
numerically, it emerged as the most clinically trustworthy architecture
evaluated in this work.

=== Multimodal Learning

The addition of clinical information improved classification performance in
both classical and deep learning frameworks.

Motor assessments (MDS-UPDRS) produced the largest performance gain, while
olfactory testing (UPSIT) emerged as the most informative non-motor biomarker.
Demographic variables and secondary biochemical biomarkers contributed little
additional information.

Among CNN-based approaches, late fusion consistently outperformed feature-level
fusion, likely because it is less susceptible to overfitting in relatively
small datasets.

=== SWEDD validation

To evaluate whether the selected CNN had learned genuine imaging biomarkers,
the best-performing trustworthy model was applied to an unseen cohort of SWEDD
patients (Scans Without Evidence of Dopaminergic Deficit).

Most SWEDD subjects were assigned low Parkinson’s disease probabilities and
clustered near healthy controls despite never being observed during training.
This result supports the conclusion that the network learned meaningful
dopaminergic imaging patterns rather than cohort-specific shortcuts.

#figure(
  gap: 0.5em,
  image("assets/figures/results/swedd_probabilities_violin.svg", width: 50%),
  caption: [Violin plot of predicted PD probabilities for HC, PD, and SWEDD
  cohorts. Individual patient predictions are overlaid as markers. A
  well-calibrated model assigning purely image-based decisions would place HC
  and SWEDD predictions near $0.0$ and PD predictions near $1.0$.]
)<violin_swedd>

== Conclusions

This study successfully evaluated diverse deep learning paradigms against
classical machine learning benchmarks, revealing that while end-to-end CNNs
achieve exceptional classification accuracy, they do not automatically
outperform classical classifiers trained on engineered semi-quantitative
biomarkers. This outcome partially refutes the initial hypothesis regarding the
absolute superiority of deep learning over traditional methods, highlighting
instead that established striatal binding metrics remain deeply robust and
highly discriminative tools in neuroimaging.

A central insight of this research is that raw performance metrics can mask
underlying shortcut learning within complex architectures. Although volumetric
3D configurations yielded the highest quantitative outputs, post-hoc
explainability analysis demonstrated that a pretrained 2.5D ResNet was the only
model to maintain a consistently localized, anatomically valid focus on the
striatal regions. This highlights a necessary requirement for clinical AI:
model selection must prioritize localized explainability and anatomical trust
over marginal statistical gains achieved by black-box alternatives. 

In conclusion, these findings suggest that deep learning architectures hold
meaningful potential for assisting in the evaluation of DaTscan imaging, while
emphasizing that raw performance metrics should not be reviewed in isolation
from interpretability. 
