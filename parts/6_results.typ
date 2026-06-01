#import "../assets/ak_tfg_lib.typ": *

#set par(leading: 0.50em + 1pt)

/*
* En aquest capítol es proporcionaran els resultats obtinguts, i s’explicaran
* respecte als 
diferents escenaris d’experimentació descrits a l’apartat “Materials i mètodes”
*/

// This chapter is still a draft, needs revision to avoid sounding like a monke

= Results

== Classical machine learning baseline

=== Effects of feature engineering and class balancing

Given how imbalanced the PPMI dataset was towards PD patients, one of the first
major steps was evaluating how different balancing methods affected classifier
behavior (refer to @eng-vs-raw-manual-vs-auto). The two compared approaches were
manually balancing the dataset by dropping extra PD patients until achieving a
strict 1:1 ratio for HC:PD, and using sklearn's `compute_sample_weight` utility
to automatically adjust weights inversely proportional to class frequencies
@Compute_sample_weight.

Under automatic sample weighting, a systematic divergence between macro
precision and macro recall was observed across nearly all classifiers,
particularly for the SVM variants and Logistic Regression. Weighted datasets
yielded comparatively high precision but markedly lower recall, indicating a
residual bias toward the majority class despite the reweighting. In contrast,
manually balanced datasets (green and red boxes in @eng-vs-raw-manual-vs-auto)
produced a consistent improvement in macro recall and a stabilization of
performance across both metrics, resulting in higher accuracy (balanced
accuracy) and F1 scores, most notably for the Random Forest and Gradient
Boosting classifiers. Based on these findings, manually balanced datasets were
used in all subsequent experiments.

#figure(
  image("../assets/figures/results/classic_ml_compare_all_models_raw_deriv_eng_raw.svg",
width: 90%),
  caption: [Five-fold cross-validation performance comparison across classical
  ML models. Subplots evaluate manual dataset balancing (1:1 HC:PD ratio)
  compared to automatic sample weighting across five evaluation metrics,
  contrasting raw DaTscan-derived indicators against feature-engineered
  variants.]
)<eng-vs-raw-manual-vs-auto>

With respect to feature set composition, the addition of four engineered
features derived from the primary DaTscan-derived indicators (orange and red
variants) consistently outperformed the raw four-feature sets (blue and green
variants) across all metrics and classifiers. In the accuracy and F1
panels, the engineered variants additionally exhibited tighter interquartile
ranges, indicating reduced fold-to-fold variance and improved model stability,
particularly for the tree-based classifiers.

In the Balanced Accuracy and F1 plots, the red bars generally have higher
medians and tighter interquartile ranges (IQRs) than the green bars and orange
better more so than blue bars, indicating that feature engineering reduces
variance and stabilizes the tree-based models (RF and GB). This shows feature
engineering produced higher accuracy and F1 scores across all evaluated
classifiers.


Restricting the comparison to the engineered, manually balanced condition
(@only_man_eng_allmodels), the SVM with a non-linear RBF kernel achieved the
highest and most consistent performance across all metrics, with a median
ROC-AUC of $0.998$, a mean accuracy of $0.974 plus.minus 0.014$, and a
mean F1 of $0.983 plus.minus 0.012$. It also exhibited the narrowest
interquartile range of all classifiers, indicating stable performance regardless
of the specific train-test split.

#figure(
  image("../assets/figures/results/comparison_models_only.svg"),
  caption: [Five-fold cross-validation performance of all classical ML
  classifiers trained on the manually balanced, feature-engineered dataset.
  Tighter distributions indicate greater consistency across folds.]
)<only_man_eng_allmodels>


== Comparison of CNN architectures

=== Effect of spatial registration across architectures

Before integrating multimodal clinical characteristics, a comprehensive
architectural exploration was conducted using standalone CNNs on the 3D DaTscan
images. This baseline evaluation serves to establish the raw diagnostic capacity
of the imaging data alone and addresses the impact of spatial registration
pipelines on deep features, and the scalability of custom architectures compared
to established 3D transfer learning baselines.

Architectures were evaluated on both raw (unregistered) and registered DaTscan
image sets, spanning custom 2D, 3D, and transfer-learning-based approaches. An
initial screening phase used 2-fold cross-validation across all architectures to
rank models under a reduced computational budget; the top-performing
architectures were subsequently re-evaluated using 5-fold cross-validation to
obtain more reliable performance estimates. Results are presented in
@basic_cnn_comp.

