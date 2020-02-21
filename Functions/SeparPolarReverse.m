function [Iraw] = SeparPolarReverse(I0, I45, I90, I135)
% Cette fonction permet de regrouper les polarisation issues des microgrilles
% de la caméra polarimétrique pour les regrouper en superpixels

% Iraw = SeparPolarReverse(I0,I45,I90,135)
% INPUT :
% I0, I45, I90, I135 : quatre images des différentes polarisations
% OUTPUT :
% Iraw : image RAW issue de la caméra polarimétrique

Ndims = ndims(I0);
if Ndims == 2
    [nl, nc] = size(I0);
    nl = 2*nl;
    nc = 2*nc;
    Iraw = NaN(nl,nc);
    
    % Séparation des polarisations
    Iraw(1:2:nl,1:2:nc) = I90; % pixels haut-gauche
    Iraw(1:2:nl,2:2:nc) = I45; % pixels haut-droite
    Iraw(2:2:nl,1:2:nc) = I135; % pixels bas-gauche
    Iraw(2:2:nl,2:2:nc) = I0; % pixels bas-droite
end
if Ndims == 3
    [nl, nc, c] = size(I0);
    nl = 2*nl;
    nc = 2*nc;
    Iraw = NaN(nl,nc,c);
    
    % Séparation des polarisations
    Iraw(1:2:nl,1:2:nc,:) = I90; % pixels haut-gauche
    Iraw(1:2:nl,2:2:nc,:) = I45; % pixels haut-droite
    Iraw(2:2:nl,1:2:nc,:) = I135; % pixels bas-gauche
    Iraw(2:2:nl,2:2:nc,:) = I90; % pixels bas-droite
end
end