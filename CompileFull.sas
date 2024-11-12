*bring in data and set up;
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

ods pdf file='C:\Users\PWS5\OneDrive - University of Pittsburgh\Desktop\SleepHUB\R3\outs030923.pdf' style=journal;
**Descriptive Statistics;
proc means data=r3.workready;
var MACE_Max UnsAng_Max MyocInf_Max CHF_Max Stroke_Max;
run;
proc freq data=r3.workready;
table
GENDER RACEETHN PARTNERED DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX;
run;
proc means data=r3.workready;
var MACE_Max UnsAng_Max MyocInf_Max CHF_Max Stroke_Max;
run;
proc means data=r3.workready;
class DisGroup;
var MACE_Max UnsAng_Max MyocInf_Max CHF_Max Stroke_Max;
run;


**Unadjusted Models;
*MACE;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model MACE_Max(event='1')= DisGroup 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*MACE_Max(0)=DisGroup YRinter_Max
	/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*UnsAng;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model UnsAng_Max(event='1')= DisGroup 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*UnsAng_Max(0)=DisGroup YRinter_Max
	/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*MyocInf;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model MyocInf_Max(event='1')= DisGroup 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*MyocInf_Max(0)=DisGroup YRinter_Max
	/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*CHF;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model CHF_Max(event='1')= DisGroup 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*CHF_Max(0)=DisGroup YRinter_Max
	/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*Stroke;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model Stroke_Max(event='1')= DisGroup 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*Stroke_Max(0)=DisGroup YRinter_Max
	/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;


*****Adjusted Models;
*MACE;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model MACE_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*MACE_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*UnsAng;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model UnsAng_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*UnsAng_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*MyocInf;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model MyocInf_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*MyocInf_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*CHF;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model CHF_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*CHF_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*Stroke;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model Stroke_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*Stroke_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*Moderation models;
*MACE;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model MACE_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*MACE_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*UnsAng;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model UnsAng_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*UnsAng_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*MyocInf;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model MyocInf_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*MyocInf_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*CHF;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model CHF_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*CHF_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

*Stroke;
proc logistic data=r3.workready;
class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
model Stroke_Max(event='1')= DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX 
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/expb clodds=pl;
run;
ods output ParameterEstimates=hrci;
proc phreg data=r3.workready;
	class DisGroup (param=reference ref='COMISA')
	  GENDER (param=reference ref='FEMALE')
	  RACEETHN (param=reference ref='WHITE,NON-HISP')
	  PARTNERED (param=reference ref='MARRIED OR COUPLED'); 	
	model OSAINStoMACE*Stroke_Max(0)=DisGroup 
Age_Max GENDER RACEETHN PARTNERED BMI_MAX DEPRIND_MAX 
CURRSMOKE_MAX FORMSMOKE_MAX HYPLIP_MAX T2D_MAX
PRIPULMHT_MAX HT_MAX YRinter_Max
Age_Max*DisGroup GENDER*DisGroup RACEETHN*DisGroup
/rl=pl;
   run;
   data hrci;set hrci;
   Covariates=cat(Parameter,ClassVal0);run;
proc sgplot data=hrci; 
 scatter x=HazardRatio y=Covariates / 
xerrorlower=HRLowerPLCL
xerrorupper=HRUpperPLCL 
markerattrs=HazardRatio 
(symbol=CircleFilled size=6); 
 refline 1 / axis=x; 
 xaxis label="HR and 95% CI " min=0; 
 yaxis label="Covariates"; 
run;

ods pdf close;
