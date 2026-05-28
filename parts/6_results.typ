#import "../assets/ak_tfg_lib.typ": *

/*
* En aquest capítol es proporcionaran els resultats obtinguts, i s’explicaran
* respecte als 
diferents escenaris d’experimentació descrits a l’apartat “Materials i mètodes”
*/

= Results

== Classical ML Baseline

=== Raw vs Engineered Features, Balanced vs Weighted

Given how imbalanced the PPMI dataset was towards PD patients, one of the first
major steps was evaluating how different balancing methods affected classifier
behavior (refer to @eng-vs-raw-manual-vs-auto). The two compared approaches were
manually balancing the dataset by dropping extra PD patients until achieving a
strict 1:1 ratio for HC:PD, and using sklearn's `compute_sample_weight` utility to
automatically adjust weights inversely proportional to class frequencies
@Compute_sample_weight.

When using the automatic sample weighting, the models exhibited a stark
divergence between Macro Precision and Macro Recall. Across almost all
classifiers (particularly the SVM and Logistic Regression models) the weighted
datasets yielded high Precision scores but sharply lower Recall scores.
Conversely, the manually balanced datasets (represented by the green and red
boxes in @eng-vs-raw-manual-vs-auto) resulted in a notable increase in Macro
Recall, stabilizing performance across both metrics and resulting in higher
overall Balanced Accuracy and F1 scores, particularly for the Random Forest and
Gradient Boosting classifiers.



#figure(
  image("../assets/figures/results/classic_ml_compare_all_models_raw_deriv_eng_raw.svg"),
  // caption: redt[Boxplot comparing performance of different classical ML models,
  // using both manually balanced and weighted (automatic) balancing and raw
  // DaTscan-derived indicators only (classification based on only 4 indicators) or
  // adding in 4 new values derived from these (AI, SBR, etc)]
  caption: [Five-fold cross-validation performance comparison across classical
  ML models. The subplots evaluate manual dataset balancing (1:1 HC/PD ratio)
  versus automatic sample weighting across five evaluation metrics, contrasting
  raw DaTscan-derived indicators against feature-engineered variants.]
)<eng-vs-raw-manual-vs-auto>

/*
On the discussion section:
The "Orange vs. Blue" Gap: In the Precision (macro) plot, there is a massive jump from blue to orange for SVM RBF, SVM Lin, and LR. This shows feature engineering explicitly helps linear/distance-based models separate the classes better under weighted conditions.

The "Red vs. Green" Stability: In the Balanced Accuracy and F1 plots, the red bars generally have higher medians and tighter interquartile ranges (IQRs) than the green bars, indicating that feature engineering reduces variance and stabilizes the tree-based models (RF and GB).
* */


Engineered features consistently outperform raw across
all classifiers and both balancing strategies.

The best model is the SVM RBF (using a non-linear kernel), which reached ana
ccuracy of
Mention SVM RBF engineered balanced ,the one with best AUC, bal.acc, etc



=== SHAP Analysis

== CNN Architecture Comparison

=== All Architectures: Raw and Registered

=== Raw versus Registered

=== GradCAM Visualisation

== Multimodal Fusion: Classical ML

=== Information Gain by Feature Group

=== SHAP on Best Multimodal Configuration

== Multimodal Fusion: CNN

=== Late Fusion vs Feature-Level Fusion

== SWEDD Inference
