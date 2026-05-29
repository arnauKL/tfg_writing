#import "../assets/ak_tfg_lib.typ": *

// Revision done

= Hypothesis and Objectives

== Research Question

Current clinical interpretation of DaTscan images relies on subjective visual
assessment by nuclear medicine specialists, supplemented in research settings by
semi-quantitative metrics such as the Striatal Binding Ratio (SBR)
computed from predefined regions of interest. The issue, as mentioned, is that
traditional semi-quantitative metrics may discard diagnostically relevant
spatial information. This thesis addresses the following research question:

#quote[
  Can end-to-end CNNs operating on the complete DaTscan image volume
  perform better than traditional machine learning methods that use manually
  crafted semi-quantitative features for the binary classification of
  Parkinson's disease compared to healthy controls? Additionally, does
  incorporating multimodal clinical variables offer a significant diagnostic
  advantage over imaging alone?
]

== Hypothesis

The central hypothesis is that a CNN trained end-to-end on DaTscan images
will learn richer and more discriminative spatial representations than those
captured by semi-quantitative SBR features, and that performance can be
further improved by incorporating complementary clinical information that is not
visible in the image. This can be rewritten into the following specific
hypotheses:

/ #smol[H1]: CNN superiority over classical baselines. A CNN classifier
  operating on the raw DaTscan volume will achieve higher AUC and
  classification accuracy than classical machine learning models (SVM, Logistic
  Regression) trained on SBR-derived features.

/ #smol[H2]: Transfer learning compensates for data scarcity. In a data-limited regime,
  leveraging pretrained weights will improve generalization relative to training
  a 3D CNN from scratch.

/ #smol[H3]: Multimodal fusion improves upon imaging alone. Combining DaTscan-derived
  markers with tabular clinical variables will yield higher classification
  performance than either modality alone.

== Objectives

=== General Objective

To systematically evaluate deep learning-based approaches for automated
classification of Parkinson's disease from DaTscan SPECT images, and to
quantify the diagnostic information gain achievable through multimodal fusion
with clinical variables, using the PPMI dataset as a standardized benchmark.

=== Specific Objectives

+ *Establish a classical ML baseline.* Train and evaluate classical machine
  learning classifiers on semi-quantitative DaTscan features (SBR values)
  and multimodal clinical variables from the PPMI dataset.

+ *Compare CNN architectures of different dimensionality and pretraining
  strategy.* Implement and evaluate multiple CNN variants. Identify
  which combination of dimensionality and pretraining strategy best suits the
  available data size.

+ *Assess the effect of spatial registration.* Compare classification
  performance on registered versus raw DaTscan images to determine whether
  spatial normalization is beneficial or detrimental in this context.

+ *Evaluate multimodal fusion strategies.* Implement and compare fusion
  strategies to quantify the added diagnostic value of each clinical modality.

+ *Ensure ethical and reproducible use of data.* Conduct all experiments in
  accordance with the PPMI data use agreement.


== Scientific Relevance and Expected Impact

The clinical motivation for this work is immediate. DaTscan is currently
interpreted by visual assessment in most clinical centres, a process that is
time-intensive, requires specialized expertise, and produces disagreement,
particularly for borderline cases in early disease. An automated classifier that
operates directly on the full image volume could serve as a consistent second
reader, reducing diagnostic uncertainty and standardizing reporting across
sites.