#figure(
  image("../assets/figures/results/cnn_unimodal_baselines_brief.svg"),
  caption: [Standalone image-only CNN baseline comparison for Area Under the
  ROC Curve (AUC-ROC) and F1-Score across variations in architecture and spatial
  processing. Purple boxes correspond to models trained on registered images;
  yellow boxes to raw (unregistered images).]
)<basic_cnn_comp>

A consistent and systematic pattern emerged across all evaluated architectures:
models trained on raw, center-cropped volumes outperformed their counterparts
trained on spatially registered images. This advantage was observed in both
absolute performance and fold-to-fold stability.

For the best-performing architecture (`25d_resnet`), training on raw images
yielded a median ROC-AUC of approximately $0.983$ with a narrow interquartile
range, whereas the registered condition produced a lower median of $0.971$ and a
markedly wider spread across folds. A comparable pattern was observed for the
custom 3D architectures: the `3d_crop` model experienced an F1-score reduction
from $0.865$ (raw) to $0.818$ (registered), while the deeper variant
(`3d_crop_deeper`) dropped from a median F1 of $0.962$ to $0.931$ following
spatial normalization.


=== Custom networks vs. 3D transfer learning

To assess the trade-off between model complexity and performance, the
lightweight custom 3D architectures were compared against the larger,
domain-pretrained MedicalNet baselines (`med3d` and `med3d_encoder`, see
@sec-deep-learning-strategies).

The results demonstrate that the moderately parameterized custom architectures
generalize more effectively to this cohort than the large pretrained networks.
The `3d_crop_deeper` model achieved the highest image-only performance across
all architectures on raw data, with a median ROC-AUC of $0.991$ and a median F1
of $0.951$. The MedicalNet-based variants produced lower median scores and wider
variance distributions across folds on this dataset.

Boxplots provide a detailed view of fold-to-fold variability across
architectures. For completeness, @table_winners summarizes the mean performance
obtained by each evaluated CNN architecture during the final 5-fold
cross-validation experiments.

#figure(
  tablec(
    columns: (auto, auto, auto, auto),
    [ Model          ],[ AUC             ],[ Acc           ],[ F1              ],
    [ `3d_crop_deeper` ],[ 0.991 $plus.minus$ 0.015 ],[ 0.952 $plus.minus$ 0.021 ],[ 0.951 $plus.minus$ 0.021 ],
    [ `25d_resnet`     ],[ 0.979 $plus.minus$ 0.021 ],[ 0.943 $plus.minus$ 0.064 ],[ 0.943 $plus.minus$ 0.073 ],
    [ `med3d_encoder`  ],[ 0.954 $plus.minus$ 0.039 ],[ 0.877 $plus.minus$ 0.028 ],[ 0.871 $plus.minus$ 0.026 ],
    [ `med3d`          ],[ 0.946 $plus.minus$ 0.028 ],[ 0.859 $plus.minus$ 0.061 ],[ 0.870 $plus.minus$ 0.052 ],
    [ `2d_sum`         ],[ 0.945 $plus.minus$ 0.017 ],[ 0.876 $plus.minus$ 0.047 ],[ 0.875 $plus.minus$ 0.056 ],
    [ `3d_crop`        ],[ 0.944 $plus.minus$ 0.016 ],[ 0.871 $plus.minus$ 0.060 ],[ 0.865 $plus.minus$ 0.046 ],
  ),
  caption: [Summary of final 5-fold cross-validation performance for all
  evaluated CNN architectures in the HC--PD classification task.]
)<table_winners>

The `3d_crop_deeper` architecture achieved the highest overall performance,
reaching a mean ROC-AUC of $0.991 plus.minus 0.015$ and an F1-score of $0.951
plus.minus 0.021$. The
`25d_resnet` model achieved the second-highest performance, while the remaining
architectures formed a lower-performing group with ROC-AUC values between
$0.944$ and $0.954$.


=== Interpretability analysis using Grad-CAM <sec-gradcam>


To assess whether each architecture's classification decisions are grounded in anatomically meaningful regions, Grad-CAM visualizations were generated for all
evaluated architectures and inspected at both the cohort-average and
individual-patient level.

@d25_gradcam_mean shows the cohort-averaged attention heatmap for the `25d_resnet`
on PD and HC patients separately. For images classified as PD, saliency is
concentrated at the center of the projection, corresponding to the anatomical
location of the striatum. For images classified as HC, attention is diffuse and
spread broadly across the projection, consistent with the absence of a focal
pathological signal.

