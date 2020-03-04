function pyc = shift_checker(pr, pi, par)

nLevels =  spyrHt(pi);
nBands = spyrNumBands(pi);
nHighElems = prod(pi(1,:));
nLowElems = prod(pi(end,:));

% Add space for high and low pass
pyc = [zeros(nHighElems,1); pr; zeros(nLowElems,1)];

% Start at the smallest level
for level = nLevels:-1:1
    
    % Correct this level
    corrected_level = correctLevel(pyc, pi, level, ...
        par.scale, par.limit);
    
    % Get the indices to fix and update pyramid in place
    first_band = 2 + nBands*(level-1);
    indices =  pyrBandIndices(pi,first_band);
    firstind = indices(1);
    ind = pi(first_band:first_band+nBands-1,:);
    pyc(firstind:firstind+sum(prod(ind,2))-1) = corrected_level;
end

% Remove high/lowpass
pyc = pyc(nHighElems+1:end-nLowElems);
end

% Shift correction on one level
function out_level = correctLevel(pyr, pind, level, scale, limit)

out_level=[];
nLevels =  spyrHt(pind);
nBands = spyrNumBands(pind);

% If not at the lowest level
if level < nLevels
    
    % Get level size
    dims = pind((2+nBands*(level-1)),:);
    
    for band=1:nBands
        
        % Get both pyramid levels and resize lower level to same size
        low_level_small = spyrBand(pyr,pind,level+1,band);
        low_level = imresize(low_level_small, dims, 'bilinear');
        high_level = spyrBand(pyr,pind,level,band);
                      
        % Unwrap based on the level below to avoid jumps > pi (Sec 3.2)
        unwrapped = [low_level(:)/scale, high_level(:)];
        p = unwrapped;
        cutoff = [];
        dim =2;

            ni = nargin;

        % Treat row vector as a column vector (unless DIM is specified)
        rflag = 0;
        if ni<3 && (ndims(p)==2) && (size(p,1)==1), 
           rflag = 1; 
           p = p.';
        end

        % Initialize parameters.
        nshifts = 0;
        perm = 1:ndims(p);
        switch ni
        case 1
           [p,nshifts] = shiftdim(p);
           cutoff = pi;
        case 2
           [p,nshifts] = shiftdim(p);
        otherwise    % nargin == 3
           perm = [dim:max(ndims(p),dim) 1:dim-1];
           p = permute(p,perm);
           if isempty(cutoff),
              cutoff = pi; 
           end
        end

        % Reshape p to a matrix.
        siz = size(p);
        p = reshape(p, [siz(1) prod(siz(2:end))]);

        % Unwrap each column of p
        q = LocalUnwrap(p,cutoff);

        % Reshape output
        q = reshape(q,siz);
        q = ipermute(q,perm);
        q = shiftdim(q,-nshifts);
        if rflag, 
           q = q.'; 
        end

        unrappedPhaseDifference = q;
        
        high_level = unrappedPhaseDifference(:,2);
        high_level = reshape(high_level, dims);
                
        % Compute phase difference between the levels 
        angle_diff = atan2(sin(high_level-low_level/scale), ...
            cos(high_level-low_level/scale));
        
        % Find which pixels to shift correct (Eq 10)
        to_fix = abs(angle_diff)>pi/2;
        
        % Apply shift correction (Eq 10)
        high_level(to_fix) = low_level(to_fix)/scale;
        
        % Limit the allowed shift, (Eq 11)
        if limit > 0
            to_fix = abs(high_level) > limit*pi/scale^(nLevels-level);
            high_level(to_fix) = low_level(to_fix)/scale;
        end
        
        out_level = [out_level;high_level(:)];
    end
end

% If lowest level, don't correct anything but the max shift
if level == nLevels
    for band=1:nBands
        low_level = spyrBand(pyr,pind,level,band);
        
        % Limit the allowed shift, if too large, use value from level below
        if limit > 0
            to_fix = abs(low_level)>limit*pi/scale^(nLevels-level);
            low_level(to_fix) = 0;
        end
        out_level = [out_level;low_level(:)];        
    end
end
end
function p = LocalUnwrap(p,cutoff)

    dp = p(2,:) - p(1,:);            % Incremental phase variations
    dps = mod(dp+pi,2*pi) - pi;      % Equivalent phase variations in [-pi,pi)
    dps(dps==-pi & dp>0,:) = pi;     % Preserve variation sign for pi vs. -pi
    dp_corr = dps - dp;              % Incremental phase corrections
    dp_corr(abs(dp)<cutoff) = 0;   % Ignore correction when incr. variation is < CUTOFF

    % Integrate corrections and add to P to produce smoothed phase values
    p(2,:) = p(2,:) + dp_corr;
end