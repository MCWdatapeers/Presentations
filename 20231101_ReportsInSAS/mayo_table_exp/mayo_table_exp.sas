
ods path work.testtemp(update) sasuser.templat(update) sashelp.tmplmst(read);

proc template; 
define style styles.notsominimal /store=work.testtemp; 
parent=styles.minimal; 
style Table / cellpadding = 3; 
end; 
run; 

/*** example: Mayo clinic SAS table macro             ***/
/*** http://bioinformaticstools.mayo.edu              ***/

%include "table.macro";

data heart;
	set sashelp.heart;
run;

proc contents data = heart; run;

/*** EXAMPLE 1: create table using only required parameters ***/
/* 
Required parameters:
DSN = dataset name, dataset must have only one line per patient
VAR = list of discrete, continuous and censored variables in the order in which
   |       they will be printed (discrete variables can be character or numeric,
   |       but continuous variables must be numeric) 
TYPE = list of indicators for type of analysis for each variable in the var parameter (REQUIRED)
   |        If a list of variables are of the same type, you only have to enter the type once
   |        1=continuous data: prints n, mean, median, std, quartiles, range
   |          - these default stats can be changed in the CSTATS variable
   |        2=discrete data: prints freqs (n, %) - these default stats can be
   |          changed in the DSTATS variable
   |        ...
*/

%table(DSN     = heart       
	  ,VAR     = Status AgeCHDdiag Sex Cholesterol Systolic Diastolic Smoking_Status       
	  ,TYPE    = 2 1 2 1 1 1 2         
	  ,OUTDOC  = heart_base_tbl.doc        
	   );


/*** EXAMPLE 2: create table with additional options ***/

/* see table.macro documentation for descriptions of additional parameters */

%let vars   = AgeCHDdiag Sex Cholesterol Systolic Diastolic Smoking_Status;
%let types  = 1 2 1 1 1 2; 
%let ptypes = te fe w w tu ch; 

%table(DSN     = heart       
      ,BY      = status      
	  ,VAR     = &vars       
	  ,TYPE    = &types     
	  ,PTYPE   = &ptypes    
	  ,PVALUES = y          
	  ,OUTDOC  = heart_baseplus_tbl.doc
      ,OUTDAT  = heart_baseplus_status
	  ,PCTTYPE = row       
	  ,CSTATS  = n 
	             mean 
	 		     sd 
	 		     median 
	 		     quartiles 
	 		     range      
	  ,PFOOT   = y          
	  ,TTITLE1 = Patient characteristics by vital status 
	  ,TOTAL   = y          
	   );

proc print data = heart_baseplus_status; run;
	   
/*** EXAMPLE 3: create document with multiple tables ***/


%include "tablemrg.macro";

%table(DSN     = heart       
      ,BY      = sex      
	  ,VAR     = &vars       
	  ,TYPE    = &types     
	  ,PTYPE   = &ptypes         
      ,OUTDAT  = heart_baseplus_sex     
	  ,TTITLE1 = Patient characteristics by sex         
	   );

%tablemrg(DSN = heart_baseplus_status heart_baseplus_sex
         ,OUTDOC = heart_status_sex_tbls.doc
);