#figure(
  box(width: 95%, grid(
    columns: 2,
    image("../assets/figures/results/25d_gradcam/gradcam_mean_25d_raw_PD.svg"),
    image("../assets/figures/results/25d_gradcam/gradcam_mean_25d_raw_HC.svg")
  )),
  caption: [Mean Grad-CAM attention heatmaps for the `25d_resnet` model on raw
  images. Left: mean activation across PD patients. Right: mean activation
  across HC patients. Higher coefficient values indicate regions to which the
  model assigned greater weight when computing the PD classification score.]
)<d25_gradcam_mean>

This spatial pattern is further confirmed by individual patient examples
(@gradcam_panel_PD and @gradcam_panel_HC). In correctly classified PD cases,
saliency maps consistently show a concentrated activation at the center of the
projection. In HC cases, where the model assigns a low PD probability, attention
is distributed broadly across the image with no focal striatal concentration.

#figure(
  image("../assets/figures/results/25d_gradcam/gradcam_25d_raw_PD_panel.svg"),
  caption: [Grad-CAM activation maps to the right of their corresponding DaTscan
  projections for three representative PD patients (`25d_resnet`, raw). Each
  column shows one patient; rows correspond to the axial, sagittal, and coronal
  projections.]
)<gradcam_panel_PD>

#figure(
  image("../assets/figures/results/25d_gradcam/gradcam_25d_raw_HC_panel.svg"),
  caption: [Grad-CAM activation maps to the right of their corresponding DaTscan
  projections for three representative HC patients (`25d_resnet`, raw). Each
  column shows one patient; rows correspond to the axial, sagittal, and coronal
  projections.]
)<gradcam_panel_HC>

In contrast, none of the remaining architectures produced anatomically grounded
attention. @gradcam_other_mean shows the cohort-averaged PD activation maps for
the four 3D architectures. The `3d_crop` model produced spatially inconsistent
activation, occasionally overlapping with the striatal region but more often
localizing to small areas at image edges with no reproducible anatomical
correspondence. The `3d_crop_deeper` and `med3d` variants exhibited strikingly
similar activation patterns despite their architectural differences: both
produced diffuse maps characterized by scattered pancake-like structures
with no consistent focal point. The `med3d_encoder` produced a distinctive
ring-shaped activation pattern centered on the image but not localized to the
striatum itself (it can be seen more clearly in @panel_med3d_encoder in
@app_extended_results).

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    image("../assets/figures/results/3d_gradcam/gradcam_3d_crop_PD_scatter_mean.svg"),
    image("../assets/figures/results/3d_gradcam/gradcam_3d_deeper_PD_scatter_mean.svg"),
    image("../assets/figures/results/3d_gradcam/gradcam_med3d_PD_scatter_mean.svg"),
    image("../assets/figures/results/3d_gradcam/gradcam_med3d_encoder_PD_scatter_mean.svg"),
  ),
  caption: [Cohort-averaged Grad-CAM attention maps for PD patients across the
  four 3D architectures. Top-left: `3d_crop`; top-right: `3d_crop_deeper`;
  bottom-left: `med3d`; bottom-right: `med3d_encoder`. None of the four
  architectures produces attention concentrated at the striatum. Individual
  patient panels for each architecture are provided in @app-gradcam.]
)<gradcam_other_mean>

/*
In all four cases, the attention maps provide no interpretable anatomical basis
for the classification decision, suggesting these models exploit image-level
shortcuts such as background intensity structure or acquisition geometry rather
than the dopaminergic signal.

This interpretability analysis qualifies the quantitative ranking in
@table_winners: although `3d_crop_deeper` achieved the highest aggregate AUC,
its Grad-CAM maps indicate that this performance is not driven by the
diagnostically relevant dopaminergic signal. The `25d_resnet` is the only
architecture whose attention is consistently and anatomically grounded in the
striatum, making it the more trustworthy model and the natural choice as backbone
for the multimodal fusion experiments that follow.
*/

In all four cases, the attention maps do not concentrate on the striatum,
suggesting these models may be exploiting dataset-specific features, such as
site-related intensity distributions or acquisition geometry, rather than the
dopaminergic signal. It should be noted that Grad-CAM provides a coarse
approximation of model attention and may not fully capture the features driving
classification; these observations should therefore be interpreted as indicative
rather than conclusive

