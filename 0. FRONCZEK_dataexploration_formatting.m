%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  FRONCZEK2&4 FILE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd SLEEP/
load('may26.mat')
head(FRONCZEK) % MAIN TABLE FOR ANALYSIS

%% START: LOOK INTO FILES

load('may6.mat')
head(FRONCZEK2a)                                                           % patient data only (N = 8); dup rows; only has 6 hours                                                          
head(FRONCZEK4)                                                            % 1 control data (PPNummer = 0); 1st and 2nd row duplicated  
head(FRONCZEK4E)                                                           % same as above but with EEG score --> ADDED TO FRONCZEK4
summary(FRONCZEK2a)
summary(FRONCZEK4)

%% CONVERT TIME IN NUMERICAL TO AM/PM FORMAT

FRONCZEK4.Tijd = datestr(FRONCZEK4.Tijd, 'HH:MM');
FRONCZEK2a.Tijd = datestr(FRONCZEK2a.Tijd, 'HH:MM');

%% CONVERT DATE FORMAT

formatOut = 2;

FRONCZEK4.Dag2=datestr(FRONCZEK4.Dag,formatOut);

FRONCZEK4.Dag = datestr(FRONCZEK4.Dag);

FRONCZEK4.Dag = datestr(FRONCZEK4.Dag,'mmmm dd, yyyy HH:MM:SS.FFF AM');

%% CONVERT TEXT TO NUMBER (IN DECIMAL VERSUS COMMA):

FRONCZEK4E.Tcore=str2double(FRONCZEK2a.Tcore);

FRONCZEK2aa.Tcore=str2double(strrep(FRONCZEK2aa.Tcore,',','.'));

%% ADD HEADER TO TABLE

FRONCZEK4E.Properties.VariableNames = {'Date', 'Time', 'Tcore', 'TSubclavicularL', 'TSubclavicularR', 'TSupraumbilical', 'TThighL','TEarL','TEarR','THandL','THandR', 'TFeetL','TFeetR','TEar','THand','TFeet','TDist','TProx','TDPG','Time of Day','Distal','Proximal','Activity','In Bed','1','2','3','4','5','6','Sleep Stage'};
FRONCZEK4.Properties.VariableNames{14}='Sleep Onset';
FRONCZEK4.Properties.VariableNames{1:4} = {'Dag','Tijd','Tcore','Stadium'};

%% DELETE ROW BY ROW NUMBER

FRONCZEK4E((1:6),:)=[];

%% DELETE COLUMNS

FRONCZEK2a = removevars(FRONCZEK2aa,{'ProxMan','DistMan','Tprox','Tdist','LaudaProx','LaudaDist','LaudaProx_1','LaudaDist_1'});
FRONCZEK4 = removevars(FRONCZEK4,{'SubclavicularL','SubclavicularR','Supra_umbilical','ThighL','EarL','EarR','HandL','HandR','FeetL','FeetR','Sleep Onset'});

%% DELETE 1 ARRAY FROM A COLUMN WITH 2 ARRAYS

FRONCZEK4 = splitvars(FRONCZEK4,'Dag','NewVariableNames',{'Dag2','Tijd2'});
FRONCZEK4.Tijd2 = [];

%% ADD NEW COLUMN WITH 0's TO MATCH CURRENT TABLE 

FRONCZEK4 = addvars(FRONCZEK4,PPNummer,'Before','Date');

%% ADD COLUMN FROM ANOTHER TABLE TO AN EXISTING TABLE

A=FRONCZEK4E.("Sleep Stage");
FRONCZEK4.FourteenthColumn=A;
FRONCZEK4.Properties.VariableNames{14}='Sleep Onset';

B=A.Date;
FRONCZEK4.FirstColumn=B;
FRONCZEK4.Properties.VariableNames{1}='Dag';

%% REARRANGE TABLE

FRONCZEK4 = FRONCZEK4(:,[5,1:4]);

%% ADD NEW COLUMN WITH SAME VALUES TO AN EXISTING TABLE

