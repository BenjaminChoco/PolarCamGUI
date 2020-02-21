function Icorr = PixelCorrection(I,L,Polarized)
% Correction des pixels morts de la cam�ra polarim�trique. Moyennage avec les pixels
% adjacents de m�me polarisation

% INPUTS :
% I : Image � corriger (ont certains pixels sont morts)
% L : liste des coordonn�es des pixels morts : [nl, nc]
% Polarized : Booleen, d�fini si l'image donn�es � des micromatrices
% polarim�trique ou non.

% OUTPUT :
% Icorr : Image I, o� les pixels aux coordonn�es (nl,nc) ont �t� remplac�
% par une moyenne sur les 4 pixels adjacents de m�me �tat de polarisation.

if Polarized == true
    pas = 2;
else
    pas = 1;
end

Icorr = double(I);
[nl,nc] = size(Icorr);
for i = 1:length(L(:,1))
    l = L(i,1);
    c = L(i,2);
    if l > nl-2 % Je ne croise que cette exception dans mon cas, j'ai d�cid� de ne pas g�rer les autres.
        Icorr(l,c) = (I(l-pas,c) + I(l,c-pas) + I(l,c+pas))/3;
    else
        if l < 3
            Icorr(l,c) = (I(l+pas,c) + I(l,c-pas) + I(l,c+pas))/3;
        else
            if c > nc-2
                Icorr(l,c) = (I(l-pas,c) + I(l+pas,c) + I(l,c-pas))/3;
            else
                if c < 3
                    Icorr(l,c) = (I(l-pas,c) + I(l+pas,c) + I(l,c+pas))/3;
                else
                    Icorr(l,c) = (I(l-pas,c) + I(l+pas,c) + I(l,c-pas) + I(l,c+pas))/4;
                end
            end
        end
    end
end


end