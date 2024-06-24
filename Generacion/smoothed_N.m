function [S_smoothed] = smoothed_N(S,ventana)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [a,b]=size(S);
    S_smoothed=[];
    for i=1:a-ventana-1
        for j=1:b-ventana-1
            tempA=sum(sum(S(i:i+ventana,j:j+ventana)));
            S_smoothed(i,j)=tempA;
        end
    end

end

