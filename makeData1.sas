*set up demographic file;
PROC IMPORT OUT= WORK.demogin 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\demographics.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="R3_3415_LUYSTER_DEMOGRAPHICS_20$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
/*
*for random pull;
proc surveyselect data=demogin
    out=demog
    seed=265325
    samprate=0.1;
run;
*/
data demog;
set demogin;
  setdate='23aug2022 09:00:00'dt;
  format setdate DATE9.;
  setdate=datepart(setdate);
  ID=input(STUDY_ID,12.);
run;
/*data demog;
set demog;
drop STUDY_ID;
run;

data demog;
set demog(rename=(ID=STUDY_ID));
run;
*/

data demog;
set demog;

if DEATH_DATE=. then Age=(setdate-BIRTH_DATE)/365.2425;
if DEATH_DATE~= . then Age=(DEATH_DATE-BIRTH_DATE)/365.2425;

if DEATH_DATE=. then Event=0;
if DEATH_DATE~= . then Event=1;

if DEATH_DATE=. then SurvTime=.;
if DEATH_DATE~= . then SurvTime=Age;

run;


*set up diagnoses file;
PROC IMPORT OUT= WORK.Diagnoses 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3583_ENGLISH_DIAGNOSES_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data diagnoses;
set diagnoses;
ID=input(STUDY_ID,12.);
run;
data diagnoses;
set diagnoses;
drop STUDY_ID;
run;
*merge demog and diagn files;
proc sort data=demog;
by ID;
run;
proc sort data=diagnoses;
by ID;
run;

/*data demodiag;
merge diagnoses (in=in_diag) demog (in=in_demog);
by STUDY_ID;
if in_demo=1 & in_diag=1;
run;
proc sql; 
  create table merp0 as
  select  * 
  from demog, diagnoses
  where demog.STUDY_ID=diagnoses.STUDY_ID;
quit;*/
/*
PROC SQL;
Create table dummy as
Select * from work.demog as x left join work.diagnoses as y
On x.STUDY_ID = y.STUDY_ID;
Quit;
*/

data res6; *res;    *<<---NOTE: THIS NAME HAS BEEN ALTERED SINCE FOLLOWING DATA STEPS ARE BLOCKED OUT THE ORIGINAL NAME SHOULD BE "res";
   merge diagnoses (in=in_diag) demog (in=in_demog);   
   by ID;
   if in_demog=1 & in_diag=1;
run;
/*
*bring in encounters;
PROC IMPORT OUT= WORK.encounters 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3583_ENGLISH_ENCOUNTERS_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data encounters;
set encounters;
ID=input(STUDY_ID,12.);
run;
data encounters;
set encounters;
drop STUDY_ID;
run;
*merge demog and diagn files;
proc sort data=res;
by ID;
run;
proc sort data=encounters;
by ID;
run;

data res2;
   merge encounters (in=in_enc) res (in=in_res);   
   by ID;
   if in_res=1 & in_enc=1;
run;

*bring in med fills;
PROC IMPORT OUT= WORK.medfills 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3415_LUYSTER_MED_FILLS_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data medfills;
set medfills;
ID=input(STUDY_ID,12.);
run;
data medfills;
set medfills;
drop STUDY_ID;
run;
*merge  files;
proc sort data=res2;
by ID;
run;
proc sort data=medfills;
by ID;
run;

data res3;
   merge medfills (in=in_medf) res2 (in=in_res2);   
   by ID;
   if in_res2=1 & in_medf=1;
run;

*bring in med orders;
PROC IMPORT OUT= WORK.medords 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3583_ENGLISH_MED_ORDERS_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data medords;
set medords
(rename=(
	QUANTITY=OrderQuantity
	START_DATE=OrderStart_Date
	END_DATE=OrderEnd_Date
	MED_UNIT=OrderMed_Unit)
	)
;
ID=input(STUDY_ID,12.);
run;
data medords;
set medords;
drop STUDY_ID;
run;
*merge  files;
proc sort data=res3;
by ID;
run;
proc sort data=medords;
by ID;
run;

data res4;
   merge medords (in=in_medo) res3 (in=in_res3);   
   by ID;
   if in_res3=1 & in_medo=1;
run;


*bring in proc orders;
PROC IMPORT OUT= WORK.procords 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3583_ENGLISH_PROC_ORDERS_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data procords;
set procords;
ID=input(STUDY_ID,12.);
run;
data procords;
set procords;
drop STUDY_ID;
run;
*merge  files;
proc sort data=res4;
by ID;
run;
proc sort data=procords;
by ID;
run;

data res5;
   merge procords (in=in_proco) res4 (in=in_res4);   
   by ID;
   if in_res4=1 & in_proco=1;
run;


*bring in proc preform;
PROC IMPORT OUT= WORK.procperf 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3583_ENGLISH_PROCS_PERFORMED_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data procperf;
set procperf
(rename=(PROC_NAME=ProcPerformed_Name))
;
ID=input(STUDY_ID,12.);
run;
data procperf;
set procperf;
drop STUDY_ID;
run;
*merge  files;
proc sort data=res5;
by ID;
run;
proc sort data=procperf;
by ID;
run;

data res6;
   merge procperf (in=in_procp) res5 (in=in_res5);   
   by ID;
   if in_res5=1 & in_procp=1;
run;
*/

