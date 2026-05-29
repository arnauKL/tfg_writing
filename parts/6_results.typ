#import "../assets/ak_tfg_lib.typ": *

/*
* En aquest capítol es proporcionaran els resultats obtinguts, i s’explicaran
* respecte als 
diferents escenaris d’experimentació descrits a l’apartat “Materials i mètodes”
*/

// This chapter is still a draft, needs revision to avoid sounding like a monke

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


#redt[Following these findings, I'll be using manually balanced datasets from
this point onward since the weighted counterparts seem to still introduce
preference for the most prevalent class (PD here).]

#figure(
  image("../assets/figures/results/classic_ml_compare_all_models_raw_deriv_eng_raw.svg"),
  caption: [Five-fold cross-validation performance comparison across classical
  ML models. The subplots evaluate manual dataset balancing (1:1 HC/PD ratio)
  versus automatic sample weighting across five evaluation metrics, contrasting
  raw DaTscan-derived indicators against feature-engineered variants.]
)<eng-vs-raw-manual-vs-auto>

When it comes to raw features (only the 4 direct DaTscan-derived indicators) vs
engineered data adding 4 more indicators derived from these previous ones, the
results are higher across all metrics for the engineered (orange and red sets
come on top of blue and green on @eng-vs-raw-manual-vs-auto).

In the Balanced Accuracy and F1 plots, the red bars generally have higher
medians and tighter interquartile ranges (IQRs) than the green bars and orange
better more so than blue bars, indicating that feature engineering reduces
variance and stabilizes the tree-based models (RF and GB).

This shows feature engineering explicitly helps models separate the classes
better under weighted conditions.

Now, isolating only the data with engineered and manually balanced (see
@only_man_eng_allmodels
The best model is the SVM RBF (using a non-linear kernel), which reached an
AUC of $0.988 plus.minus 0.005$, a balanced accuracy of $0.974$ and F1 of $0.983$



#figure(
  image("../assets/figures/results/comparison_models_only.svg"),
  caption: [Five-fold cross-validation performance comparison across classical
  ML models. The tighter the boxplot, the more consistent the model, while the
  closer to 1.000 it ranks, the better.]
)<only_man_eng_allmodels>

The most consistent and high-scorer of the classical ML classifiers is the SVM
with non-linear kernel (the left-most model in the subplots in
@only_man_eng_allmodels). Across every metric, SVM RBF sits at the top. Its
median ROC-AUC is nearly perfect ($0.998$), and its median for the other metrics
hovers around $0.983$. It is also the most consistent across all metrics (smallest
boxplot in all subplots in @only_man_eng_allmodels. A tighter box means the
model is stable; it performs almost identically regardless of which subset of
data it is trained on.


== CNN Architecture Comparison

=== All Architectures: Raw and Registered

All architectures were trained on 2 folds initially, only resorting to 5 folds
for the top-scoring ones.

Before integrating multimodal clinical characteristics, a comprehensive
architectural exploration was conducted using standalone CNNs on the 3D DaTSCAN
images. This baseline evaluation serves to establish the raw diagnostic capacity
of the imaging data alone and adresses the the impact of spatial registration
pipelines on deep features, and the scalability of custom architectures compared
to established 3D transfer learning baselines.

#figure(
  image("../assets/figures/results/cnn_unimodal_baselines_brief.svg"),
  caption: [Standalone image-only CNN baseline comparison for Area Under the
  ROC Curve (AUC-ROC) and F1-Score across variations in architecture and spatial
  processing.]
)<basic_cnn_comp>

A primary technical objective of this study was to evaluate whether transforming
raw SPECT scans into an anatomically standard space benefits deep visual feature
extraction. The empirical data reveals a clear, systemic trend: training models
on raw, bounding-box-isolated spatial volumes routinely outperforms identical
networks trained on registered volumes (yellow boxes outscoring purple boxes on
@basic_cnn_comp).

see #redt[some discussion section where I
explain why this might be (registration losing finer details, messing with the
signal, etc)].

#redt[in discussions too, comment how this is actually something very positive
since it means that time can be spent on something else provided that these
models work better on raw images where no human does work to make them fit a
certain atlas, orientation, grid size, intensity range.]

