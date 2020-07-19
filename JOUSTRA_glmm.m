%% START

clear("all")
clc
load("GLMMinput.mat")

%% PREPARE DATA

combined=vertcat(control,experimental);
combined.Gradient=gradient(combined.Core);

SleepOnset(1:48960,1)=0;
SleepOnset=array2table(SleepOnset);
combined=horzcat(combined,SleepOnset);

index = ismember(combined.('Sleep Stage'),{'N2'});
sum(index)
combined(index,'SleepOnset')={1};
combined(index,:)

combined.Properties.VariableNames{9}='Time';
combined.Properties.VariableNames{10}='Time2';
combined.Properties.VariableNames{7}='AdjustedGrp';

clear("SleepOnset")
clear("index")

control.Gradient=gradient(control.Core);
SleepOnset(1:11520,1)=0;
SleepOnset=array2table(SleepOnset);
combined=horzcat(control,SleepOnset);

index = ismember(control.('Sleep Stage'),{'N2'});
sum(index)
control(index,'SleepOnset')={1};
control(index,:)

clear("SleepOnset")
clear("index")

experimental.Gradient=gradient(experimental.Core);
SleepOnset(1:37440,1)=0;
SleepOnset=array2table(SleepOnset);
combined=horzcat(experimental,SleepOnset);

index = ismember(experimental.('Sleep Stage'),{'N2'});
sum(index)
experimental(index,'SleepOnset')={1};
experimental(index,:)


index = ismember(combined.('Sleep Stage'),{'N2'});
loc = find(index);
maxWindow = 60;
vec=[-6 -5 -4 -3 -2 1 2 3 4 5 6 7 8 9 10 11 12 13];

for ii = 1:length(loc)
    for i = 1:length(vec)
        x =i*maxWindow;
        loc2 = loc(i)+(vec*(maxWindow-1));
        combined(loc(i):loc2,15)=vec;
    end
end

%% GLMM

glme0 = fitglme(combined,...
		'SleepOnset ~ 1 + Gradient + (1|Studienr)',...
		'Distribution','Binomial','Link','logit','FitMethod','Laplace');

glme6 = fitglme(combined,...
 		'SleepOnset ~ 1 + Gradient + (1|Studienr) + (1|AdjustedGrp)',...
 		'Distribution','Binomial','Link','logit','FitMethod','Laplace');

results4 = compare (glme6,glme0);

glme7 = fitglme(combined,...
 		['SleepOnset ~ 1 + Gradient ' ...
        '+ (1|Studienr) + (1|AdjustedGrp) + (1 | Studienr:AdjustedGrp)'] ,...
 		'Distribution','Binomial','Link','logit','FitMethod','Laplace');

results5 = compare (glme6,glme7);    
    
% glme1 = fitglme(combined,...
% 		'SleepOnset ~ 1 + age + (1|Studienr)',...
% 		'Distribution','Binomial','Link','logit','FitMethod','Laplace');
    
glme2 = fitglme(combined,...
		'SleepOnset ~ 1 + Gradient + Time + (1|Studienr)',...
		'Distribution','Binomial','Link','logit','FitMethod','Laplace');

results1 = compare(glme0,glme2,'CheckNesting',true);

glme3 = fitglme(combined,...
    ['SleepOnset ~ 1 + Gradient + AdjustedGrp + Gradient:AdjustedGrp + ' ...
    '(1|Studienr)'],...
	'Distribution','Binomial','Link','logit','FitMethod','Laplace');

results = compare(glme3,glme0);

glme4 = fitglme(control,...
		'SleepOnset ~ 1 + Gradient + (1|Studienr)',...
		'Distribution','Binomial','Link','logit','FitMethod','Laplace');
    
results2 = compare(glme4,glme0);
    
glme5 = fitglme(experimental,...
		'SleepOnset ~ 1 + Gradient + (1|Studienr)',...
		'Distribution','Binomial','Link','logit','FitMethod','Laplace');

results3 = compare(glme5,glme0);

%% END SESSION

save("GLMMresults.mat")

% save("RStudio", "control", "experimental", "combined")
% writetable(control,'control.txt'); 
% writetable(experimental,'experimental.txt'); 
% writetable(combined,'combined.txt');
