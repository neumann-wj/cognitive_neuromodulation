function D=wjn_remove_bad_time_segments(filename,segments,mode)

D=wjn_sl(filename);

if D.ntrials > 1
    error('This function is intended for continuous data!')
end

if strcmp(mode,'remove')
    ksamples = 1:D.nsamples;
    rsamples=[];
    for a = 1:size(segments,1)
        rsamples = [rsamples D.indsample(segments(a,1)):D.indsample(segments(a,end))];
    end
    ksamples(rsamples)=[];
elseif strcmp(mode,'keep')
    rsamples = 1:D.nsamples;
    ksamples = [];
    for a=1:size(segments,1)
        ksamples = [ksamples D.indsample(segments(a,1)):D.indsample(segments(a,end))];
    end
            
    rsamples(ksamples) = [];
end

fname = D.fname;
D=wjn_spm_copy(D.fullfile,['a' fname]);
try
anames = fieldnames(D.analog);
for a = 1:length(anames)
    D.analog.(anames{a})(rsamples)=nan;
end
catch
    disp('no analog channels found')
end
if length(size(D))==4
    nd = D(:,:,ksamples,:);
    D(:,:,rsamples,:) = nan;
else
    nd = D(:,ksamples,:);
    D(:,rsamples,:) = nan;
end
save(D)
if length(size(nd))==3
    s = [size(nd) 1];
else
    s=size(nd);
end


if length(s)==2;
    s(3) = 1;
end
nD=clone(D,['r' D.fname],s);
nD=timeonset(nD,0);
% keyboard
nD(:,:,:,:) = nd(:,:,:,:);
try
for a = 1:length(anames)
    nD.analog.(anames{a})(rsamples)=nan;
end
catch
end
save(nD)

D=nD;
