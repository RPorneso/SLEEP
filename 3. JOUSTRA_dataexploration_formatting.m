%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%    JOUSTRA FILES   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd SLEEP/
load('may26.mat')
head(JOUSTRA5) % MAIN TABLE FOR ANALYSIS

%% START: LOOK INTO FILES

head(JOUSTRA)
head(JOUSTRA2)
[GE,GT]=groupcounts(JOUSTRA.Group); % 1 - control | 2 - craniofaryngioma | 0 - nfma
[Gf,GU]=groupcounts(JOUSTRA2.Groep); % control | craniofaryngioma | nfma

unique(JOUSTRA.Subject);
FF = JOUSTRA(:,["Subject","Group"]);
grpstats(FF,{'Group','Subject'})
% grp 0 subject 16 not in JOUSTRA2 but in JOUSTRA
% grp 2 subjects 7 & g not in JOUSTRA2 but in JOUSTRA
% this is the reason why you have 4320 assigned as 0 below!!!

unique(JOUSTRA2.Studienr);
unique(JOUSTRA2.Groep);
  
%% CREATE UNIQUE IDENTIFIER FOR BOTH TABLES

ZZ=[1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 1; 2; 3; 
    4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 17; 18; 1; 2; 3; 4; 5; 6; 9];

% grp 0 subject 16 not in JOUSTRA2 but in JOUSTRA
% grp 2 subjects 7 & 8 not in JOUSTRA2 but in JOUSTRA
% this is the reason why you have 4320 assigned as 0 below!!!

JOUSTRA2.Thirtyfifth=ZZ;
head(JOUSTRA2)
JOUSTRA2(:,32)=[];
JOUSTRA2.Subject=[];
JOUSTRA2.Properties.VariableNames{33}='Subject';
head(JOUSTRA2)

JOUSTRA2(:,32) = {1};
JOUSTRA2(ismember(JOUSTRA2{:,3},'control'),32) = {1}; % YES it is really 1
JOUSTRA2(ismember(JOUSTRA2{:,3},'craniofaryngioma'),32) = {2};
JOUSTRA2(ismember(JOUSTRA2{:,3},'nfma'),32) = {0}; % YES it is really 0
JOUSTRA2.Properties.VariableNames{32}='Group';

head(JOUSTRA2)
[GD,GS]=groupcounts(JOUSTRA2.Group);
WW=JOUSTRA2(:,[1,2,32,33]);
grpstats(WW,{'Group','Studienr'})

YY=JOUSTRA2(:,[2,3,32,33]);
YY;
tabulate(YY.Groep)

RR=mergevars(JOUSTRA2,{'Subject','Group'},'NewVariableName','ID');
JOUSTRA2.ThirtySecondColumn=RR.ID;
JOUSTRA2.Properties.VariableNames{32}='ID';
JOUSTRA2=JOUSTRA2(:,[32,1:31]);

SS=mergevars(JOUSTRA,{'Subject','Group'},'NewVariableName','ID');
SSc=SS(:,1);
[Gg,Gh]=groupcounts(SSc.ID); % 43 rows

JOUSTRA.FifthColumn=SS.ID;
JOUSTRA.Properties.VariableNames{5}='ID';
JOUSTRA=JOUSTRA(:,[5,1:4]);

head(JOUSTRA)
JOUSTRA2;

[GF,GW]=groupcounts(JOUSTRA.Group);
[GG,GX]=groupcounts(JOUSTRA2.Group); 

[GH,GY]=groupcounts(JOUSTRA.ID); % total 43 - bec this has more IDs than JOUSTRA2
[GI,GZ]=groupcounts(JOUSTRA2.ID); % total 41 missing subjects as noted above

PP = JOUSTRA(:,(1:3));
grpstats(PP,{'Subject','Group'})
[Gy,Gz] = groupcounts(PP.ID); % only up to 17 Subj! JOUSTRA2 has 18 in Grp 0


%% CONVERT GROUP TO {'experimental'} (i.e., 0) IF CRITERIA IS MET

JOUSTRA3=outerjoin(JOUSTRA,JOUSTRA2,'Keys','ID','MergeKeys',true); % merge JOUSTRA2 vars with JOUSTRA

head(JOUSTRA3)
tail(JOUSTRA3)

ee = JOUSTRA3.Subject_JOUSTRA==JOUSTRA3.Subject_JOUSTRA2;
ff = JOUSTRA3.Group_JOUSTRA==JOUSTRA3.Group_JOUSTRA2;

tabulate(ee) % 4321 = 0 -> OK, remove these subjects
tabulate(ff) % 4321 = 0 -> OK, remove these subjects

unique(JOUSTRA3.ID) % includes Subj 18 from JOUSTRA2
unique(JOUSTRA3.Subject_JOUSTRA) % does not include Subj 18

JOUSTRA3(30000:30010,:) % validate order of new table
JOUSTRA3(28500:28510,:) % based on ID first then Group next