proc sort data=res6;
by ID DX_FROM_DATE;run;
data intermed1;
set res6;
by ID;
DXdate1=first.ID;
DXdateT=last.ID;
run;
proc sort data=intermed1;
by ID DX_FROM_DATE descending DXdate1;
run;
data intermed2;
set intermed1;
if DXdate1=1 then firD=DX_FROM_DATE;
else firD=.;
if DXdateT=1 then finD=DX_FROM_DATE;
else finD=.;
run;
data intermed3;
  drop temp;
  set intermed2;
  by ID;
  /* RETAIN the new variable */
  retain temp; 
  /* Reset TEMP when the BY-Group changes */
  if first.ID then temp=.;
  /* Assign TEMP when X is non-missing */
  if firD ~= . then temp=firD;
  /* When X is missing, assign the retained value of TEMP into X */
  else if firD=. then firD=temp;
run;

proc sort data=intermed3;
by ID descending DX_FROM_DATE descending DXdateT;
run;
data intermed4;
  drop temp;
  set intermed3;
  by ID;
  /* RETAIN the new variable */
  retain temp; 
  /* Reset TEMP when the BY-Group changes */
  if first.ID then temp=.;
  /* Assign TEMP when X is non-missing */
  if finD ~= . then temp=finD;
  /* When X is missing, assign the retained value of TEMP into X */
  else if finD=. then finD=temp;
run;

data datdif;
set intermed4;
YRinter=(finD-firD)/365.2425;
run;

data rec4_2yrs;
set datdif;
if YRinter>=2;
run;

data rec4_5yrs;
set rec4_2yrs;
if YRinter>=5;
run;

proc means data=rec4_5yrs;
var YRinter;
run;

