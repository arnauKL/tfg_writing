#import "../assets/ak_tfg_lib.typ": *

/* Section 8. Conclusions 
Here, it is important to distinguish between the achievement of the thesis
objectives and the achievement of these objectives through the developments and
results obtained. Any deviations from the original objectives must also be
explained, along with the reasons for them.

In this section, you should discuss possible extensions, improvements, or future
work that could be undertaken (ideally in different scenarios: short- and
long-term, technical improvements, more ambitious objectives, etc.).
*/

= Conclusions

This thesis set out to evaluate deep learning-based approaches for automated
binary classification of Parkinson's disease from DaTscan SPECT images, and to
quantify the diagnostic information gain achievable through multimodal fusion
with clinical variables.

== Deviation from the original proposal

The original proposal targeted multi-stage classification including prodromal
patients, using a cohort that was expected to comprise HC, manifest PD, and
prodromal PD subjects with available DaTscan imaging. Approximately six weeks
into the project, it became apparent that the version of the PPMI dataset
available through the research group did not include prodromal DaTscans, these
were added to PPMI at a later date and were not yet accessible. The scope was
then rerouted toward a rigorous comparative evaluation of CNN architectures,
transfer learning strategies, spatial preprocessing choices, and multimodal
fusion paradigms for the binary HC--PD task, a reframing that turned out
to be a worthwhile and relevant research direction in its own right, even if the
original clinical ambition was not fully realized.

== Summary of findings

All five specific objectives were met. A classical ML baseline was established
using SVM classifiers on semi-quantitative SBR features, achieving a median AUC
of $0.998$, a result that underscores how discriminative the DaTscan signal
already is at the manifest disease stage. More complex CNN architectures of
varying dimensionality and pretraining strategy were compared under identical
preprocessing and evaluation conditions. The `3d_crop_deeper` achieved the
highest aggregate AUC ($0.991 plus.minus 0.015$), but Grad-CAM analysis
indicated that this and all other 3D architectures may be attending to
non-anatomical features rather than the dopaminergic signal, raising
generalizability concerns beyond the PPMI cohort. The `25d_resnet`, leveraging
ImageNet transfer learning via orthogonal maximum-intensity projections, was the
only architecture whose attention was consistently localized to the striatum,
making it the only clinically trustworthy model. Raw, unregistered images
consistently outperformed spatially normalized ones across all architectures,
suggesting that the interpolation and smoothing introduced by registration
degrade the high-frequency intensity contrast on which DaTscan classification
depends.

Multimodal fusion supported that motor scores (MDS-UPDRS) provide the largest
single-step performance gain when added to imaging, but this improvement is
confounded by the circularity between motor examination scores and a
clinician-confirmed PD diagnosis. Olfactory testing (UPSIT) emerged as a
genuinely complementary non-motor marker, contributing independent signal not
present in the imaging features. Late fusion outperformed feature-level fusion
throughout, a result attributable to the small fusion cohort, where the added
parameters of a joint classification head introduce overfitting. Inference
carried out on SWEDD patients indicates that the `25d_resnet` has learned the
imaging signal rather than a cohort artifact: patients with normal dopamine
transporter scans were correctly classified as HC-like by a model that had never
seen them during training.

Commenting on the hypotheses defined in @sec-hypothesis, hypothesis _#smol[H]1_
(that CNNs would outperform classical models) is partially refuted. The
`25d_resnet` does not exceed the SVM RBF baseline in raw AUC, but it operates
directly on the full image volume without hand-crafted features and produces
anatomically interpretable decisions, which are prerequisites for clinical
deployment. _#smol[H]2_ (that transfer learning compensates for data scarcity)
is supported for ImageNet pretraining but not for MedicalNet, whose structural
segmentation priors do not transfer to functional SPECT data. _#smol[H]3_ (that
multimodal fusion improves upon imaging alone) is technically supported within
the limitations of this study, but with the caveat that the gain attributable
to motor features reflects circularity rather than genuine complementarity.

== Future work

In the short term, the most natural extension is to re-run the same pipeline on
an updated PPMI extract that includes prodromal DaTscan data, directly addressing
the original proposal objective. A secondary short-term priority is
multi-site validation: evaluating the `25d_resnet` on data from clinical
scanners outside PPMI would test whether its anatomically grounded attention
generalizes beyond the controlled multicenter protocol.

In the medium term, the shortcut-learning problem identified in the 3D
architectures could have dedicated investigation. Attention-constrained
training, for example, incorporating a Grad-CAM consistency loss that penalizes
activations outside an anatomical striatal mask, could enforce anatomically
correct feature learning without sacrificing the volumetric information that 3D
models are in principle better positioned to exploit.

A more ambitious long-term direction, originally proposed by my tutor,
supervisor, would be to train a generative model on MRI-to-DaTscan image
synthesis using healthy subjects only. Given an incoming patient's structural
MRI, the model would synthesise a personalized healthy DaTscan baseline; the
deviation between this synthetic healthy scan and the patient's real acquisition
could then be quantified as a subject-specific abnormality score. This approach
would eliminate the need for population-level thresholds, would be inherently
subject-specific, and could potentially detect subtle DAT deficits before they
cross the binary normal/abnormal boundary, addressing the early and prodromal
diagnostic challenge that motivated this thesis from the outset.
