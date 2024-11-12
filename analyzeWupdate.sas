libname r3 'C:\Users\PWS5\OneDrive - University of Pittsburgh\Desktop\SleepHUB\R3\';
run;
proc format library=work;
value disg
1='OSA only'
2='Insomnia only'
3='COMISA'
4='Control';
run;
PROC FORMAT LIBRARY=WORK;
VALUE RCET
1='WHITE,NON-HISP'
2='BLACK,NON-HISP'
3='HISPANIC/LATIN'
4='ASIAN & PACIFIC ISLANDER'
5='AMERINDIAN OR UNSPECIFIED';
RUN;
PROC FORMAT LIBRARY=WORK;
VALUE MARSTAT
1='MARRIED OR COUPLED'
2='SEPARATED,DIVORCED,WIDOWED'
3='SINGLE'
4='OTHER OR UNKNOWN';
RUN;
PROC FORMAT LIBRARY=WORK;
VALUE RACETH3F
1='WHITE,NON-HISP'
2='BLACK,NON-HISP'
3='Other';
RUN;
PROC FORMAT LIBRARY=WORK;
VALUE smokelev
1='Never'
2='Former'
3='Current';
RUN;

data r3.workready;
set r3.workready;
OSAINStoMACE_yr=OSAINStoMACE/365.2425;
run;

proc freq data=r3.workready;
table MACE_Max
UnsAng_Max
MyocInf_Max
CHF_Max
Stroke_Max; 
run;

proc freq data=r3.workready;
table DisGroup*
(MACE_Max
UnsAng_Max
MyocInf_Max
CHF_Max
Stroke_Max)/chisq
; run;

proc means data=r3.workready;
*by MACE_Max;
class DisGroup;
var YRinter_Max
OSAINStoMACE_yr;
;run;
proc sort data=r3.workready;
by MACE_Max;run;

proc anova data=r3.workready;
class DisGroup;
by MACE_Max;
model OSAINStoMACE_yr=DisGroup;
means DisGroup/ 
bon welch hovtest clm;
run; 
proc anova data=r3.workready;
class DisGroup;
model YRinter_Max=DisGroup;
means DisGroup/ 
bon welch hovtest clm;
run; 

/**************************************************
********UPDATES May 2nd****************************
************************************************/
**running in blocks;
*MACE;
*unadj;
*Time to MACE;
data r3.workready;
set r3.workready;
if DisGroup=3 then DCcom=1;
else DCcom=0;
if DisGroup=1 then DCosa=1;
else DCosa=0;
if DisGroup=2 then DCins=1;
else DCins=0;
run;
*PH test;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model OSAINStoMACE*MACE_Max(0)= DCcom DCosa DCins DCcomXL DCosaXL DCinsXL/rl=pl;
DCcomXL=DCcom*log(OSAINStoMACE);
DCosaXL=DCosa*log(OSAINStoMACE);
DCinsXL=DCins*log(OSAINStoMACE);
 proportionality_test: test DCcomXL,DCosaXL, DCinsXL;
run;
*unadj;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model OSAINStoMACE*MACE_Max(0)= DisGroup YRinter_Max/rl=pl;
run;
*add demog;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model OSAINStoMACE*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max/rl=pl; run;
*add risk;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model OSAINStoMACE*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX YRinter_Max/rl=pl; run;
*add comorbids;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model OSAINStoMACE*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX 
HYPLIP_MAX T2D_MAX PRIPULMHT_MAX HT_MAX DEPRIND_MAX YRinter_Max/rl=pl;
run;

**MACE;
*Time to MACE;
title "Time to MACE models";
*unadj;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup YRinter_Max/rl=pl;run;
*add demog;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max;
run;
*Ineraction Gender;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*GENDER/rl=pl;
hazardratio DisGroup / at (GENDER=ALL);
run;
*Ineraction Age (checked at 25th, 50th, 75th percentile for age);
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*Age_Max/rl=pl;
hazardratio DisGroup / at (Age_Max=49 61 71);
run;
proc univariate data=sashelp.baseball;
    var nHits;
     output out=work.baseball_percentiles_80_99_5
	pctlpts = 80, 99.5
	pctlpre = P_;
run;
 proc rank data=r3.workready out=tertage  groups=3;
  var Age_Max;
  ranks Age3tile;
run;
proc sort data=tertage;
by Age3tile;run;
proc means data=tertage min max;
by Age3tile;
var Age_Max;
run;

