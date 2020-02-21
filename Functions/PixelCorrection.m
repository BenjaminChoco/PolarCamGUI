function Icorr = PixelCorrection(I,L,Polarized)
% Correction des pixels morts de la caméra polarimétrique. Moyennage avec les pixels
% adjacents de même polarisation

% INPUTS :
% I : Image à corriger (ont certains pixels sont morts)
% L : liste des coordonnées des pixels morts : [nl, nc]
% Polarized : Booleen, défini si l'image données à des micromatrices
% polarimétrique ou non.

% OUTPUT :
% Icorr : Image I, où les pixels aux coordonnées (nl,nc) ont été remplacé
% par une moyenne sur les 4 pixels adjacents de même état de polarisation.

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
    if l > nl-2 % Je ne croise que cette exception dans mon cas, j'ai décidé de ne pas gèrer les autres.
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