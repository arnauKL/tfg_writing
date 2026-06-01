#import "../assets/ak_tfg_lib.typ": *

// notes from the thesis guide:
/*
The "state of the art" refers to studying what has already been developed (what
exists in the world) at the most advanced level achieved to date in relation to
the TFG to be carried out. It is necessary to identify the literature that
relates to the device, technique, or method most closely related to what is
intended to be tested in the TFG. 
*/

= State of the Art

The application of machine learning to DaTscan neuroimaging for PD diagnosis
draws on three intersecting research areas: clinical nuclear medicine, which has
established DaTscan as a validated diagnostic biomarker; deep learning, which
provides the architectures and training strategies used to process imaging data;
and multimodal learning, which investigates the principled combination of
heterogeneous data sources. This section reviews relevant prior work across
these areas and positions the present project within them.


== Clinical interpretation of DaTscan

/* rewritten according to the feedback:
This has already been commented previously. I'd rather mention the problems of
visual assessment: inter-rate variability, not generalizable, etc.

And also problems with semi-quantitative: ad-hoc rules, some methods need
registration to a template, not subject-specific, etc.

Some of the methods used need to be referenced: DatQUANT (GE Healthcare, paid)
and BasGANv2 (not available at this time), for example. Mention that they are
not public currently and, as such, canoot be used freely to process data.
*/

Visual interpretation of DaTscan is performed by trained nuclear medicine
specialists, who classify scans as normal or abnormal based on the shape and
symmetry of striatal tracer uptake. Despite being the established clinical
standard, visual assessment is inherently subjective and suffers from
well-documented limitations. Inter-rater variability is a primary concern:
agreement between readers degrades considerably in early-stage presentations,
where putaminal thinning produces only subtle deviations from the normal
bilateral comma-shaped pattern @jakobsonmoAccuracy2015. Beyond reproducibility,
visual reads are not easily generalizable across sites and reader experience
levels, and provide no structured numerical output that can be tracked
longitudinally or compared across cohorts. A 2021 systematic review confirmed
that DaTscan led to a change in clinical management in approximately half of
patients tested and altered the final diagnosis in roughly one third
@begaClinical2021, underscoring both its practical impact and the uncertainty
inherent in current interpretive practice.

/*problems w/ semiquantitative*/
Semi-quantitative analysis through the Striatal Binding Ratio (SBR) was
introduced to address the reproducibility shortcomings of visual reads,
providing a numerical summary by comparing tracer uptake in predefined
striatal regions against a background reference @tinazSemiquantitative2018.
However, this approach carries its own set of limitations. The SBR thresholds
applied in practice are ad-hoc: they were derived predominantly from cohorts
with advanced disease, which reduces their sensitivity at earlier stages
@palermoDopamine2021. Many semi-quantitative pipelines additionally require
spatial registration of the patient volume to a standard template, introducing
dependence on registration quality and making results less subject-specific.
Moreover, compressing a full three-dimensional SPECT volume into a handful of
regional means discards spatial information about the distribution of uptake
within regions, asymmetry texture, and subtle intensity patterns that may carry
diagnostic value @tinazSemiquantitative2018.

/* this mentions the state of datquant & basgan*/
Commercial implementations of semi-quantitative analysis, such as DaTQUANT
@brogleyDaTQUANT2019 and BasGANv2, automate parts of this pipeline but are not
publicly available: DaTQUANT is a paid proprietary tool, and BasGANv2 is not
currently accessible for independent research use. This limits their utility for
open, reproducible research and precludes their free application to datasets
such as PPMI @marekParkinson2011.

Both limitations are most consequential where automated tools would have the
greatest clinical impact: in borderline and early-stage presentations where
these assessments are least reliable. These considerations motivate data-driven
approaches that operate directly on the full image volume rather than on derived
scalar summaries.

// done up to here

== Deep learning for neuroimaging classification

/*
* Adrià:
* here just talk about classifying anything using neuroimaging
*
* === Transfer Learning
* ...
* === Explainability
* ...
*
* */