unique(JOUSTRA3.Group_JOUSTRA)
unique(JOUSTRA3.Groep)

JOUSTRA3.Groep(ismember(JOUSTRA3.Groep,''))
length(JOUSTRA3.Groep(ismember(JOUSTRA3.Groep,''))) % 4320, OK to remove
tail(JOUSTRA3)

[GC,GR]=groupcounts(JOUSTRA3.Groep); % 4320 = 0, OK to remove
VV=JOUSTRA3(:,[2,3,7]);
grpstats(VV,{'Groep','Subject_JOUSTRA'})

a1=41*1440; % rows of VV by count of total members per Groep
b1=a1+1440+1440; % total VV members of each Groep = total JOUSTRA3 rows

JOUSTRA3(:,39)={'keep'};
JOUSTRA3(ee==0,39)={'for exclusion'}; % mark rows for removal due to missing data, i.e. the 4320 noted above
QQ = JOUSTRA3.Var39;
tabulate(QQ) % 4321 due to 1 add'l, i.e. Subj 18 from from JOUSTRA2 table
JOUSTRA3.Properties.VariableNames{39}='Missing Data';

JOUSTRA.Subject(JOUSTRA.Subject==1);
length(JOUSTRA.Subject(JOUSTRA.Subject==1)) % 4320, which is correct
JOUSTRA.Subject(JOUSTRA.Subject==18);
length(JOUSTRA.Subject(JOUSTRA.Subject==18))

JOUSTRA3.Group=JOUSTRA3.Group_JOUSTRA;
head(JOUSTRA3)
tail(JOUSTRA3)

gg=JOUSTRA3.Group==JOUSTRA3.Group_JOUSTRA;
tabulate(gg)

JOUSTRA3.Var41=JOUSTRA3.Group;
jj=JOUSTRA3.Var41==JOUSTRA3.Group;
tabulate(jj)

JOUSTRA3(JOUSTRA3{:,9}>=60,41)={0}; % IF 60 years old or over THEN change Group to 0

ind=ismember(JOUSTRA3.gender,'vrouw');
JOUSTRA3(ind,41)={0};

ind2=ismember(JOUSTRA3.Groep,'craniofaryngioma');
JOUSTRA3(ind2,41)={0};

ww=JOUSTRA3(:,[2,3,7,8,9,40,41]);
[Gq,Gp]=groupcounts(ww.Group);
tabulate(ww.Group) 

[Gm,Gn]=groupcounts(ww.Var41);
tabulate(ww.Var41) % 2880 = 2, i.e. Grp 2 Subjects 7 & 8

ind4=JOUSTRA3.Var41==2;
tt2=JOUSTRA3(ind4,:);
unique(tt2.Subject_JOUSTRA) % Grp 2 Subjects 7 & 8
unique(tt2.Var39) % the ones already marked for exclusion so all good

rr=JOUSTRA3.Group==JOUSTRA3.Var41;
tabulate(rr)

ab=JOUSTRA3(rr,:);
bc=JOUSTRA3(~rr,:); % Group was re-assigned, i.e., v or >=60 or cranio

unique(bc.ID)
unique(bc.Studienr)
length(unique(bc.Studienr)) % 17 subjects excluded (this is OK) / 26 remain

JOUSTRA3.Properties.VariableNames{41}='Adj Grp';


%% FORMAT SLEEP ONSET IN JOUSTRA USING LIGHTS OFF & SOL FROM JOUSTRA2

SO = JOUSTRA3(:,[1,2,3,34,35]);
summary(SO)
subj=SO(:,[2,3]);
grpstats(subj,{'Group_JOUSTRA','Subject_JOUSTRA'})

dates2 = datetime(SO.Time_lightsoff, 'InputFormat', 'HH:mm'); % convert string to datetime datatype
nums2 = datenum(dates2); % convert dates to numbers
SO.SixthColumn = nums2; 
SO.Properties.VariableNames{6} = 'Time_lightsoff(double)'; 
SO.Time_lightsoff=dates2;
summary(SO)

unique(SO.Time_lightsoff)
length(unique(SO.Time_lightsoff)) % 14, why (kinda checks out, see below)
[Aa,Bb]=groupcounts(SO.Time_lightsoff); % 36 total

unique(SO.sleepLatency_minutesAfterLightsOff_)
length(unique(SO.sleepLatency_minutesAfterLightsOff_)) % 8663 why? OK now
[Ca,Cb]=groupcounts(SO.sleepLatency_minutesAfterLightsOff_); % HERE IT'S 24

unique(SO.("Time_lightsoff(double)")) % Time Lights Off (double)
length(unique(SO.("Time_lightsoff(double)")))
[Ax,Bx]=groupcounts(SO.("Time_lightsoff(double)")); % 36 total, checks out with above code

