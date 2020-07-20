%% START

clc
clear('all')
load('jun24b.mat')                                                         


%% DEFINE VARIABLES

IDs=unique(control.Studienr);
m = length(IDs); 
maxWindow = 60;                                                            % for slopes calculation


%% ASSUMPTION TESTING

% outliers

for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);
    n_cbt=n.Core;                                                         
    [~,TF(:,i)]=rmoutliers(n_cbt,'movmean',3);
end

figure(1000);

for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);                                                     
    n_cbt=n.Core;                                                          
    subplot((m/2),2,i);
    boxplot(n_cbt);
end

% saveas(gcf,'outliers.pdf');                                              % Subj 4 has outlier

% normality testing using lillie test

accept=nan(1,m); pval=nan(1,m); teststat=nan(1,m); critval=nan(1,m);

figure(1001);

for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);                                                     
    n_cbt=n.Core;
    subplot((m/2),2,i);
    histogram(n_cbt);
    [n,p,kstat,c]=lillietest(n_cbt);
    accept(1,i)=n;                                                         % 0 accept null, 1 reject
    pval(1,i)=p;
    teststat(1,i)=kstat;
    critval(1,i)=c;
end

normalitytesting=vertcat(accept,pval,teststat,critval);
normalitytesting=array2table(normalitytesting);
% saveas(gcf, 'normality.pdf');

%% CBT W/MARKED SLEEP ONSET, 2HR CURVE FIT, GOF & CFIT (CONTROLS) 

f=cell(m,1);
g=cell(m,1);
foutlier=cell(m,1);
goutlier=cell(m,1);

for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:); 
    [~,outlier]=rmoutliers(n.Core,'movmean',3);
    control_cbt(:,i)=n.Core;                                                          
    val001(:,i) = find(ismember(n.('Sleep Stage'),{'N2'}));
    [xData, yData] = prepareCurveData( [], control_cbt(:,i) );
    ft = fittype( 'fourier2' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0 0 0 0 0 0];
    [fitresult_n{i}, gof_n{i}] = fit(xData,yData,ft,opts);  
    f{i} = fitresult_n{i};
    g{i} = gof_n{i};
    [fitresult_n2{i}, gof_n2{i}] = fit(xData,yData,ft,'Exclude',outlier);  
    foutlier{i} = fitresult_n2{i};
    goutlier{i} = gof_n2{i};
    figure(i);
    plot(xData, yData,'-o','MarkerFaceColor','red','MarkerEdgeColor', ...
        'red','MarkerIndices',val001(:,i));
    hold on;
    plot(fitresult_n{i}); 
    hold on;
    scatter(xData(outlier),yData(outlier),50,'*','k');
    hold on;
    plot(fitresult_n2{i},'--r');
    legend hide
    xlabel('Time in Minutes');
    ylabel('Temperature');
    hold off;
end                                                                        % order based on order of unique(IDs)
                                                                           % list, not same as order of slopes

% gof summary table

for i = 1:m
    sse(:,i)=g{i}.sse;
    rsquare(:,i)=g{i}.rsquare;
    dfe(:,i)=g{i}.dfe;
    adjrsquare(:,i)=g{i}.adjrsquare;
    rmse(:,i)=g{i}.rmse;
end

gsummary=vertcat(sse,rsquare,dfe,adjrsquare,rmse);
gsummary(1,m+1)=mean(gsummary(1,1:m));
gsummary(2,m+1)=mean(gsummary(2,1:m));
gsummary(3,m+1)=mean(gsummary(3,1:m));
gsummary(4,m+1)=mean(gsummary(4,1:m));
gsummary(5,m+1)=mean(gsummary(5,1:m));

rowNames={'sse','rsquare','dfe','adjrsquare','rmse'};
colNames={'Subject1','Subject2','Subject3','Subject4','Subject5',...
    'Subject6','Subject7','Subject8','Mean'};
gsummary=array2table(gsummary,'RowNames',rowNames, ...
    'VariableNames',colNames);


for i = 1:m
    ssex(:,i)=goutlier{i}.sse;
    rsquarex(:,i)=goutlier{i}.rsquare;
    dfex(:,i)=goutlier{i}.dfe;
    adjrsquarex(:,i)=goutlier{i}.adjrsquare;
    rmsex(:,i)=goutlier{i}.rmse;
end

goutliersummary=vertcat(ssex,rsquarex,dfex,adjrsquarex,rmsex);
goutliersummary(1,m+1)=mean(goutliersummary(1,1:m));
goutliersummary(2,m+1)=mean(goutliersummary(2,1:m));
goutliersummary(3,m+1)=mean(goutliersummary(3,1:m));
goutliersummary(4,m+1)=mean(goutliersummary(4,1:m));
goutliersummary(5,m+1)=mean(goutliersummary(5,1:m));

goutliersummary=array2table(goutliersummary,'RowNames',rowNames, ...
    'VariableNames',colNames);

% fitresult summary table

for i = 1:m
    a0(:,i)=f{i}.a0;
    a1(:,i)=f{i}.a1;
    b1(:,i)=f{i}.b1;
    a2(:,i)=f{i}.a2;
    b2(:,i)=f{i}.b2;
    w(:,i)=f{i}.w;
