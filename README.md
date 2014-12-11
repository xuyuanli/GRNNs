GRNNs
=====

Generalised Regression Neural Network

	Overview
The Water Systems research group at the University of Adelaide School of Engineering has been researching the use of artificial neural networks (ANNs) for water resources modeling applications, such as flow forecasting, water quality forecasting and water treatment process modeling since the early 1990s. While Multi-Layer Perceptrons (MLPs) are the most widely used ANN architecture in water resources and hydrology, Generalised Regression Neural Networks (GRNNs) provide an alternative that is worth considering, especially as their structure is fixed and therefore does not have to be determined by trial-and-error. Consequently, this removes some of the uncertainty associated with the ANN model development process. In order to be able to implement GRNNs for research purposes, software code for developing GRNN models has been developed in PGI Visual Fortran 2008.



	Features
The primary feature of the code for developing GRNNs is that is caters to nine (9) different methods of estimating the GRNN smoothing parameter (i.e. nine different method of model calibration / ANN training). Of these methods, five are based on bandwidth estimators used in kernel density estimation, and four are based on single and multivariable calibration strategies.

	Five methods adopted from the kernel density literature 
	The Gaussian reference rule (GRR)
	Biased cross validation (BCV)
	2-stage direct plug-in (DPI) 
	A combination of BCV and DPI (BCVDPI)
	Smoothed cross validation (SCV)

	Four methods based on calibration optimisation strategies 
	Single variable calibration with squared error as the objective function (SVCS)
	Single variable calibration with mean absolute error as the objective function (SVCA)
	Multivariable calibration with squared error as the objective function (MVCS)
	Multi-variable calibration with mean absolute error as the objective function (MVCA)



	Download
Requirements
The provided software is FORTRAN 90 source code, and therefore requires a FORTRAN 90/95 compiler. (The source code was developed using the PGI Visual Fortran 2003.)
Download
GRNN Software
Download
GRNN Software Guide



Terms of Use
The software is freely available to use under the terms and conditions of the Creative Commons license. If you intend to use this software for an academic publication or report, we would appreciate your acknowledgement of the origin of the software by referencing the following article:
	Li X., Zecchin A.C. and Maier H.R. (2014) Selection of smoothing parameter estimators for General Regression Neural Networks - applications to hydrological and water resources modelling, Environmental Modelling and Software, 59, 162-186,  DOI: 10.1016/j.envsoft.2014.05.010.



	Related Publications
For further information on the application of artificial neural networks to water resources modeling and the methods used in their development, please refer to the following articles:
Application of General Regression Neural Networks
	Bowden G.J, Nixon J.B., Dandy G.C., Maier H.R. and Holmes M. (2006) Forecasting chlorine residuals in a water distribution system using a general regression neural network. Mathematical and Computer Modelling, 44(5-6), 469-484.
	Gibbs M.S., Morgan N., Maier H.R., Dandy G.C., Nixon J.B. and Holmes M. (2006) Investigation into the relationship between chlorine decay and water distribution parameters using data driven methods. Mathematical and Computer Modelling, 44(5-6), 485-498.
	May R.J., Dandy G.C., Maier H.R. and Nixon J.B. (2008) Application of partial mutual information variable selection to ANN forecasting of water quality in water distribution systems. Environmental Modelling and Software, 23(10-11), 1289-1299, doi:10.1016/j.envsoft.2008.03.008.
	May R.J., Maier H.R. and Dandy G.C. (2010) Data splitting for artificial neural networks using SOM-based stratified sampling, Neural Networks, 23(2), 283-294, doi:10.1016/j.neunet.2009.11.009.
	Wu W., May R.J., Maier H.R. and Dandy G.G. (2013) A benchmarking approach for comparing data splitting methods for modeling water resources parameters using artificial neural networks, Water Resources Research, 49(11), 7598-7614, DOI: 10.1002/2012WR012713.