// Generic papers on deep learning in neuroimage classification
/*
* Classifier on AD instead
@article{joDeep2019,
  title = {Deep {{Learning}} in {{Alzheimer}}'s {{Disease}}: {{Diagnostic Classification}} and {{Prognostic Prediction Using Neuroimaging Data}}},
  author = {Jo, Taeho and Nho, Kwangsik and Saykin, Andrew J.},
  date = {2019-08-20},
  journaltitle = {Frontiers in Aging Neuroscience},
  doi = {10.3389/fnagi.2019.00220},
  url = {https://www.frontiersin.org/journals/aging-neuroscience/articles/10.3389/fnagi.2019.00220/full},
}*/

/*
* Kind of an overview:
@article{akanDeep2025,
  title = {Deep {{Learning}} in Neuroimaging for Neurodegenerative Diseases: {{State-of-the}} Art, {{Challenges}}, and {{Opportunities}}},
  author = {Akan, Taymaz and Akan, Sara and Alp, Sait and Ledbetter, Christina Raye and Tafti, Ahmad P. and Arevalo, Octavio and Bhuiyan, Mohammad Alfrad Nobel},
  date = {2025-11-15},
  journaltitle = {Journal of the Neurological Sciences},
  doi = {10.1016/j.jns.2025.123735},
  url = {https://www.sciencedirect.com/science/article/pii/S0022510X25003557},
  keywords = {3D brain scans,Brain disorders,Brain volume,CNN,Deep learning,Early diagnosis,Neurodegenerative diseases,Neuroimaging modalities,Transformers},
}
*/

The success of convolutional neural networks on large-scale natural image
benchmarks translated rapidly to neuroimaging, where CNNs now constitute the
dominant paradigm for image-based classification of neurological disease.
Litjens et al. @litjensSurvey2017 provided an early comprehensive survey of this
transition, documenting how end-to-end learned representations displaced
handcrafted feature pipelines across medical imaging domains, including brain
lesion detection and neurodegenerative disease staging. More recently, Akan et
al. @akanDeep2025 surveyed the state of deep learning across multiple
neurodegenerative conditions and imaging modalities, finding that CNN- based
architectures, alongside emerging transformer-based approaches, achieve
state-of-the-art performance on tasks including Alzheimer's disease (AD)
staging, PD classification, and multiple sclerosis lesion segmentation.

The AD literature provides the closest methodological parallel to DaTscan
classification: both tasks involve detecting subtle pathological changes in a
three-dimensional brain image, often against a backdrop of normal anatomical
variation and with limited labeled training data. Jo et al. @joDeep2019 reviewed
CNN-based approaches for AD diagnostic classification and prognostic prediction
from neuroimaging, highlighting consistent gains from 3D architectures and
transfer learning, and noting that model interpretability remains a persistent
barrier to clinical adoption. The themes that dominate this literature: the
trade-off between 2D and 3D representations, the utility of pretraining under
data scarcity, and the need for interpretable decisions; are directly relevant
to the DaTscan problem and inform the architecture choices evaluated in this
thesis.

== Deep learning for DaTscan classification

/* this section should be for DaTscan classification only, and needs specific
* works to be cited, it's sota in the end, not just previous concepts
* */

/*
// Here they use PPMI but SVM with RBF kernel on SBR data derived from datscan, 
// could maybe be used to mention previous state (classic ML on tabular data)
@article{prashanthAutomatic2014,
  title = {Automatic Classification and Prediction Models for Early {{Parkinson}}’s Disease Diagnosis from {{SPECT}} Imaging},
  author = {Prashanth, R. and Dutta Roy, Sumantra and Mandal, Pravat K. and Ghosh, Shantanu},
  date = {2014-06-01},
  journaltitle = {Expert Systems with Applications},
  shortjournal = {Expert Systems with Applications},
  volume = {41},
  number = {7},
  pages = {3333--3342},
  issn = {0957-4174},
  doi = {10.1016/j.eswa.2013.11.031},
  url = {https://www.sciencedirect.com/science/article/pii/S0957417413009512},
  urldate = {2026-06-01},
  keywords = {Computer-aided early diagnosis,Logistic regression,Parkinson’s disease,Pattern analysis,Risk prediction,Support vector machine},
  file = {/home/ak/Zotero/storage/5VIPGR5X/Prashanth et al. - 2014 - Automatic classification and prediction models for early Parkinson’s disease diagnosis from SPECT im.pdf;/home/ak/Zotero/storage/C8GZM4KD/S0957417413009512.html}
}
*/

