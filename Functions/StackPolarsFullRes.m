function [Istack] = StackPolarsFullRes(Iraw)
% Cette fonction permet mettres les polarisations selon la 3e dimension, en
% considérant les polarisations autour des noeuds (coins des pixels).
% Imos = SeparPolar(Iraw)
% INPUT :
% Iraw : image RAW issue de la caméra polarimétrique
% OUTPUT :
% Istack : stack les 4 polarisations en chaque noeud (milieu de 4 pixels)

[nl, nc] = size(Iraw);

% Séparation des polarisations
I90 = Iraw(1:2:nl,1:2:nc); % pixels haut-gauche
I45 = Iraw(1:2:nl,2:2:nc); % pixels haut-droite
I135 = Iraw(2:2:nl,1:2:nc); % pixels bas-gauche
I0 = Iraw(2:2:nl,2:2:nc); % pixels bas-droite

Istack = NaN((nl-1), (nc-1), 4);

Istack(1:2:(nl-1), 1:2:(nc-1), :) = cat(3, I90, I45, I135, I0);
Istack(1:2:(nl-1), 2:2:(nc-1), :) = cat(3, I90(:,2:(nc/2)), I45(:,1:(nc/2-1)), I135(:,2:(nc/2)), I0(:,1:(nc/2-1)));
Istack(2:2:(nl-1), 1:2:(nc-1), :) = cat(3, I90(2:(nl/2),:), I45(2:(nl/2),:), I135(1:(nl/2-1),:), I0(1:(nl/2-1),:));
Istack(2:2:(nl-1), 2:2:(nc-1), :) = cat(3, I90(2:(nl/2),2:(nc/2)), I45(2:(nl/2),1:(nc/2-1)), I135(1:(nl/2-1),2:(nc/2)), I0(1:(nl/2-1),1:(nc/2-1)));
end