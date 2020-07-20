%% START

clc
clear("all")
load("stats.mat")
load("stats1.mat")

%% ASSUMPTION TESTING CONTROLS

IDs=unique(control.Studienr);
m = length(IDs);

% outliers --> none using moving average

figure(1000);
for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);                                                     
    n_grad=gradient(n.Core);                                                         
    subplot((m/2),2,i);
    plot(n_grad);
end

figure(1001);
for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);                                                     
    n_grad=gradient(n.Core);                                                         
    subplot((m/2),2,i);
    boxplot(n_grad);
end

for i = 1:m
    ind1=ismember(control.Studienr,IDs(i));
    n=control(ind1,:);
    n_grad=gradient(n.Core);                                                         
    [~,TF(:,i)]=rmoutliers(n_grad,"movmean",3);
end

sum(TF)                                                                    % total # of outliers per subj

%% HYPOTHESIS TESTING BETWEEN SUBJ IN CONTROLS

kruskalwallis(dy1)
kruskalwallis(dy1(:,[1,2,3,5,6,8]))                                        % reject H0
kruskalwallis(grad0)
kruskalwallis(grad0(:,[1,2,3,5,6,8]))                                      % reject H0

% grad0: with posthoc

[p,tbl,stats]=kruskalwallis(grad0,[],'on')
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")                                            

[p,tbl,stats]=kruskalwallis(grad0(:,[1,2,3,4,5,6,8]),[],'on')
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")                       % without SUBJ 7

[p,tbl,stats]=kruskalwallis(grad0(:,[1,2,3,5,6,7,8]),[],'on')              % without SUBJ 4, p=0.0012
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")  

[p,tbl,stats]=kruskalwallis(grad0(:,[1,2,3,5,6,8]),[],'on')                % without SUBJ 4 & 7, p=0.0304
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")

[p,tbl,stats]=kruskalwallis(grad0(:,[1,2,4,5,6,8]),[],'on')                % without SUBJ 3 & 7, p=1.6415e-4
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")

% dy1: with posthoc

[p,tbl,stats]=kruskalwallis(dy1,[],'on')
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni") 

[p,tbl,stats]=kruskalwallis(dy1(:,[1,2,3,5,6,8]),[],'on')                  % without SUBJ 4 & 7, p=2.711e-22
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")


%% FRIEDMAN TEST CONTROLS WITH PAIRWISE COMPARISON & GRAPH
% test to see if slopes 60 bef S.0. different from slopes elsewhere

% group slopes

maxWindow = 60;
vec=[-6 -5 -4 -3 -2 2 3 4 5 6 7 8 9 10 11 12 13 14];

for ii = 1:length(val001)
    for i=vec
        k=val001(:,ii)+(i*maxWindow); 
        b=grad0(k:k+(maxWindow-1),ii);  
        if ii == 1
           a(:,1)=dy1(:,ii);
           a=horzcat(a,b); 
        else
            col=(length(vec)+1)*(ii-1)+1; 
            a(:,col)=dy1(:,ii);
            a=horzcat(a,b); 
        end
    end  
end

% execute friedman test & calculate/graph posthoc comparison

z=length(vec)+1;
zz=[0:z:(size(a,2)-z)]; 

for i=zz
    [p,tbl,stats]=friedman(a(:,(1+i:z+i)))
    [c,mm,h,nms]=multcompare(stats,'CType','tukey-kramer')
end

% combine all groups between persons 

q = length(val002);
t = a(1:q,(1:z));

for i = 2:m
    addme = a(1:q,((z*(i-1))+1:z*i));
    t = vertcat(t, addme); 
end

[p,tbl,stats]=friedman(t,maxWindow)
[c,mm,h,nms]=multcompare(stats,'CType','tukey-kramer')

%% ASSUMPTION TESTING EXP

% outliers --> none using moving average

IDs=unique(experimental.Studienr);
m = length(IDs);

figure("Position",[500,500,1000,2000])
for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);                                                     
    n_grad=gradient(n.Core);                                                          
    subplot((m/2),2,i);
    plot(n_grad);
end

figure("Position",[500,500,1000,2000])
for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);                                                     
    n_grad=gradient(n.Core);                                                          
    subplot((m/2),2,i);
    boxplot(n_grad);
end

for i = 1:m
    ind1=ismember(experimental.Studienr,IDs(i));
    n=experimental(ind1,:);
    n_grad=gradient(n.Core);                                                         
    [~,TFI(:,i)]=rmoutliers(n_grad,"movmean",20);
end

sum(TFI)

%% HYPOTHESIS TESTING BETWEEN SUBJ IN EXP