/*
// They use PPMI:
@article{ortizParkinsons2019,
  title = {Parkinson's {{Disease Detection Using Isosurfaces-Based Features}} and {{Convolutional Neural Networks}}},
  author = {Ortiz, Andrés and Munilla, Jorge and Martínez-Ibañez, Manuel and Górriz, Juan M. and Ramírez, Javier and Salas-Gonzalez, Diego},
  date = {2019-07-02},
  journaltitle = {Frontiers in Neuroinformatics},
  publisher = {Frontiers},
  doi = {10.3389/fninf.2019.00048},
  url = {https://www.frontiersin.org/journals/neuroinformatics/articles/10.3389/fninf.2019.00048/full},
}

// they too use PPMI
@inproceedings{martinez-murcia3D2017,
  title = {A {{3D Convolutional Neural Network Approach}} for the {{Diagnosis}} of {{Parkinson}}’s {{Disease}}},
  booktitle = {Natural and {{Artificial Computation}} for {{Biomedicine}} and {{Neuroscience}}},
  author = {Martinez-Murcia, Francisco Jesús and Ortiz, Andres and Górriz, Juan Manuel and Ramírez, Javier and Segovia, Fermin and Salas-Gonzalez, Diego and Castillo-Barnes, Diego and Illán, Ignacio A.},
  date = {2017},
  publisher = {Springer International Publishing},
  doi = {10.1007/978-3-319-59740-9_32},
  keywords = {Convolutional Neural Network,Independent Component Analysis,Progressive Supranuclear Palsy,Single Photon Emission Compute Tomography},
}

// These guys also use and compare transfer learning alongside datscan and PPMI
@article{pantDeep2025,
  title = {Deep {{Learning-Based Feature Extraction}} and {{Machine Learning Models}} for {{Parkinson}}'s {{Disease Prediction Using DaTscan Image}}},
  author = {Pant, Janmejay and Pant, Hitesh and Pant, Vinay and Bhatt, Vikas and Rautela, Devendra and Joshi, Kapil},
  date = {2025-01-20},
  journaltitle = {Biomedical and Pharmacology Journal},
  doi = {10.13005/bpj/3079},
}

// These guys also use PPMI and the InceptionV3 architecture (which I don't, but)
@online{quanDaTscan2019,
  title = {{{DaTscan SPECT Image Classification}} for {{Parkinson}}'s {{Disease}}},
  author = {Quan, Justin and Xu, Lin and Xu, Rene and Tong, Tyrael and Su, Jean},
  date = {2019-09-09},
  eprint = {1909.04142},
  eprinttype = {arXiv},
  eprintclass = {eess.IV},
  doi = {10.48550/arXiv.1909.04142},
  url = {http://arxiv.org/abs/1909.04142},
  urldate = {2026-06-01},
  pubstate = {prepublished},
  keywords = {Computer Science - Computer Vision and Pattern Recognition,Computer Science - Machine Learning,Electrical Engineering and Systems Science - Image and Video Processing,Statistics - Machine Learning},
}
*/

Before CNN-based approaches were applied to DaTscan imaging, automated analysis
relied on classical machine learning classifiers trained on semi-quantitative
features derived from the images. Prashanth et al. @prashanthAutomatic2014
demonstrated that an SVM with an RBF kernel trained on SBR values from PPMI
achieved high classification accuracy for early PD diagnosis, establishing a
strong tabular baseline and confirming that the imaging-derived SBR already
captures most of the discriminative signal for binary PD classification.

