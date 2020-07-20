%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%      EVA FILES     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd SLEEP/
load('may26.mat')
head(EVA) % MAIN TABLE FOR ANALYSIS

%% START: LOOK INTO FILES

head(EVA1)
tail(EVA1)
summary(EVA1) % do this 14 times for each loaded sheet

%% ADD HEADER TO TABLE
EVA4.Properties.VariableNames={'Time','Subject','Date','Block','WAKE','NREMS','REMS','Group','Solution','BodyTemperatureData'};

%% DELETE ROW BY ROW NUMBER
EVA4(1,:)=[];

%% CONVERT TIME IN NUMERICAL TO AM/PM FORMAT
EVA.Time = datestr(EVA.Time,'HH:MM');

%% RENAME 1 COLUMN IN A TABLE
EVA1.Properties.VariableNames{2}='Subject';

%% COMBINE TABLES WITH SAME HEADERS
EVA=vertcat(EVA1,EVA2,EVA3,EVA4,EVA5,EVA6,EVA7,EVA8,EVA9,EVA10,EVA11,EVA12,EVA13,EVA14);

%% END SESSION
save('may6.mat')
