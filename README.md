# Application of Artificial Neural Networks for NARX Nonlinear Systems Identification

The present work aims the application of artificial neural networks in the identification of nonlinear dynamic systems. Open-source tools will be used to implement the NARX framework methods, which will be tested against actual case study data available in the literature.

## Contents:

### Sampling Period

#### waveform.m

Building excitation signals: Multisine, Chirpy(Swept Sine) and Square Sweep

#### tek007.m - tek0016.m

Choosing the ideal sampling period for each of the following signals:
- tek0007.csv - Chirp - Só Gerador e Amp - 20mVpp - 900 A 1350kHz 100MS OK
- tek0008.csv - Chirp - Só Gerador e Amp - 80mVpp - 900 A 1350kHz 100MS OK
- tek0009.csv - Chirp - 20mVpp - 900 A 1350kHz 100MS OK
- tek0010.csv - Chirp - 80mVpp - 900 A 1350kHz 100MS 
- tek0016.csv - Multisine - 50mVpp - 10KhZ (5k pontos - u2 500ms) OK

The used method was based on Luis A. Aguirre' work: https://arxiv.org/pdf/1907.06803.pdf

### Model

#### TSample_tek002.m 

Choosing the ideal sampling period for each of the signal:
- TEK002 - CHIRP 900 A 1350 80 MVPP 100MS

#### TSample_tek002.m 
Choosing the ideal sampling period for each of the signal, after filtering it
- TEK002 - CHIRP 900 A 1350 80 MVPP 100MS

#### SignalGenrators.m 

Clearing input and output data. Prepocessing data

#### ModelsInteratively.m

MATLAB script to interate trough a set of ARMAX orders parameters: n_a, n_b and n_c. Generating ARMAX model

#### NARX.m and NarxNetwork.m

Script responsibles for creating narx models with neural network structures