The transition to deep learning was led by works that applied convolutional
networks directly to the volumetric data. Martinez-Murcia et al.
@martinez-murcia3D2017 trained a 3D CNN on PPMI DaTscan images, showing that
spatial patterns within the full volume could be exploited for classification
without reducing the data to hand-engineered scalar summaries. Ortiz et al.
@ortizParkinsons2019 proposed an intermediate representation: isosurfaces
computed from the 3D volume served as a compact structural encoding, which was
then classified by a CNN, achieving an AUC of $97%$ on PPMI. Both works
demonstrated the representational potential of volumetric DaTscan data, but
required bespoke preprocessing to handle the dimensionality of the input.

Limitations in data availability and computational cost prompted adoption of 2D
transfer learning strategies. Quan et al. @quanDaTscan2019 evaluated InceptionV3
pretrained on ImageNet applied to 2D slices from PPMI volumes, demonstrating
competitive classification performance with substantially reduced training cost.
Kurmi et al. @kurmiEnsemble2022 extended this line of work into a fuzzy ensemble
of four pretrained 2D architectures (VGG16, ResNet50, InceptionV3, and Xception)
achieving AUC values above 0.95 on PPMI. More recently, Pant et al.
@pantDeep2025 combined CNN-based feature extraction with classical downstream
classifiers in a hybrid pipeline, again evaluated on PPMI. The near-universal
reliance on PPMI across these works makes it the de facto benchmark for DaTscan
deep learning studies and methodological comparisons.

/* reference some papers/works here, there have to be some that you have not
* found, this section needs some more references. */

=== Transfer learning

Transfer learning addresses data scarcity by initializing network weights from a
large auxiliary dataset before fine-tuning on the target task. For 2D
architectures, ImageNet @dengImageNet2009 pretrained weights (available for
ResNet, VGG, and related backbones) are the standard source, and have been shown
to improve generalization in data-limited medical imaging settings despite the
domain gap between natural photographs and medical scans.

For 3D volumetric models, domain-specific pretraining is more appropriate
@raghuTransfusion2019. MedicalNet @chenMed3D2019 provides ResNet backbones
pretrained on 23 heterogeneous medical image segmentation datasets including
SPECT volumes, offering feature representations more semantically aligned
with the target task than ImageNet features.

=== Explainability

/*They use PPMI and a VGG16 w/ transfer learning too. They propose a machine learning model that accurately classifies
any given DaTSCAN as having Parkinson's disease or not, in addition to providing
a plausible reason for the prediction.

@article{mageshExplainable2020,
  title = {An {{Explainable Machine Learning Model}} for {{Early Detection}} of {{Parkinson}}'s {{Disease}} Using {{LIME}} on {{DaTSCAN Imagery}}},
  author = {Magesh, Pavan Rajkumar and Myloth, Richard Delwin and Tom, Rijo Jackson},
  date = {2020-11-01},
  shortjournal = {Computers in Biology and Medicine},
  issn = {0010-4825},
  doi = {10.1016/j.compbiomed.2020.104041},
  url = {https://www.sciencedirect.com/science/article/pii/S0010482520303723},
  urldate = {2026-06-01},
  keywords = {Computer-aided diagnosis,Convolutional neural network,Explainable AI,Interpretability,Parkinson's disease},
}
*/

A recurring limitation of deep learning models in clinical settings is their
opacity: a model may achieve high classification accuracy without providing any
explanation of which image regions or features drove its decision, which is a
significant barrier to clinical adoption. Two complementary techniques dominate
the interpretability literature in this context.

- Gradient-weighted Class Activation Mapping (Grad-CAM) computes a coarse
  spatial map highlighting the image regions that most influenced a specific
  prediction, by weighting the feature maps of a convolutional layer by the
  gradient of the class score with respect to those maps @selvarajuGradCAM2017.

- SHAP (SHapley Additive exPlanations) provides complementary feature-level
  explanations for both classical and deep models by assigning each input
  feature a contribution score derived from cooperative game theory
  @lundbergUnified2017.