This interpretability analysis qualifies the quantitative ranking in
@table_winners: although `3d_crop_deeper` achieved the highest aggregate AUC,
its Grad-CAM maps suggest that its performance may not be primarily driven by
the dopaminergic signal, raising concerns about generalizability to datasets
acquired under different protocols. The `25d_resnet` is the only architecture
whose attention is consistently localized to the striatum, making it the more
trustworthy candidate and the natural choice as backbone for the multimodal
fusion experiments that follow.

== Multimodal integration with classical models

Following the image-only evaluation, the contribution of progressively richer
clinical feature sets to classification performance was assessed using the
classical ML framework. Features were added in the additive sequence described
in @tab-incremental-sets, designed to mirror the increasing clinical burden of
each modality.

=== Information gain by feature group

@tab_info_gain reports the cross-validated performance of the SVM RBF
classifier, the best-performing model from the previous section, across all
seven feature sets. The addition of the full PPMI SBR panel and the engineered
features produced modest but consistent improvements over the four-indicator
baseline (AUC $0.992$ to $0.995$). The inclusion of demographic variables (age
and sex) yielded no measurable gain. The largest single-step improvement was
observed upon adding the motor assessment battery (UPDRS, and symptom
flags), which raised the mean AUC from $0.995$ to $0.999$ and accuracy
from $0.978$ to $0.990$. Subsequent addition of non-motor prodromal markers
(UPSIT, RBD, ESS, GDS, SCOPA) produced a further marginal improvement in
accuracy ($0.993$). The addition of secondary biomarkers
(alpha-synuclein, NfL, urate) resulted in no further gain, with performance
remaining stable at $0.998$ AUC.

/*mutli_pretty.py script*/
#figure(
  tablec(columns: (auto, auto, auto, auto, auto),
  [ Modality Set],[Feat. ],[AUC],[B_Acc],[F1],
  [ DaTscan raw         ],[          4 ],[ 0.992 $plus.minus$ 0.012 ],[ 0.975 $plus.minus$ 0.015 ],[ 0.975 $plus.minus$ 0.015 ],
  [ DaTscan full SBR    ],[         13 ],[ 0.994 $plus.minus$ 0.008 ],[ 0.976 $plus.minus$ 0.015 ],[ 0.976 $plus.minus$ 0.015 ],
  [ DaTscan engineered  ],[         17 ],[ 0.995 $plus.minus$ 0.007 ],[ 0.978 $plus.minus$ 0.014 ],[ 0.978 $plus.minus$ 0.014 ],
  [\+ Demographics      ],[         19 ],[ 0.995 $plus.minus$ 0.006 ],[ 0.978 $plus.minus$ 0.016 ],[ 0.978 $plus.minus$ 0.016 ],
  [\+ Motor (UPDRS)     ],[         27 ],[ 0.999 $plus.minus$ 0.003 ],[ 0.990 $plus.minus$ 0.014 ],[ 0.990 $plus.minus$ 0.014 ],
  [\+ Non-motor (UPSIT) ],[         33 ],[ 0.998 $plus.minus$ 0.003 ],[ 0.993 $plus.minus$ 0.008 ],[ 0.993 $plus.minus$ 0.008 ],
  [\+ Biomarkers        ],[         36 ],[ 0.998 $plus.minus$
  0.004 ],[ 0.990 $plus.minus$ 0.014 ],[ 0.990 $plus.minus$ 0.014 ]),
  caption: [SVM RBF cross-validated performance (mean $plus.minus$ std, 5-fold)
  across the seven additive feature sets. Performance is reported for the
  manually balanced dataset.]
)<tab_info_gain>


=== SHAP on best multimodal configuration

To identify which individual features drove classification decisions in the best
multimodal configuration, SHAP (SHapley Additive exPlanations) analysis
@lundbergUnified2017 was conducted on the SVM RBF model trained on the full
feature set. Results are shown in @shap_multimodal.

Features from motor, imaging, and olfactory domains appeared among the
highest-ranked variables. The model prioritizes continuous motor impairment
(`updrs3_score`), specifically targets the established biological pattern of
putaminal-first dopaminergic degradation (`Putamen_Caudate_Ratio`), and
integrates known non-motor prodromal indicators (`upsit`).

