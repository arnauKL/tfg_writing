#import "../assets/ak_tfg_lib.typ": *

= Extended results <app_extended_results>

== Supplementary interpretability map analysis <app-gradcam>

Extended Grad-CAM saliency maps generated across all alternative 3D CNN
architectures (`3d_crop`, `3d_crop_deeper`, `med3d`, and `med3d_encoder`). These
visualizations supplement the aggregate findings presented in @sec-gradcam. They
are categorized into cohort-averaged distributions for HC subjects and
case-by-case individual patient panels for both clinical classes.

=== Cohort-averaged scatter maps (HC group)

While the cohort-averaged maps for PD patients were examined in
@gradcam_other_mean to identify structural shortcut learning,
@gradcam_other_hc_mean_3d and @gradcam_other_hc_mean_meds document the
corresponding aggregate saliency maps across the HC cohort. 

#figure(
  grid(
    columns: 2,
    gutter: 1.2em,
    image("../assets/figures/results/3d_gradcam/gradcam_3d_crop_HC_scatter_mean.svg"),
    image("../assets/figures/results/3d_gradcam/gradcam_3d_deeper_HC_scatter_mean.svg"),
  ),
  caption: [
    Cohort-averaged Grad-CAM attention maps for HC patients across the custom 3D
    architectures. Left: `3d_crop`; right: `3d_crop_deeper`. In the absence of
    focal dopaminergic degradation, these unregularized models distribute
    attention across diffuse extrastriatal areas and outer cropping boundaries.
    Notably, these maps visualize only the top 5% highest activations (95th
    percentile threshold); the absolute saliency coefficients remain remarkably
    low-peaking at $0.3$ and $0.6$ respectively, confirming the absence of
    strong, anatomically structured attention.
  ]
)<gradcam_other_hc_mean_3d>

#figure(
  grid(
    columns: 2,
    gutter: 1.2em,
    image("../assets/figures/results/3d_gradcam/gradcam_med3d_HC_scatter_mean.svg"),
    image("../assets/figures/results/3d_gradcam/gradcam_med3d_encoder_HC_scatter_mean.svg"),
  ),
  caption: [
    Cohort-averaged Grad-CAM attention maps for HC patients across the
    domain-pretrained MedicalNet baselines. Left: `med3d`; right:
    `med3d_encoder`. Parallel to the custom baselines, the lack of a localized
    pathognomonic signal loss causes these large-parameter models to settle onto
    diffuse outer matrix geometries and acquisition edge artifacts rather than
    meaningful neuroanatomy.
  ]
)<gradcam_other_hc_mean_meds>

As illustrated above, without a localized pathognomonic signal loss to anchor
onto, the unconstrained 3D models demonstrate arbitrary spatial convergence,
frequently highlighting peripheral reconstruction limits or zero-padding noise
boundaries.

=== Case-by-case individual patient panels

To verify that the aggregate cohort tendencies reflect persistent geometric
biases rather than smoothing artifacts, individual patient panels are provided
below. Each figure contrasts three representative patient examinations for both
the HC and PD categories across orthogonal viewing planes.

==== Custom 3D baseline models (`3d_crop` and `3d_crop_deeper`)

@panel_3d_crop and @panel_3d_deeper document the localized predictions of the
custom-parameterized 3D architectures. Despite the high cross-validated
classification metrics achieved by `3d_crop_deeper`, its individual attention
pathways systematically track non-anatomical boundaries across both clinical
cohorts.

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    [#image("../assets/figures/results/3d_gradcam/gradcam_HC_panel-3d_crop.svg")
    \ #text(size: 9pt, weight: "medium")[A: HC group samples]],
    [#image("../assets/figures/results/3d_gradcam/gradcam_PD_panel-3d_crop.svg")
    \ #text(size: 9pt, weight: "medium")[B: PD group samples]]
  ),
  caption: [
    Individual patient Grad-CAM panels for the lightweight `3d_crop` network.
    Saliency distributions demonstrate severe spatial instability and structural
    fragmentation across slice selections.
  ]
)<panel_3d_crop>

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    [#image("../assets/figures/results/3d_gradcam/gradcam_HC_panel-3d_deeper.svg")
    \ #text(size: 9pt, weight: "medium")[A: HC group samples]],
    [#image("../assets/figures/results/3d_gradcam/gradcam_PD_panel-3d_deeper.svg")
    \ #text(size: 9pt, weight: "medium")[B: PD group samples]]
  ),
  caption: [
    Individual patient Grad-CAM panels for the `3d_crop_deeper` network. The
    model demonstrates high localized confidence patterns that deliberately
    encircle or entirely bypass the central striatal volume.
  ]
)<panel_3d_deeper>


