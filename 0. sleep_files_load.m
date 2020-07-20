%% LOAD WORKSPACE

load('may26.mat')
load('may6')

%% LOAD DATA:

FRONCZEK2a = readtable("FRONCZEK.txt"); % patient data only (N = 8); dup rows, only has 6 hours
FRONCZEK3 = readtable("FRONCZEK3vfinal.xlsx"); %patient and control data (N=16)
FRONCZEK4 = readtable ("FRONCZEK4vfinal.xlsx"); % 1 control data (PPNummer = 0); 1st and 2nd row duplicated
FRONCZEK4E = readtable("FRONCZEK4.xls"); %same as above but with EEG score --> ADDED TO FRONCZEK4
HARDINGT = readtable("Paired Temperature Data.txt");
HARDING1T = readtable("E190315 FM2901D SC CNO at 1 min.txt");
HARDING1E = readtable("E190315 FM2901D EEG CNO at 1min.txt");
HARDING2E = readtable("E200315 FM2901E EEG CNO at 14 min.txt");
HARDING2T = readtable("E200315 FM2901E SC CNO at 14 min.txt");
HARDING3T = readtable("E190315 FM2910A SC CNO at 10 min.txt");
HARDING3E = readtable("E190315 FM2901A EEG CNO at 10 min.txt");
HARDING4T = readtable("E150615 FM0505A SC CNO at 60 min.txt");
HARDING4E = readtable("E150615 FM0505A EEG CNO at 60 min.txt");
HARDING5T = readtable("E050815 FM2105C SC CNO at 60 min.txt");
HARDING5E = readtable("E050815 FM2105C EEG CNO at 60 min.txt");
HARDING6T = readtable("E050815 FM2105E SC CNO at 60 min.txt");
HARDING6E = readtable("E050815 FM2105E EEG CNO at 60 min.txt");
HARDING7T = readtable("070616 FM2611B SC CNO at 60 min.txt");
HARDING7E = readtable("070616 FM2611B EEG CNO at 60 min.txt");
HARDING8T = readtable("E120815 FM2105A SC CNO at 60 min.txt");
HARDING8E = readtable("E120815 FM2105A EEG CNO at 60 min.txt");
JOUSTRA = readtable("JOUSTRA.xls");
JOUSTRA2 = readtable("Joustra data Vfinal.xlsx");
% MATEO = readtable("02122008.S2R"); %could not load file
% LUSHINGTON = readtable("LUSHINGTON CR n down by t across raw3_statview_supernova"); %could not read content of file

%% LOAD DATA FROM MULTIPLE XLS SHEETS:

folder = fileparts(which('FRONCZEK4.xls')); 
fullFileName = fullfile(folder, 'FRONCZEK4.xls');
[status, sheetNames] = xlsfinfo(fullFileName);
numSheets = length(sheetNames);
FRONCZEK4E = readtable(fullFileName, 'Sheet', 12);

folder = fileparts(which('EVAvfinal.xlsx')); 
fullFileName = fullfile(folder, 'EVAvfinal.xlsx');
[status, sheetNames] = xlsfinfo(fullFileName);
numSheets = length(sheetNames);
EVA1 = readtable(fullFileName, 'Sheet', 1);
EVA2 = readtable(fullFileName, 'Sheet', 2);
EVA3 = readtable(fullFileName, 'Sheet', 3);
EVA4 = readtable(fullFileName, 'Sheet', 4);
EVA5 = readtable(fullFileName, 'Sheet', 5);
EVA6 = readtable(fullFileName, 'Sheet', 6); 
EVA7 = readtable(fullFileName, 'Sheet', 7);
EVA8 = readtable(fullFileName, 'Sheet', 8);
EVA9 = readtable(fullFileName, 'Sheet', 9);
EVA10 = readtable(fullFileName, 'Sheet', 10);
EVA11 = readtable(fullFileName, 'Sheet', 11);
EVA12 = readtable(fullFileName, 'Sheet', 12);
EVA13 = readtable(fullFileName, 'Sheet', 13);
EVA14 = readtable(fullFileName, 'Sheet', 14);

%% CHECK DATA:
FRONCZEK2a(1:13,1:13)
FRONCZEK3(1:5,1:35)
FRONCZEK4(1:5,1:13)
HARDINGT(1:5, 1:10)
HARDING1T(1:5, 1:2)
HARDING1E(1:5, 1:2)
HARDING2T(1:5, 1:2)
HARDING2E(1:5, 1:2)
JOUSTRA(1:4,1:4)
% LUSHINGTON(1:5,1:7) %could not read content of file

%% HOW TO MAKE A TABLE FROM SCRATCH

grades = table([1;2;3],{'Robin';'Sparrow';'Finch'},[70;80;90],'VariableNames',{'Code' 'Name' 'Number'});

%%% HOW TO CHANGE ITEM IN A TABLE BY SPECIFYING ROW, VAR COORDINATES

grades{2,2} = {'Martin'};
grades{1,3} = 75;

%%% COUNT

[GC,GR] = groupcounts(x); 

%%% DELETE TABLE

clear("LUSHINGTON")

%%% DELETE FILE IN CURRENT FOLDER

delete 'load.m'


%% END SESSION

save('may1')
save('may2')
save('may6') % combines may1 and may2 + change in time format in JOUSTRA & FRONCZEK2a and 4 text to number