FRONCZEK4{:,'PPNummer'} = 0;
FRONCZEK4{:,'Group'}={'controls'};
FRONCZEK2a{:,'Group'}={'experimental'};

%% SPLITTING THE DATE AND TIME FROM AND DATE-TIME ARRAY

FRONCZEK4.Dag.Format='dd-MM-yyy';
column6=cellstr(FRONCZEK4.Dag);

%% REPLACE EXISTING VALUE WITH A NEW VALUE (USING LOGICAL INDEXING)

dates = datetime(FRONCZEK4.Dag, 'InputFormat', 'dd-MM-yyyy'); % convert string to datetime datatype
nums = datenum(dates); % convert dates to numbers
days = floor(nums-nums(1) + 1); % assuming the first entry in table is the earliest date and you want to set that to 1
FRONCZEK4.Dag = days; % add the list of numbers to table

% RowsToChange = FRONCZEK4(:,1) == '31-Dec-2007';
% FRONCZEK4(RowsToChange,1) = 1;
% 
% RowsToChange=FRONCZEK4(:,1)==FRONCZEK4.Dag(isbetween(FRONCZEK4.Dag, '31-Dec-2007 00:00:00','31-Dec-2007 23:59:59'));
% FRONCZEK4(RowsToChange,1) = 1;
% 
% A = FRONCZEK4.Dag(isbetween(FRONCZEK4.Dag,'31-Dec-2007 00:00:00', '31-Dec-2007 23:59:59'));
% B = FRONCZEK4.Dag(isbetween(FRONCZEK4.Dag,'01-Jan-2008 00:00:00', '01-Jan-2008 23:59:59'));
% RowsToChange = A;
% FRONCZEK4(RowsToChange,1) = 1;
% 
% A = FRONCZEK4.Dag(isbetween(FRONCZEK4.Dag,'31-Dec-2007 00:00:00', '31-Dec-2007 23:59:59'));
% RowsToChange = FRONCZEK4(:,1) == A;
% FRONCZEK4(RowsToChange,1) = 1;

%% REPLACE EXISTING VALUES IN A TABLE COLUMN USING LOGICAL INDEX

lId = ismember(FRONCZEK2aa.Stadium, '');
A(lId,1)=0;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-S0');
A(lId,1)=0;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-S1');
A(lId,1)=1;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-S2');
A(lId,1)=2;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-S3');
A(lId,1)=3;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-S4');
A(lId,1)=4;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-REM');
A(lId,1)=5;

lId = ismember(FRONCZEK2aa.Stadium, 'SLEEP-MT');
A(lId,1)=6;

FRONCZEK2aa.Stadium=A;

%% FORMAT TIME TO HH:MM (DELETE LAST n CHARACTERS FROM A CHARACTER ARRAY)

E=D(:,1:end-2);
FRONCZEK4.Tijd=FRONCZEK4.Tijd(:,1:end-2);

