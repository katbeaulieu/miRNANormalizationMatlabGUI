function factor = weightedFactor(colVec,refCol,logRatio,sumTrim,doWeighting,Acutoff)

if colVec == refCol
    factor = 1;
    return;
end

nO = nansum(colVec);

nR = nansum(refCol);



logR = log2((colVec./nO)./(refCol./nR));

absE = ((log2(colVec./nO))+(log2(refCol./nR)))/2;

v = ((nO-colVec)./nO./colVec) + ((nR-refCol)./nR./refCol);


fin = isfinite(logR) & isfinite(absE) & (absE > Acutoff);

logR = logR(fin);

absE = absE(fin);


v = v(fin);


n = nansum(fin);
loL = floor(n*logRatio)+1;
hiL = n+1 - loL;
loS = floor(n*sumTrim) + 1;

hiS = n + 1 - loS;
%correct

rank1 = tiedrank(logR);

rank2 = tiedrank(absE);

keep = (rank1 >= loL & rank1 <= hiL) & (rank2 >= loS & rank2 <= hiS);

if doWeighting == 1
    factor = 2^(nansum(logR(keep)./v(keep))./(nansum(1./v(keep))));
else
    factor = 2^(nanmean(logR(keep)));
end