data depr;
set rec4_2yrs;
if(
(DIAGNOSIS_TYPE="ICD10CM" &
(DX_CODE="F32.0" |
DX_CODE="F32.1" |
DX_CODE="F32.2" |
DX_CODE="F32.3" |
DX_CODE="F32.4" |
DX_CODE="F32.5" |
DX_CODE="F32.9" |
DX_CODE="F33.0" |
DX_CODE="F33.1" |
DX_CODE="F33.2" |
DX_CODE="F33.3" |
DX_CODE="F33.41" |
DX_CODE="F33.42" |
DX_CODE="F33.9" |
DX_CODE="F34.1" )
)
|
(DIAGNOSIS_TYPE="ICD9CM" &
(DX_CODE="296.20" |
DX_CODE="296.21" |
DX_CODE="296.22" |
DX_CODE="296.23" |
DX_CODE="296.24" |
DX_CODE="296.25" |
DX_CODE="296.26" |
DX_CODE="296.30" |
DX_CODE="296.31" |
DX_CODE="296.32" |
DX_CODE="296.33" |
DX_CODE="296.34" |
DX_CODE="296.35" |
DX_CODE="296.36" |
DX_CODE="296.50" |
DX_CODE="296.51" |
DX_CODE="296.52" |
DX_CODE="296.53" |
DX_CODE="296.54" |
DX_CODE="296.55" |
DX_CODE="296.56" |
DX_CODE="300.4" |
DX_CODE="311") )
)
then DEPRIND=1;
else DEPRIND=0;
RUN;


data addInDiag;
set depr;
if(
(DIAGNOSIS_TYPE="ICD10CM" &
 DX_CODE="G47.33" )
|
(DIAGNOSIS_TYPE="ICD9CM" &
DX_CODE="327.23" )
)
then OSAIND=1;
else OSAIND=0;
if(
(DIAGNOSIS_TYPE="ICD10CM" &
 (DX_CODE="F51.01"|
 DX_CODE="F51.02"|
 DX_CODE="F51.03"|
 DX_CODE="F51.04"|
 DX_CODE="F51.05"|
 DX_CODE="F51.09"|
 DX_CODE="F51.12"|
 DX_CODE="F51.9"|
 DX_CODE="G47.00"|
 DX_CODE="G47.01"|
 DX_CODE="G47.09"|
 DX_CODE="Z72.82")
)
|
(DIAGNOSIS_TYPE="ICD9CM" &
(DX_CODE="307.40"|
DX_CODE="307.41"|
DX_CODE="307.42"|
DX_CODE="327.00"|
DX_CODE="327.01"|
DX_CODE="327.02"|
DX_CODE="327.09"|
DX_CODE="780.51"|
DX_CODE="780.52"|
DX_CODE="V69.4"|
 DX_CODE="V69.5") )
)
then INSIND=1;
else INSIND=0;

if(
(DIAGNOSIS_TYPE="ICD10CM" &
 DX_CODE="Z72.0")
|
(DIAGNOSIS_TYPE="ICD9CM" &
DX_CODE="305.1" )
)
then CurrSmoke=1;
else CurrSmoke=0;

if(
(DIAGNOSIS_TYPE="ICD10CM" &
 DX_CODE="Z87.891")
|
(DIAGNOSIS_TYPE="ICD9CM" &
DX_CODE="V15.85") )
then FormSmoke=1;
else FormSmoke=0;

if(
(DIAGNOSIS_TYPE="ICD10CM" &
 (DX_CODE="E78.0"|
  DX_CODE="E78.1"|
DX_CODE="E78.2"|
DX_CODE="E78.3"|
DX_CODE="E78.4"|
DX_CODE="E78.5"))
|
(DIAGNOSIS_TYPE="ICD9CM" &
(DX_CODE="272.0"|
DX_CODE="272.1"|
DX_CODE="272.2"|
DX_CODE="272.3"|
DX_CODE="272.4"))
)
then HypLip=1;
else HypLip=0;
RUN;

data inPrep;
set addInDiag;
Code1 = scan(DX_CODE,1,'.');
Code2 = input(scan(DX_CODE,2,'.'),12.);
run;

data inPrep2;
set inPrep;
if((Code1="250" 
& (Code2~=01|
Code2~=11|
Code2~=21|
Code2~=31|
Code2~=41|
Code2~=51|
Code2~=61|
Code2~=71|
Code2~=81|
Code2~=91|
Code2~=03|
Code2~=13|
Code2~=23|
Code2~=33|
Code2~=43|
Code2~=53|
Code2~=63|
Code2~=73|
Code2~=83|
Code2~=93))
|
Code1="E11" 
)
then T2D=1;
else T2D=0;