This characteristic can be obseverd across architectures. When utilizing raw
data, the 25d_resnet (raw) achieves a highly stable median AUC-ROC of
approximately $0.983$ with an extremely tight inter-fold variance. Upon undergoing
space registration, the median performance drops to $0.971,$ and the model
exhibits a severely elongated boxplot spread, indicating significant validation
instability across folds.

On the custom 3D crop architectures, the standard crop model experiences an
F1-score drop from $0.865$ down to $0.818$ following template registration.
Similarly, the top-performing crop_deeper architecture drops from an exceptional
median F1-score of $0.962$ down to $0.931$ under the registered condition.

=== Custom Networks vs. 3D Transfer Learning

To determine the ideal model complexity required for this cohort, lightweight
custom architectures were benchmarked against heavy, multi-layered 3D networks
utilizing transfer learning (`med3d` and `med3d_encoder`, see details in
@sec-deep-learning-strategies).

The performance distributions demonstrate that domain-specific, moderately
parameterized networks scale significantly better than massive, pre-trained
medical imaging baselines: the custom `3d_crop_deeper` network achieved the
highest standalone image performance in this study (using the non-registered
images), yielding a median AUC-ROC of $0.993$ and a dominant F1-score of
$0.962$. This architecture captures the essential spatial geometries of the
basal ganglia without introducing unnecessary parameters that trigger
overfitting.

=== GradCAM Visualisation

To validate that the top-performing networks are making decisions based on valid
pathological biomarkers rather than exploiting background artifacts, qualitative
saliency mapping was performed using Gradient-weighted Class Activation Mapping
(Grad-CAM). This analysis focused specifically on the `25d_resnet` pipeline,
which processes volumetric data by extracting three orthogonal 2D projections
(Axial, Sagittal, and Coronal views, see @sec-deep-learning-strategies).

To get a general view of the result of gradCAM across the cohorts, the mean
attention heatmap has been extracted for both HC and PD (see @gradcam_mean).
In this plot, it is very apparent that for patients that the net marked as PD,
the attention was focused on the center of the image, which is where the
striatum lays. The model looks at the center of the image primarily when
defining the sample to be PD. In the opposite case, the image can be seen to be
more averaged everywhere. This makes less sense on images for the healthy cohort
since this is measuring where the model looked at to define that this is a PD
patient. As a result, the mean for HC patients is just noise of the very low
probability that pointed the model towards diagnosing PD in these HC images.

#figure(
  grid(
    columns: 2,
    image("../assets/figures/results/pretty/gradcam_mean_25d_raw_PD.svg"),
    image("../assets/figures/results/pretty/gradcam_mean_25d_raw_HC.svg")
  ),
  caption: [Compare mean gradCAM for PD (left) and HC (right) patients. A higher
coefficient indicates the model paid more attention to that region]
)<gradcam_mean>

This can be further seen when comparing the outputs of individual patients on
this same network (see @gradcam_panel_PD and @gradcam_panel_HC). In here, for
all the patients where the model decided on high PD, the model is focusing on
the very center of the image (concentrated red dot), as opposed to having hot
spots all across the image when the model deems a very low probability of being
a PD patient (see @gradcam_panel_HC, where the model's attention is spread
throughout the image, not focusing specifically on the striatum).

#figure(
  image("../assets/figures/results/pretty/gradcam_25d_raw_PD_panel.svg"),
  caption: [Series of slices and gradCAM view on three PD patients.]
)<gradcam_panel_PD>

#figure(
  image("../assets/figures/results/pretty/gradcam_25d_raw_HC_panel.svg"),
  caption: [Series of slices and gradCAM view on three PD patients.]
)<gradcam_panel_HC>

== Multimodal Fusion: Classical ML

Once a primary evaluation of both classical and deep learning methods has been
done using only DaTscan images (or DaTscan-derived) data, we evaluate the added
value and performance of multimodal studies, using first Classical ML again as a
baseline.

As previously mentioned, data was added trying to emulate how real clinical data
tends to be available (see @tab-incremental-sets to find the descriptions of
each set of added features).

=== Information Gain by Feature Group

In 

