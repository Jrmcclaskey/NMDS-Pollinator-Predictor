# NMDS-Pollinator-Predictor
For this project we will utilize a machine learning algorithm to predict plant pollinators based on plant scent as well as flower color. This data was collected utilizing Gas Chromatography and Mass Spectroscopy (GCMS) techniques to create a profile of over 40 different chemicals across the plant fragrance as well as the quantity of chemicals found in the plant fragrance.
### Contents
1. Data Cleaning and Preparation
2. PCA Analysis
3. NMDS Analysis
5. Summary
### Data Cleaning and Preparation
We began by importing our data from its online repository in github found here:

"https://raw.githubusercontent.com/VinaugerLab/BCHM4354_2022/main/Dataset_R_2022.csv"

From there we transform the data into longform and create a variety of subsets of the data to be used in the analysis including removal of the Color and Pollinator rows as their string type data is not useful to our machine learning model until after data points have been calculated.

We generate two quick graphs to take a look at our data points

The first is a count for our different Pollinator types
![alt text](https://github.com/Jrmcclaskey/NMDS-Pollinator-Predictor/blob/68b4391ca6746533127bdbb41eb0edeeed29c602/Images/Pollinators.jpeg)

The next graph is a count of our different plant colors
![alt text](https://github.com/Jrmcclaskey/NMDS-Pollinator-Predictor/blob/68b4391ca6746533127bdbb41eb0edeeed29c602/Images/Color_Count.jpeg)

From this information we determine that there are a variety of different colors and pollinators that will need to be taken into consideration for our final analysis.

### PCA Analysis
Principal Component Analysis (PCA) is a statistical technique used for simplifying the complexity in high-dimensional data while retaining trends and patterns. It does this by transforming the original variables into a new set of variables, called principal components, which are linear combinations of the original features. These principal components are ordered by their ability to explain the variance in the data, with the first component explaining the most variance, the second component explaining the second most, and so on.

Using this technique we can analyze chemical from our data will have the greatest weight on our NMDS plot which is Aldehyde B.

### NMDS Analysis
Non-metric Multi Dimensional Scaling or NMDS is a form of machine learning that places variables int a data matrix to make graphical determinations about likeness for multi-vector variables. This is perfect to utilize for our plant fragrances, the closer two points are to one another on the graph, the closer their fragrance profile is to one another. Utilizing this machine learning, we can predict pollinator type for a plant with a given scent profile.

The graph below summarizes our findings.

![alt text](https://github.com/Jrmcclaskey/NMDS-Pollinator-Predictor/blob/8b5c7ffa46d8e4110cbb8496cf69011f46a91617/Images/NMDS_plot.jpeg)

### Summary
As you can see from our NMDS plot, our unknown pollinator is particularly attracted to pink flowers and is most likely a moth if not a completely different type of insect all together. The unkown's chemical profile are all very similar to one another and are relatively close together meaning our unknown pollinator is most likely attracted to this specific species of plant.

Thank you for your time and I hope you found this presentation informative

Special thanks to Professor Vinauger for his guidance and teaching