*Ineraction Age (categorizing age in tertiles);
proc phreg data=tertage;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED')
	  Age3tile (param=reference ref='0'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age3tile GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*Age3tile/rl=pl;
hazardratio DisGroup /at (Age3Tile=ALL);
run;

*Ineraction Race Ethnicity;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*RACETH3/rl=pl;
hazardratio DisGroup / at (RacEth3=ALL);
run;
*i've dropped the interactions, they create problems in estimations as they are non-significant;
*add risk;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX YRinter_Max/rl=pl; run;
*add comorbids;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MACE_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX 
HYPLIP_MAX T2D_MAX PRIPULMHT_MAX HT_MAX DEPRIND_MAX YRinter_Max/rl=pl;
run;

title "Time to Unstable Angina";
**Unstable Angina;
*Time to unstable angina;
*unadj;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup YRinter_Max/rl=pl;run;
*add demog;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max;
run;
*Ineraction Gender;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*GENDER/rl=pl;
hazardratio DisGroup / at (GENDER=ALL);
run;
*Ineraction Age (checked at 25th, 50th, 75th percentile for age);
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*Age_Max/rl=pl;
hazardratio DisGroup / at (Age_Max=49 61 71);
run;
*Ineraction Race Ethnicity;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*RACETH3/rl=pl;
hazardratio DisGroup / at (RacEth3=ALL);
run;
*i've dropped the interactions, they create problems in estimations as they are non-significant;
*add risk;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX YRinter_Max/rl=pl; run;
*add comorbids;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*UnsAng_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX 
HYPLIP_MAX T2D_MAX PRIPULMHT_MAX HT_MAX DEPRIND_MAX YRinter_Max/rl=pl;
run;

title "Time to Myocardial Infarction models";
**Myocardial Infarction;
*Time to Myocardial Infarction;
*unadj;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup YRinter_Max/rl=pl;run;
*add demog;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max;
run;
*Ineraction Gender;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*GENDER/rl=pl;
hazardratio DisGroup / at (GENDER=ALL);
run;
*Ineraction Age (checked at 25th, 50th, 75th percentile for age);
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*Age_Max/rl=pl;
hazardratio DisGroup / at (Age_Max=49 61 71);
run;
*Ineraction Race Ethnicity;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*RACETH3/rl=pl;
hazardratio DisGroup / at (RacEth3=ALL);
run;
*i've dropped the interactions, they create problems in estimations as they are non-significant;
*add risk;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX YRinter_Max/rl=pl; run;
*add comorbids;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*MyocInf_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX 
HYPLIP_MAX T2D_MAX PRIPULMHT_MAX HT_MAX DEPRIND_MAX YRinter_Max/rl=pl;
run;

title "Time to Congestive Heart Failure Models";
**Congestive Heart Failure;
*Time to Congestive Heart Failure;
*unadj;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup YRinter_Max/rl=pl;run;
*add demog;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max;
run;
*Ineraction Gender;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*GENDER/rl=pl;
hazardratio DisGroup / at (GENDER=ALL);
run;
*Ineraction Age (checked at 25th, 50th, 75th percentile for age);
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*Age_Max/rl=pl;
hazardratio DisGroup / at (Age_Max=49 61 71);
run;
*Ineraction Race Ethnicity;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*RACETH3/rl=pl;
hazardratio DisGroup / at (RacEth3=ALL);
run;
*i've dropped the interactions, they create problems in estimations as they are non-significant;
*add risk;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX YRinter_Max/rl=pl; run;
*add comorbids;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*CHF_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX 
HYPLIP_MAX T2D_MAX PRIPULMHT_MAX HT_MAX DEPRIND_MAX YRinter_Max/rl=pl;
run;

title "Time to Stroke";
**Stroke;
*Time to Stroke;
*unadj;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup YRinter_Max/rl=pl;run;
*add demog;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max/rl=pl;
run;
*Ineraction Gender;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*GENDER/rl=pl;
hazardratio DisGroup / at (GENDER=ALL);
run;
*Ineraction Age (checked at 25th, 50th, 75th percentile for age);
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*Age_Max/rl=pl;
hazardratio DisGroup / at (Age_Max=49 61 71);
run;
*Ineraction Race Ethnicity;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED YRinter_Max
DisGroup*RACEth3/rl=pl;
hazardratio DisGroup / at (RacEth3=ALL);
run;
*i've dropped the interactions, they create problems in estimations as they are non-significant;
*add risk;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX YRinter_Max/rl=pl; run;
*add comorbids;
proc phreg data=r3.workready;
class DisGroup (param=reference ref='Control')
	  GENDER (param=reference ref='FEMALE')
	  RACETH3 (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model SDDtoMACEyr*Stroke_Max(0)= DisGroup Age_Max GENDER RACETH3 PARTNERED 
BMI_MAX CURRSMOKE_MAX FORMSMOKE_MAX 
HYPLIP_MAX T2D_MAX PRIPULMHT_MAX HT_MAX DEPRIND_MAX YRinter_Max/rl=pl;
run;
ods pdf close;
PROC FORMAT LIBRARY=WORK;
VALUE smokelev
1='Never'
2='Former'
3='Current';
RUN;
data smokecat;
set r3.workready;
if CURRSMOKE_MAX=1 then SmokeCat=3;
if FORMSMOKE_MAX=1 then SmokeCat=2;
if (CURRSMOKE_MAX=0 & FORMSMOKE_MAX=0) then SmokeCat=1;
format SmokeCat smokelev.;
run;

proc freq data=smokecat;
table DisGroup*SmokeCat
/cellchi2 chisq deviation nocol;run;