if(Code1="416" |
(Code1="I27" & Code2=0)|
(Code1="I27" & Code2=2)
)
then PriPulmHT=1;
else PriPulmHT=0;

if(Code1="401"|
Code1="402"|
Code1="403"|
Code1="404"|
Code1="405"|
Code1="I10"|
Code1="I11"|
Code1="I12"|
Code1="I13"|
Code1="I14"|
Code1="I15")
then HT=1;
else HT=0;

if(
(Code1="411"|
Code1="I20")
)
then UnsAng=1;
else UnsAng=0;

if(
(Code1="410"|
Code1="412"|
Code1="I21"|
Code1="I22")
)
then MyocInf=1;
else MyocInf=0;

if(
(Code1="428" |
 Code1="I50")
)
then CHF=1;
else CHF=0;

if(
(Code1="430"|
Code1="431"|
Code1="432"|
Code1="433"|
Code1="434"|
Code1="I60"|
Code1="I61"|
Code1="I62"|
Code1="I63"|
Code1="I65"|
Code1="I66")
)
then Stroke=1;
else Stroke=0;

if(
UnsAng=1 |
MyocInf=1|
CHF=1|
Stroke=1
)
then MACE=1;
else MACE=0;
run;

data inprep3;
set inprep2;
if ((INSIND=1) or (OSAIND=1)) then INSorOSA=1;
if ((INSIND=0) and (OSAIND=0)) then INSorOSA=0;
run;

proc sort data=inprep3;
by ID descending INSorOSA DX_FROM_DATE;
run;
data inprep4;
set inprep3;
by ID;
InsOSA_date1=(first.ID)*DX_FROM_DATE;
if InsOSA_date1=0 then InsOSA_date1=.;
run;

data inprep5;
drop temp;
set inprep4;
by ID;
retain temp;
if first.ID then temp=.;
if InsOSA_date1 ~= . then temp=InsOSA_date1;
else if InsOSA_date1=. then InsOSA_date1=temp;
run;

proc sort data=inprep5;
by ID descending MACE DX_FROM_DATE;
run;
data inprep6;
set inprep5;
by ID;
MACE_date1=(first.ID)*DX_FROM_DATE;
if MACE_date1=0 then MACE_date1=.;
run;

data inprep7;
drop temp;
set inprep6;
by ID;
retain temp;
if first.ID then temp=.;
if MACE_date1 ~= . then temp=MACE_date1;
else if MACE_date1=. then MACE_date1=temp;
run;
data inprep8;
set inprep7;
OSAINS_MACE_time=MACE_date1-InsOSA_date1;
run;
PROC IMPORT OUT= WORK.vitals 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3583_ENGLISH_VITALS_2022_08_18.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data vitalT;
set vitals;
ID=input(STUDY_ID,12.);
run;
data vitalT;
set vitalT;
drop STUDY_ID;
run;

proc sort data=vitalT;
by ID CONTACT_DATE;
run;
 
data vitalb;
set vitalT;
by ID CONTACT_DATE;
recBMI=last.ID;
run;

data vitalRec;
set vitalb;
if recBMI=1;
run;

*merge  files;
proc sort data=inPrep8;
by ID;
run;
proc sort data=vitalRec;
by ID;
run;

data res7;
   merge vitalRec (in=in_vital) inPrep8 (in=in_inPrep8);   
   by ID;
   if in_inPrep8=1 & in_vital=1;
run;

PROC IMPORT OUT= WORK.qnr 
            DATAFILE= "C:\Users\PWS5\OneDrive - University of Pittsburgh
