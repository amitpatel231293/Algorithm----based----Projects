addpath('matlabPyrTools');
addpath('matlabPyrTools/Mex');

image1 = (imread(imagename1));
image2 = (imread(imagename2));
[h,w,l] = size(image1);
ps.nFrames = 25;
ps.nOrientations = 8;
ps.tWidth = 1;
ps.scale = 0.5^(1/4);
ps.limit = 0.4;
ps.min_size = 15;
ps.max_levels = 23;
ps.nScales = min(ceil(log2(min([h w]))/log2(1/ps.scale) - ...
    (log2(ps.min_size)/log2(1/ps.scale))),ps.max_levels);
output_video = zeros([h,w,l,ps.nFrames],'uint8');

for m=1:2
    
    if m==1
        im = image1;
    else
        im = image2;
    end
    
    %% convert image to LAB
    cform = makecform('srgb2lab');
    im = applycform(im,cform);
    im = im2single(im);
    im_dims = size(im);

    for i=1:size(im,3)
        % Build the pyramid
        [pyr, pind] = buildSCFpyr_scale(im(:,:,i),ps.nScales,...
            ps.nOrientations-1,ps.tWidth,ps.scale,...
            ps.nScales,im_dims);

        % Store decomposition residuals
        high_pass = spyrHigh(pyr,pind);
        low_pass = pyrLow(pyr,pind);
        mhigh_pass(:,i) = high_pass(:);
        mlow_pass(:,i) = low_pass(:);

        % Store decomposition phase and magnitudes
        pyr_levels = pyr(numel(high_pass)+1:numel(pyr)-numel(low_pass));        
        phase(:,i) = angle(pyr_levels);
        amplitude(:,i) = abs(pyr_levels);  

        % Store indices (same every channel)
        pind = pind;
    end
    
    if m==1
        Lhigh_pass = mhigh_pass;
        Llow_pass = mlow_pass;
        Lphase=phase;
        Lamplitude=amplitude;
        Lpind = pind;
    else
        Rhigh_pass = mhigh_pass;
        Rphase=phase;
        Rlow_pass = mlow_pass;
        Ramplitude=amplitude;
        Rpind= pind;
    end
end

%% Compute shift corrected phase difference
phase_diff = Cpd_differnce(Lphase, Rphase, Lpind, ps);

%% Generate inbetween images
step = 1/(ps.nFrames+1);
for f=1:ps.nFrames
    alpha = step*f;

    % Compute new phase
    new_phase =  Rphase + (alpha-1)*phase_diff;

    % Blend amplitude and lowpass
    new_amplitude = (1-alpha)*Lamplitude + alpha*Ramplitude;
    new_lowpass = (1-alpha)*Llow_pass + alpha*Rlow_pass;

    % Compute new pyramid
    new_pyr = new_amplitude.*exp(1i*new_phase);

    % Using either left or right highpass
    if alpha < 0.5
        high_pass = Lhigh_pass;
    else
        high_pass = Rhigh_pass;
    end

    out_pyr = [high_pass;new_pyr;new_lowpass];
    
    pyr =out_pyr;
    param = ps;
    pind = Lpind ;
    imSize = pind(1,:);
    dim = size(pyr,2);
    out_img = zeros(imSize(1),imSize(2),dim);

    % reconstruct each color channel
    for i=1:dim
        out_img(:,:,i) = reconSCFpyr_scale(pyr(:,i), pind, ...
            'all', 'all', param.tWidth, param.scale, param.nScales);
    end

    % convert to RGB
    out_img = im2uint8(out_img);
    cform = makecform('lab2srgb');
    out_img = applycform(out_img,cform);
    
    output_video(:,:,:,f) = out_img;

end

myVideo = VideoWriter(namevid);
uncompressedVideo = VideoWriter(namevid, 'Uncompressed AVI');
myVideo.FrameRate = 69;  % Default 30
myVideo.Quality = 50;    % Default 75
open(myVideo);
writeVideo(myVideo, output_video);
close(myVideo);

