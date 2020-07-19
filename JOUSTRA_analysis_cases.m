%% START

clc
clear('all')
load('jun24b.mat')  


%% DEFINE VARIABLES (EXPERIMENTAL)

IDs=unique(experimental.Studienr);
m = length(IDs); 
maxWindow = 120;                                                           % for slopes calculation


%% DELETE ROWS WITH MISSING DATA IN EXPERIMENTAL TABLE

[rows,~] = find(isnan(experimental.Core));
experimental(rows,:)=[];
[rows,~] = find(isnan(experimental.age));
experimental(rows,:)=[];

%% CHECK AND DELETE I's WHOSE SLEEP ONSET IS MISSING 

q = ismember(experimental.Studienr,'NFASC003'); % NFASC003
experimental(q,:)=[];
q = ismember(experimental.Studienr,'NFASC011');% NFASC011
experimental(q,:)=[];
q = ismember(experimental.Studienr,'NFASP010');% NFASP010
experimental(q,:)=[];

%% REMOVE F's < 60 YO W/O INDICATION OF OVULATION CYCLE FROM EXPERIMENTAL GRP

f_exp=ismember(experimental.gender,{'vrouw'});
check=experimental(f_exp,:);

f_exp2=check.age<60;
check2=check(f_exp2,:);

f_exp3=ismember(check2.Groep,{'control'});
check3=check2(f_exp3,:);
unique(check3.Studienr);
check2(f_exp3,:) = [];

%% ASSUMPTION TESTING

IDs=unique(experimental.Studienr);
m = length(IDs); 

% outliers

for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);
    n_cbt=n.Core;                                                         
    [~,TF1(:,i)]=rmoutliers(n_cbt);
end

figure(2000);

for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);                                                     
    n_cbt=n.Core;                                                          
    subplot(9,3,i);
    boxplot(n_cbt);
end

% saveas(gcf,'outlierscases.pdf');                                         % Subj 1 & 4 *6* have outliers                                              % Subj 4 has outlier

% normality testing using lillie test

accept=nan(1,m); pval=nan(1,m); teststat=nan(1,m); critval=nan(1,m);

figure(2001);

for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);                                                     
    n_cbt=n.Core;
    subplot(9,3,i);
    histogram(n_cbt);
    [n,p,kstat,c]=lillietest(n_cbt);
    accept(1,i)=n;                                                         % 0 accept null, 1 reject
    pval(1,i)=p;
    teststat(1,i)=kstat;
    critval(1,i)=c;
end

normalitytestingcases=vertcat(accept,pval,teststat,critval);
normalitytestingcases=array2table(normalitytestingcases);
% saveas(gcf, 'normalitycases.pdf');

%% CBT W/MARKED SLEEP ONSET, 2HR CURVE FIT, GOF & CFIT  (CASES)

f1 = cell(m,1);
g1 = cell(m,1);
f1outlier=cell(m,1);
g1outlier=cell(m,1);

for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:); 
    [~,outlier]=rmoutliers(n.Core,'movmean',3);
    experimental_cbt(:,i)=n.Core;                                                          
    val001(:,i) = find(ismember(n.('Sleep Stage'),{'N2'}));
    [xData, yData] = prepareCurveData( [], experimental_cbt(:,i) );
    ft = fittype( 'fourier2' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0 0 0 0 0 0];
    [fitresult_n{i}, gof_n{i}] = fit(xData,yData,ft,opts);                       
    f1{i} = fitresult_n{i};
    g1{i} = gof_n{i};
    [fitresult_n2{i}, gof_n2{i}] = fit(xData,yData,ft,'Exclude',outlier);  
    f1outlier{i} = fitresult_n2{i};
    g1outlier{i} = gof_n2{i};
    figure(i)
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
                                                                           % list, not same as order of slopes1
% gof summary table

for i = 1:m
    sse(:,i)=g1{i}.sse;
    rsquare(:,i)=g1{i}.rsquare;
    dfe(:,i)=g1{i}.dfe;
    adjrsquare(:,i)=g1{i}.adjrsquare;
    rmse(:,i)=g1{i}.rmse;
end