The three highest-ranked features by mean absolute SHAP value were
`updrs3_score`, `Putamen_Caudate_Ratio`, and `con_putamen`. The motor score
(`updrs3_score`) contributed the largest individual SHAP magnitudes, with low
values (blue) strongly pushing predictions toward HC (negative SHAP) and high
values (red) pushing toward PD. The `Putamen_Caudate_Ratio`, an engineered
DaTscan-derived feature, ranked second, with high values (red) pushing toward HC
and low values (blue, indicating preferential putaminal loss) associated with PD
predictions. The contralateral putamen binding (`con_putamen`) ranked third,
following a similar pathophysiological trend where lower dopamine transporter
binding pushed the model toward a PD diagnosis. While global summary metrics
like `Mean_SBR` ranked at the very bottom, specific regional and asymmetric
DaTscan indicators remained highly influential even when clinical and motor
features were present.

#figure(
  grid(columns: (auto, 4em), image("../assets/figures/results/shap_summary_multimodal_pt.svg"),[]),
  caption: [SHAP beeswarm plot for the SVM RBF classifier trained on the full
  multimodal feature set (PD class). Each point represents one patient,
  positioned horizontally by its SHAP value and colored by the corresponding
  feature value (red = high, blue = low). Features are ranked by mean absolute
  SHAP value.]
)<shap_multimodal>


== Multimodal integration with CNNs

Following the classical ML multimodal evaluation, clinical features were
integrated with the `25d_resnet` (raw images) to assess whether fusion improves
over imaging alone. Although `3d_crop_deeper` achieved a marginally higher
aggregate AUC in the image-only evaluation, the `25d_resnet` was selected as the
fusion backbone on interpretability grounds: as shown in @sec-gradcam, it is the
only architecture whose Grad-CAM activations are anatomically localized to the
striatum, a prerequisite for clinically meaningful integration.

The fusion cohort comprised $N = 306$ ($153$ HC, $153$ PD) patients after the
intersection of available image and tabular data was computed and class
balancing was applied. A 5-fold cross-validation scheme was used throughout this
section. @multi_cnn presents the performance distributions across the four clinical
feature groups (motor, olfactory, cognitive, and demographic) and their
combination (ALL), for both late fusion and feature-level fusion configurations.

The motor feature group (`motor_updrs`) achieved the highest overall performance
of all evaluated configurations: under late fusion, it yielded a median AUC of
$0.999$ with an exceptionally narrow interquartile range, indicating highly
stable classification across all folds. The olfactory group (`smell_upsit`)
similarly produced consistent, low-variance results across both fusion
strategies, ranking among the strongest individual feature groups.

In contrast, models incorporating cognitive scores (`moca`) and demographic
variables exhibited wider fold-to-fold variance, particularly within the
feature-level fusion pipeline, suggesting that these features introduce greater
uncertainty into the fusion head relative to the motor and olfactory domains.

#figure(
  image("../assets/figures/results/multimodal_cnn.svg"),
  caption: [Multimodal fusion performance across clinical feature groups and
  fusion strategies (late fusion and feature-level fusion). Results are based on
  5-fold cross-validation with the `25d_resnet` (raw) as the frozen CNN backbone;
  $N = 306$.]
)<multi_cnn>


The combination of all feature groups (ALL) did not yield the highest overall
diagnostic performance despite incorporating the full available clinical
information. While the ALL late fusion configuration achieved a median AUC
approaching $0.999$, it fell short of the motor-only configuration on the
remaining metrics, suggesting that the additional features introduced by the
cognitive and demographic groups contribute noise that partially offsets the
signal carried by the motor and olfactory domains.

/*
- Motor and Olfactory Domains: Independent testing of motor impairments
  (`motor_updrs`) and olfactory performance (`smell_upsit`) yielded highly stable,
  low-variance metrics. Notably, motor (Late) achieved exceptionally tight
  distribution boundaries across folds, showing a median AUC of 0.999 and
  highest scrore overall.

- Cognitive and Demographic Domains: While displaying strong overall
  performance, models incorporating cognitive scores (moca) and basic
  demographics exhibited wider variances across validation folds, particularly
  within the intermediate feature fusion pipeline.

- Combined Features (ALL): The combination of all tabular feature groups (motor,
  smell, cognitive, and demographics) did not yeald the highest overall diagnostic
  performance. Under the Late Fusion paradigm, the ALL configuration achieved a
  peak median AUC approaching $0.999$, falling short on other metrics to the
  motor set of data. The added features have likely introduced more noise than
  real useful data.
*/

=== Comparison of fusion strategies