end

fsummary=vertcat(a0,a1,a2,b1,b2,w);
fsummary(1,m+1)=mean(fsummary(1,1:m));
fsummary(2,m+1)=mean(fsummary(2,1:m));
fsummary(3,m+1)=mean(fsummary(3,1:m));
fsummary(4,m+1)=mean(fsummary(4,1:m));
fsummary(5,m+1)=mean(fsummary(5,1:m));
fsummary(6,m+1)=mean(fsummary(6,1:m));

rowNames={'a0','a1','b1','a2','b2','w'};
fsummary=array2table(fsummary,'RowNames',rowNames, ...
    'VariableNames',colNames);


for i = 1:m
    a0(:,i)=foutlier{i}.a0;
    a1(:,i)=foutlier{i}.a1;
    b1(:,i)=foutlier{i}.b1;
    a2(:,i)=foutlier{i}.a2;
    b2(:,i)=foutlier{i}.b2;
    w(:,i)=foutlier{i}.w;
end

foutliersummary=vertcat(a0,a1,a2,b1,b2,w);
foutliersummary(1,m+1)=mean(foutliersummary(1,1:m));
foutliersummary(2,m+1)=mean(foutliersummary(2,1:m));
foutliersummary(3,m+1)=mean(foutliersummary(3,1:m));
foutliersummary(4,m+1)=mean(foutliersummary(4,1:m));
foutliersummary(5,m+1)=mean(foutliersummary(5,1:m));
foutliersummary(6,m+1)=mean(foutliersummary(6,1:m));

foutliersummary=array2table(foutliersummary,'RowNames',rowNames, ...
    'VariableNames',colNames);


%% SLOPE CALC (CONTROLS)

% CBT matrix (window x I)

N2i=ismember(control.('Sleep Stage'),'N2');
indices = find(N2i);
N2all_control=control(N2i,11);
N2all_control=table2array(N2all_control);

for p = 1:maxWindow
    N2ix = indices-p;
    N2allx=control(N2ix,11);
    N2allx=table2array(N2allx);
    N2all_control=horzcat(N2all_control,N2allx);
end

N2all_control=transpose(N2all_control);                                    % order based on var ID in control 
                                                                           % table unlike CBT & 2HR fit above
nEntries = maxWindow*(maxWindow + 1) / 2; 
slopes = nan(nEntries, length(IDs)); 
lookupTable = nan(nEntries, 3); 
                                
% Slope calc: Loop over window, over subject

for i = 1:length(IDs)
    idx = 0; 
    for j = 1:maxWindow
        nPositions = maxWindow - j + 1; 
        for k = 1:nPositions 
            idx = idx + 1; 
            a = j; 
            b = j+k;                                                      
            slopes(idx,i) = (N2all_control(a,i) - ...
                N2all_control(b,i))/(b-a);
            lookupTable(idx, :) = [idx, j, k];                             % NFASC016 (8) inc CBT in the window 
        end
    end
end

% Lookup Table

lookupTable = table(lookupTable(:,1), lookupTable(:,2), lookupTable(:,3));
lookupTable.Properties.VariableNames = {'Index', 'WindowSize', ...
    'WindowPosition'};

%% SLOPES (GRADIENT) ON CBT CURVE 

val002=nan(maxWindow,m);
grad0=nan(length(control_cbt),m);
dy1=nan(maxWindow,m);

for i=1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);
    grad0(:,i)=gradient(n.Core);
    dy=gradient(n.Core);
    for ii=1:maxWindow
        val002(ii,i)=val001(:,i)-ii;        
        k=val001(:,i)-ii;
        dy1(ii,i)=dy(k);
    end
end

dy1=flipud(dy1);

figure; plot(dy1)
figure; plot(grad0)

figure('Position',[500,500,500,500])

for i=1:m
    subplot(m,1,i)
    histogram(dy1(:,i))
end

figure('Position',[500,500,500,500])

for i=1:m
    subplot(m,1,i)
    histogram(grad0(:,i))
end

%% TEST THAT GRAD AND SLOPE ARE EQUIVALENT

new = slopes; new = array2table(new); temp = lookupTable(:,2); 
new = horzcat(new,temp); new = new(:,[9,(1:8)]); new = table2array(new);

c = unique(new(:,1));

for i = 1:length(c)
    for ii = 1:m
        xx = new(:,1)==i;
        yy = new(xx,ii+1);
        slopes00(i,ii) = mean(yy);
    end
end

for ii = 1:m
    [p,h,stats]=signrank(dy1(:,ii),slopes00(:,ii));
    p(:,ii)=p;
    h(:,ii)=h;
    stats(:,ii)=stats;
end

slopesvsgrad=horzcat(p,h);

% comparison plot

for i = 1:m
    figure(i)
    subplot(2,1,1); plot(flipud(slopes(:,i)));
    subplot(2,1,2); plot(dy1(:,i));
end

%% END SESSION

save('joustraresults2.mat')

X=gradient(control.Core);
save("stats","X","slopes","grad0","dy1","control","val002","val001");