g1summary=vertcat(sse,rsquare,dfe,adjrsquare,rmse);
g1summary(1,m+1)=mean(g1summary(1,1:m));
g1summary(2,m+1)=mean(g1summary(2,1:m));
g1summary(3,m+1)=mean(g1summary(3,1:m));
g1summary(4,m+1)=mean(g1summary(4,1:m));
g1summary(5,m+1)=mean(g1summary(5,1:m));

rowNames={'sse','rsquare','dfe','adjrsquare','rmse'};
colNames={'Subject1','Subject2','Subject3','Subject4','Subject5',...
    'Subject6','Subject7','Subject8', 'Subject9','Subject10',... 
    'Subject11','Subject12','Subject13','Subject14','Subject15',...
    'Subject16','Subject17','Subject18', 'Subject19','Subject20',...
    'Subject21','Subject22','Subject23','Subject24','Subject25',...
    'Subject26','Mean'};
g1summary=array2table(g1summary,'RowNames',rowNames, ...
    'VariableNames',colNames);

for i = 1:m
    ssex(:,i)=g1outlier{i}.sse;
    rsquarex(:,i)=g1outlier{i}.rsquare;
    dfex(:,i)=g1outlier{i}.dfe;
    adjrsquarex(:,i)=g1outlier{i}.adjrsquare;
    rmsex(:,i)=g1outlier{i}.rmse;
end

g1outliersummary=vertcat(ssex,rsquarex,dfex,adjrsquarex,rmsex);
g1outliersummary(1,m+1)=mean(g1outliersummary(1,1:m));
g1outliersummary(2,m+1)=mean(g1outliersummary(2,1:m));
g1outliersummary(3,m+1)=mean(g1outliersummary(3,1:m));
g1outliersummary(4,m+1)=mean(g1outliersummary(4,1:m));
g1outliersummary(5,m+1)=mean(g1outliersummary(5,1:m));

g1outliersummary=array2table(g1outliersummary,'RowNames',rowNames, ...
    'VariableNames',colNames);

% fitresult summary table

for i = 1:m
    a0(:,i)=f1{i}.a0;
    a1(:,i)=f1{i}.a1;
    b1(:,i)=f1{i}.b1;
    a2(:,i)=f1{i}.a2;
    b2(:,i)=f1{i}.b2;
    w(:,i)=f1{i}.w;
end

f1summary=vertcat(a0,a1,a2,b1,b2,w);
f1summary(1,m+1)=mean(f1summary(1,1:m));
f1summary(2,m+1)=mean(f1summary(2,1:m));
f1summary(3,m+1)=mean(f1summary(3,1:m));
f1summary(4,m+1)=mean(f1summary(4,1:m));
f1summary(5,m+1)=mean(f1summary(5,1:m));
f1summary(6,m+1)=mean(f1summary(6,1:m));

rowNames={'a0','a1','b1','a2','b2','w'};
f1summary=array2table(f1summary,'RowNames',rowNames, ...
    'VariableNames',colNames);


for i = 1:m
    a0(:,i)=f1outlier{i}.a0;
    a1(:,i)=f1outlier{i}.a1;
    b1(:,i)=f1outlier{i}.b1;
    a2(:,i)=f1outlier{i}.a2;
    b2(:,i)=f1outlier{i}.b2;
    w(:,i)=f1outlier{i}.w;
end

f1outliersummary=vertcat(a0,a1,a2,b1,b2,w);
f1outliersummary(1,m+1)=mean(f1outliersummary(1,1:m));
f1outliersummary(2,m+1)=mean(f1outliersummary(2,1:m));
f1outliersummary(3,m+1)=mean(f1outliersummary(3,1:m));
f1outliersummary(4,m+1)=mean(f1outliersummary(4,1:m));
f1outliersummary(5,m+1)=mean(f1outliersummary(5,1:m));
f1outliersummary(6,m+1)=mean(f1outliersummary(6,1:m));

f1outliersummary=array2table(f1outliersummary,'RowNames',rowNames, ...
    'VariableNames',colNames);

%% SLOPE CALC (CASES)

% CBT matrix (window x I)

N2i=ismember(experimental.('Sleep Stage'),'N2');
indices = find(N2i);
N2all_experimental=experimental(N2i,11);
N2all_experimental=table2array(N2all_experimental);