==== Pretrained MedicalNet architectures (`med3d` and `med3d_encoder`)

@panel_med3d and @panel_med3d_encoder illustrate the feature maps produced by
domain-transfer baselines. The large parameter space inherent to these transfer
frameworks yields highly geometric artifact tracking, most notably expressing a
distinct, non-biological ring or "donut" activation topology that avoids deep
subcortical nuclei.

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    [#image("../assets/figures/results/3d_gradcam/gradcam_HC_panel-med3d.svg") \
    #text(size: 9pt, weight: "medium")[A: HC patient samples]],
    [#image("../assets/figures/results/3d_gradcam/gradcam_PD_panel-med3d.svg") \
    #text(size: 9pt, weight: "medium")[B: PD patient samples]]
  ),
  caption: [
    Individual patient Grad-CAM panels for the pretrained `med3d` baseline.
    Saliency fields settle into diffuse extrastriatal matrices across both
    normal and pathologically depleted inputs.
  ]
)<panel_med3d>

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    [#image("../assets/figures/results/3d_gradcam/gradcam_HC_panel-med3d_encoder.svg")
    \ #text(size: 9pt, weight: "medium")[A: HC patient samples]],
    [#image("../assets/figures/results/3d_gradcam/gradcam_PD_panel-med3d_encoder.svg")
    \ #text(size: 9pt, weight: "medium")[B: PD patient samples]]
  ),
  caption: [
    Individual patient Grad-CAM panels for the `med3d_encoder` baseline.
    Saliency maps exhibit highly reproducible, geometric ring artifacts centered
    around the matrix midlines rather than adapting dynamically to the patient's
    internal striatal anatomy. ]
)<panel_med3d_encoder>


== Multimodal post-hoc inference on unseen cohorts (SWEDD) <swedd_app>

To evaluate how clinical symptoms interact with functional neuroimaging
signatures, a post-hoc zero-shot evaluation was executed using the late fusion
configuration ($alpha = 0.5$). For this analysis, cohorts were aligned to
isolate complete-record patients possessing both full DaTscan volumes and
baseline tabular clinical data ($N = 779$). 

The addition of baseline clinical features (including UPDRS3 and UPSIT scores)
shifts the SWEDD cohort’s profile. While the image-only CNN backbone classifies
the SWEDD group as highly healthy (median probability of $0.004$, with only
$8.9%$ classified as PD), the multimodal model yields a large positive shift,
increasing the median predicted PD probability to $0.450$ and tripling the
classification rate to $30.4%$.


#text(size: 10pt)[
#figure(
  tablec(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
      [*Group*], [*N*], [*CNN \ Mean*], [*CNN \ Med.*], [*CNN \ %PD*], [*Multi
      Mean*], [*Multi Med.*], [*Multi %PD*],
    [HC], [153], [0.029], [0.003], [2.0%], [0.042], [0.017], [1.3%],
    [PD], [570], [0.953], [0.994], [97.4%], [0.946], [0.990], [99.1%],
    [SWEDD], [56], [0.097], [0.004], [8.9%], [0.383], [0.450], [30.4%]
  ),
  caption: [Zero-shot evaluation metrics comparison between image-only (CNN) and late fusion multimodal configurations across complete-record aligned cohorts.],
) <tab:multimodal_swedd>
]

Mann-Whitney U tests performed on the multimodal outputs reveal that the SWEDD
group no longer remains statistically indistinguishable from Healthy Controls.
Instead, it occupies a distinct, highly significant intermediate boundary
position separating it from both pure cohorts (see @tab_multi_swedds).

#figure(
  tablec(
    columns: (auto, auto, auto),
    [ HC vs. SWEDD ], [ PD vs. SWEDD ], [ HC vs. PD ],
    [ $U = 424.0$], [ $U = 31304.0$], [ $U = 39.0$],
    [ $p < 0.0001$], [ $p < 0.0001$], [ $p < 0.0001$],
  ),
  caption: [Results of Mann-Whitney U test on the multimodal outputs with $alpha =
0.5$]
)<tab_multi_swedds>

This behavior highlights a clinical reality: while the image-only model confirms
that SWEDD patients exhibit structurally intact dopaminergic pathways, the
multimodal fusion model captures their clinical presentation as a symptomatic
"phenotypic mimic" of Parkinson's Disease.

#figure(
  image("../assets/figures/results/swedd_probabilities_violin_multimodal_comp.svg"),
  caption: [Comparative probability distributions demonstrating the phenotypic
  pull of tabular clinical features on the SWEDD cohort ($alpha = 0.5$).]
)<fig_multimodal_violin>