mins=minutes(SO.sleepLatency_minutesAfterLightsOff_); % converts duration to minutes
length(unique(mins)) % 8663, why? mostly NaN min, this is in the end OK
tabulate(mins)
length(mins(mins>0))

SO.SeventhColumn=mins; % SOL (double)
SO.Properties.VariableNames{7}='SOL';

SO.EighthColumn=SO.Time_lightsoff+SO.SOL;
SO.Properties.VariableNames{8}='Sleep Onset';
head(SO)

SO.NinthColumn=datestr(SO.("Sleep Onset"),'HH:MM');
SO.Properties.VariableNames{9}='Time Sleep Onset';
length(unique(SO.('Time Sleep Onset'))) % 14 
[Da,Db]=groupcounts(SO.('Time Sleep Onset')); % 32 (i expected 36 like above)

table1=SO.('Time Sleep Onset'); % 32 including NaN:NaN
tabulate(table1)

%% CREATE JOUSTRA4 BY ADDING SO table Time_lightsoff, SOL, Sleep Onset, Time Sleep Onset TO JOUSTRA3

SO1=SO(:,{'ID','Time_lightsoff','SOL','Sleep Onset','Time Sleep Onset'});
SO1.Properties.VariableNames{1}='ID_SO1';
SO1.Properties.VariableNames{2}='Time_lightsoff_SO1';

JOUSTRA4 = horzcat(JOUSTRA3,SO1);
head(JOUSTRA4)
kk=JOUSTRA4.ID==JOUSTRA4.ID_SO1;
length(kk(kk(:,1==1))) % 61921, so correct
length(kk(kk(:,1==0))) % 0, so correct
length(kk(kk(:,2)==1)) % 61921, so correct
length(kk(kk(:,2)==0)) % 0, so correct

JOUSTRA4.FortySeventhColumn=JOUSTRA4.('Time Sleep Onset')(:,1:end-2);
ll=JOUSTRA4.FortySeventhColumn==JOUSTRA4.Time;
length(ll(ll(:,(1&&2&&3&&4&&5)==1))) % 13560
length(ll(ll(:,1)==1)) % 13560
length(ll(ll(:,2)==1)) % 6660
length(ll(ll(:,3)==1)) % 53280
length(ll(ll(:,4)==1)) % 8880
length(ll(ll(:,5)==1)) % 5328

ll(428,:) % all 5 columns true

lll=all(ll,2); % check rows where all columns are true
lll(428,:) % true
lll(427,:) % false
tabulate(lll) % true = 37!!

JOUSTRA4.('Time Sleep Onset 2')=JOUSTRA4.('Time Sleep Onset')(:,1:end-2);
JOUSTRA4.CheckSleepOnset=JOUSTRA4.('Time Sleep Onset 2')==JOUSTRA4.Time;
JOUSTRA4.AllTrueSO=all(JOUSTRA4.CheckSleepOnset,2);

xyz=JOUSTRA4.AllTrueSO;
tabulate(xyz) % true = 37!
JOUSTRA4(428,:) % TRUE!
JOUSTRA4(427,:) % FALSE!

%% MARK SLEEP STAGE

JOUSTRA4{:,52}={'Non N2'};
JOUSTRA4([JOUSTRA4{:,51}]==1,52)={'N2'};
JOUSTRA4.Properties.VariableNames{52}='Sleep Stage';
abc=JOUSTRA4.('Sleep Stage');
tabulate(abc) % 37 like above! Good!

ind7=JOUSTRA4{:,51}==1; % has all 60921 rows where both 0 & 1's in Var51 are included
tt4=JOUSTRA4(ind7,:); % shows all 37 rows with all columns included

%% CONVERT TIME IN NUMERICAL TO AM/PM FORMAT

JOUSTRA.Time = datestr (JOUSTRA.Time,"HH:MM");
JOUSTRA3.Time_lightsoff = datestr(JOUSTRA3.Time_lightsoff, 'HH:MM'); 

%% CREATE JOUSTRA5 TABLE FOR ANALYSIS

JOUSTRA5=JOUSTRA4(:,{'ID','Studienr','age','gender','Groep','Group','Adj Group',('Missing Data'),'Time','Time in Time Format','Core','Sleep Stage'});
head(JOUSTRA5)
fgh=JOUSTRA5(:,[1,2]);
tabulate(fgh.Studienr)
summary(JOUSTRA5) % NumMissing: Core (5761), Time in Time Format (1), Group (1), Age (4320)
                  % Core missing: CR02 (2-2), CR06 (2-6), CR09 (2-9)

ind9=ismember(JOUSTRA5.('Sleep Stage'),'N2');
tt6=JOUSTRA5(ind9,:);


%% COPY TABLES TO ANOTHER FOLDER

save('may30.mat', 'JOUSTRA5','EVA', 'FRONCZEK');
copyfile may30.mat SLEEP2;


%% END SESSION

save('may26.mat')