for p = 1:maxWindow
    N2ix = indices-p;
    N2allx=experimental(N2ix,11);
    N2allx=table2array(N2allx);
    N2all_experimental=horzcat(N2all_experimental,N2allx);
end

N2all_experimental=transpose(N2all_experimental);                          % order based on var ID in 
                                                                           % experimental table  
nEntries = maxWindow*(maxWindow + 1) / 2; 
slopes1 = nan(nEntries, length(IDs)); 
lookupTable1 = nan(nEntries, 3); 
                                
% Slope calc: Loop over window, over subject

for i = 1:length(IDs)
    idx = 0; 
    for j = 1:maxWindow
        nPositions = maxWindow - j + 1; 
        for k = 1:nPositions 
            idx = idx + 1; 
            a = j; 
            b = j+k; 
            slopes1(idx,i) = (N2all_experimental(a,i) - ...
                N2all_experimental(b,i))/(b-a);                            % order based on var ID 
            lookupTable1(idx, :) = [idx, j, k]; 
        end
    end
end

% Lookup Table

lookupTable1 = table(lookupTable1(:,1), lookupTable1(:,2), ...
    lookupTable1(:,3));
lookupTable1.Properties.VariableNames = {'Index', 'WindowSize', ... 
    'WindowPosition'};

%% PUT ALL SLOPE VALUES IN 1 COLUMN

IDs=unique(experimental.Studienr);
slopes1x = slopes1(:,1);
 
for i = 2:length(IDs)
    addme = slopes1(:,i);
    slopes1x = vertcat(slopes1x,addme);
end 
 
IDs=unique(control.Studienr);
slopesx = slopes(:,1);
 
for i = 2:length(IDs)
    addme = slopes(:,i);
    slopesx = vertcat(slopesx,addme);
end 
 
% some graphs and normality testing

figure("Position",[500,500,500,500]);
subplot(3,1,1);histogram(vertcat(slopesx,slopes1x));
subplot(3,1,2);histogram(slopesx);
subplot(3,1,3);histogram(slopes1x); 
saveas (gcf,'slopes_controls_cases.pdf');
 
[n,p,k,c]=lillietest(vertcat(slopesx,slopes1x));                           % not normally distributed
adtest(vertcat(slopesx,slopes1x))
kstest(vertcat(slopesx,slopes1x))


%% SLOPES (GRADIENT) ON CBT CURVE 

val002=nan(maxWindow,m);
grad0=nan(length(experimental_cbt),m);
dy1=nan(maxWindow,m);

for i=1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);
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
    subplot(9,3,i)
    histogram(dy1(:,i))
end

figure('Position',[500,500,500,500])

for i=1:m
    subplot(9,3,i)
    histogram(grad0(:,i))
end

%% TEST THAT GRAD AND SLOPE ARE EQUIVALENT

new = slopes1; new = array2table(new); temp = lookupTable1(:,2); 
new = horzcat(new,temp);new = new(:,[27,(1:26)]);new = table2array(new);

c = unique(new(:,1));

for i = 1:length(c)
    for ii = 1:m
        xx = new(:,1)==i;
        yy = new(xx,ii+1);
        slopes11(i,ii) = mean(yy);
    end
end

for ii = 1:m
    [p,h,stats]=signrank(dy1(:,ii),slopes11(:,ii));
    p(:,ii)=p;
    h(:,ii)=h;                                                             % only subjs 1 & 26 are 1 
    stats(:,ii)=stats;                                                     % p = 0.039
end

slopevsgrad=vertcat(p,h);

% check for those that turned out marginally significant

figure;subplot(1,2,1);plot(dy1(:,1));
subplot(1,2,2);plot(dy1(:,26));

figure;subplot(1,2,1);plot(experimental_cbt(:,1));
subplot(1,2,2);plot(experimental_cbt(:,26))

% plot slopes versus gradients

for i = 1:m
    figure(i)
    subplot(2,1,1); plot(flipud(slopes1(:,i)));
    subplot(2,1,2); plot(dy1(:,i));
end

%% END SESSION

save('joustraresultscases2.mat')

Y=gradient(experimental.Core);
dy1_e=dy1;
grad0_e=grad0;
val002_e=val002;
val001_e=val001;

save("stats1","Y","slopes1","grad0_e","dy1_e","val002_e", ...
    "experimental", "val001_e");

