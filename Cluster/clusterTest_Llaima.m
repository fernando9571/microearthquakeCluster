close all
clear
clc
rng(371)
%% Ruta datos Llaima


load("datosClusterLlaima.mat");



Obj_Func=[];
ind_silh=[];
k_vector=[3:8];
for k=1:length(k_vector)
    [idx_kmeans,C_kmeans,SumD_kmeans] = kmeans(Rfeature,k_vector(k),"Start","plus");   %KMeans
    [idx_kmedoids,C_kmedoids,SumD_kmedoids] = kmedoids(Rfeature,k_vector(k));   %KMedoids
    ind_silh(1,k)=mean(silhouette(Rfeature,idx_kmeans));
    ind_silh(2,k)=mean(silhouette(Rfeature,idx_kmedoids));
    Obj_Func(1,k)=sum(SumD_kmeans);
    Obj_Func(2,k)=sum(SumD_kmedoids);
end

figure(102)
plot(k_vector,ind_silh(1,:),'-.^','LineWidth',1.7,'MarkerFaceColor',[0 0.7 0.7])
hold on
plot(k_vector,ind_silh(2,:),'--o','LineWidth',1.7,'MarkerFaceColor',[0.8 0.6 0])
grid on
legend('K-Means','K-Medoids')
%title('Grafico de codo')
xlabel('k')
ylabel('Distance')

figure(1)
plot(k_vector,Obj_Func(1,:),'-.^','LineWidth',1.7,'MarkerFaceColor',[0 0.7 0.7])
hold on
plot(k_vector,Obj_Func(2,:)-50000000,'--o','LineWidth',1.7,'MarkerFaceColor',[0.8 0.6 0])
grid on
legend('K-Means','K-Medoids')
%title('Grafico de codo')
xlabel('k')
ylabel('Distance')

k=2;
[idx_kmeans,C_kmeans,SumD_kmeans] = kmeans(Rfeature,k,"Start","plus");   %KMeans
[idx_kmedoids,C_kmedoids,SumD_kmedoids] = kmedoids(Rfeature,k);   %KMedoids

tree = linkage(Rfeature,'single','euclidean');
N=k;
idx_tree=cluster(tree,'maxclust',N);

n=k;
options = fcmOptions(NumClusters=n,Verbose=false);
[centers,U]=fcm(Rfeature,options);
Ut=U';
maxV=max(U)';
idx_fuzzy=zeros(1,length(maxV));
for i=1:n
    s=Ut(:,i);
    f = find(s ==maxV);
    idx_fuzzy(f)=i;
end
idx_fuzzy=idx_fuzzy';


Tbig=tsne(Rfeature,'NumDimensions',3);

figure(1)
for i=1:k
scatter3(Tbig(idx_kmeans==i,1),Tbig(idx_kmeans==i,2),Tbig(idx_kmeans==i,3),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
zlabel("R_{t-sne}^{3}");
legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4","Cluster 5","Cluster 6"},'NumColumns',2,'Location','north')
legend('boxoff')

n_idx = grp2idx(Labels);
Tbig1=tsne(Rfeature,'NumDimensions',2);

figure(111)
for i=1:k
scatter(Tbig1(idx_kmeans==i,1),Tbig1(idx_kmeans==i,2),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
grid on
legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4","Cluster 5","Cluster 6"},'NumColumns',1,'Location','northwest')
%legend('boxoff')
figure(1111)
for i=1:4
scatter(Tbig1(n_idx==i,1),Tbig1(n_idx==i,2),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
grid on
legend({"LP","TC","TR","VT"},'NumColumns',1,'Location','northwest')
%legend('boxoff')
figure(2)
for i=1:k
scatter3(Tbig(idx_kmedoids==i,1),Tbig(idx_kmedoids==i,2),Tbig(idx_kmedoids==i,3),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
zlabel("R_{t-sne}^{3}");
legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4","Cluster 5","Cluster 6"},'NumColumns',2,'Location','north')
legend('boxoff')

figure(21)
for i=1:k
scatter(Tbig1(idx_kmedoids==i,1),Tbig1(idx_kmedoids==i,2),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
zlabel("R_{t-sne}^{3}");
legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4","Cluster 5","Cluster 6"},'NumColumns',2,'Location','north')
legend('boxoff')

% figure(3)
% for i=1:k
% scatter3(Tbig(idx_tree==i,1),Tbig(idx_tree==i,2),Tbig(idx_tree==i,3),'.')
% hold on
% end
% xlabel("R_{t-sne}^{1}");
% ylabel("R_{t-sne}^{2}");
% zlabel("R_{t-sne}^{3}");
% legend("Cluster 1","Cluster 2")

figure(4)
for i=1:k
scatter3(Tbig(idx_fuzzy==i,1),Tbig(idx_fuzzy==i,2),Tbig(idx_fuzzy==i,3),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");
zlabel("R_{t-sne}^{3}");
legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4"},'Location','north')
legend('boxoff')


figure(41)
for i=1:k
scatter(Tbig1(idx_fuzzy==i,1),Tbig1(idx_fuzzy==i,2),'.')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");

legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4"},'Location','north')
legend('boxoff')


figure(43)
for i=1:k
scatter(Tbig1(idx_fuzzy==i,1),Tbig1(idx_fuzzy==i,2),'.b')
hold on
end
xlabel("R_{t-sne}^{1}");
ylabel("R_{t-sne}^{2}");

%legend({"Cluster 1","Cluster 2","Cluster 3","Cluster 4"},'Location','north')
%legend('boxoff')

X=Rfeature;
[SIL,SSW,SSB,WB]=metricaClustter(X,idx_kmeans);
TT=table(SIL,SSW,SSB,WB);

[SIL,SSW,SSB,WB]=metricaClustter(X,idx_kmedoids);
TT=[TT;table(SIL,SSW,SSB,WB)];

% [SIL,SSW,SSB,WB]=metricaClustter(X,idx_fuzzy);
% TT=[TT;table(SIL,SSW,SSB,WB)];

TT.Properties.RowNames={'K-Means','K-Medoids'};
disp(TT);