#figure(
  text(0.9em, 
  tablef(columns: (auto, auto, auto, auto, auto, auto),
  [ Modality Set],[Feat. ],[   Samples ],[AUC],[B_Acc],[F1],
  [ DaTscan raw         ],[          4 ],[       592 ],[ 0.992 $plus.minus$ 0.012 ],[ 0.975 $plus.minus$ 0.015 ],[ 0.975 $plus.minus$ 0.015 ],
  [ DaTscan full SBR    ],[         13 ],[       592 ],[ 0.994 $plus.minus$ 0.008 ],[ 0.976 $plus.minus$ 0.015 ],[ 0.976 $plus.minus$ 0.015 ],
  [ DaTscan engineered  ],[         17 ],[       592 ],[ 0.995 $plus.minus$ 0.007 ],[ 0.978 $plus.minus$ 0.014 ],[ 0.978 $plus.minus$ 0.014 ],
  [\+ Demographics      ],[         19 ],[       592 ],[ 0.995 $plus.minus$ 0.006 ],[ 0.978 $plus.minus$ 0.016 ],[ 0.978 $plus.minus$ 0.016 ],
  [\+ Motor (UPDRS)     ],[         27 ],[       592 ],[ 0.999 $plus.minus$ 0.003 ],[ 0.990 $plus.minus$ 0.014 ],[ 0.990 $plus.minus$ 0.014 ],
  [\+ Non-motor (UPSIT) ],[         33 ],[       592 ],[ 0.998 $plus.minus$ 0.003 ],[ 0.993 $plus.minus$ 0.008 ],[ 0.993 $plus.minus$ 0.008 ],
  [\+ Biomarkers        ],[         36 ],[       592 ],[ 0.998 $plus.minus$
  0.004 ],[ 0.990 $plus.minus$ 0.014 ],[ 0.990 $plus.minus$ 0.014 ])),
  caption: [Performance on different added sets of features averaged for all
  tested classifiers.]
)<tab:info_gain>


=== SHAP on Best Multimodal Configuration

To asses the usefullness of the individual added features to try and see which
are most worth adding to improve the performance by the largest margin with the
least added information, a SHAP study @lundbergUnified2017 was conducted (see
@shap_multimodal).

#figure(
  image("../assets/figures/results/shap_summary_multimodal_pt.svg", width: 70%),
  caption: [SHAP test on individual features independently.]
)<shap_multimodal>


== Multimodal Fusion: CNN

The inclusion of clinical features demonstrated high diagnostic capabilities
across all evaluated sub-groups, with median AUC values consistently exceeding
0.990 (see @multi_cnn).

#figure(
  image("../assets/figures/results/multimodal_cnn.svg"),
  caption: [Multimodal fusion performance comparison across clinical feature
  groups and fusion architectures.]
)<multi_cnn>

// I do not like this section all bullet points

- Combined Features (ALL): The combination of all tabular feature groups (motor,
  smell, cognitive, and demographics) yielded the highest overall diagnostic
  performance. Under the Late Fusion paradigm, the ALL configuration achieved a
  peak median AUC approaching 0.999, paired with a dominant median F1-score of
  0.990.

- Motor and Olfactory Domains: Independent testing of motor impairments
  (motor_updrs) and olfactory performance (smell_upsit) yielded highly stable,
  low-variance metrics. Notably, motor (Late) achieved exceptionally tight
  distribution boundaries across folds, showing a median AUC of 0.999.

- Cognitive and Demographic Domains: While displaying strong overall
  performance, models incorporating cognitive scores (moca) and basic
  demographics exhibited wider variances across validation folds, particularly
  within the intermediate feature fusion pipeline.

=== Late Fusion vs Feature-Level Fusion

A comparative analysis between the two multimodal integration methods revealed an operational advantage for the Late Fusion baseline over the trained Feature Fusion network:

- Precision and Generalization: The most pronounced divergence occurred within
  the cognitive feature subset. Feature Fusion on cognitive data exhibited a
  notable performance degradation in Precision, dropping to a median of 0.963
  with a elongated lower whisper, whereas Late Fusion maintained a stable
  precision of 0.981.

- Architectural Stability: Across almost all feature combinations (with a minor
  exception in the demographic AUC), Late Fusion demonstrated equal or narrower
  boxplot distributions and higher medians than Feature Fusion, signaling lower
  sensitivity to fold-specific data splits.


== SWEDD Inference