Both techniques have been applied to DaTscan classification. Magesh et al.
@mageshExplainable2020 incorporated LIME-based saliency maps into a VGG16
classifier trained on PPMI, identifying image regions consistent with striatal
uptake as the primary basis for the model's predictions and arguing that such
visualizations are a prerequisite for clinical deployment. In the DaTscan
context, Grad-CAM can further reveal whether a CNN attends to anatomically
plausible regions such as the posterior putamen, while SHAP can quantify the
contribution of individual tabular clinical variables. Incorporating these tools
alongside classification metrics is increasingly expected in clinical machine
learning, and both are applied in this thesis.


== Multimodal neuroimaging fusion with clinical variables

/* 
* previously 'Multimodal Fusion with Clinical Variables'
* TODO: change contents. Feeback:
* this needs more works to be cited, not just PPMI and another. If not enough
* papers/references can be found, then this subsection should be removed
* */

The clinical assessment of PD integrates imaging findings with motor examination
scores, olfactory testing, demographic context, and patient history. Multimodal
machine learning formalizes this integration by combining representations from
multiple data sources within a single predictive model. Fusion strategies are
broadly classified by the stage at which modalities are combined: _early fusion_
merges raw feature representations before any modality-specific processing;
_late fusion_ combines independent per-modality predictions at the decision
level; and _intermediate fusion_ merges learned embeddings from separate
processing branches before the classification head @liReview2024.

This paradigm has been explored most thoroughly in the AD literature, where
combining structural MRI with cognitive test scores and genetic risk factors has
consistently outperformed single-modality approaches @youngAccurate2013. For PD
specifically, Ding et al. @dingParkinsons2024 proposed a contrastive graph
cross-view learning framework that jointly processes DaTscan SPECT images and
clinical features, reporting an AUC of $92.8%$ in five-fold cross-validation on
PPMI. The PPMI dataset @marekParkinson2011 provides a uniquely rich resource for
such experiments: alongside DaTscan SPECT volumes, it collects motor assessments
(MDS-UPDRS), olfactory testing (UPSIT), cognitive screening, and biospecimen
markers from a standardized longitudinal cohort. Despite this richness, few
studies have systematically quantified which clinical modalities contribute the
most complementary information to imaging for binary PD classification.


/*
These are the guys mentioned with DaTscans and metadata:
@inproceedings{dingParkinson2023,
  author  = {Ding, Jun-En and Hsu, Chien-Chin and Liu, Feng},
  title   = {Parkinson Disease Classification Using Contrastive Graph Cross-View Learning with Multimodal Fusion of {SPECT} Images and Clinical Features},
  year    = {2023},
  eprint  = {2311.14902},
  archivePrefix = {arXiv}
}

* These guys use voice recordings from UCI using both ML and DL
@article{srinivasanDetection2024,
  title = {Detection of {{Parkinson}} Disease Using Multiclass Machine Learning Approach},
  author = {Srinivasan, Saravanan and Ramadass, Parthasarathy and Mathivanan, Sandeep Kumar and Panneer Selvam, Karthikeyan and Shivahare, Basu Dev and Shah, Mohd Asif},
  date = {2024-06-15},
  journaltitle = {Scientific Reports},
  publisher = {Nature Publishing Group},
  issn = {2045-2322},
  doi = {10.1038/s41598-024-64004-9},
  url = {https://www.nature.com/articles/s41598-024-64004-9},
  urldate = {2026-06-01},
  keywords = {Cancer,Diseases,Health care,Medical research,Risk factors},
}
*/


== Research gap
// this section is ok

The present work addresses two specific gaps in the existing literature. First,
direct comparisons of 2D projection-based, 2.5D multi-axis, and 3D volumetric
CNN architectures under identical preprocessing and evaluation conditions remain
relatively uncommon in the DaTscan literature. Second, the complementary
diagnostic value of tabular clinical variables (motor function, olfactory
sensitivity, and demographics) combined with DaTscan-derived image features has
not been systematically quantified in the DaTscan literature using PPMI as a
standardized benchmark for binary HC compared to manifest PD classification. 
