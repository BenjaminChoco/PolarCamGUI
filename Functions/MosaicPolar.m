function [Imos] = MosaicPolar(Iraw)
% Cette fonction permet de s�parer les polarisation issues des microgrilles
% de la cam�ra polarim�trique pour les regrouper ensembles chacune de leur
% cot�.
% Imos = SeparPolar(Iraw)
% INPUT :
% Iraw : image RAW issue de la cam�ra polarim�trique
% OUTPUT :
% Imos : image s�par�e en 4 parties. Les polarisation sont regroup�es
% ensembles dans un m�me coin de l'image.

% end
[I0, I45, I90, I135] = SeparPolar(Iraw);
Imos = cat(1,cat(2, I90, I45),cat(2, I135, I0)); % Les polar sont regroup�es chacunes dans leur coin.
end