% General display control
function [I] = Display(Iraw, Dx, Dy, display_type, Wt_sparse, vid)
    if isequal(display_type,'mos')
        I = MosaicPolar(Iraw); % Custom function to separate the different polarisation into 4 quadrants of the image.
        colormap gray
    end
    if isequal(display_type,'dolp')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        I(I>1) = 1;
        I(I<0) = 0;
        colormap parula
    end
    if isequal(display_type,'aop')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = (180/pi)*Stokes2AoP(S(:,:,2),S(:,:,3));
        colormap hsv
    end
    if isequal(display_type,'raw')
        if or(isequal(vid.VideoFormat, 'Mono16'), isequal(vid.VideoFormat, 'BayerRG16'))
            I = uint8(Iraw/256);
        else
            I = Iraw; % Raw image without any process.
        end
        colormap gray
    end
    if isequal(display_type,'S0')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        I = S(:,:,1);
        colormap gray
    end
    if isequal(display_type,'hsv')
        [I0, I45, I90, I135] = SeparPolar(double(Iraw));
        Isparse = reshape(cat(3,I90,I45, I135, I0),[Dx*Dy/4,4]);
        I_sparse = Isparse';
        S_sparse = Wt_sparse(1:Dx*Dy*3/4,1:Dx*Dy)*I_sparse(:);
        S = permute(reshape(S_sparse,[3,Dy/2,Dx/2]),[2,3,1]);
        
        DoLP = Stokes2DoLP(S(:,:,1),S(:,:,2),S(:,:,3));
        DoLP(DoLP>1) = 1;
        DoLP(DoLP<0) = 0;
        
        AoP = Stokes2AoP(S(:,:,2),S(:,:,3));
        
        Hue = (pi/2 + AoP)/pi;
        Sat = DoLP;
%         Val = S(:,:,1)./max(max(S(:,:,1)));
%         Val = max(cat(3, DoLP, S(:,:,1)./max(max(S(:,:,1)))),[],3);
        Val = ones(size(DoLP));
        HSV = cat(3,Hue,Sat,Val);
        I = hsv2rgb(HSV);
        
    end
end