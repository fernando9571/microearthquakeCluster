close all
clear
clc

rng(37)
%% Ruta datos Llaima

load("CotopaxiSuperletS.mat");

net=CotopaxiSuperletS;

Ruta="..\Generacion\LlaimaPeriodS";
imds = imageDatastore(Ruta,'IncludeSubfolders',true,'LabelSource','foldernames');

augImds=augmentedImageDatastore(net.Layers(1, 1).InputSize(1:2),imds);


idx=randperm(numel(imds.Files),9);

imgEx=readByIndex(augImds,idx);

figure;montage(imgEx.input);


% Gather label information from the image datastore
Labels=imds.Labels;
% count the number of images
numClass=numel(countcats(Labels));
disp(unique(Labels));
% 

feature=(activations(net,augImds,'NuevaConv10'));


Rfeature=[];

for i=1:augImds.NumObservations
    
    temp=squeeze(feature(:,:,:,i));
    Rfeature(i,:)=temp(:);
end



figure;
% conduct a principal component analysis for the dimension reduction
A=pca(Rfeature',"Centered",true);
subplot(1,2,1)
gscatter(A(:,1),A(:,2),Labels)
subplot(1,2,2)
% perform t-sne for the dimension reduction
T=tsne(Rfeature);
gscatter(T(:,1),T(:,2),Labels)

figure(23)
Tbig=tsne(Rfeature,'NumDimensions',3);
scatter3(Tbig(:,1),Tbig(:,2),Tbig(:,3),'.','MarkerEdgeColor',[0 .75 .75])
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
zlabel("R_{t-sne}^{3}");
T=tsne(Rfeature);
figure(10);
% conduct a principal component analysis for the dimension reduction
A=pca(Rfeature',"Centered",true);
subplot(1,2,1)
scatter3(A(:,1),A(:,2),A(:,3),15,'filled')
subplot(1,2,2)
% perform t-sne for the dimension reduction
T=tsne(Rfeature);
gscatter(T(:,1),T(:,2),Labels)
%% Image clustering using k-means after feature extraction with Darknet-19
figure(11)
T=tsne(Rfeature,'NumDimensions',3);
scatter3(T(:,1),T(:,2),T(:,3),15,Labels,'filled')
numClass=4;
C=kmeans(Rfeature,numClass,"Start","plus");

[~,Frequency] = mode(C);
sz=net.Layers(1, 1).InputSize(1:2);
% prepare a matrix to show the clustering result
I=zeros(sz(1)*numClass,sz(2)*Frequency,3,'uint8');
% loop over the class to display images assigned to the group
for i=1:numClass
    % read the images assigned to the group 
    % use the function "find" to find out the index of the i-th group image
    ithGroup=readByIndex(augImds,find(C==i));
    % tile the images extracted above
    I((i-1)*sz(1)+1:i*sz(1),1:sz(2)*numel(find(C==i)),:)=cat(2,ithGroup.input{:});
end
figure;imshow(I(:,1:5000,:));title('Clustering example')


save('datosClusterLlaima.mat','Rfeature','Labels','imds');