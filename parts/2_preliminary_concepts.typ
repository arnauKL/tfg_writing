#import "../assets/ak_tfg_lib.typ": *

= Preliminary Concepts
//== Parkinson's Disease
// Epidemiology: prevalence, age of onset
// Pathophysiology: focus on neurodegeneration in the substantia nigra and its
// projection to the striatum. Keep it tightly scoped to what's relevant: you're explaining *why
// dopamine loss in the striatum is what DaTscan measures, so everything should
// build toward that. You don't need to cover all PD pathology --- just the
// dopaminergic circuit. A good citation anchor here would be a major PD review
// paper.
//== DaTSCAN (#super[123]Ioflupane)
// Explain the mechanism (DAT transporter binding, SPECT imaging)
// what the resulting images look like (comma vs period visual)
// why it produces the image pattern the CNN will learn to classify
// The PPMI protocol docs and original validation papers are adequate here
//== Convolutional Neural Networks (CNNs)
// To Adrià: Should I explain basics like perceptrons and connections?
// Start with convolutional layers and explain the inductive bias that makes
// them suited to images (local feature detection, translation invariance,
// hierarchical features.
// Show the convolution equation, but frame it in terms of what it does rather

// than what it is (whatever that means).
// Then pooling, activation functions and the overall architecture concept
//== Evolution of CNNs in Medical Imaging
// Cover LeNet -> AlexNet, then talk about the shift to deeper architectures
// (VGG, ResNet with its residual connections), and then the specific adoption
// in medical imaging.
// The Litjens et al. 2017 survey "A survey on deep learning in medical image
// analysis" is the canonical citation here and covers everything you need.
//== Clasical Machine learning
// SVM, logistic regression
