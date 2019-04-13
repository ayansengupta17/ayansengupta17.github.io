---
title: "Extracting Water Resources From Satellite Images <br> <br><img src='/images/project-2/images/teaser.jpg'>"
excerpt: "In this project, a Convolution Neural Network (CNN) was trained to detect
water bodies in satellite images which produced promising result. <br/><img src='/images/header.jpg'>"
header:
  image: project-2/images/header.jpg
collection: projects
author_profile: true
---


# Introduction
In the age of climate change and global warming, monitoring of water bodies is an ultimate essence. Geographical data frequently shows up the drying up of lakes, rivers. Whereas the scientific data shows us the gradual increase of sea water level. The main motivation of the project is to monitor the change in the water resources. We have achieved a small part of this greater motivation by applying Machine learning techniques on satellite images to extract water body resources.

# Methodology:

### Data collection and preprocessing:

 We used sentinel-2 satellite image(in WGS 64 co-ordinate system) obtained from USGS earth explorer for training the model. The shape files have been downloaded from Geofabrik. The shape files are available only in WGS84 coordinate system. Hence the satellite image has been converted to WGS84 coordinate system.

 The shape files has been then rasterized into bitmap image which has only 0s and 1s where 0 represents the non water area and 1 represents the water bodies.
The Satellite image (which is in WGS64) was converted into WGS84 coordinate system, so that the GeoTIFF image will be overlapped onto the bitmap image to locate the presence of water.

We have used 15 satellite images. Dimesnsion of the images are very large and hence we have createed tiles of 64 x 64 x 3 size small larger number of images, which was used to train the model. Around 80000 smaller sized images has been created. Preprocessing of images motivated from DeepOSM libraries

### Our network
We started out with 1 convolutional layers we could not get suitable results even on our training dataset. Thereafter we fixed our network to have 2 convolutional layers.

We have tried tweeking the convolution network with the following range of Hyper parameter values. The best hyper parameters  has been shown in the result session


<figure>
  <img src="{{site.url}}/images/project-2/images/1.jpg" alt="my alt text"/>
  <figcaption>This is my caption text.</figcaption>
</figure>


**One layer architecture**:
|Hyperparameters| Values|
|------|-------|
 |Architecture | 1 layers|
|Filters for layer 1 | 64|
|Kernel size for layer 1 | 12|
|Stride for layer 1 | (3,3) to (4,4)|
|Max pool for layer 1 | (4,4)|
|Learning rate | 0.005 |
|Momentum | 0.9 |
|Convolution layer activation function | Relu |
|Output layer activation function | sigmoid|


**Two layer architecture**:
|Hyperparameters|Values|
|------|------|
 |Architecture | 2 layers|
|Filters for layer 1 | 64|
|Kernel size for layer 1 | 6-9|
|Stride for layer one | (2,2) to (5,5)|
|Max pool for layer 1 | (4,4)|
|Filters for layer 2 | 64 and 128|
|Kernel for layer 2| 3and 4|
|Stride for layer 2| (2,2) to (4,4)|
|Learning rate| 0.01 - 0.0005 |
|Momentum| 0.7 to 0.9 |
|Convolution layer activation function| Relu, Leaky Relu and softplus |
|Output layer activation function| sigmoid|

## Results

The best results were got for 2 layer convolution neural network with  relu activation function for the 2 covolution layers and sigmoid activation function for fully connected layer.For the 1st covolution layer  filter dimention is 64 and kernal size 7   with stride [3 , 3]. Then max pooling was done with filter $4 \times 4$\par. For 2nd convolution layer the filter dimension is 128 and kernal size 4 and with stride
[2 , 2]. The optimum learning rate was 0.005 and momentum 0.9. The evaluation of best model gives\\

**Accuracy = 98.1 %**
**Precision = 97.34 %**
**Recall = 98.1 %**



The best evaluations are show in the figures below.The green parts are true positives, the red parts are false positives, the blue parts are false negatives and the rest are true negatives.