kruskalwallis(dy1_e)                                                       % reject H0 
kruskalwallis(grad0_e)                                                     % reject H0

[p,tbl,stats]=kruskalwallis(grad0_e,[],'on')
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")                                            

[p,tbl,stats]=kruskalwallis(grad0_e(:,[1:15,17:26]),[],'on')               % without Subj 16
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")

[p,tbl,stats]=kruskalwallis(dy1_e,[],'on')
[c,mm,h,nms]=multcompare(stats,'CType',"bonferroni")


%% HYPOTHESIS TESTING COMPARING CONTROL AND EXPERIMENTAL GRPS

% grad0 vs grad0_e

[p,h,stats] = ranksum(X,Y,'alpha',0.05,'tail','left');                     % reject, p=0.0164
[p,h,stats] = ranksum(X,Y,'alpha',0.01,'tail','left');                     % accept, p=0.0164
 
[p,h,stats] = ranksum(X,Y,'alpha',0.05,'tail','both');                     % reject (p = 0.0329)
[p,h,stats] = ranksum(X,Y,'alpha',0.01,'tail','both');                     % accept (p = 0.0329)

[p,h,stats] = ranksum(X,Y,'alpha',0.05,'tail','right');                    % accept (p = 0.9836)
[p,h,stats] = ranksum(X,Y,'alpha',0.01,'tail','right');                    % accept (p = 0.9836)

% dy1 vs dy1_e
 
IDs=unique(control.Studienr);
U = dy1(:,1);
 
for i = 2:length(IDs)
    addme = dy1(:,i);
    U = vertcat(U,addme);
end 

IDs=unique(experimental.Studienr);
V = dy1_e(:,1);

for i = 2:length(IDs)
     addme = dy1_e(:,i);
     V = vertcat(V,addme);
end 

[p,h,stats] = ranksum(U,V,'alpha',0.05,'tail','left');                     % accept H0 @ 0.05 alpha lvl (p=0.999)
[p,h,stats] = ranksum(U,V,'alpha',0.01,'tail','left');                     % accept H0 @ 0.01 alpha lvl (p=0.999)
 
[p,h,stats] = ranksum(U,V,'alpha',0.05,'tail','both');                     % reject H0 (p=0.0339)
[p,h,stats] = ranksum(U,V,'alpha',0.01,'tail','both');                     % accept H0 (p=0.0339)

[p,h,stats] = ranksum(U,V,'alpha',0.05,'tail','right');                    % reject H0 (p=0.017)
[p,h,stats] = ranksum(U,V,'alpha',0.01,'tail','right');                    % accept H0 (p=0.017)


%% FRIEDMAN TEST EXPERIMENTAL WITH POSTHOC COMPARISON AND GRAPH
% test to see if slopes 60 mins bef S.0. different from slopes elsewhere

% group slopes

maxWindow = 60;
vec=[-6 -5 -4 -3 -2 2 3 4 5 6 7 8 9 10 11 12 13];

for ii = 1:length(val001_e)
    for i=vec
        k=val001_e(:,ii)+(i*maxWindow); 
        b=grad0_e(k:k+(maxWindow-1),ii);  
        if ii == 1
           a_e(:,1)=dy1_e(:,ii);
           a_e=horzcat(a_e,b); 
        else
            col=(length(vec)+1)*(ii-1)+1; 
            a_e(:,col)=dy1_e(:,ii);
            a_e=horzcat(a_e,b); 
        end
    end  
end

% execute friedman test & calculate/graph posthoc comparison

z=length(vec)+1;
zz=[0:z:(size(a_e,2)-z)]; 

for i=zz
    [p,tbl,stats]=friedman(a_e(:,(1+i:z+i)));
    [c,mm,h,nms]=multcompare(stats,'CType','tukey-kramer')
end

% group slopes and compare between experimental subjects

q = length(val002);
t_e = a_e(1:q,(1:z));

for i = 2:m
    addme = a_e(1:q,((z*(i-1))+1:z*i));
    t_e = vertcat(t_e, addme); 
end

[p,tbl,stats]=friedman(t_e,q);
[c,mm,h,nms]=multcompare(stats,'CType','tukey-kramer')

%% SLOPES COMPARISON ACROSS ALL SUBJECTS - CONTROL AND EXPERIMENTAL
 
tot_t=vertcat(t(:,1:z),t_e);
[p,tbl,stats]=friedman(tot_t,q);
[c,mm,h,nms]=multcompare(stats,'CType','tukey-kramer');


%% END SESSION

save("hypothesistestingresults_60mins.mat");

save("GLMMinput", "control", "experimental")