Across nearly all feature group and metric combinations, late fusion
demonstrated equal or superior performance to feature-level fusion (see
@multi_cnn) , with narrower interquartile ranges indicating lower sensitivity to
fold-specific data composition. The most pronounced difference was observed in
the cognitive feature subset: feature-level fusion on cognitive data produced a
median precision of $0.963$ with a substantially elongated lower whisker,
whereas late fusion maintained a stable median precision of $0.981$. The only
exception to this pattern was a marginal advantage for feature-level fusion in
the demographic AUC, which did not generalize to other metrics.

== SWEDD Inference and CNN validation

To further characterize the specificity of the imaging signal learned by the
best-performing model, post-hoc inference was performed on the SWEDD cohort
(Scans Without Evidence of Dopaminergic Deficit; $N = 57$). As described in
@sec-swedd-inference, SWEDD patients were excluded from all training and model
selection procedures; the trained `25d_resnet` (raw) classifier was applied
directly without retraining or fine-tuning.

@tab_swedd_inference and @violin_swedd jointly summarise the predicted PD
probability distributions across all three cohorts. The model separated PD from
HC with high confidence: HC patients received a mean predicted PD probability of
$0.029$ (median $0.003$; $1.9%$ classified as PD), while PD patients received a
mean of $0.954$ (median $0.994$; $97.5%$ classified as PD). Patients in the
SWEDD cohort received a mean probability of $0.113$ (median $0.004$; $10.5%$
classified as PD). This value is substantially lower than the 97.5% observed in
the PD cohort and closer to the HC distribution. The standard deviation for the
SWEDD group ($sigma = 0.267$) was notably higher than for HC ($sigma = 0.136$)
and PD ($sigma = 0.145$), reflecting greater heterogeneity within the SWEDD
cohort. The violin plot in @violin_swedd makes this distribution particularly
visible: the bulk of SWEDD predictions cluster near zero, alongside HC, while a
small subset of patients receives substantially elevated PD probabilities
(further commented in @sec-swedd-discussion).

#figure(
  tablec(
    columns: (6em, auto, auto, auto, auto, auto),
    [Cohort], [N], [Mean], [Median], [Std.], [Classified as PD],
    [HC],    [157], [0.029], [0.003], [0.136], [1.9%],
    [PD],    [606], [0.954], [0.994], [0.145], [97.5%],
    [SWEDD], [57],  [0.113], [0.004], [0.267], [10.5%],
  ),
  caption: [Summary statistics of predicted PD probabilities per cohort.
  Classification threshold set at $0.5$.]
)<tab_swedd_inference>

#figure(
  gap: 0.5em,
  image("../assets/figures/results/swedd_probabilities_violin.svg", width: 37%),
  caption: [Violin plot of predicted PD probabilities for HC, PD, and SWEDD
  cohorts. Individual patient predictions are overlaid as markers. A
  well-calibrated model assigning purely image-based decisions would place HC
  and SWEDD predictions near $0.0$ and PD predictions near $1.0$.]
)<violin_swedd>

/*Results directly from the script:
Inference (model outputs PD probability, higher means more PD-like):
  HC            n= 157  mean=0.029  median=0.003  classified as PD=1.9%
  PD            n= 606  mean=0.954  median=0.994  classified as PD=97.5%
  SWEDD         n=  57  mean=0.113  median=0.004  classified as PD=10.5%

Mann-Whitney U tests (non-parametric, no normality assumption):
  HC vs SWEDD         U=3765  p=0.0766 ns   Key: SWEDD should look like HC
  PD vs SWEDD         U=33754  p=0.0000 ***   Key: SWEDD should differ from PD
  HC vs PD            U=721  p=0.0000 ***   Sanity check: HC vs PD separation

Saved: analysis/outputs/group_inference/group_probabilities_violin.svg
Saved: analysis/outputs/group_inference/group_probabilities_hist.svg

Summary table:
Group            n    Mean   Median    Std     %PD
HC             157   0.029    0.003  0.136    1.9%
PD             606   0.954    0.994  0.145   97.5%
SWEDD           57   0.113    0.004  0.267   10.5%
*/

Mann-Whitney U tests confirmed that the observed differences were statistically
significant where expected. The comparison between HC and PD yielded strong
separation ($U = 721$, $p < 0.001$), validating the model's primary
classification performance. The PD against SWEDD comparison was equally
significant ($U = 33754$, $p < 0.001$), confirming that SWEDD patients receive
markedly lower PD probabilities than confirmed PD cases. Finally, the comparison
between HC and SWEDD did not reach statistical significance ($U = 3765$, $p =
0.077$), consistent with the hypothesis that SWEDD patients present DaTscan
  profiles that are statistically indistinguishable from HC subjects at the
  population level.