\Desktop\SleepHUB\R3\R3_3415_LUYSTER_QNR_DATA_2022_08_18_Study_ID (1).csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
data qnrESS;
set qnr;
if
(QUEST_NAME=
"EPWORTH SLEEPINESS SCALE (ESS) SCORE");
ID=input(STUDY_ID,12.);
ESS=input(ANSWER,8.);
run;
data qnrEDU;
set qnr;
if
(QUEST_NAME=
"SOCIAL FACTOR EDUCATION");
ID=input(STUDY_ID,12.);
EducLev=ANSWER;
run;
proc sort data=qnrEDU;
by ID; run;
proc sort data=qnrESS;
by ID; run;
data qnr1;
   merge qnrEDU qnrESS;   
   by ID;
run;
/*
data qnr2;
set qnr1;
if QUEST_NAME=
"EPWORTH SLEEPINESS SCALE (ESS) SCORE"
then ESS=input(ANSWER,8.);
if QUEST_NAME=
"SOCIAL FACTOR EDUCATION" 
then EducLev=ANSWER;
run;
*/
data qnr2;
set qnr1;
drop QUEST_NAME QUESTION ANSWER;run;
proc sort data=qnr2;
by ID CONTACT_DATE;
run;

data qnr2;
set qnr2;
by ID;
ind1ob=last.ID;
run;

data qnr3;
set qnr2;
drop DEPARTMENT_ID ENC_TYPE;
if ind1ob=1 then ESSrec=ESS;
run; 
proc sort data=qnr3;
by ID descending CONTACT_DATE descending ind1ob;
run;

data qnr4;
  drop temp;
  set qnr3;
  by ID;
  /* RETAIN the new variable */
  retain temp; 
  /* Reset TEMP when the BY-Group changes */
  if first.ID then temp=.;
  /* Assign TEMP when X is non-missing */
  if ESSrec ~= . then temp=ESSrec;
  /* When X is missing, assign the retained value of TEMP into X */
  else if ESSrec=. then ESSrec=temp;
run;
*merge  files;
proc sort data=qnr4;
by ID;
run;
proc sort data=res7;
by ID;
run;

data res8;
   merge qnr4 (in=in_qnr) res7 (in=in_res7);   
   by ID;
   if in_res7=1 & in_qnr=1;
run;


*working set;
proc summary data=res8 noprint
MAX MEAN;
by ID; 
output OUT=numagg mean= max=/autoname;
var
ESS ESSrec BMI 
Age Event SurvTime YRinter
DEPRIND OSAIND INSIND CurrSmoke FormSmoke
HypLip T2D PriPulmHT HT 
UnsAng MyocInf CHF Stroke MACE
InsOSA_date1 MACE_date1 OSAINS_MACE_time;
RUN;
proc sort data=res8;
by ID CONTACT_DATE;
RUN;
data nomstr1;
set res8;
by ID;
recRec=last.ID;
if recRec=1 ;
keep ID EducLev GENDER RACE ETHNICITY MARITAL_STATUS;
run;

proc sort data=numagg;
by ID; run;
proc sort data=nomstr1;
by ID; run;

data workset;
merge numagg nomstr1;
by ID; run;
proc format library=work;
value disg
1='OSA only'
2='Insomnia only'
3='COMISA'
4='Control';
run;
data workReady;
set workset;
if (OSAIND_Max=1 & INSIND_Max=0) then DisGroup=1;
if (OSAIND_Max=0 & INSIND_Max=1) then DisGroup=2;
if (OSAIND_Max=1 & INSIND_Max=1) then DisGroup=3;
if (OSAIND_Max=0 & INSIND_Max=0) then DisGroup=4;
OSAINStoMACE=OSAINS_MACE_time_Max;
if OSAINStoMACE=<0 then OSAINStoMACE=.;
if (MACE_Max=0) then OSAINStoMACE=YRinter_Max*365.2425;
format DisGroup disg.;
run;

proc means data=workready;
class DisGroup MACE_Max;
var
OSAINStoMACE;
run;

proc freq data=workready;
table DisGroup*MACE_Max;
run;

data workready;
set workready;
if SurvTime_Max=. then ST=Age_Max;
else ST=SurvTime_Max;
run;
