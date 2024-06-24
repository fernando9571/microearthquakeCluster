# microearthquakeCluster

TITLE
Microearthquakes Identification Based on CNN and Clustering Techniques

ABSTRACT
Microearthquakes are critical for understanding volcanic activity, leading to monitoring many volcanoes worldwide with seismic sensor networks. These networks generate a substantial amount of data, making visual analysis challenging. Consequently, researchers have focused on developing automatic microearthquake recognition systems over the past decades. A primary challenge with these systems is their reliance on labeled databases for training supervised learning models, where the output labels depend on the database labels. In order to improve, we propose using clustering algorithms in conjunction with a fine-tuned Convolutional Neural Network (CNN) as a feature extractor to identify overlapping microearthquakes and other types of microearthquakes without the need for labeled datasets. This methodology has two stages: a First stage that is based on Transfer Learning to specialize the CNN in the recognition of microearthquakes, and a Second stage that uses the fine-tuned CNN as a feature extractor. This methodology is applied to the Cotopaxi and validated in the Llaima volcanoes, with unsupervised databases can find clusters of isolated events with similar characteristics to Long Period (LP), Volcano Tectonic, Tremor, among others. Additionally, it identifies a cluster with overlapping microearthquakes. In the validation stage, 91\% of the LP events are associated to the same cluster, without the need to adjust the fine.tuned CNN. 

FOLDERS
1- Generacion
2- Extraccion
3- Cluster

DETAILS
Generacion
This folder contains RAW data (subfolfder datosLlaima) of volcanic microearthquakes, and with the generationLlaimaSuperlets.m script, these microearthquakes are converted into images with time-frequency representation (subfolder LlaimaPeriodS).

Extraccion
Process to use a CNN as a feature extractor in the clustter_cnn_Llaima.m script

Cluster
Use of cluster algorithms with the features extracted from the CNN in the script clusterTest_Llaima.m