FRONCZEK2a.Stadium=FRONCZEK2a.Stadium(1:end-2);
Ex=FRONCZEK2a.Stadium(:,1:end-2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  FRONCZEK3 FILE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%
load('may6.mat')
head(FRONCZEK3)                                                            % correct dag from 1 to 2 on rows 1441-2880
tail(FRONCZEK3)
summary(FRONCZEK3)

%% CHECK EQUALITY BETWEEN 2 VARIABLES (a-c: sleeponset / d-f: sleep)

a=FRONCZEK3.SleepOnset == FRONCZEK3.Sleeponset_5;
length(a(a==1))
length(a(a==0))

b=FRONCZEK3.SleepOnset == FRONCZEK3.SleepOnset_15;
length(b(b==1))
length(b(b==0))

c=FRONCZEK3.SleepOnset == FRONCZEK3.SleepOnset_30;
length(c(c==1))
length(c(c==0))

d=FRONCZEK3.Sleep == FRONCZEK3.Sleep_5;
length(d(d==1))
length(d(d==0))

e=FRONCZEK3.Sleep == FRONCZEK3.Sleep_15;
length(e(e==1))
length(e(e==0))

f=FRONCZEK3.Sleep == FRONCZEK3.Sleep_30;
length(f(f==1))
length(f(f==0))

%% SAVING CHECKS DONE ABOVE IN THE SAME TABLE, I.E. FRONCZEK3

FRONCZEK3.Test1 = a; %sleep onset vs sleep onset 5
FRONCZEK3.Test2 = b; %sleep onset vs sleep onset 15
FRONCZEK3.Test3 = c; %sleep onset vs sleep onset 30
FRONCZEK3.Test4 = d; %sleep vs sleep 5
FRONCZEK3.Test5 = e; %sleep vs sleep 15
FRONCZEK3.Test6 = f; %sleep vs sleep 30

%% CALCULATE DIFF BETWEEN SLEEP PARAMETERS (PERCENTAGE) 

(length(a(a==0))/length(FRONCZEK3.SleepOnset))*100;
(length(b(b==0))/length(FRONCZEK3.SleepOnset))*100;
(length(c(c==0))/length(FRONCZEK3.SleepOnset))*100; %bet 2.97 and 4.70

(length(d(d==0))/length(FRONCZEK3.SleepOnset))*100;
(length(e(e==0))/length(FRONCZEK3.SleepOnset))*100;
(length(f(f==0))/length(FRONCZEK3.SleepOnset))*100; %bet 22 and 33

%% ALIGN COLUMNS OF FRONCZEK3 w/ FRONCZEK = FRONCZEK3a

FRONCZEK3a=FRONCZEK3(:,[3,4,6,11,18]); % missing 1 var Dag
FRONCZEK3a{:,'Dag'} = 1;% add var Dag should be 1 and 2!!                   %%% CORRECT THIS SO THAT 1441-2880 IS DAY 2!!
FRONCZEK3a.Properties.VariableNames(1:6)={'PPNummer','Group','Tijd','Tcore','Stadium','Dag'};

%% REFORMAT TIME

FRONCZEK3a.Tijd= datestr(FRONCZEK3a.Tijd,'HH:MM');

%% CHANGE PPNummer FROM 1-16 TO 21-36

J=FRONCZEK3a.PPNummer;
 
Z=J(:,1)==1;
J(Z,1)=21;

K=J(:,1)==2;
J(K,1)=22;

L=J(:,1)==3;
J(L,1)=23;

M=J(:,1)==4;
J(M,1)=24;

N=J(:,1)==5;
J(N,1)=25;

O=J(:,1)==6;
J(O,1)=26;

P=J(:,1)==7;
J(P,1)=27;

Q=J(:,1)==8;
J(Q,1)=28;

R=J(:,1)==9;
J(R,1)=29;

S=J(:,1)==10;
J(S,1)=30;

T=J(:,1)==11;
J(T,1)=31;

U=J(:,1)==12;
J(U,1)=32;

V=J(:,1)==13;
J(V,1)=33;

W=J(:,1)==14;
J(W,1)=34;

X=J(:,1)==15;
J(X,1)=35;

Y=J(:,1)==16;
J(Y,1)=36;

FRONCZEK3a.PPNummer=J;

%% CHANGE GROUP FROM 0-1 TO CONTROL-EXPERIMENTAL

FRONCZEK3a(:,7) = {0};
FRONCZEK3a([FRONCZEK3a{:,2}]==1,7) = {1};

FRONCZEK3a(:,8) = {'control'};
FRONCZEK3a([FRONCZEK3a{:,7}]==1,8) = {'experimental'};

FRONCZEK3a(:,9) = {'control'};
FRONCZEK3a([FRONCZEK3a{:,2}]==1,9) = {'experimental'};

% Value  = {1, 0};   
% FRONCZEK3a(:,7) = (2 - strcmp(FRONCZEK3a(:,2), 1));
% 
% FRONCZEK3a(:,8) = num2cell(strcmp(FRONCZEK3a(:, 2), 1));
% 
% FRONCZEK3a(:,7) = {1};
% FRONCZEK3a(strcmp(FRONCZEK3a(:,2),0),7) = {1};
% 
% 
% AA=FRONCZEK3a.Group;
% 
% G=AA(:,1)==0;
% H=AA(G);
% HH=num2cell(H);
% HH(:,2)={'control'}; 
% 
% I=AA(:,1)==1;
% J=AA(I);
% JJ=num2cell(J);
% JJ(:,2)={'experimental'};
% 
% BB=vertcat(H,J);
% CC=vertcat(HH,JJ);
% 
% FRONCZEK3a.SeventhColumn=BB;
% FRONCZEK3a.EighthColumn=CC;
% 
% FRONCZEK3a=splitvars(FRONCZEK3a,'EighthColumn','NewVariableNames',{'GroupText','Grouping'});

%% CHECK ABOVE CODE OUTPUT

aa=FRONCZEK3a.Group==FRONCZEK3a.Var7; 
[GC,GR]=groupcounts(aa); 
tabulate(aa)

cc=FRONCZEK3a(:,[7,8]);
grpstats(cc,{'Var7','Var8'})

dd=FRONCZEK3a(:,[2,8]);
grpstats(dd,{'Group','Var8'})

bb=FRONCZEK3a.Var8==FRONCZEK3a.Var9;
bb=isequal(FRONCZEK3a.Var8,FRONCZEK3a.Var9);

% bb=FRONCZEK3a.SeventhColmn(FRONCZEK3a.SeventhColmn==0);
% cc=FRONCZEK3a.SeventhColmn(FRONCZEK3a.SeventhColmn==1);
% 
% dd=FRONCZEK3a.EigthColumn(ismember(FRONCZEK3a.EigthColumn,{'control'}));
% ee=FRONCZEK3a.EigthColumn(ismember(FRONCZEK3a.EigthColumn,{'experimental'}));
% 
% ff=FRONCZEK3a(:,[2,8]);
% tabulate(ff.EigthColumn)
% grpstats(ff,{'Group','EigthColumn'})

%% FORMAT FRONCZEK3a AS FRONCZEK (CREATE BACKUP TABLE FRONCZEK3aa)

FRONCZEK3aa=FRONCZEK3a; % back up table
FRONCZEK3a.Group=FRONCZEK3a.Var8;
FRONCZEK3a=removevars(FRONCZEK3a,{'Var7','Var8','Var9'});

%% ADD NEW COLUMN (INTERVENTION) IN FRONCZEK3a FROM FRONCZEK3

FRONCZEK3a.Intervention=FRONCZEK3.intervention;
xx=FRONCZEK3a(:,["PPNummer","Intervention"]);
grpstats(xx,{'Intervention','PPNummer'})

yy=FRONCZEK3(:,["subject","intervention"]); 
grpstats(yy,{'intervention','subject'}) % this checks out!

% FRONCZEK3aaa=FRONCZEK3(:,[3,4,5,6,11,18]); % added col intervention
% 
% TA=FRONCZEK3(:,[3:6]);
% TA=mergevars(TA,{'subject','time'},'NewVariableName','ID');
% 
% TB=FRONCZEK3a(:,[1:3]);
% TB=mergevars(TB,{'PPNummer','Tijd'},'NewVariableName','ID');

%% CHECK RECORDING DURATION

Q=FRONCZEK3a.PPNummer(FRONCZEK3a.PPNummer==1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%  FRONCZEK FILE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% COMBINE TABLES WITH SAME HEADERS

FRONCZEK=vertcat(FRONCZEK2aa,FRONCZEK4);

%% ADD COLUMN INTERVENTION WHERE ALL VALUES = 0

FRONCZEK{:,'Intervention'} = 0;

%% MERGE FRONCZEK3a with FRONCZEK

FRONCZEK=vertcat(FRONCZEK,FRONCZEK3a); 

sum(FRONCZEK.Intervention==1);
sum(FRONCZEK3a.Intervention==1);
sum(FRONCZEK3a.Intervention==0); % sums check out against all tables combined so far!


%% END SESSION
save('may6.mat')