Overview / Review Papers
	Maier, H.R., Jain A., Dandy, G.C. and Sudheer, K.P. (2010) Methods used for the development of neural networks for the prediction of water resource variables in river systems: Current status and future directions, Environmental Modelling & Software, 25(8), 891-909, 2010 10.1016/j.envsoft.2010.02.003.
	Maier H.R. and Dandy G.C. (2000) Neural networks for the prediction and forecasting of water resources variables: a review of modelling issues and applications. Environmental Modelling and Software, 15(1), 101-124.
	Wu W., Dandy G.C. and Maier H.R. (2014) Protocol for developing ANN models and its application to the assessment of the quality of the ANN model development process in drinking water quality modeling, Environmental Modelling and Software, 54, 108-127, http://dx.doi.org/10.1016/j.envsoft.2013.12.016.
Input Variable Selection
	Bowden G.J., Dandy G.C. and Maier H.R. (2005) Input determination for neural network models in water resources applications: Part 1 - Background and methodology. Journal of Hydrology, 301(1-4), 75-92.
	Bowden G.J., Maier H.R. and Dandy G.C.(2005) Input determination for neural network models in water resources applications: Part 2 - Case study: Forecasting salinity in a river. Journal of Hydrology, 301(1-4), 93-107.
	Fernando T.M.K.G., Maier H.R. and Dandy G.C. (2009) Selection of input variables for data driven models: An average shifted histogram partial mutual information estimator approach. Journal of Hydrology, 367(3-4), 165-176, doi:10.1016/j.jhydrol.2008.10.019.
	May R.J., Dandy G.C., Maier H.R. and Nixon J.B. (2008) Application of partial mutual information variable selection to ANN forecasting of water quality in water distribution systems. Environmental Modelling and Software, 23(10-11), 1289-1299, doi:10.1016/j.envsoft.2008.03.008.
Data Splitting
	Bowden G.J., Maier H.R. and Dandy G.C. (2002) Optimal division of data for neural network models in water resources applications. Water Resources Research, 38(2), 2.1-2.11.
	Wu W., May R.J., Maier H.R. and Dandy G.G. (2013) A benchmarking approach for comparing data splitting methods for modeling water resources parameters using artificial neural networks, Water Resources Research, 49(11), 7598-7614, DOI: 10.1002/2012WR012713.
ANN Training / Model Selection
	Kingston G.B., Maier H.R. and Lambert M.F. (2008) Bayesian model selection applied to artificial neural networks used for water resources modeling, Water Resources Research, 44, W04419, doi:10.1029/2007WR006155.
	Kingston G.B., Maier H.R. and Lambert M.F. (2006) A probabilistic method to assist knowledge extraction from artificial neural networks used for hydrological prediction. Mathematical and Computer Modelling, 44(5-6), 499-512.
	Kingston G.B., Lambert M.F and Maier H.R. (2005) Bayesian training of artificial neural networks used for water resources modeling. Water Resources Research, 41, W12409, doi:10.1029/2005WR004152.
	Kingston G.B., Maier H.R. and Lambert M.F. (2005) Calibration and validation of neural networks to ensure physically plausible hydrological modeling. Journal of Hydrology, 314(1-4), 158-176.
	Maier H.R. and Dandy G.C. (1999) Empirical comparison of various methods for training feedforward neural networks for salinity forecasting. Water Resources Research, 35(8), 2591-2596.
	Maier H.R. and Dandy G.C. (1998) The effect of internal parameters and geometry on the performance of back-propagation neural networks: an empirical study. Environmental Modelling and Software, 13(2), 193-209.
	Maier H.R. and Dandy G.C. (1998) Understanding the behaviour and optimising the performance of back-propagation neural networks: an empirical study. Environmental Modelling and Software, 13(2), 179-191.
ANN Model Deployment
	Bowden G.J., Maier H.R. and Dandy G.C. (2012) Real-time deployment of artificial neural network forecasting models - understanding the range of applicability, Water Resources Research, 48(10), doi:10.1029/2012WR011984.



Access to the on-line content from the University of Adelaide:
http://www.ecms.adelaide.edu.au/civeng/research/water/software/generalised-regression-neural-network/
