close all
clear
clc

%% Ruta datos Llaima
addpath("DatosLlaima");

%% LP
dataLP = h5read('lp.hdf5','/LP');
[~,~,eventos]=size(dataLP);
i_global=0;
coleccion=[];
for i=1:eventos
    i_global=i_global+1;
    coleccion(i_global).evento=dataLP(1,:,i);
    coleccion(i_global).tipo="LP";
end

%% VT
dataVT = h5read('vt.hdf5','/VT');
[~,~,eventos]=size(dataVT);


for i=1:eventos
    i_global=i_global+1;
    coleccion(i_global).evento=dataVT(1,:,i);
    coleccion(i_global).tipo="VT";
end

%% TC
dataTC = h5read('tc.hdf5','/TC');
[~,~,eventos]=size(dataTC);


for i=1:eventos
    i_global=i_global+1;
    coleccion(i_global).evento=dataTC(1,:,i);
    coleccion(i_global).tipo="TC";
end
%% TR
dataTR = h5read('tr.hdf5','/TR');
[~,~,eventos]=size(dataTR);


for i=1:eventos
    i_global=i_global+1;
    coleccion(i_global).evento=dataTR(1,:,i);
    coleccion(i_global).tipo="TR";
end

clearvars dataLP dataTC dataTR dataVT eventos
%% Detección de Fin
numMuestra=6000;
for i=1:i_global
    s=coleccion(i).evento;
    finT=numMuestra;
    for j=1:length(s)-4
        if s(j)==s(j+1) && s(j)==s(j+2) && s(j)==s(j+3) && s(j)==s(j+4)
            finT=j;
            break;
        end
    end
    s=s(1:finT);
    %% Retirar valor medio
    s=s-mean(s);
    %% Grabar en colección
    coleccion(i).evento=s;
end


rutaGeneral="LlaimaPeriodS\";
cc = jet; %Gama de color
nueralInput=[227,227]; % Red Neuronal tamaño entrada SqueezeNet
fs=100; %Frecuencia de muestreo
% compute spectrogram and scalograms
f   = 1:0.2:25;
o   = [10, 20];
mul = 1; % enable multiplicative super-resolution (for better frequency localization)

ventana=10;
for i=1:i_global
    S_superlet = aslt(coleccion(i).evento, fs, f, 3, o, mul);
    S_superlet=log10(S_superlet); %Escala Logaritmica
    S_superlet=smoothed_N(S_superlet,ventana);
    %% Normalización Superlet
    S_superlet=S_superlet-min(S_superlet(:));
    S_superlet=ceil((S_superlet/max(S_superlet(:)))*255);
    S_superlet=uint8(S_superlet);
    %% Gama para RGB
    RGB = ind2rgb(S_superlet,cc);
    RGB = imresize(RGB,[nueralInput(1), nueralInput(2)]);
    RGB = flip(RGB);
    % figure(1)
    % imshow(RGB)
    % a=input("w");
    disp(i);
    ruta= strcat(rutaGeneral,coleccion(i).tipo,"\",int2str(i),".png");
    imwrite(RGB,ruta);
end