function [S0,S1,S2] = Polars2Stokes(I0, I45, I90, I135)
% Calcule le vecteur de Stokes linéaire à partir des 4 polarisations fournies (à 0°, 45°, 90°,
% 135°) par l'image RAW Iraw.
%
% INPUT : 
% I0, I45, I90, I135 : Images des polarisations linéaires aux angles 0°, 45°, 90°,
% 135°).
%
% OUTPUT :
% Idolp : 3 images contenant chacune un coefficient du vecteur de Stokes


I0 = double(I0);
I45 = double(I45);
I90 = double(I90);
I135 = double(I135);

% Calcul des composantes du vecteur de Stokes linéaire
S0 = (I0 + I45 + I90 + I135)/2;
S1 = I0 - I90;
S2 = I45 - I135;
end