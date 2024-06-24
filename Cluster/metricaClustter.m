function [indice_silhouette,indice_SSW,indice_SSB,indice_WB] = metricaClustter(X,idx)

% metricaClustter 
%% X - vector de datos (caractersiticas)
%% idx - indices 
%% Autor: Fernando Lara
k=unique(idx);

indice_silhouette=mean(silhouette(X,idx));
centroides=[];
distancias=[];
dist_grupo=[];
for i=1:length(k)
    grupo=X(idx==k(i),:);
    centroides(i,:)=mean(grupo);
    distancias=pdist2(grupo,centroides(i,:),'euclidean');
    dist_grupo(i)=sum(distancias);
end
indice_SSW=sum(dist_grupo)/length(X(:,1));

dist_centroides=mean(centroides);
dist_centroides=mean(X);
temp_centroide=pdist2(centroides,dist_centroides,'euclidean');
indice_SSB=mean(temp_centroide);

indice_WB=(indice_SSW*length(k))/indice_SSB;

end