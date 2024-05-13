%*  This macro generate summary for variables in your data set     		    						      ;
%*  Author: 				Geliang Gan																      ;
%*	Last Update:			02-08-2019																      ;
%*	Contact Information:	geliang.gan@yale.edu 													      ;
%*							Yale Center for Analytical Sciences										      ;
%*							300 George Street, Suite 511											      ;
%*							New Haven, CT, 06520													      ;
%*																									      ;
%*	Parameter Explanation:																			      ;
%*    	            dsn - data set name which contains the variables for summarizing					  ;
%*    	          group - variable on which summary talbe stratifies									  ;
%*				  	      observation(s) with missing on group variable is(are) excluded from analysis	  ;
%*    	         calist - list of categorical variables for analysis, separated with space				  ;
%* 		        coplist - list of continuous variable for analysis, p value calculated with parametric    ;
%*					      method																		  ;
%*           cononplist - list of continuous variable for analysis, p value calculated with nonparametric ;
%*					      method																		  ;
%*          outputorder - specify the order of the variables in the final report						  ;
%*      continuousorder - specify which type of continuous variable will be put first in the final report ;
%*                        default is 1, which means variable(s) in parametric list will be placed first,  ;
%*                        2 means putting non-parametric list on top of parametric list                   ;
%*    	         outdsn - name of data set which holds the summary result								  ;
%*				  	      default name for output data set is Talbe1Macro								  ;
%*    	         Eratio - proportion of the number of cells in which the expected frequencyis less than   ;
%*				  	      5, if it is greater than the specified one, fisher exact instead of Chi-Square  ;
%*				  	      test is applied for p value													  ;
%*          percenttype - percentage type for categorical variable(s), default is column, which is        ;
%*                        stratified on the different levels of the variable, another legal value is row, ;
%*                        which output the percentage stratified on group variable                        ;
%*              copmain - main part of the output for continuous variable using parametric test, default  ;
%*						  is mean																		  ;
%*        copsupplement - supplemental part of the output for continuous variable using parametric test,  ;
%*                        this value will be put in the parenthesis, default is standard deviation        ;
%*           cononpmain - main part of the output for continuous variable using nonparametric test,		  ;
%*						  default is median																  ;
%*     cononpsupplement - supplemental part of the output for continuous variable using parametric test,  ;
%*                        this value will be put in the parenthesis, default is range                     ;
%*	      caexcludelist - the list of categorical variable(s) for which you do not want to do Chi-square  ;
%*                  	  or Fisher Exact test, only frequency table will generate for those variable(s)  ;
%*	     copexcludelist - the list of continuous variable(s) for which you do not want to test using      ;
%*                	      parametric method, only summary statistics in the output          			  ;
%*    cononpexcludelist - the list of continuous variable(s) for which you do not want to test using      ;
%*              	      non-parametric method, only summary statistics in the output          		  ;
%*     caincludemissing - yes or no, specify if missing should be a level including in the frequency   	  ;
%*					      table, but test never use missing, it is only part of frequency table,		  ;
%*					      default value is no															  ;
%* 		     missingtop - yes or no, specify if the missing is the first level to output, default is yes  ;
%*    copincludemissing - yes or no, specify if missing information should be reported for parametric  	  ;
%*					      continuous variable,	default value is no										  ;
%* cononpincludemissing - yes or no, specify if missing information should be reported for non-parametric ;
%*					      continuous variable,	default value is no										  ;
%*			     notest - yes or no, specify if p value is calculated using relative test if group 		  ;
%*						  variable is provided, default value is no						  				  ;
%*			      cadec - specify how many decimals are there in the frequency table for percentages	  ;
%*					      0, 1 and 2 are avaialbe, default is 2											  ;
%*			     copdec - specify how many decimals are there for the statistics of continuous variable	  ;
%*					      using parametric analysis, 0, 1, 2, 4 and 5 are avaialbe, default is 1          ;	
%*	          cononpdec - specify how many decimals are there for the statistics of continuous variable	  ;
%*					      using nonparametric analysis, 0, 1, 2, 4 and 5 are avaialbe, default is 1       ;											  
%*			    overall - yes or no, specify if overall columns are include in the final result table,	  ;
%*					      default is no																	  ;
%*          paddingchar - specify the type of paddingchar, default is 1, available 0, 1, and 2            ;
%*						  0 means no padding char, numbers in the report are not aligned				  ;
%*						  1 means using 0 as padding char, so numbers are alligned in the report		  ;
%*						  2 means using space as padding char, numbers are aligned if typewriter fonts	  ;
%*							is used, as Simsum and Courier												  ;
%*          reportinSAS - specify there is a copy of report showing up in SAS, defaylt is no, if 		  ;
%*						  parameter creatertf is no, reportinSAS will be changed to yes	by program		  ;
%*      variableshading - specify if shade the variable name row, default is yes						  ;
%*        labelvariable - label variable if Fisher Exact test is applied for p value of categorical       ;
%*                        variable, or non-equal variance during T-test for continuous variable           ;
%*      suppresswarning - supress the pop-up window for warning message, default is yes  				  ;
%* 		      creatertf - specify if a rtf file is created, default is yes								  ;
%* 	       compacttable - specify if the table is in compact format, default is yes						  ;
%*			 tabletitle - specify the title for table													  ;
%*	       savefilename - specify the name for rtf file, default is Variable Summary  				  	  ;
%*			  showgroup - specify if show group title in the table, default it yes                        ;
%*		  orderbyformat - specify if order the categories of categorical variable by their formatted      ;
%*                        values once a format is provided, default is yes 								  ;
%*            pvaluetop - put pvalue line as the first line for each variable                             ;
%*		    orientation - specify orientation of the rtf document, by default, portrait for reports       ;
%*						  without a group variable and landscape for reportw with a group variable		  ;
%*		 missingpercent - specify if include percentage of missing in the table, default is no			  ;
%*		   missinglabel - specify row label for missing information of categorical varialbel			  ;
%*				NAlabel - specify label for missing value due to non-applicable calculation				  ;
%*		showtotalcount	- specify if show total number of observation in the summary table				  ;
%*                                                                                                        ;
%*                                                                                                        ;
%*	This macro is developed using SAS 9.4.3 and tested using office word 2013. It might be not            ;
%*  compatible with previous version of SAS or office. Please use it with caution.                        ;

option noquotelenmax;
ods escapechar = "~";
%macro  Table1Macro( dsn 					= , 
					 group 					= ,  
					 calist 				= ,
					 coplist				= ,
					 cononplist				= ,
					 outputorder			= ,
					 continuousorder		= 1,
					 outdsn 				= Table1Summary, 
					 Eratio 				= 0.2,
					 percenttype 			= column,
					 copmain				= mean,
					 copsupplement			= std,
					 cononpmain				= median,
					 cononpsupplement		= iqr, 
					 caexcludelist 			= , 
					 copexcludelist 		= ,
				     cononpexcludelist		= ,
					 caincludemissing 		= no, 
					 copincludemissing 		= no,
					 cononpincludemissing 	= no,
					 missingtop				= yes,
					 notest 				= no, 
					 cadec 					= 2, 
					 copdec					= 2,
				     cononpdec				= 1,
					 overall 				= no,
					 paddingchar			= 1,
					 reportinSAS      		= no,
					 variableshading    	= yes,
					 labelvariable			= no,
					 suppresswarning 		= yes,
					 creatertf				= yes,
					 compacttable			= yes,
					 tabletitle				= ,
					 savefilename 			= Variable Summary,
					 showgroup				= yes,
					 orderbyformat			= yes,
                     pvaluetop              = no,
					 orientation			= ,
					 missingpercent			= no,
					 missinglabel			= Missing,
					 NAlabel				= NA,
					 showtotalcount			= yes);
	%*set up background color of the table matching paper background color just in case printing on non-white paper;
	%let bcolor				= CXffffff;
	%*remove title and footnote from previous program;
	title;
	footnote;
	%*if paddingchar is 0 then no padding, if 2 then padding with space, otherwise padding with 0s;
	%if &paddingchar = 0 %then %let paddingchar = ;
		%else %if &paddingchar = 2 %then %let paddingchar = %str( );
		%else %let paddingchar = 0;
    %*if there is no group variable provided, output overall results;
	%if "&group" = "%str()" %then %let overall = yes;
    %*choose whether to put missing inforamtion as top or bottom row;
	%if "%upcase(%substr(&missingtop, 1, 1))" ^= "N" %then %let missingtop = 1;
		%else %let missingtop = 3;
	%*check orientation;
	%if "&orientation" ^= "%str()" %then %do;
		%if "%upcase(&orientation)" ^= "LANDSCAPE" and "%upcase(&orientation)" ^= "PORTRAIT" %then %do;
			%put WARNING: orientation, &orientation, is not valueable, only landscape or portrait is accepted;
			dm "post 'WARNING: orientation, &orientation, is not valueable, only landscape or portrait is accepted'"; 
			%let orientation =;
		%end;
	%end;
	%*check missingpercent option, if no missing output for categorical variable, then missingpercent equals to no;
	%if "%substr(%upcase(&caincludemissing, 1, 1))" = "N" %then %let missingpercent = no;
	%if "&group" ^= "%str()" %then %do;
		%if "&calist" ^= "%str()" %then %do;
			%if "%IfStr1inStr2(str1 = &calist, str2 = &group, out = 2)" = "%str()" %then %do;
				%put WARNING: categorical variabe list is empty after removing group varialble;
				dm "post 'WARNING: categorical variabe list is empty after removing group varialble'";
			%end;
		%end;
		%if "&coplist" ^= "%str()" %then %do;
			%if "%IfStr1inStr2(str1 = &coplist, str2 = &group, out = 2)" = "%str()" %then %do;
				%put WARNING: continuous parametric variabe list is empty after removing group varialble;
				dm "post 'WARNING: continuous parametric variabe list is empty after removing group varialble'";
			%end;
		%end;
		%if "&cononplist" ^= "%str()" %then %do;
			%if "%IfStr1inStr2(str1 = &cononplist, str2 = &group, out = 2)" = "%str()" %then %do;
				%put WARNING: continuous non-parametric variabe list is empty after removing group varialble;
				dm "post 'WARNING: continuous non-parametric variabe list is empty after removing group varialble'";
			%end;
		%end;
	%end; 
	%*initiate variable list;
	%let group 				= %upcase(&group);
	%if "&calist" ^= "%str()" 		%then %let calist 		= %upcase(%IfStr1inStr2(str1 = &calist, str2 = &group, out = 2));
	%if "&coplist" ^= "%str()" 		%then %let coplist 		= %upcase(%IfStr1inStr2(str1 = &coplist, str2 = &group, out = 2));
	%if "&cononplist" ^= "%str()" 	%then %let cononplist 	= %upcase(%IfStr1inStr2(str1 = &cononplist, str2 = &group, out = 2));
	%let outputorder 		= %upcase(&outputorder);
	%let copmain			= %upcase(&copmain);
	%let copsupplement  	= %upcase(&copsupplement);
	%let cononpmain			= %upcase(&cononpmain);
	%let cononpsupplement	= %upcase(&cononpsupplement);	
	%*if all variable lists are empty, leave the macro;
    %if "&calist.&coplist.&cononplist." = "%str()" %then %do;
        %put ERROR: all variabe lists are empty after removing group variable;
		dm "post 'ERROR: all variabe lists are empty after removing group variable'";
		%return;
    %end;	
	%local i j k CVar varcnt TestType temp temp1 temp2 temp3 tempinfo tempvarinfo tempfmt Cfmt tempdsn messenger varlist
		   fmtlist groupf moptions statlist prob1 prob2 CVar Cstat cntlevel orivarlist cnt1 cnt2 caresult copresult grouplabel
		   cononpresult coResult coVar copf cononpf frequencylen1 percentlen1 frequencylen2 percentlen2 temporder len len1 len2 
		   len3 len4 coporder cononporder orientation_setup tempmissing savefilepath missingonly1 missingonly2;
	%*if choose not to create RTF output or no savefilename provided, the reportinSAS will change to yes;
	%if "%upcase(%substr(&creatertf, 1, 1))" = "N" or "&savefilename" = "%str()" or "&savefilename" = "%str(\)" %then %do;
        %if "&savefilename" = "%str()" or "&savefilename" = "%str(\)" %then %do;
    		%put no saving file name provided, output only shows in SAS;
    		dm "post 'no saving file name provided, output only shows in SAS'";
        %end;
        %let reportinSAS = yes;
        %let creatertf   = no;
        %let savefilename = ;
    %end;
	%*check savefilename;
    %if "&savefilename" ^= "%str()" %then %do; 
        %let savefilename = &savefilename;
		*if it is windows system, check validity of path;
        %if "&SYSSCP" = "WIN" %then %do;
			%if %sysfunc(findc(&savefilename, %str(\), , -%length(&savefilename))) > 0 %then %do;
				*if \ is the first letter, save file in current folder; 
				%if %sysfunc(findc(&savefilename, %str(\), , -%length(&savefilename))) - 1 > 0 %then %do;
					%let savefilepath = %substr(&savefilename, 1, %sysfunc(findc(&savefilename, %str(\), , -%length(&savefilename))) - 1);
					%if %FolderExist(dir = &savefilepath) = 0 %then %do;
						%put WARNING:folder  &savefilepath    does not exist, file will be saved on current folder;
						dm "post 'folder   &savefilepath   does not exist, file will be saved on current folder'";
						%let savefilepath =;
					%end;
				%end;
				%else %let savefilepath = ;
				*if only directory provided, file name is set as Variable Summary; 
				%if %sysfunc(findc(&savefilename, %str(\), , -%length(&savefilename))) < %length(&savefilename) %then
                    %let savefilename = %substr(&savefilename, %sysfunc(findc(&savefilename, %str(\), , -%length(&savefilename))) + 1);
                    %else %let savefilename = Variable Summary;
			%end;
			%if %length(&savefilename) >= 4 %then %do;
                    %if "%upcase(%substr(&savefilename, %length(&savefilename) - 3, 4))" = ".RTF" %then 
                        %let savefilename = %substr(&savefilename, 1, %length(&savefilename) - 4);
            %end;
		%end;
        %if "&savefilepath" ^= "%str()" %then  %let savefilename = &savefilepath.\&savefilename;
    %end;
	%*by default, parametric continuous variables appear on top of non-parametric continuous variables;
	%if "&continuousorder" ^= "2" %then %do;
		%let coporder = 1;
		%let cononporder = 2;
	%end;
	%else %do;
		%let coporder = 2;
		%let cononporder = 1;
	%end;
	%*clear log and ods results window and save option settings;
	dm "odsresults;clear;log;clear;";
	%let moptions = %sysfunc(getoption(mprint)) %sysfunc(getoption(mlogic)) %sysfunc(getoption(symbolgen))
                    %sysfunc(getoption(number)) %sysfunc(getoption(date));
	%let orientation_setup = %sysfunc(getoption(orientation));
	*repress the output to both log and SAS and save time;
	option nosource nonotes nosymbolgen nomprint nomlogic nonumber nodate; 
	%put;
	%put ********************Aanlysis Start********************;
	%put;
	%put *******************Check Parameters*******************;
	%put;
	%*if no data set specified, leave the macro;
    %if &dsn = %str() %then %do;
		%put ERROR: please specify a data set;
		dm "post 'ERROR: please specify a data set'";
		option source notes &moptions orientation = &orientation_setup; 
		%return;
	%end;
	%*if data set does not exist, warn and quit;
	%if %sysfunc(exist(&dsn)) = 0 %then %do;
		%put ERROR: data set does not exist - &dsn;
		dm "post 'ERROR: data set does not exist - &dsn'";
		option source notes &moptions orientation = &orientation_setup; 
		%return;
	%end;
	%*if data set is empty, quit macro;
	%if %Varlist(&dsn) = %str() or %nobs(&dsn) = 0 %then %do;
		%put ERROR: data set is empty - &dsn;
		dm "post 'ERROR: data set is empty - &dsn'";
		option source notes &moptions orientation = &orientation_setup; 
		%return;
	%end;
	%*if calist is not empty check expected ratio;
	%if "&calist" ^= "%str()" %then %do;
		%let Eratio = &Eratio;
		%if %sysfunc(compress(&Eratio, ., d)) ^= %str() or %sysfunc(countc(&Eratio, .)) > 1 %then %do;
			%put ERROR: illegal eratio parameter, &Eratio;
			dm "post 'ERROR: illegal eratio parameter, &Eratio'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
		%if &Eratio > 1 or &Eratio < 0 %then %do;
			%put ERROR: illegal eratio parameter, it should between 0 and 1;
			dm "post 'ERROR: illegal eratio parameter, it should between 0 and 1'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
	%end; 
	%*check if every variable in every varlist is in the data set;	
	%let CVar  = %upcase(%VarList(&dsn));
	%*if any variable in the any list is not in the data set, quit macro;
	%*categorical variable list;
	%if "&calist" ^= "%str()" %then %do;
		%let messenger = %IfStr1inStr2(str1 = &calist, str2 = &CVar, out = 2);
		%if "&messenger" ^= "%str()" %then %do;
			%put ERROR: variable(s) from Varlist not in &dsn - &messenger;
			dm "post 'ERROR: variable(s) from categorical varlist not in &dsn - &messenger'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
		%let temp2 = %UniqueandReduncant(str = &calist, out = 2);
		%if "&temp2" ^= "%str()" %then %do;
			%put WARNING: duplicate variable(s): &temp2, frequency only generate once for these variable(s);
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
				dm "post 'WARNING: duplicate variable(s): &temp2, frequency only generate once for these variable(s)'";;
		%end;
		%*remove redundant variables in the list;
		%let calist = %UniqueandReduncant(str = &calist, out = 1);
		%*if group variable in the list, remove it;
		%if "&group" ^= "%str()" %then %let calist = %IfStr1inStr2(str1 = &calist, str2 = &group, out = 2);
	%end;
	%*continuous variable list using parametric method;
	%if "&coplist" ^= "%str()" %then %do;		
		%let messenger = %IfStr1inStr2(str1 = &coplist, str2 = &CVar, out = 2);
		%if "&messenger" ^= "%str()" %then %do;
			%put ERROR: variable(s) from parametric list not in &dsn - &messenger;
			dm "post 'ERROR: variable(s) from parametric list not in &dsn - &messenger'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
		%let temp2 = %UniqueandReduncant(str = &coplist, out = 2);
		%if "&temp2" ^= "%str()" %then %do;
			%*remove redundant variables in the list;
			%let coplist = %UniqueandReduncant(str = &coplist, out = 1);
			%put WARNING: duplicate variable(s): &temp2, statistics only generate once for these variable(s) in parametric list;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
				dm "post 'WARNING: duplicate variable(s): &temp2, statistics only generate once for these variable(s) in parametric list'";;
		%end;
	%end; 
	%*continuous variable list using nonparametric method;
	%if "&cononplist" ^= "%str()" %then %do;		
		%let messenger = %IfStr1inStr2(str1 = &cononplist, str2 = &CVar, out = 2);
		%if "&messenger" ^= "%str()" %then %do;
			%put ERROR: variable(s) from non-parametric list not in &dsn - &messenger;
			dm "post 'ERROR: variable(s) from non-parametric list not in &dsn - &messenger'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
		%let temp2 = %UniqueandReduncant(str = &cononplist, out = 2);
		%if "&temp2" ^= "%str()" %then %do;
			%*remove redundant variables in the list;
			%let cononplist = %UniqueandReduncant(str = &cononplist, out = 1);
			%put WARNING: duplicate variable(s): &temp2, statistics only generate once for these variable(s) for non-parametric list;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
				dm "post 'WARNING: duplicate variable(s): &temp2, statistics only generate once for these variable(s) for non-parametric list'";;
		%end;
	%end;
	%*check if group variable are there in the data set;
	%if "&group" ^= "%str()" and %sysfunc(indexw(&CVar, &group)) = 0 %then %do;
		%put ERROR: group variable is not in the data set &dsn - &group;
		dm "post 'ERROR: group variable is not in the data set &dsn - &group'";
		option source notes &moptions orientation = &orientation_setup; 
		%return;
	%end; 
	%*check stat list for continuous variable;
	%let statlist = %upcase(clm nmiss css range cv skewness kurtosis kurt std stddev lclm stderr max sum mean 
							sumwgt min uclm mode uss n  var median q3 p50 p1 p90 p5 p95 p10 p99 p20 p30 p40 p60 
							p70 p80 q1 p25 qrange probt prt t iqr);
	%*check statistic list for parametric variable;
	%if "&coplist" ^= "%str()" %then %do;
		%if "&copmain" = "%str()" %then %do;
			%let copmain = MEAN;
			%put WARNING: parametric main is missing, Mean will report;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
				dm "post 'WARNING: parametric main is missing, Mean will report'";;
		%end;
		%else %let copmain = %UniqueandReduncant(str = &copmain, out = 1);
		%*if more than one statistic is specified, use the first one;
		%if %sysfunc(countw(&copmain)) > 1 %then %do;
			%let copmain = %scan(&copmain, 1);	
			%put WARNING: only first statistic for parametric main will be in the output - &copmain;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
				dm "post 'WARNING: only first statistic for parametric main will be in the output - &copmain'";;
		%end;
		%*if specified statistics is not supported, warn and quit;
		%if %sysfunc(indexw(&statlist, &copmain)) = 0 %then %do;
			%put ERROR: statistic &copmain not supported for copmain, supported statistic list: &statlist;
			dm "post 'ERROR: statistic &copmain not supported for copmain, supported statistic list: &statlist'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
		%*change statistics to standard name supported by proc means;
		%if "&copmain" = "KURTOSIS" %then %let copmain = KURT;
			%else %if "&copmain" = "STD" 		%then %let copmain = STDDEV;
			%else %if "&copmain" = "PRT" 		%then %let copmain = PROBT;
			%else %if "&copmain" = "IQR" 		%then %let copmain = QRANGE;
		%if "&copsupplement" ^= "%str()" %then %do;
			%let copsupplement = %UniqueandReduncant(str = &copsupplement, out = 1);
			%*if first statistic in supplement list is the same as the copmain, use the second one;
			%if "&copmain" = "%scan(&copsupplement, 1)" %then %do;
				%let copsupplement = %scan(&copsupplement, 2);
				%put WARNING: first supplement statistic for parametric variable(s) is the same as the main, second statistic will be reported if available;
				%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
					dm "post 'WARNING: first supplement statistic for parametric variable(s) is the same as the main, second statistic will be reported if available'";;
			%end;
			%*if specified statistics is not supported, warn and quit;
			%if "&copsupplement" ^= "%str()" %then %do;
				%*if more than one statistic is specified, use the first one;
				%if %sysfunc(countw(&copsupplement)) > 1 %then %do;			
					%put WARNING: only first statistic for parametric supplement will be in the output;
					%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
						dm "post 'WARNING: only first statistic for parametric supplement will be in the output'";;
					%let copsupplement = %scan(&copsupplement, 1);
				%end;
				%if %sysfunc(indexw(&statlist, &copsupplement)) = 0 %then %do;
					%put ERROR: statistic &copsupplement not supported for copsupplement, supported statistic list: &statlist;
					dm "post 'ERROR: statistic &copsupplement not supported for copsupplement, supported statistic list: &statlist'";
					option source notes &moptions orientation = &orientation_setup; 
					%return;
				%end;
				%*change statistics to standard name supported by proc means;
				%if "&copsupplement" = "KURTOSIS" %then %let copsupplement = KURT;
					%else %if "&copsupplement" = "STD" 	%then %let copsupplement = STDDEV;
					%else %if "&copsupplement" = "PRT" 	%then %let copsupplement = PROBT; 
					%else %if "&copsupplement" = "IQR" 	%then %let copsupplement = QRANGE;
			%end;
		%end;
	%end;
	%else %do;
		%let copmain = ;
		%let copsupplement = ;
	%end;
	%*check statistic list for non-parametric variable;
	%if "&cononplist" ^= "%str()" %then %do;
		%if "&cononpmain" = "%str()" %then %do;
			%let cononpmain = MEDIAN;
			%put WARNING: non-parametric main is missing, Median will report;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
				dm "post 'WARNING: non-parametric main is missing, Median will report'";;
		%end;
		%else %let cononpmain = %UniqueandReduncant(str = &cononpmain, out = 1);
		%*if more than one statistic is specified, use the first one;
		%if %sysfunc(countw(&cononpmain)) > 1 %then %do;			
			%put WARNING: only first statistic for non-parametric main will be in the output;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
				dm "post 'WARNING: only first statistic for non-parametric main will be in the output'";;
			%let cononpmain = %scan(&cononpmain, 1);
		%end;
		%*if specified statistics is not supported, warn and quit;
		%if %sysfunc(indexw(&statlist, &cononpmain)) = 0 %then %do;
			%put ERROR: statistic &cononpmain not supported, supported statistic list: &statlist;
			dm "post 'ERROR: statistic &cononpmain not supported, supported statistic list: &statlist'";
			option source notes &moptions orientation = &orientation_setup; 
			%return;
		%end;
		%*change statistics to standard name supported by proc means;
		%if "&cononpmain" = "KURTOSIS" %then %let cononpmain = KURT;
			%else %if "&cononpmain" = "STD" 		%then %let cononpmain = STDDEV;
			%else %if "&cononpmain" = "PRT" 		%then %let cononpmain = PROBT;
			%else %if "&cononpmain" = "IQR" 		%then %let cononpmain = QRANGE;
		%if "&cononpsupplement" ^= "%str()" %then %do;
			%let cononpsupplement = %UniqueandReduncant(str = &cononpsupplement, out = 1);
			%*if first statistic in supplement list is the same as the cononpmain, use the second one;
			%if "&cononpmain" = "%scan(&cononpsupplement, 1)" %then %do;
				%let cononpsupplement = %scan(&cononpsupplement, 2);
				%put WARNING: first supplement statistic for non-parametric variable(s) is the same as the main, second statistic will be reported if available;
				%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
					dm "post 'WARNING: first supplement statistic for non-parametric variable(s) is the same as the main, second statistic will be reported if available'";;
			%end;
			%if "&cononpsupplement" ^= "%str()" %then %do;
				%*if more than one statistic is specified, use the first one;
				%if %sysfunc(countw(&cononpsupplement)) > 1 %then %do;			
					%put WARNING: only first statistic for non-parametric supplement will be in the output;
					%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then
						dm "post 'WARNING: only first statistic for non-parametric supplement will be in the output'";;
					%let cononpsupplement = %scan(&cononpsupplement, 1);
				%end;
				%*if specified statistics is not supported, warn and quit;
				%if %sysfunc(indexw(&statlist, &cononpsupplement)) = 0 %then %do;
					%put ERROR: statistic &cononpsupplement not supported for cononpsupplement, supported statistic list: &statlist;
					dm "post 'ERROR: statistic &cononpsupplement not supported for cononpsupplement, supported statistic list: &statlist'";
					option source notes &moptions orientation = &orientation_setup; 
					%return;
				%end;
				%*change statistics to standard name supported by proc means;
				%if "&cononpsupplement" = "KURTOSIS" 			%then %let cononpsupplement = KURT;
					%else %if "&cononpsupplement" = "STD" 	%then %let cononpsupplement = STDDEV;
					%else %if "&cononpsupplement" = "PRT" 	%then %let cononpsupplement = PROBT;
					%else %if "&cononpsupplement" = "IQR" 	%then %let cononpsupplement = QRANGE;
			%end;
		%end;
	%end;
	%else %do;
		%let cononpmain = ;
		%let cononpsupplement = ;
	%end;	
	%*combine statitics from parametric and non-parametric list and remove redundant statistics;
	%if "&coplist.&cononplist." ^= "%str()" %then %do;
		%let temp1 = ;
		%let temp2 = ;
		%let Cstat = %upcase(&copmain &copsupplement &cononpmain &cononpsupplement);
		%*add N and Nmiss to stat list;
		%let Cstat = %UniqueandReduncant(str = &Cstat NMISS N);
		%let varcnt = %sysfunc(countw(&Cstat));
		%do i = 1 %to &varcnt;
			%if %sysfunc(indexw(&temp1,%scan(&Cstat, &i))) = 0 %then %do;
				%if "%scan(&Cstat, &i)" = "RANGE" 	%then %let temp2 = &temp2 MIN MAX;
					%else %if "%scan(&Cstat, &i)" = "QRANGE" 	%then %let temp2 = &temp2 Q1 Q3;
					%else %if "%scan(&Cstat, &i)" = "CLM" 	%then %let temp2 = &temp2 LCLM UCLM;
					%else %let temp2 = &temp2 %scan(&Cstat, &i);
				%let temp1 = &temp1 %scan(&Cstat, &i);
			%end;
		%end;
		%let statlist = &temp2;
	%end;
	%else %let statlist = ; 
	%*check the order information;
	%if "&outputorder" ^= "%str()" %then %do;
		%*remove redundancy;
		%let temp1 = %uniqueandreduncant(str = %upcase(&outputorder), out = 1);
		%let temp2 = %uniqueandreduncant(str = %upcase(&outputorder), out = 2); 
		%if "&temp2" ^= "%str()" %then %do;
			%put WARNING: redundancy found in output order list - &temp2;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
				dm "post 'WARNING: redundancy found in output order list - &temp2'";;
			%let outputorder = &temp1;
		%end;
		%*remove variable not in the variable lists;
		%let temp1 = %IfStr1inStr2(str1 = &outputorder, str2 = &calist &coplist &cononplist, out = 1);
		%let temp2 = %IfStr1inStr2(str1 = &outputorder, str2 = &calist &coplist &cononplist, out = 2);
		%if "&temp2" ^= "%str()" %then %do;
			%put WARNING: variable(s) in output order list but not in variable list - &temp2;
			%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
				dm "post 'WARNING: variable(s) in output order list but not in variable list - &temp2'";;
			%let outputorder = &temp1;
		%end; 
		%*remove variable name not in the data set;
		%if "&outputorder" ^= "%str()" %then %do;
			%let messenger = %IfStr1inStr2(str1 = &outputorder, str2 = &CVar, out = 2);
			%if "&messenger" ^= "%str()" %then %do;
				%put WARNING: variable(s) in outputorder not in data set &dsn - &messenger;
				%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
					dm "post 'WARNING: variable(s) in outputorder not in data set &dsn - &messenger'";;
				%let outputorder = %IfStr1inStr2(str1 = &outputorder, str2 = &CVar, out = 1);
			%end;			
			%*check categorical variable list;
			%if "&calist" ^= "%str()" %then %do;
				%let messenger = %IfStr1inStr2(str1 = &calist, str2 = &outputorder, out = 2);
				%if "&messenger" ^= "%str()" %then %do;
					%put WARNING: variable(s) in categorical list not in outputorder list - &messenger;
					%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
						dm "post 'variable(s) in categorical list not in outputorder list - &messenger'";;
				%end;
			%end;
			%*check parametric list;
			%if "&coplist" ^= "%str()" %then %do;
				%let messenger = %IfStr1inStr2(str1 = &coplist, str2 = &outputorder, out = 2);
				%if "&messenger" ^= "%str()" %then %do;
					%put WARNING: variable(s) in parametric list not in outputorder list - &messenger;
					%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
						dm "post 'variable(s) in parametric list not in outputorder list - &messenger'";;
				%end;
			%end;
			%*check non-parametric list;
			%if "&cononplist" ^= "%str()" %then %do;
				%let messenger = %IfStr1inStr2(str1 = &cononplist, str2 = &outputorder, out = 2);
				%if "&messenger" ^= "%str()" %then %do;
					%put WARNING: variable(s) in non-parametric list not in outputorder list - &messenger;
					%if "%upcase(%substr(&suppresswarning, 1, 1))" = "N" %then 
						dm "post 'variable(s) in non-parametric list not in outputorder list - &messenger'";;
				%end;
			%end;
			%*create dataset storing order information;
			%let temporder = %FindTMP;  
			%let varcnt = %sysfunc(countw(&outputorder));
			data &temporder;
				length varname $ 32;
				%do i = 1 %to &varcnt;
					varname = "%scan(&outputorder, &i)";
					order1  = &i;
					output;
				%end;
			run;
		%end;		
	%end; 
	%*prepare new dataset remove missing for group variable;
	%let tempdsn = %FindTMP;
	data &tempdsn;
		set &dsn;
		%if "&group" ^= "%str()" %then where not missing(&group);;
	run;
	%*check adjusted data set;
	%let cnt2 = 1;
	%if "&group" ^= "%str()" %then %do;
		%if %nobs(&tempdsn) = 0 %then %do;
			%let group = ;
			%let overall = yes;
			data &tempdsn;
				set &dsn;
			run;
			%put WARNING: group variable are all missing in the data set, data will not stratified on group variable;
			dm "post 'WARNING: group variable are all missing in the data set, data will not stratified on group variable'";
		%end;
		%else %do;
			proc sql noprint;
				select count(*)
					into :temp1
					from &dsn
					where missing(&group);
			quit;
			%let temp1 = &temp1;
			%if &temp1 > 0 %then %do;
				%put WARNING: value of group variable is missing for &temp1 observation(s);
				dm "post 'WARNING: value of group variable is missing for &temp1 observation(s)'";
			%end;
			*obtain the number of unique levels of group variable;			
			proc sql noprint;
		        select count(distinct &group)
		            into :cnt2
		            from &tempdsn;
		    quit;
            %*if group variable has only 1 level, output overall statistics;
			%if &cnt2 = 1 %then %do;
				%let group =;
				%let overall = yes;	
				%put WARNING: group variable only has one level, data will not stratified on group variable;
				dm "post 'WARNING: group variable only has one level, data will not stratified on group variable'";
			%end;	
		%end;
	%end;
	%*delete output dsn for new results;
	%DeleteData(dsn = &outdsn);
	%*obtain variable information;
	%let tempfmt = %FindTMP;
	proc contents data = &dsn out = &tempfmt(keep = name label format type rename = (type = ___type___));
		ods select none;
	run;
	data &tempfmt;
		length oriname $32;
		set &tempfmt;
		oriname = upcase(name);
		format = compress(format, ".");
		if missing(format) then format = "___";
			else if upcase(substr(format, 1, findc(format, "_$", "abi"))) in ("BEST" "$") then format = "___";
		%if "&group" ^= "%str()" %then %do;
			if oriname = upcase("&group") then do;
				if not missing(format) then call symputx("groupf", format);
					else call symputx("groupf", "___");
				call symputx("grouplabel", label);
			end;
		%end;
	run;
	%*analyses for contunous variable;
	%*check if all continuous variable are numeric;
	%let messenger = ;
	%if "&coplist.&cononplist." ^= "%str()" %then %do;
		proc sort data = &tempfmt out = &tempfmt;
			by oriname;
		run;
		%*create data set store variable information;
		%if "&coplist" ^= "%str()" %then %do;
			%let varlist = &coplist;
			%let temp1 = %FindTMP;
			%let i = 1;
			%let CVar = %qscan(&varlist, &i);
			data &temp1;
				length varname $ 32 oriname $32;;
				%do %while(&CVar ^= %str());
					varname = "___var___&i";
					oriname = "&CVar";
					order2 = &i;
					order1 = &coporder;
					%let i = %eval(&i + 1);
					%let CVar = %qscan(&varlist, &i);
					output;	
				%end;
			run;			
			%*combine information;		
			proc sort data = &temp1 out = &temp1;
				by oriname;
			run;			
			data &temp1;
				merge &temp1(in = in1) &tempfmt;
				by oriname;				
				if in1;
			run;
			proc sql noprint;
				select name
					into :messenger separated by " "
					from &temp1
					where ___type___ ^= 1;
			quit;
			%if "&messenger" ^= "%str()" %then %do;
				%put ERROR: parametric continuous variable(s), &messenger, not numeric;
				dm "post 'ERROR: parametric continuous variable(s), &messenger, not numeric'";
				%DeleteData(dsn = &temporder);
				%DeleteData(dsn = &tempdsn);
				%DeleteData(dsn = &tempfmt);
				%DeleteData(dsn = &temp1);
				option source notes &moptions orientation = &orientation_setup; 
				%return;
			%end;
		%end; 
		%if "&cononplist" ^= "%str()" %then %do;
			%let varlist = &cononplist;
			%let temp2 = %FindTMP;
			%let i = 1;
			%let CVar = %qscan(&varlist, &i);
			data &temp2;
				length varname $ 32 oriname $32;;
				%do %while(&CVar ^= %str());
					varname = "___var___&i";
					oriname = upcase("&CVar");
					order2 = &i;
					order1 = &cononporder;
					%let i = %eval(&i + 1);
					%let CVar = %qscan(&varlist, &i);
					output;	
				%end;
			run;
			proc sort data = &temp2 out = &temp2;
				by oriname;
			run;
			
			data &temp2;
				merge &temp2(in = in1) &tempfmt;
				by oriname;
				if in1;
			run;
			proc sql noprint;
				select name
					into :messenger separated by " "
					from &temp2
					where ___type___ ^= 1;
			quit;
			%if "&messenger" ^= "%str()" %then %do;
				%put ERROR: non-prametric continuous variable(s), &messenger, not numeric;
				dm "post 'ERROR: non-parametric continuous variable(s), &messenger, not numeric'";
				%DeleteData(dsn = &temporder);
				%DeleteData(dsn = &tempdsn);
				%DeleteData(dsn = &tempfmt);
				%DeleteData(dsn = &temp1);
				%DeleteData(dsn = &temp2);
				option source notes &moptions orientation = &orientation_setup; 
				%return;
			%end;
		%end;
		%let tempinfo = %FindTMP;
		data &tempinfo;
			set %if "&coplist" 		^= "%str()" %then &temp1;
				%if "&cononplist" 	^= "%str()" %then &temp2;;
		run; 
		%DeleteData(dsn = &temp1);
		%*let temp1 = ;
		%DeleteData(dsn = &temp2);
		%*let temp2 = ; 
		%if "&coplist" ^= "%str()" %then %do;
			%put;
			%put analyzing continuous variable(s) using parametric test;
			proc sql noprint;
				select varname, 
					   oriname
					into :varlist separated by " ",
						 :orivarlist separated by " "
					from &tempinfo
					where order1 = &coporder
					order by order2;
			quit; 
			%*create a copy of original data set;
			%let i = 1;
			%let CVar = %qscan(&orivarlist, &i);
			data &tempdsn;
				set &dsn;
				rename 	%do %while(&CVar ^= %str());
							&CVar = %qscan(&varlist, &i)
							%let i = %eval(&i + 1);
							%let CVar = %qscan(&orivarlist, &i);	
						%end;;
				%if "&group" ^= "%str()" %then where not missing(&group);;
			run;
			%let temp1 = %FindTMP;
		    data &temp1;
		    run;
		    %let temp2 = %FindTMP;
		    data &temp2;
		    run;		
			%let copResult = %FindTMP;
			data &copResult;
			run;
			%let temp = %FindTMP;
			proc sql;
				create table &temp (varname char(32),
									___method___ char(15),
									pvalue num,
									order1 num
									);
			quit;
			*obtain summary statistics;
			proc means data = &tempdsn noprint;		
				%if "&group" ^= "%str()" %then class &group;;
				var &varlist;
				output out = &copResult(drop = _type_ _freq_) %let j = 1;
									 %let CVar = %qscan(&statlist, &j);
									 %do %while(&CVar ^= %str());
								     	&CVar.=
										%let j = %eval(&j + 1);
										%let CVar = %qscan(&statlist, &j);	
									 %end;
									 /autoname;
			run;
			data &copResult;
				length stattype $ 10 varname $ 32;
				set &copResult;
				order1 = &coporder;
				order = 0;
				%let k = 1;		
				%let CVar = %scan(&varlist, &k);
				%do %while(&CVar ^= %str());
					order + 1;	
					%let j = 1;
					%let Cstat = %scan(&statlist, &j);
					%do %while(&Cstat ^= %str());
						%if "&group" ^= "%str()" %then group = &group;;
						values = &CVar._&Cstat;
						varname = "&CVar";
						stattype = "_&Cstat";
						output;					
						%let j = %eval(&j + 1);
						%let Cstat = %scan(&statlist, &j);
					%end;
					%let k = %eval(&k + 1);
					%let CVar = %scan(&varlist, &k);
				%end;
			run; 
			proc sort data = &copResult;
				by order order1 varname %if &group ^= %str() %then &group;;
			run;
			proc transpose data = &copResult out = &temp1;
				var values;
				by order order1 varname %if &group ^= %str() %then &group;;
				id stattype;
			run;
			data &copResult;
				set &temp1 %if &group ^= %str() %then (where = (missing(&group)));;
				rename 	%let j = 1;
						%let Cstat = %scan(&statlist, &j);
						%do %while(&Cstat ^= %str());
							_&Cstat = &Cstat._all
							%let j = %eval(&j + 1);
							%let Cstat = %scan(&statlist, &j);
						%end;;
			run;
			%*if group varialbe is not missing and level is greater than 1, merge overall stats to each group level;
			%if "&group" ^= "%str()" %then %do;
				proc sort data = &copResult;
					by varname;
				run;
				proc sort data = &temp1 (where = (not missing(&group)));;
					by varname;
				run;
				data &copResult;
					merge &copResult(drop = &group) &temp1;
					by varname;
				run;
			%end;
			%if "%upcase(%substr(&notest, 1, 1))" = "Y" or &cnt2 <= 1 %then %do;
				proc sort data = &tempinfo;
					by varname;
				run;
				proc sort data = &copResult;
					by varname;
				run;
				data &copResult(drop = varname rename = (oriname = varname));
					merge &copResult &tempinfo(where = (order1 = &coporder));
					by varname;
				run;
				%DeleteData(dsn = &temp);
				%let temp = ;
				%DeleteData(dsn = &temp1);
				%let temp1 = ;
				%DeleteData(dsn = &temp2);
				%let temp2 = ;
				%goto skiptest1;
			%end;
		    %let i = 1;
		    %let CoVar = %qscan(&Varlist, &i);  
			ods select none;	
		    %do %while(&CoVar ^= %str());
				%put &i	- current variable is %qscan(&orivarlist, &i);
				%if %sysfunc(indexw(%upcase(&copexcludelist), %upcase(%qscan(&orivarlist, &i)))) > 0 %then %goto copnext;
				proc sql noprint;
			        select count(distinct &group)
			            into :cnt3
			            from &tempdsn
						where not missing(&group) and not missing(&CoVar);
			    quit;
				%if &cnt3 = 2 %then %do;
			        proc ttest data = &tempdsn(where = (not missing(&group) and not missing(&CoVar)));				
			            class &group;
			            var   &CoVar;
			            ods output equality = &temp1;
			            ods output ttests   = &temp2;
			        run;
			        data _NULL_;
			            set &temp1;
			            if ProbF > 0.05 then call symputx("Prob1", "Pooled");
			                else call symputx("Prob1", "Satterthwaite"); 
			        run;
			        data &temp2( rename = (probt = pvalue));
			            length varname $ 32 ___method___ $ 15;
						set &temp2(where = (Method = "&Prob1") drop = variable);
				        set &temp1(keep = Probf);
						___method___ = "&Prob1";
						varname = "&CoVar";
						order1 = &coporder;
						keep probt varname order1 ___method___;
			        run;		
			        proc append data = &temp2 base = &temp;
			        run; 
				%end;
				%else %if &cnt3 > 2 %then %do;
					proc glm data = &tempdsn;				
			            class &group;
			            model &CoVar = &group;
			            ods output OverallANOVA = &temp1(where = (Source = "Model"));
			        run;		
			        data &temp1(rename = (probf = pvalue));
			            length varname $ 32 ___method___ $15;
				        set &temp1(keep = Probf);
						varname = "&CoVar";
						order1 = &coporder;
			        run; 				
			        proc append data = &temp1 base = &temp;
			        run;
				%end;
				%copnext:
		        %let i = %eval(&i + 1);
		        %let CoVar = %qscan(&Varlist, &i);
		    %end;
			%if %sysfunc(exist(&temp)) %then %do;
				proc sort data = &temp;
					by varname;
				run;
				%let temp3 = %FindTMP;
				proc sort data = &tempinfo(where = (order1 = &coporder)) out = &temp3;
					by varname;
				run;
				data &copresult;
					merge &copresult &temp &temp3;
					by varname;
				run;
			%end;
			%else %do;
				%let temp3 = %FindTMP;
				proc sort data = &tempinfo(where = (order1 = &coporder)) out = &temp3;
					by varname;
				run;
				data &copresult;
					merge &copresult &temp3;
					by varname;
				run;
			%end;
		%end;
		%DeleteData(dsn = &temp);
		%let temp = ;
		%DeleteData(dsn = &temp1);
		%let temp1 = ;
		%DeleteData(dsn = &temp2);
		%let temp2 = ;
		%DeleteData(dsn = &temp3);	
		%let temp3 = ;	
	%skiptest1: 
		%if "&cononplist" ^= "%str()" %then %do;
			%put;
			%put analyzing continuous variable(s) using non-parametric test;
			proc sql noprint;
				select varname, 
					   oriname
					into :varlist separated by " ",
						 :orivarlist separated by " "
					from &tempinfo
					where order1 = &cononporder
					order by order2;
			quit; 
			%*create a copy of original data set;
			%let i = 1;
			%let CVar = %qscan(&orivarlist, &i);
			data &tempdsn;
				set &dsn;
				rename 	%do %while(&CVar ^= %str());
							&CVar = %qscan(&varlist, &i)
							%let i = %eval(&i + 1);
							%let CVar = %qscan(&orivarlist, &i);	
						%end;;
				%if "&group" ^= "%str()" %then where not missing(&group);;
			run;
			%let temp1 = %FindTMP;
		    data &temp1;
		    run;
		    %let temp2 = %FindTMP;
		    data &temp2;
		    run;		
			%let cononpResult = %FindTMP;
			data &cononpResult;
			run;
			%let temp = %FindTMP;
			*obtain summary statistics;
			proc means data = &tempdsn noprint;		
				%if &cnt2 > 1 %then class &group;;
				var &varlist;
				output out = &cononpResult(drop = _type_ _freq_) %let j = 1;
									 %let CVar = %qscan(&statlist, &j);
									 %do %while(&CVar ^= %str());
								     	&CVar.=
										%let j = %eval(&j + 1);
										%let CVar = %qscan(&statlist, &j);	
									 %end;
									 /autoname;
			run;
			data &cononpResult;
				length stattype $ 10 varname $ 32;
				set &cononpResult;
				order1 = &cononporder;
				order = 0;
				%let k = 1;		
				%let CVar = %scan(&varlist, &k);
				%do %while(&CVar ^= %str());
					order + 1;	
					%let j = 1;
					%let Cstat = %scan(&statlist, &j);
					%do %while(&Cstat ^= %str());
						%if &group ^= %str() %then group = &group;;
						values = &CVar._&Cstat;
						varname = "&CVar";
						stattype = "_&Cstat";
						output;					
						%let j = %eval(&j + 1);
						%let Cstat = %scan(&statlist, &j);
					%end;
					%let k = %eval(&k + 1);
					%let CVar = %scan(&varlist, &k);
				%end;
			run;
			proc sort data = &cononpResult;
				by order order1 varname %if &group ^= %str() %then &group;;
			run;
			proc transpose data = &cononpResult out = &temp1;
				var values;
				by order order1 varname %if &group ^= %str() %then &group;;
				id stattype;
			run;
			data &cononpResult;
				set &temp1 %if &group ^= %str() %then (where = (missing(&group)));;
				rename 	%let j = 1;
						%let Cstat = %scan(&statlist, &j);
						%do %while(&Cstat ^= %str());
							_&Cstat = &Cstat._all
							%let j = %eval(&j + 1);
							%let Cstat = %scan(&statlist, &j);
						%end;;
			run;
			%*if group varialbe is not missing and level is greater than 1, merge overall stats to each group level;
			%if &cnt2 >= 2 %then %do;
				proc sort data = &cononpResult;
					by varname;
				run;
				proc sort data = &temp1 (where = (not missing(&group)));;
					by varname;
				run;
				data &cononpResult;
					merge &cononpResult(drop = &group) &temp1;
					by varname;
				run;
			%end;
			%if "%upcase(%substr(&notest, 1, 1))" = "Y" or &cnt2 <= 1 %then %do;
				proc sort data = &tempinfo;
					by varname;
				run;
				proc sort data = &cononpResult;
					by varname;
				run;
				data &cononpResult(drop = varname rename = (oriname = varname));
					merge &cononpResult &tempinfo(where = (order1 = &cononporder));
					by varname;
				run;
				%DeleteData(dsn = &temp);
				%let temp = ;
				%DeleteData(dsn = &temp1);
				%let temp1 = ;
				%DeleteData(dsn = &temp2);
				%let temp2 = ;
				%goto skiptest2;
			%end;
		    %let i = 1;
		    %let CoVar = %qscan(&Varlist, &i);  
			%let messenger = 0;
			ods select none;
		    %do %while(&CoVar ^= %str());
				%put &i	- current variable is %qscan(&orivarlist, &i);
				%if %sysfunc(indexw(%upcase(&cononpexcludelist), %upcase(%qscan(&orivarlist, &i)))) > 0 %then %goto cononpnext;
				proc sql noprint;
			        select count(distinct &group), count(distinct &CoVar)
			            into :cnt3, :cnt4
			            from &tempdsn
						where not missing(&group) and not missing(&CoVar);
			    quit;
				%if &cnt3 = 2 and &cnt4 > &cnt3 %then %do;
			        proc npar1way data = &tempdsn(where = (not missing(&group) and not missing(&CoVar))) wilcoxon;
		                class &group;
		                var   &CoVar;
		                ods output WilcoxonTest = &temp1(where = (name1 = "P2_WIL"));
		            run;
		            data &temp2(drop = nvalue1);
		                length varname $ 32;
		                set &temp1(keep = nvalue1);
		                pvalue = nvalue1;
		                varname = "&CoVar";
						order1 = &cononporder;
		            run;
		            proc append data = &temp2 base = &temp;
		            run;
				%end;
				%else %if &cnt3 > 2 and &cnt4 > &cnt3 %then %do;
					proc npar1way data = &tempdsn(where = (not missing(&group) and not missing(&CoVar))) wilcoxon;
		                class &group;
		                var   &CoVar;
		                ods output KruskalWallisTest = &temp1(where = (name1 = "P_KW"));
		            run;
		            data &temp2(drop = nvalue1);
		                length varname $ 32;
		                set &temp1(keep = nvalue1);
		                pvalue = nvalue1;
		                varname = "&CoVar";
						order1 = &cononporder;
		            run;
		            proc append data = &temp2 base = &temp;
		            run;
				%end;
				%cononpnext:
		        %let i = %eval(&i + 1);
		        %let CoVar = %qscan(&Varlist, &i);
		    %end;
			%if %sysfunc(exist(&temp)) %then %do;
				proc sort data = &temp;
					by varname;
				run;
				%let temp3 = %FindTMP;
				proc sort data = &tempinfo(where = (order1 = &cononporder)) out = &temp3;
					by varname;
				run;
				data &cononpresult;
					merge &cononpresult &temp &temp3;
					by varname;
				run;
			%end;
			%else %do;
				%let temp3 = %FindTMP;
				proc sort data = &tempinfo(where = (order1 = &cononporder)) out = &temp3;
					by varname;
				run;
				data &cononpresult;
					merge &cononpresult &temp3;
					by varname;
				run;
			%end;
		%end;
		%DeleteData(dsn = &temp);
		%let temp = ;
		%DeleteData(dsn = &temp1);
		%let temp1 = ;
		%DeleteData(dsn = &temp2);
		%let temp2 = ;
		%DeleteData(dsn = &temp3);	
		%let temp3 = ;
	%skiptest2: 
		%let coResult = %FindTMP;
		data &coResult;
			set %if "&coplist"      ^= "%str()" %then &copresult;
				%if "&cononpresult" ^= "%str()" %then &cononpresult;;
		run;
		%DeleteData(dsn = &copresult);
		%let copresult = ;
		%DeleteData(dsn = &cononpresult);
		%let cononpresult = ;
		proc format;	
			picture num1f(round)  	low - <0 = "000000009.0" (mult = 10 prefix = "-")
									0 - high = "000000009.0" (mult = 10)
									other = "NA";
			picture num2f(round)  	low - <0 = "000000009.00" (mult = 100 prefix = "-")
									0 - high = "000000009.00" (mult = 100)
									other = "NA";
			picture num3f(round)  	low - <0 = "000000009.000" (mult = 1000 prefix = "-")
									0 - high = "000000009.000" (mult = 1000)
									other = "NA";
			picture num4f(round)  	low - <0 = "000000009.0000" (mult = 10000 prefix = "-")
									0 - high = "000000009.0000" (mult = 10000)
									other = "NA";
			picture num5f(round)  	low - <0 = "000000009.00000" (mult = 100000 prefix = "-")
									0 - high = "000000009.00000" (mult = 100000)
									other = "NA";
			picture num0f(round)  	low - <0 = "000000009" (mult = 1 prefix = "-")
									0 - high = "000000009" (mult = 1)
									other = "NA";
		run;
		%if &copdec = 5 %then %let copf = num&copdec.f;
			%else %if &copdec = 4 %then %let copf = num&copdec.f;
			%else %if &copdec = 3 %then %let copf = num&copdec.f;
			%else %if &copdec = 2 %then %let copf = num&copdec.f;
			%else %if &copdec = 0 %then %let copf = num&copdec.f;
			%else %let copf = num1f;
		%if &cononpdec = 5 %then %let cononpf = num&cononpdec.f;
			%else %if &cononpdec = 4 %then %let cononpf = num&cononpdec.f;
			%else %if &cononpdec = 3 %then %let cononpf = num&cononpdec.f;
			%else %if &cononpdec = 2 %then %let cononpf = num&cononpdec.f;
			%else %if &cononpdec = 0 %then %let cononpf = num&cononpdec.f;
			%else %let cononpf = num1f; 
        proc sort data = &coResult;
            by order1 order2;
        run; 
		data &coResult;
			length _value_by_group_ $ 200 ___group1 $ 256 ___group2 $ 256;
			set &coResult;
			if order1 = &coporder then do;
				___group1 = coalescec(label, name);				
				%if "%upcase(%substr(&copincludemissing, 1, 1))" = "Y" %then %do;
					___group2 = "N (N Missing)";
					order3 = &missingtop;
					_value_by_group_ = strip(put(_n, best.)) || " (" ||
									   strip(put(_nmiss, best.)) || ")";
					output;
				%end; 	
				%else %do;
					if _n = 0 or n_all = 0 then do;
						___group2 = "N (N Missing)";
						order3 = &missingtop;
						_value_by_group_ = strip(put(_n, best.)) || " (" ||
										   strip(put(_nmiss, best.)) || ")";
						output;
					end;
				%end;	
				order3 = 2;
				if _n > 0 or n_all > 0 then do;
					%if "&copmain" = "RANGE" %then %do;
						_value_by_group_ = strip(put(_min, &copf..)) || " " || byte(150) || " " ||
										   strip(put(_max, &copf..));
						___group2 = "Range";
					%end;
						%else %if "&copmain" = "QRANGE" %then %do;
							_value_by_group_ = strip(put(_Q1, &copf..)) || " " || byte(150) || " " ||
											   strip(put(_Q3, &copf..));
							___group2 = "IQR";
						%end;
						%else %if "&copmain" = "CLM" %then %do;
							_value_by_group_ = strip(put(_LCLM, &copf..)) || " " || byte(150) || " " ||
											   strip(put(_UCLM, &copf..));
							___group2 = "95% CL";
						%end;
						%else %do;
							_value_by_group_ = strip(put(_&copmain, &copf..));
							___group2 = strip(propcase("&copmain"));
						%end;
					%if "&copsupplement" ^= "%str()" %then %do;
						%if "&copsupplement" = "RANGE" %then %do;
							_value_by_group_ = strip(_value_by_group_) || " (" || 
											  	strip(put(_min, &copf..)) || " " || byte(150) || " " ||
											  	strip(put(_max, &copf..)) || ")";
							___group2 = strip(___group2) || " (" || "Range" || ")";
						%end;
							%else %if "&copsupplement" = "QRANGE" %then %do;
								_value_by_group_ = strip(_value_by_group_) || " (" || 
													  strip(put(_Q1, &copf..)) || " " || byte(150) || " " ||
													  strip(put(_Q3, &copf..)) || ")";
								___group2 = strip(___group2) || " (" || "IQR" || ")";
							%end;
							%else %if "&copsupplement" = "CLM" %then %do;
								_value_by_group_ = strip(_value_by_group_) || " (" || 
													  strip(put(_LCLM, &copf..)) || " " || byte(150) || " " ||
													  strip(put(_UCLM, &copf..)) || ")";
								___group2 = strip(___group2) || " (" || "95% CL" || ")";
							%end;
							%else %do;
								_value_by_group_ = strip(_value_by_group_) || " (" || strip(put(_&copsupplement, &copf..)) || ")";
								___group2 = strip(___group2) || " (" || strip(propcase("&copsupplement")) || ")";
							%end;
					%end;
				output;
				end;
			end;
			if order1 = &cononporder then do;
				___group1 = coalescec(label, name);				
				%if "%upcase(%substr(&cononpincludemissing, 1, 1))" = "Y" %then %do;
					___group2 = "N (N Missing)";
					order3 = &missingtop;
					_value_by_group_ = strip(put(_n, best.)) || " (" ||
									   strip(put(_nmiss, best.)) || ")";
					output;
				%end;
				%else %do;
					if (_n = 0 or n_all = 0) and indexw("%upcase(&coplist)", upcase(name)) = 0 then do;
						___group2 = "N (N Missing)";
						order3 = &missingtop;
						_value_by_group_ = strip(put(_n, best.)) || " (" ||
										   strip(put(_nmiss, best.)) || ")";
						output;
					end;
				%end;	
				order3 = 2;
				if _n > 0 or n_all > 0 then do;
					%if "&cononpmain" = "RANGE" %then %do;
						_value_by_group_ = strip(put(_min, &cononpf..)) || " " || byte(150) || " " ||
										   strip(put(_max, &cononpf..));
						___group2 = "Range";
					%end;
						%else %if "&cononpmain" = "QRANGE" %then %do;
							_value_by_group_ = strip(put(_Q1, &cononpf..)) || " " || byte(150) || " " ||
											   strip(put(_Q3, &cononpf..));
							___group2 = "IQR";
						%end;
						%else %if "&cononpmain" = "CLM" %then %do;
							_value_by_group_ = strip(put(_LCLM, &cononpf..)) || " " || byte(150) || " " ||
											   strip(put(_UCLM, &cononpf..));
							___group2 = "95% CL";
						%end;
						%else %do;
							_value_by_group_ = strip(put(_&cononpmain, &cononpf..));
							___group2 = strip(propcase("&cononpmain"));
						%end;
					%if "&cononpsupplement" ^= "%str()" %then %do;
						%if "&cononpsupplement" = "RANGE" %then %do;
							_value_by_group_ = strip(_value_by_group_) || " (" || 
											  	strip(put(_min, &cononpf..)) || " " || byte(150) || " " ||
											  	strip(put(_max, &cononpf..)) || ")";
							___group2 = strip(___group2) || " (" || "Range" || ")";
						%end;
							%else %if "&cononpsupplement" = "QRANGE" %then %do;
								_value_by_group_ = strip(_value_by_group_) || " (" || 
													  strip(put(_Q1, &cononpf..)) || " " || byte(150) || " " ||
													  strip(put(_Q3, &cononpf..)) || ")";
								___group2 = strip(___group2) || " (" || "IQR" || ")";
							%end;
							%else %if "&cononpsupplement" = "CLM" %then %do;
								_value_by_group_ = strip(_value_by_group_) || " (" || 
													  strip(put(_LCLM, &cononpf..)) || " " || byte(150) || " " ||
													  strip(put(_UCLM, &cononpf..)) || ")";
								___group2 = strip(___group2) || " (" || "95% CL" || ")";
							%end;
							%else %do;
								_value_by_group_ = strip(_value_by_group_) || " (" || strip(put(_&cononpsupplement, &cononpf..)) || ")";
								___group2 = strip(___group2) || " (" || strip(propcase("&cononpsupplement")) || ")";
							%end;
					%end;
				output;
				end;
			end;
		run;  
	%end; 
	%if "&calist" ^= "%str()" %then %do;
		%put;
		%put analyzing categorical variable(s);
		data &tempdsn;
			set &dsn;
			%if &group ^= %str() %then where not missing(&group);;
		run;
		%let i = 1;
		%let CVar = %qscan(&calist, &i);
		%if "&tempinfo" = "%str()" %then %let tempinfo = %FindTMP;
		data &tempinfo;
			length varname $ 32;
			%do %while(&CVar ^= %str());
				varname	= upcase("&CVar");
				order2 = &i;
				order1 = 3;	
				%let i = %eval(&i + 1);
				%let CVar = %qscan(&calist, &i);
				output;	
			%end;
		run;
		data &tempfmt(rename = (format = fmtname name = varname));
			set &tempfmt;
			oriname = name;
			name	= upcase(name);
		run;	
		proc sort data = &tempinfo out = &tempinfo;
			by varname;
		run;
		proc sort data = &tempfmt out = &tempfmt;
			by varname;
		run;
		data &tempinfo;
			merge &tempinfo(in = in1) &tempfmt;
			by varname;
			if in1;
		run;
		proc sort data = &tempinfo out = &tempinfo;
			by order2;
		run;
		proc sql noprint;
			select varname, fmtname
				into :varlist separated by " ",
					 :fmtlist separated by " "
				from &tempinfo;
		quit;
		%DeleteData(dsn = &temp1);
		%let temp1 = ;
		%DeleteData(dsn = &temp2);
		%let temp2 = ;
		%*prepare temporary dataset for output;
	    %let temp1 = %FindTMP;
	    data &temp1;
	    run;
	    %let temp2 = %FindTMP;
	    data &temp2;
	    run;
	    %let temp3 = %FindTMP;
	    data &temp3;
	    run;
		%let temp4 = %FindTMP;
	    data &temp4;
	    run;
		%let temp5 = %FindTMP;
	    data &temp5;
	    run;
		%let caResult = %FindTMP;
	    %let i = 1;
		%let CVar = %qscan(&VarList, &i, %str( ));
		%let Cfmt = %scan(&fmtlist, &i, %str( ));
		%do %while(&CVar ^= %str());
			%if "&Cfmt" = "___" %then %let tempvarinfo = no format; 
				%else %let tempvarinfo = format is &Cfmt;;
			%let tempvarinfo = &i - current var is &CVar, &tempvarinfo; 
	        %put &tempvarinfo;
			
			%let missingonly1 = %FindTMP;
			data &missingonly1;
				set &tempdsn(where = (not missing(&CVar)));
			run; 
			%if %nobs(&missingonly1.) = 0 %then %let missingonly2 = Yes;
				%else %let missingonly2 = No;
			%DeleteData(dsn = &missingonly1); 
	
			%if "%substr(%upcase(&missingonly2), 1, 1)" = "Y" %then %do;
				%let caincludemissing1 = &caincludemissing;
				%let caincludemissing = Yes;
			%end;

	        proc freq data = &tempdsn %if "&Cfmt" ^= "___" and "%upcase(%substr(&orderbyformat, 1, 1))" = "Y" %then order = formatted; %else order = internal;;
	            table &Cvar %if %upcase(%substr(%left(&caincludemissing), 1, 1)) = Y %then / missing;;
	            ods output OneWayFreqs = &temp1 (keep = &CVar Frequency Percent
	                                            rename = (&CVar = ___levels Frequency = Frequency2 Percent = Percent2)) ;
	            %if "&group" ^= "%str()" %then %do;
	                table &group*&CVar / nopercent expected %if %upcase(%substr(%left(&caincludemissing), 1,1)) = Y %then missing;;            
	                ods output CrossTabFreqs = &temp2 (keep = &group &CVar Frequency RowPercent Expected Colpercent _type_
	                                                  rename = (RowPercent = Percent1 Frequency = Frequency1 &CVar = ___levels)
	                                                  where = (_type_ = "11"));
	            %end;
				%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
	        run;  
			
			%DeleteData(dsn = &missingonly1);
			%if "%substr(%upcase(&missingpercent), 1, 1)" = "N" and "%substr(%upcase(&missingonly2), 1, 1)" = "N" %then %do;
				proc freq data = &tempdsn %if "&Cfmt" ^= "___" and "%upcase(%substr(&orderbyformat, 1, 1))" = "Y" %then order = formatted; %else order = internal;;
		            table &Cvar ;
		            ods output OneWayFreqs = &temp4 (keep = &CVar Frequency Percent
		                                            rename = (&CVar = ___levels Frequency = Frequency2 Percent = Percent2)) ;
		            %if "&group" ^= "%str()" %then %do;
		                table &group*&CVar / nopercent expected;            
		                ods output CrossTabFreqs = &temp5 (keep = &group &CVar Frequency RowPercent Expected Colpercent _type_
		                                                  rename = (RowPercent = Percent1 Frequency = Frequency1 &CVar = ___levels)
		                                                  where = (_type_ = "11"));
		            %end;
					%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
		        run; 
				data &temp1;
					set &temp1(where = (missing(___levels))) &temp4;
				run; 
				%if "&group" ^= "%str()" %then %do;
					data &temp2;
						set &temp2(where = (missing(___levels))) &temp5;
					run; 
				%end;
			%end;   
			%if "%upcase(%substr(&notest,1,1))" ^= "Y" and "%substr(%upcase(&missingonly2), 1, 1)" = "N" %then %do;
		        %if "&group" ^= "%str()" %then %do;
					%if %upcase(%substr(%left(&caincludemissing), 1,1)) = Y %then %do;
						proc freq data = &tempdsn %if "&Cfmt" ^= "___" and "%upcase(%substr(&orderbyformat, 1, 1))" = "Y" %then order = formatted; %else order = internal;;
			                table &group*&CVar / nopercent expected;            
			                ods output CrossTabFreqs = &temp5 (keep = &group &CVar Frequency RowPercent Expected Colpercent _type_
			                                                  rename = (RowPercent = Percent1 Frequency = Frequency1 &CVar = ___levels)
			                                                  where = (_type_ = "11"));
							%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
				        run; 
						data &temp2;
							set &temp2(where = (missing(___levels))) &temp5;
						run; 
					%end;
		            proc sql noprint;
		                select count(distinct ___levels), count(distinct &group)
		                    into :cnt1, :cnt2
		                    from &temp2;
		            quit;
					%*calculate the maximum number of cell of which the expected frequency is less than 5,
					  if it is less than 20% (default) of the total, chi-squre test, otherwise fisher exaxt test;
		            %let limit = %sysevalf(&cnt1*&cnt2*&ERatio, ceil);
		        %end;
			%end; 
			%if "&Cfmt" ^= "___" and "%upcase(%substr(&orderbyformat, 1, 1))" = "Y" %then %do;
				data &temp1;
					set &temp1;
					___level_order___ = _n_;
				run;
			%end;
		    proc sort data = &temp1;
		        by ___levels;
		    run;
	        %if "&group" ^= "%str()" %then %do;
	            proc sort data = &temp2;
	                by ___levels;
	            run;			
	            data &temp1;
	                merge &temp1 &temp2;
	                by ___levels;
	            run;   
	            %if "%upcase(%substr(&notest,1,1))" ^= "Y" %then %let TestType = ChiSquare;		
	            data &temp1(drop = ___levels);
	                length ___group2 $256 ___group1 $32;
	                set &temp1;
					percent2 = percent2 / 100;				
					percent1 = percent1 / 100;
					colpercent = colpercent / 100;
	                ___group1 = "&CVar";
					%if %sysfunc(indexw("&Cfmt", "___")) > 0 %then %do;
						if vtype(___levels) = "C" then	___group2 = ___levels;
						else do;
							if missing(___levels) then call missing(___group2);
								else ___group2 = putn(___levels, "best.");
						end;
					%end;
					%else %do;
						if vtype(___levels) = "C" then	___group2 = putc(___levels, "&Cfmt");
						else do;
							if missing(___levels) then call missing(___group2);
								else ___group2 = putn(___levels, "&Cfmt");
						end;
					%end;                
	            run; 
				*decide which test to use and do the test;
				proc sql noprint;
			        select count(distinct &group)
			            into :cnt3
			            from &tempdsn
						where not missing(&group) and not missing(&CVar);
			    quit;
				%if "%upcase(%substr(&notest, 1, 1))" ^= "Y" %then %do;
					data &temp2;
						set &temp2 end = last;
						if . < Expected < 5 and (not missing(___levels)) %if &group ^= %str() %then and (not missing(&group)); then number + 1;
		                if last then call symputx("NofL5E", number);
					run;
		            %if "%substr(%upcase(&missingonly2), 1, 1)" = "N" and %symexist(NofL5E) and %symexist(limit) %then %do;
						%if &NofL5E >= &limit %then %let TestType = Fisher;
					%end;
		            %if "&caexcludelist" ^= "%str()" %then %do;
						%*if variabel in exclude list or level of group or itself is less than 2, test does not run;
		                %if %sysfunc(indexw(%upcase(&caexcludelist), %upcase(&CVar))) > 0 or &cnt1 <= 1 or &cnt2 <= 1 or &cnt3 <= 1 %then %do;
		                    data &temp3;
		                        Prob = .;
		                        format Prob pvalue6.4;
		                    run;
		                %end;
		                %else %do;
		                    %if "&TestType" = "Fisher" %then %do;
								%let messenger = 1;
		                        proc freq data = &tempdsn;
		                            table &group*&CVar / fisher;
		                            ods output FishersExact = &temp3 (keep = Name1 nValue1
		                                                             where = (Name1 = "XP2_FISH")
		                                                             rename = (nValue1 = Prob));
									%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
		                        run;
		                    %end;
		                    %else %do;
		                        proc freq data = &tempdsn;
		                            table &group*&CVar / Chisq;
									%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
		                            ods output ChiSq = &temp3 (where = (Statistic = "Chi-Square") keep = Statistic Prob);
		                        run;
		                    %end;            
		                %end;
		            %end;
		            %else %do;
		                %if &cnt1 <= 1 or &cnt2 <= 1 or &cnt3 <= 1 %then %do;
		                    data &temp3;
		                        Prob = .;
		                        format Prob pvalue6.4;
		                    run;
		                %end;
		                %else %do; 
		                    %if "&TestType" = "Fisher" %then %do;
								%let messenger = 1;
		                        proc freq data = &tempdsn;
		                            table &group*&CVar / fisher;
		                            ods output FishersExact = &temp3 (keep = Name1 nValue1
		                                                             where = (Name1 = "XP2_FISH")
		                                                             rename = (nValue1 = Prob));
									%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
		                        run;
		                    %end;
		                    %else %do;
		                        proc freq data = &tempdsn;
		                            table &group*&CVar / Chisq;
									%if "&Cfmt" ^= "___" %then format &CVar &Cfmt..;;
		                            ods output ChiSq = &temp3 (where = (Statistic = "Chi-Square") keep = Statistic Prob);
		                        run;
		                    %end;            
		                %end;
		            %end;
		        %end;
			%end; 
            %if "&Cfmt" ^= "___" and "%upcase(%substr(&orderbyformat, 1, 1))" = "Y" %then %do;
				proc sort data = &temp1 out = &temp1;
					by ___level_order___;
				run;
			%end; 
			data &temp3 %if "&group" = "%str()" %then (drop = ___levels);;
				length ___group1 $ 32 ___group2 $ 256;
	            %if "&group" = "%str()" %then %do;
	                set &temp1;
					%if "%upcase(%substr(&caincludemissing, 1, 1))" = "Y" %then %do;
						if _n_ = 1 then do;
							if not missing(___levels) then call symputx("tempmissing", "1", "l");
								else call symputx("tempmissing", "0", "l");
						end;
					%end;
					percent2 = percent2/100;
					___group1 = "&CVar";	
					if missing(___levels) then ___group2 = "&missinglabel";
					else do;	
						%if %sysfunc(indexw("&Cfmt", "___")) > 0 %then %do;
							if vtype(___levels) = "C" then	___group2 = ___levels;
								else ___group2 = putn(___levels, "best.");
						%end;
						%else %do;
							if vtype(___levels) = "C" then ___group2 = putc(___levels, "&Cfmt");
								else ___group2 = putn(___levels, "&Cfmt");
						%end;
					end;
	            %end;
	            %else %do;
	                length temp $ 256 ___test___ $ 10;
	                set &temp1; 
					if missing(percent1) then percent1 = 0;
					if missing(colpercent) then colpercent = 0;
					%if "%upcase(%substr(&caincludemissing, 1, 1))" = "Y" %then %do;
						if _n_ = 1 then do;
							if not missing(___group2) then call symputx("tempmissing", "1", "L");
								else call symputx("tempmissing", "0", "L");
						end;
					%end; 
					if missing(___group2) then ___group2 = "&missinglabel";
					%if %upcase(%substr(&notest,1,1)) ^= Y %then %do;
						retain temp;
		                if _n_ = 1 then do;
		                    set &temp3 (keep = prob rename = (prob = prob1));
		                    temp = ___group2;
		                end;            
		                format prob  prob1 pvalue6.4;
		                if ___group2 = temp then prob = prob1;
		                ___test___ = "&TestType";
		                drop temp;
					%end;
	            %end;   
                %if "&Cfmt" ^= "___" and "%upcase(%substr(&orderbyformat, 1, 1))" = "Y" %then drop ___level_order___;;
	        run; 

			%if "%upcase(%substr(&caincludemissing, 1, 1))" = "Y" and &tempmissing = 1 %then %do;
				%let tempmissing = %FindTMP;				
				data &tempmissing (rename = (___group3 = ___group2));
					length ___group3 $ 256;
					set &temp3;	
					retain tempgroup;	
					if _n_ = 1 then tempgroup = ___group2;
					___group3 = "&missinglabel";
					frequency2 = 0;
					percent2 = 0;
					%if "&group" ^= "%str()" %then %do;
						frequency1 = 0;
						percent1 = 0;
						colpercent = 0;
					%end;
					if ___group2 = tempgroup then output;
					drop ___group2 tempgroup;
				run; 
				data &temp3;
					set &tempmissing &temp3(%if "&group" ^= "%str()" and "%substr(%upcase(&notest), 1, 1)" ^= "Y" %then drop = prob;);
				run; 
				%DeleteData(dsn = &tempmissing);
			%end;  
			%if "%substr(%upcase(&missingonly2), 1, 1)" = "Y" %then %let caincludemissing = &caincludemissing1;
			proc append base = &caResult data = &temp3;
	        run;        
	        %let i = %eval(&i + 1);
			%let CVar = %qscan(&VarList, &i, %str( ));
			%let Cfmt = %scan(&fmtlist, &i, %str( ));
	    %end;
		%DeleteData(dsn = &temp1);
		%DeleteData(dsn = &temp2);
		%DeleteData(dsn = &temp3);	
		%DeleteData(dsn = &temp4);
		%DeleteData(dsn = &temp5);		
		data &caResult;
			set &caResult;
			if ___group2 = "&missinglabel" then order3 = &missingtop;
				else order3 = 2;
			order5 = _n_;
		run;
		proc sort data = &caResult(rename = (___group1 = varname));
			by varname;
		run;
		proc sort data = &tempinfo(keep = varname oriname label order1 order2);
			by varname;
		run;
		data &caResult(drop = oriname label);
			length ___group1 $256;
			merge &caResult(in = in1) &tempinfo;
			by varname;
			___group1 = coalescec(label, oriname);;
			if in1;
		run;
	%end;  
	%*prepare dataset for report;
	%*prepare format;
	proc format;
		picture p1f(round) 	0.001 	- <0.05 	= "9.999" (mult = 1000)
						  	0.05 	- 1 		= "9.99" (mult = 100);
		value   pf         	0.001 	- 1 		= [p1f.]
							low		- <0.001   = "<0.001";
						  
		%if &cadec = 0 %then %do;
			picture percentf (round)  low - high = "009%" (mult = 100);
		%end;
		%else %if &cadec = 1 %then %do;
			picture percentf (round)  low - high = "009.9%" (mult = 1000);
		%end;
		%else %do;
			picture percentf (round)  low - high = "009.99%" (mult = 10000);
		%end;
	run;
	%if "&calist" ^= "%str()" and "&group" ^= "%str()" %then %do;
		%if "%upcase(%substr(&percenttype, 1, 1))" = "R" %then %let percenttype = ColPercent;
			%else %let percenttype = percent1;
	%end;
    %*obtain number of variable in the outputorder list;
	%if "&temporder" ^= "%str()" and %sysfunc(exist(&temporder)) = 1 %then %do;
		proc sql noprint;
			select count(*)
				into :len
				from &temporder;
		quit;
		%let len = &len;
	%end;
	%else %let len = 0;
    %*obtain maximum length of output for categorical variables, pad short output with paddingchar;
	%if  "&calist" ^= "%str()" %then %do;
		proc sql noprint;
			select max(length(strip(put(frequency2, best.)))),
			   max(length(strip(put(percent2, percentf.))))
	        into :frequencylen2,
			     :percentlen2
	        from &caResult;
		quit;
		%let frequencylen2 = &frequencylen2;
		%let percentlen2 = &percentlen2;
		%if "&group" ^= "%str()" %then %do;
			proc sql noprint;
				select max(length(strip(put(frequency1, best.)))),
					   max(length(strip(put(&percenttype, percentf.))))
		            into :frequencylen1,
					     :percentlen1
		            from &caResult;
				quit;
			%let frequencylen1 = &frequencylen1;
			%let percentlen1   = &percentlen1; 
		%end;			
	%end;
	%if "&group" ^= "%str()" %then %do;
		%let temp1 = %FindTMP;	
		proc sql noprint;
			create table &temp1 as 
				select &group, count(*) as ___ngroup___
					from &tempdsn
					group by &group;
		quit;			
	%end;
	proc sql noprint;
	select count(*) 
		into :temp2
		from &tempdsn;
	quit;	
	%let temp2 = &temp2;
	%deletedata(dsn = &tempdsn); 
	%if "&calist" ^= "%str()" %then %do;
		data &caResult;
			set &caResult;
			order4 = order1;
			order1 = order1 + &len;
			len3 = length(strip(put(frequency2, best.)));
			len4 = length(strip(put(percent2, percentf.)));
			%if "&group" ^= "%str()" %then %do;
				length _value_by_group_ $ 200;
				len1 = length(strip(put(frequency1, best.)));
				len2 = length(strip(put(&percenttype, percentf.)));
				___bygroup1___ = frequency1;
				___bygroup2___ = &percenttype;
				if len1 < &frequencylen1 then 
					_value_by_group_ =  "~{style [color = &bcolor]" || repeat("&paddingchar", &frequencylen1 - 1 - len1) || "}" || 
										strip(put(frequency1, best.));
					else _value_by_group_ = strip(put(frequency1, best.));
				%if "%substr(%upcase(&missingpercent), 1, 1)" = "N" %then %do;
					if ___group2 = "&missinglabel" then do;
						if len2 < &percentlen1 then
							_value_by_group_ = strip(_value_by_group_) || "~{style [color = &bcolor]" || " (" || 
		                                       repeat("&paddingchar", &percentlen1 - 1 - len2)  ||
											   strip(put(&percenttype, percentf.)) || ")" || "}"; 
							else _value_by_group_ = strip(_value_by_group_) || "~{style [color = &bcolor]" || " (" || strip(put(&percenttype, percentf.)) || ")" || "}";
						end;
					else do;
						if len2 < &percentlen1 then
							_value_by_group_ = strip(_value_by_group_) || " (" || "~{style [color = &bcolor]" ||
		                                       repeat("&paddingchar", &percentlen1 - 1 - len2) || "}" ||
											   strip(put(&percenttype, percentf.)) || ")"; 
							else _value_by_group_ = strip(_value_by_group_) || " (" || strip(put(&percenttype, percentf.)) || ")";
					end;
				%end;
				%else %do;
					if len2 < &percentlen1 then
						_value_by_group_ = strip(_value_by_group_) || " (" || "~{style [color = &bcolor]" ||
	                                       repeat("&paddingchar", &percentlen1 - 1 - len2) || "}" ||
										   strip(put(&percenttype, percentf.)) || ")"; 
						else _value_by_group_ = strip(_value_by_group_) || " (" || strip(put(&percenttype, percentf.)) || ")";
				%end;
			%end;			
			___all1___ = frequency2;
			___all2___ = percent2;		
		run; 
        %*add pvalue to top level of categorical variable;
        %if "%upcase(%substr(&missingtop, 1, 1))" ^= "Y" and "%upcase(%substr(&notest, 1, 1))" ^= "Y" and "&group" ^= "%str()" %then %do;
            data &tempinfo;
        		set &caResult(where = (not missing(prob1)));
        		keep ___group1 prob1;
        	run;
        	proc sort data = &tempinfo out = &tempinfo nodupkey;
        		by ___group1 prob1;
        	run;
        	proc sort data = &caResult out = &caResult;
        		by ___group1 order5;
        	run;
        	data &caResult;
        		merge &caResult(drop = prob1 prob) &tempinfo;
        		by ___group1;
        	run;
			proc sort data = &caResult;
				by order1 order2 order3 order5;
			run; 
    		data &caResult;
    			set &caResult;
    			by ___group1 ___group2 notsorted;
    			retain temp;
    			if first.___group1 then temp = ___group2;
    			if ___group2 = temp then prob = prob1;
    		run;
        %end;
	%end; 
	%if "&coplist.&cononplist." ^= "%str()" %then %do;
		%let len1 = 0;
		%let len2 = 0;
		%let len3 = 0;
		%let len4 = 0;
		data &coResult;
			length ___all1___ ___all2___ ___all3___ ___all4___ 8;
			set &coResult;
			varname = upcase(name);
			if order1 = &coporder then do;
				%if "%upcase(&copmain)" = "RANGE" %then %do;
					___all1___ = min_all;
					___all2___ = max_all;
					call symputx("len1", "1");
				%end;
				%else %if "%upcase(&copmain)" = "QRANGE" %then %do;
					___all1___ = Q1_all;
					___all2___ = Q3_all;
					call symputx("len1", "1");
				%end;
				%else %if "%upcase(&copmain)" = "CLM" %then %do;
					___all1___ = LCLM_all;
					___all2___ = UCLM_all;
					call symputx("len1", "1");
				%end;
				%else ___all1___ = &copmain._all;;
				%if "&copsupplement" ^= "%str()" %then %do;
					%if "%upcase(&copsupplement)" = "RANGE" %then %do;
						___all3___ = min_all;
						___all4___ = max_all;
						call symputx("len2", "1");
					%end;
					%else %if "%upcase(&copsupplement)" = "QRANGE" %then %do;
						___all3___ = Q1_all;
						___all4___ = Q3_all;
						call symputx("len2", "1");
					%end;
					%else %if "%upcase(&copsupplement)" = "CLM" %then %do;
						___all3___ = LCLM_all;
						___all4___ = UCLM_all;
						call symputx("len2", "1");
					%end;
					%else ___all3___ = &copsupplement._all;;
				%end;				
				if ___group2 = "N (N Missing)" then do;
					___all1___ = n_all;
					___all2___ = nmiss_all;
				end;
			end;
				else if order1 = &cononporder then do;
					%if "%upcase(&cononpmain)" = "RANGE" %then %do;
						___all1___ = min_all;
						___all2___ = max_all;
						call symputx("len3", "1");
					%end;
					%else %if "%upcase(&cononpmain)" = "QRANGE" %then %do;
						___all1___ = Q1_all;
						___all2___ = Q3_all;
						call symputx("len3", "1");
					%end;
					%else %if "%upcase(&cononpmain)" = "CLM" %then %do;
						___all1___ = LCLM_all;
						___all2___ = UCLM_all;
						call symputx("len3", "1");
					%end;
					%else ___all1___ = &cononpmain._all;;
					%if "&cononpsupplement" ^= "%str()" %then %do;
						%if "%upcase(&cononpsupplement)" = "RANGE" %then %do;
							___all3___ = min_all;
							___all4___ = max_all;
							call symputx("len4", "1");
						%end;
						%else %if "%upcase(&cononpsupplement)" = "QRANGE" %then %do;
							___all3___ = Q1_all;
							___all4___ = Q3_all;
							call symputx("len4", "1");
						%end;
						%else %if "%upcase(&cononpsupplement)" = "CLM" %then %do;
							___all3___ = LCLM_all;
							___all4___ = UCLM_all;
							call symputx("len4", "1");
						%end;
						%else ___all3___ = &cononpsupplement._all;;
					%end;
					if ___group2 = "N (N Missing)" then do;
						___all1___ = n_all;
						___all2___ = nmiss_all;
					end;
				end;
			order4 = order1;
			order1 = order1 + &len;
			order5 = _n_;
			___group2 = tranwrd(___group2, "Stddev", "SD");
		run;
	%end;  
	data &outdsn;
		length ___all1___ ___all2___ ___all3___ ___all4___ 8;
		___vl___ = 0;
		set %if "&coplist.&cononplist." ^= "%str()" %then &coResult
			%if "&calist" ^= "%str()" %then &caResult;;
		vtype = order4;
		if order4 = 3 then pvalue = prob;
			else if order4 in (1 2) then pvalue = pvalue;
		if ___group2 = "N (N Missing)" and order4 in (1 2) then do;
			vtype = 4;
		end;
	run;  
	%if "&group" ^= "%str()" %then %do;	
		proc sort data = &outdsn;
			by &group;
		run;
		proc sort data = &temp1;
			by &group;
		run;
		%let temp = ;
		%let temp3 = ;
        %*add sample size information;
		data &outdsn;
			length __report__group__ $ 100;
			merge &outdsn &temp1;			
			by &group;
			%if "&groupf" ^= "___" %then %do;
				if vtype(&group) = "N" then 
				 	__report__group__ = trim(putn(&group, "&groupf..")) || "/(N = " || strip(put(___ngroup___, best.)) || ")";
				else __report__group__ = trim(putc(&group, "&groupf..")) || "/(N = " || strip(put(___ngroup___, best.)) || ")";	
			%end;	
			%else %do;
				if vtype(&group) = "N" then
					__report__group__ = strip(putn(&group, "best.")) || "/(N = " || strip(put(___ngroup___, best.)) || ")";
				else __report__group__ = &group. || "/(N = " || strip(put(___ngroup___, best.)) || ")";
			%end;
			%if "&grouplabel" ^= "%str()" %then 
				label __report__group__ = "&grouplabel";
				%else label __report__group__ = "%sysfunc(propcase(&group))";
				;
			%if "%upcase(%substr(&labelvariable, 1, 1))" = "Y" %then %do;
				%if "&group" ^= "%str()" and "%upcase(%substr(&notest, 1, 1))" ^= "Y" %then %do;
					if upcase(___test___) = "FISHER" then do;
/*						___group1 = strip(___group1) || " ~{super ~{style [fontfamily = symbol]a}}";*/
						call symputx("temp", "1");
						___vl___ = 1;
					end;
					%if "&coplist" ^= "%str()" and &cnt2 = 2 %then %do;
						if ___method___ = "Satterthwaite" then do;
/*							___group1 = strip(___group1) || " ~{super ~{style [fontfamily = symbol] b}}";*/
							call symputx("temp3", "1");
							___vl___ = 10;
						end;						
					%end;
				%end;
			%end;
		run;
		%deletedata(dsn = &temp1);
	%end; 
	%*if list of variable order is provided, obtain information and adjust the order;
	%if "&temporder" ^= "%str()" and %sysfunc(exist(&temporder)) = 1 %then %do;
		proc sort data = &temporder;
			by varname;
		run;
		proc sort data = &outdsn;
			by varname;
		run; 
		data &outdsn;
			merge &outdsn %if "&coplist.&cononplist" ^= "%str()" %then (drop = order); 
					&temporder(rename = (order1 = order));
			by varname;
			order1 = coalesce(order, order1);
		run; 
	%end;  
	%let temp1 = %FindTMP; 
	proc sort data = &outdsn;
		by order1 order2 order3 order5;
	run;

    data &outdsn;
    	set &outdsn;
    	by ___group1 ___group2 notsorted;
        %if "%upcase(%substr(&pvaluetop, 1, 1))" ^= "Y" %then 
            if ___group2 = "N (N Missing)" and order4 in (1 2) then call missing(pvalue);;
    	if first.___group2 then _outorder_ + 1;
    run;

    %if "%upcase(%substr(&pvaluetop, 1, 1))" = "Y" %then %do;
        proc sort data = &outdsn;
            by order4 order1 order2 order5;
        run;
        data &outdsn;
        	set &outdsn;
        	by ___group1 ___group2 notsorted;
            if order4 in (1 2) then do; 
            	retain temp;
            	if first.___group1 and first.___group2 then temp = ___group2;
            	  else if temp ^= ___group2 then call missing(pvalue);
            end; 
        run;
        proc sort data = &outdsn;
    		by order1 order2 order3 order5;
    	run;
    %end; 
	%deletedata(dsn = &temp1);
	%deletedata(dsn = &coResult);
	%deletedata(dsn = &caResult);
	%deletedata(dsn = &tempfmt);
	%deletedata(dsn = &temporder);
	%deletedata(dsn = &tempinfo);
	%put;
	%put ********************Analysis   End********************;
	%put;
	%put *******************Creating  Report*******************;
	proc template;
		define style styles.Table1Style;
			parent = styles.journal;
			style fonts from fonts/
				'TitleFont' = ("<sans-serif>, Helvetica, Helv",2, italic);
			class UserText from Note / 
				font_size=10pt
		        foreground=black 
			    outputwidth=100%
				font_face = "Arial";
		end;
	run;
	ods select all; 
	ods escapechar = "~";	
	%if "%upcase(%substr(&reportinSAS, 1, 1))" = "N" %then %do;
		ods html select none;
	%end;
	%else %do;		
		title justify = center height = 14pt bold %if "&tabletitle" = "%str()" %then "Table1 - Variable Summary";
			%else "&tabletitle";;
		proc report data = &outdsn nowd spanrows 
		    style(report) = {just=center outputwidth=100% rules = groups frame = hsides font_face = "Arial"}
		    style(header) = {just = center vjust = center font_size = 12pt font_weight = bold backgroundcolor = &bcolor} 
		    style(column) = {just = center vjust = center font_size = 11pt backgroundcolor = &bcolor};
			column 	 ___group1 order4 ___vl___
					(%if "%upcase(%substr(&overall, 1, 1))" = "N" and "%upcase(%substr(&showtotalcount, 1, 1))" ^= "N" %then "N = &temp2"; %else ""; _outorder_ ___group2) 
					vtype  %if "&calist" ^= "%str()" %then len3 len4;
					%if "&group" ^= "%str()" %then %do;
						__report__group__,  _value_by_group_ 
					%end;
					(%if "%upcase(%substr(&showtotalcount, 1, 1))" ^= "N" %then "Total/(N = &temp2)"; %else "Total"; ___all1___ ___all2___ ___all3___ ___all4___ ___all___)
					%if "&group" ^= "%str()"  %then %do;
						("P Value" pvalue _prob_);
					%end;
					;
			define _outorder_ / group order = data noprint;
			define ___vl___ / analysis mean noprint;
			define ___group1 / "" group order = data noprint;
			define ___group2 /  "" group order = data style(column) = {just = left indent = 0.25in width = 
									%if "%upcase(%substr(&copincludemissing, 1, 1))" = "Y" or "%upcase(%substr(&cononpincludemissing, 1, 1))" = "Y"
										%then 2in; %else 1.5in;};
			define ___all___ / "" computed style(column) = {just = center vjust = center 
										%if "&paddingchar" = "%str( )" %then font_face = "Courier New";}
							   %if "%upcase(%substr(&overall, 1, 1))" = "N" %then noprint;;
			define ___all1___ /  analysis mean noprint;
			define ___all2___ /  analysis mean noprint;
			define ___all3___ /  analysis mean noprint;
			define ___all4___ /  analysis mean noprint;
			%if "&group" ^= "%str()" %then %do;			 
				define pvalue / "" analysis mean  format = pf. noprint;
				define _prob_ /"" computed style(column) = {width = 1in} %if "%upcase(%substr(&notest, 1, 1))" = "Y" %then noprint;
								  style(header) = {just = center};
			%end;
			define order4 / group noprint;
			define vtype / analysis mean noprint;
			%if "&calist" ^= "%str()" %then %do;
				define len3 / analysis mean noprint;
				define len4 / analysis mean noprint;
			%end;
			%if "&group" ^= "%str()" %then %do; 
				define __report__group__/ 	%if "%upcase(%substr(&showgroup, 1,1 ))" ^= "N" %then %do;
										  		%if "&grouplabel" ^= "%str()" %then "&grouplabel"; 
										  	%end;
											%else "";
											order = internal
										  across style = {borderbottomcolor = CX000001 borderbottomstyle = solid just = center}; 
				define _value_by_group_ / "" %if "&paddingchar" = "%str( )" %then style = {font_face = "Courier New"};;
			%end;
			%if "&group" ^= "%str()" %then %do;
				compute _prob_ / character length = 50;
					if missing(pvalue.mean) then _prob_ = "";
						else if pvalue.mean < 0.001 then _prob_ = strip(put(pvalue.mean, pf.)) || "~{super ***}";
						else if pvalue.mean < 0.01 then _prob_ = strip(put(pvalue.mean, pf.)) || "~{super **}";
						else if pvalue.mean < 0.05 then _prob_ = strip(put(pvalue.mean, pf.)) || "~{super *}~{style [color = &bcolor]*}";
						else _prob_ = strip(put(pvalue.mean, pf.));
				endcomp;
			%end;
			compute ___all___ / character length = 200;
				%if "&coplist" ^= "%str()" %then %do;
					%if "&copsupplement" = "%str()" %then %do;
						if vtype.mean = &coporder then do;					
							%if &len1 = 1 %then ___all___ = strip(putn(___all1___.mean, "&copf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&copf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&copf.."));
							;
						end;
					%end;
					%else %do;
						if vtype.mean = &coporder then do;					
							%if &len1 = 1 %then ___all___ = strip(putn(___all1___.mean, "&copf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&copf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&copf.."));
							;
							%if &len2 = 1 %then ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&copf..")) ||
													    " " || byte(150) || " " || strip(putn(___all4___.mean, "&copf..")) || ")";
								%else ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&copf..")) || ")";
							;
						end;
					%end;
				%end;
				%if "&cononplist" ^= "%str()" %then %do;
					%if "&cononpsupplement" = "%str()" %then %do;
						if vtype.mean = &cononporder then do;
							%if &len3 = 1 %then ___all___ = strip(putn(___all1___.mean, "&cononpf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&cononpf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&cononpf.."));
							;
						end;
					%end;
					%else %do;
						if vtype.mean = &cononporder then do;
							%if &len3 = 1 %then ___all___ = strip(putn(___all1___.mean, "&cononpf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&cononpf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&cononpf.."));
							;
							%if &len4 = 1 %then ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&cononpf..")) ||
													    " " || byte(150) || " " || strip(putn(___all4___.mean, "&cononpf..")) || ")";
								%else ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&cononpf..")) || ")";
							;
						end;
					%end;
				%end;
				%if "&calist" ^= "%str()" %then %do;
					if vtype.mean = 3 then do;
						if len3.mean < &frequencylen2 then
						___all___ = %if "&paddingchar" = "%str( )" %then %do;
										"~{nbspace " || strip(put(&frequencylen2 - len3.mean, best.)) || "}" ||
									%end;
									%else "~{style [color = &bcolor]" || repeat("&paddingchar", &frequencylen2 - 1 - len3.mean) || "}" ||;
									strip(put(___all1___.mean, best.)); 
						else ___all___ = strip(put(___all1___.mean, best.));
						%if "%substr(%upcase(&missingpercent), 1, 1)" ^= "N" %then %do;
							if len4 < &percentlen2 then
								___all___ = strip(___all___) || " (" ||
												   "~{style [color = &bcolor]" || repeat("&paddingchar", &percentlen2 - 1 - len4.mean) || "}"
												   || strip(put(___all2___.mean, percentf.)) || ")"; 
								else ___all___ = strip(___all___) || " (" || strip(put(___all2___.mean, percentf.)) || ")";
						%end;
						%else %do;
							if ___group2 = "&missinglabel" then do;
								if len4 < &percentlen2 then
									___all___ = strip(___all___) || "~{style [color = &bcolor]" || " (" ||
													   repeat("&paddingchar", &percentlen2 - 1 - len4.mean)
													   || strip(put(___all2___.mean, percentf.)) || ")" || "}"; 
									else ___all___ = strip(___all___) || "~{style [color = &bcolor]" || " (" || strip(put(___all2___.mean, percentf.)) || ")" || "}";
							end;
							else do;
								if len4 < &percentlen2 then
									___all___ = strip(___all___) || " (" ||
													   "~{style [color = &bcolor]" || repeat("&paddingchar", &percentlen2 - 1 - len4.mean) || "}"
													   || strip(put(___all2___.mean, percentf.)) || ")"; 
									else ___all___ = strip(___all___) || " (" || strip(put(___all2___.mean, percentf.)) || ")";
							end;
						%end;
					end;
				%end;
				if vtype.mean = 4 then ___all___ = put(___all1___.mean, best.) || " (" || strip(put(___all2___.mean, best.)) || ")";
			endcomp;
			compute before ___group1 / style = {just = left vjust = center bordertopstyle = solid bordertopwidth = 1px color = black
												font_size = 11pt font_weight = bold backgroundcolor = 
												%if "%upcase(%substr(&variableshading, 1, 1))" ^= "N" %then CXcccccc; %else &bcolor;};
				%if "%upcase(%substr(&labelvariable, 1, 1))" = "Y" %then %do;
					if ___vl___.mean = 1 then ___groupname = catx(" ", ___group1, "~{super ~{style [fontfamily = symbol]a}}");
						else if ___vl___.mean > 1 then ___groupname = catx(" ", ___group1, "~{super ~{style [fontfamily = symbol]b}}");
						else if ___vl___.mean = 0 then ___groupname = ___group1;
				%end;
				%else ___groupname = ___group1;;
				line ___groupname $200.;
		    endcomp;
		run;
	%end; 
	%if "%upcase(%substr(&creatertf, 1, 1))" ^= "N" %then %do;	
		%if "&group" ^= "%str()" %then %do;
			%if "&orientation" = "%str()" %then %let orientation = landscape; 
		%end;
		%else %let orientation = portrait;
		option orientation = &orientation;
		%if "&group" ^= "%str()" %then %do;
			proc sql noprint;;
				select count(distinct &group)
				into: cnt2
				from &outdsn;
			quit;
			%let cnt2 = &cnt2;
			%if "%upcase(&orientation)" = "LANDSCAPE" %then %let cellwidth = %sysevalf(4/&cnt2.);
				%else %if "%upcase(&orientation)" = "PORTRAIT" %then %let cellwidth = %sysevalf(3/&cnt2.);	
		%end;	
		ods html select none;
		ods rtf file = "&savefilename..rtf" style = Table1Style bodytitle;	
		title justify = center height = 14pt bold %if "&tabletitle" = "%str()" %then "Table1 - Variable Summary";
			%else "&tabletitle";;
		%if "&group" ^= "%str()" and "%upcase(%substr(&notest, 1, 1))" ^= "Y" %then %do;
			footnote justify = left height = 10pt bold "Note:";
			%if "%upcase(%substr(&labelvariable, 1, 1))" = "Y" %then %do;
			    %if &temp = 1 %then footnote2 justify = left height = 10pt "~{super  ~{style [fontfamily = symbol] a}} sparse table, Fisher Exact test for p value";;
				%if &temp3 = 1 %then %do;
					%if &temp = 1 %then
						footnote3 justify = left height = 10pt "~{super  ~{style [fontfamily = symbol] b}} non-equal variances, Satterthwaite method is applied to calculate adjusted DF";
					%else
						footnote2 justify = left height = 10pt "~{super  ~{style [fontfamily = symbol] b}} non-equal variances, Satterthwaite method is applied to calculate adjusted DF";;
				%end;
			%end;
			%if "&group" ^= "%str()" and "%upcase(%substr(&notest, 1, 1))" ^= "Y" %then %do;
				%if &temp = 1 and &temp3 = 1 %then %do;
					footnote4 justify = left height = 10pt "~{super   *} P value less than 0.05";
					footnote5 justify = left height = 10pt "~{super  **} P value less than 0.01";
					footnote6 justify = left height = 10pt "~{super ***} P value less than 0.001";
				%end;
				%else %if (&temp = 1 and &temp3 ^= 1) or (&temp ^= 1 and &temp3 = 1) %then %do;
					footnote3 justify = left height = 10pt "~{super   *} P value less than 0.05";
					footnote4 justify = left height = 10pt "~{super  **} P value less than 0.01";
					footnote5 justify = left height = 10pt "~{super ***} P value less than 0.001";
				%end;
				%else %do;
					footnote2 justify = left height = 10pt "~{super   *} P value less than 0.05";
					footnote3 justify = left height = 10pt "~{super  **} P value less than 0.01";
					footnote4 justify = left height = 10pt "~{super ***} P value less than 0.001";
				%end;
			%end;
		%end;
		proc report data = &outdsn nowd spanrows 
		    style(report) = {just=center outputwidth=100% rules = groups frame = hsides font_face = "Arial"}
		    style(header) = {just = center vjust = center font_size = 12pt font_weight = bold backgroundcolor = &bcolor} 
		    style(column) = {%if "%upcase(%substr(&compacttable, 1, 1))" = "Y" %then protectspecialchars = off pretext = '~R/RTF"\sa0\sb0 "'; 
							 just = center vjust = center font_size = 11pt backgroundcolor = &bcolor};
			column 	 ___group1 order4 ___vl___
					(%if "%upcase(%substr(&overall, 1, 1))" = "N" and "%upcase(%substr(&showtotalcount, 1, 1))" ^= "N" %then "N = &temp2"; %else ""; _outorder_ ___group2) 
					vtype  %if "&calist" ^= "%str()" %then len3 len4;
					%if "&group" ^= "%str()" %then %do;
						__report__group__,  _value_by_group_ 
					%end;
					(%if "%upcase(%substr(&showtotalcount, 1, 1))" ^= "N" %then "Total/(N = &temp2)"; %else "Total"; ___all1___ ___all2___ ___all3___ ___all4___ ___all___)
					%if "&group" ^= "%str()"  %then %do;
						("P Value" pvalue _prob_);
					%end;
					;
			define _outorder_ / group order = data noprint;
			define ___vl___ / analysis mean noprint;
			define ___group1 / "" group order = data noprint;
			define ___group2 /  "" group  style(column) = {just = left indent = 0.25in width =
									%if "%upcase(&orientation)" = "LANDSCAPE" %then 3in; %else 2in;};
			define ___all___ / "" computed style(column) = {just = center vjust = center %if "&group" ^= "%str()" %then width = &cellwidth.in;
										%if "&paddingchar" = "%str( )" %then font_face = "Simsun" asis = on;}
							   %if "%upcase(%substr(&overall, 1, 1))" = "N" %then noprint;;
			define ___all1___ /  analysis mean noprint;
			define ___all2___ /  analysis mean noprint;
			define ___all3___ /  analysis mean noprint;
			define ___all4___ /  analysis mean noprint;
			%if "&group" ^= "%str()" %then %do;			 
				define pvalue / "" analysis mean  format = pf. noprint;
				define _prob_ /"" computed style(column) = {width = 1in} %if "%upcase(%substr(&notest, 1, 1))" = "Y" %then noprint;
								  style(header) = {just = center};
			%end;
			define order4 / group noprint;
			define vtype / analysis mean noprint;
			%if "&calist" ^= "%str()" %then %do;
				define len3 / analysis mean noprint;
				define len4 / analysis mean noprint;
			%end;
			%if "&group" ^= "%str()" %then %do; 
				define __report__group__/ 	%if "%upcase(%substr(&showgroup, 1,1 ))" ^= "N" %then %do;
										  		%if "&grouplabel" ^= "%str()" %then "&grouplabel"; 
										  	%end;
											%else "";
											order = internal
										  across style = {borderbottomcolor = CX000001 borderbottomstyle = solid just = center}; 
				define _value_by_group_ / "" %if "&paddingchar" = "%str( )" %then style = {font_face = "Simsun" asis = on width = &cellwidth.in};
												%else style = {width = &cellwidth.in};;
			%end;
			%if "&group" ^= "%str()" %then %do;
				compute _prob_ / character length = 50;
					if missing(pvalue.mean) then _prob_ = "";
						else if pvalue.mean < 0.001 then _prob_ = strip(put(pvalue.mean, pf.)) || "~{super ***}";
						else if pvalue.mean < 0.01 then _prob_ = strip(put(pvalue.mean, pf.)) || "~{super **}";
						else if pvalue.mean < 0.05 then _prob_ = strip(put(pvalue.mean, pf.)) || "~{super *}~{style [color = &bcolor]*}";
						else _prob_ = strip(put(pvalue.mean, pf.));
				endcomp;
			%end;
			compute ___all___ / character length = 200 ;
				%if "&coplist" ^= "%str()" %then %do;
					%if "&copsupplement" = "%str()" %then %do;
						if vtype.mean = &coporder then do;					
							%if &len1 = 1 %then ___all___ = strip(putn(___all1___.mean, "&copf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&copf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&copf.."));
							;
						end;
					%end;
					%else %do;
						if vtype.mean = &coporder then do;					
							%if &len1 = 1 %then ___all___ = strip(putn(___all1___.mean, "&copf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&copf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&copf.."));
							;
							%if &len2 = 1 %then ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&copf..")) ||
													    " " || byte(150) || " " || strip(putn(___all4___.mean, "&copf..")) || ")";
								%else ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&copf..")) || ")";
							;
						end;
					%end;
				%end;
				%if "&cononplist" ^= "%str()" %then %do;
					%if "&cononpsupplement" = "%str()" %then %do;
						if vtype.mean = &cononporder then do;
							%if &len3 = 1 %then ___all___ = strip(putn(___all1___.mean, "&cononpf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&cononpf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&cononpf.."));
							;
						end;
					%end;
					%else %do;
						if vtype.mean = &cononporder then do;
							%if &len3 = 1 %then ___all___ = strip(putn(___all1___.mean, "&cononpf..")) ||
													    " " || byte(150) || " " || strip(putn(___all2___.mean, "&cononpf.."));
								%else ___all___ = strip(putn(___all1___.mean, "&cononpf.."));
							;
							%if &len4 = 1 %then ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&cononpf..")) ||
													    " " || byte(150) || " " || strip(putn(___all4___.mean, "&cononpf..")) || ")";
								%else ___all___ = strip(___all___) || " (" || strip(putn(___all3___.mean, "&cononpf..")) || ")";
							;
						end;
					%end;
				%end;
				%if "&calist" ^= "%str()" %then %do;
					if vtype.mean = 3 then do;
						if len3.mean < &frequencylen2 then
						___all___ = "~{style [color = &bcolor]" || repeat("&paddingchar", &frequencylen2 - 1 - len3.mean) || "}" ||
									strip(put(___all1___.mean, best.)); 
						else ___all___ = strip(put(___all1___.mean, best.));
						%if "%substr(%upcase(&missingpercent), 1, 1)" ^= "N" %then %do;
							if len4 < &percentlen2 then
								___all___ = strip(___all___) || " (" ||
												   "~{style [color = &bcolor]" || repeat("&paddingchar", &percentlen2 - 1 - len4.mean) || "}"
												   || strip(put(___all2___.mean, percentf.)) || ")"; 
								else ___all___ = strip(___all___) || " (" || strip(put(___all2___.mean, percentf.)) || ")";
						%end;
						%else %do;
							if ___group2 = "&missinglabel" then do;
								if len4 < &percentlen2 then
									___all___ = strip(___all___) || "~{style [color = &bcolor]" || " (" ||
													   repeat("&paddingchar", &percentlen2 - 1 - len4.mean)
													   || strip(put(___all2___.mean, percentf.)) || ")" || "}"; 
									else ___all___ = strip(___all___) || "~{style [color = &bcolor]" || " (" || strip(put(___all2___.mean, percentf.)) || ")" || "}";
							end;
							else do;
								if len4 < &percentlen2 then
									___all___ = strip(___all___) || " (" ||
													   "~{style [color = &bcolor]" || repeat("&paddingchar", &percentlen2 - 1 - len4.mean) || "}"
													   || strip(put(___all2___.mean, percentf.)) || ")"; 
									else ___all___ = strip(___all___) || " (" || strip(put(___all2___.mean, percentf.)) || ")";
							end;
						%end;
					end;
				%end;
				if vtype.mean = 4 then ___all___ = strip(put(___all1___.mean, best.)) || " (" || strip(put(___all2___.mean, best.)) || ")";
			endcomp;
			compute before ___group1 / style = {just = left vjust = center bordertopstyle = solid bordertopwidth = 1px color = black
												font_size = 11pt font_weight = bold backgroundcolor = 
												%if "%upcase(%substr(&variableshading, 1, 1))" ^= "N" %then CXcccccc; %else &bcolor;
												width = %if "%upcase(&orientation)" = "LANDSCAPE" %then 10in; %else 7.5in;};
				%if "%upcase(%substr(&labelvariable, 1, 1))" = "Y" %then %do;
					if ___vl___.mean = 1 then ___groupname = catx(" ", ___group1, "~{super ~{style [fontfamily = symbol]a}}");
						else if ___vl___.mean > 1 then ___groupname = catx(" ", ___group1, "~{super ~{style [fontfamily = symbol]b}}");
						else if ___vl___.mean = 0 then ___groupname = ___group1;
				%end;
				%else ___groupname = ___group1;;
				line ___groupname $200.;
		    endcomp;
		run;
		ods rtf close;
		ods html select all;	
	%end;
	%put;
	%put ********************   Finished   ********************;
	option source notes &moptions orientation = &orientation_setup; 
	%if "%upcase(%substr(&reportinSAS, 1, 1))" = "N" %then %do;
		ods html select all;
	%end;
	title;
	footnote;
%mend Table1Macro;
%* this macro is to find an unused name for a temporary dataset;
%macro FindTMP();
   %local i dn;
   %let i = 1;
   %do %while(%sysfunc(exist(temp&i)));
      %let i = %eval(&i+1);
   %end;
   temp&i
%mend;
%*this macro is to obtain number of observartion in a data set;
%*replace dsn with your data set name;
%macro nobs(dsn);
	%let dsid = %sysfunc(open(&dsn));
	%let nobs = %sysfunc(attrn(&dsid, nobs));
	%let rc   = %sysfunc(close(&dsid));
	&nobs
%mend nobs;
%*this macro is to obtain variable list in a dataset separated with blank;
%*replace dsn with your data set name;
%macro VarList(dsn);
	%local dsid i varlist rc;
	%let dsid = %sysfunc(open(&dsn));
	%do i = 1 %to %sysfunc(attrn(&dsid, nvar));
		%let varlist = &varlist %sysfunc(varname(&dsid,&i));
	%end;
	%let rc = %sysfunc(close(&dsid));
	&varlist
%mend VarList;
%*delete a dats set if it exists;
%macro DeleteData(dsn = , lib = work);
	%if "&dsn" = "%str()" %then %return;
	%if %sysfunc(exist(&dsn)) %then %do;
		proc datasets lib = &lib nolist;
			delete &dsn;
		quit;
	%end;
%mend DeleteData;
%*check if every element in str1 is in str2, out = 1 output list of varialbe from str1 and in str2, out = 2 output
	list of variable in str1 but not in str2;
%macro IfStr1inStr2(str1 = , str2 = , sep = %str( ), out = 1);
	%local i temp1 temp2 temp cnt;
	%let cnt = %sysfunc(countw(&str1));
	%do i = 1 %to &cnt;
		%let temp = %scan(&str1, &i);
		%if %sysfunc(indexw(%upcase(&str2), %upcase(&temp), &sep)) > 0 %then %do;
				%if %sysfunc(indexw(&temp1, &temp, &sep)) = 0 %then %let temp1 = &temp1 &temp;
			%end;
			%else %if %sysfunc(indexw(%upcase(&str2), %upcase(&temp), &sep)) = 0 %then %do;
				%if %sysfunc(indexw(&temp2, &temp, &sep)) = 0 %then %let temp2 = &temp2 &temp;
			%end;
	%end;
	%if &out = 1 %then &temp1;
		%else %if &out = 2 %then &temp2;
%mend IfStr1inStr2;
%*find the unique and redundant elements in a string, out = 1 output list of unique variable, out = 2 output list of redundant variable;
%macro UniqueandReduncant(str = , out = 1);
	%local i temp temp1 temp2 cnt;
	%let cnt = %sysfunc(countw(&str));
	%do i = 1 %to &cnt;
		%let temp = %scan(&str, &i);
		%if %sysfunc(indexw(%upcase(&temp1), %upcase(&temp))) = 0 %then %let temp1 = &temp1 &temp;
			%else %if %sysfunc(indexw(%upcase(&temp2), %upcase(&temp))) = 0 %then %let temp2 = &temp2 &temp;
	%end;
	%if &out = 1 %then &temp1;
		%else %if &out = 2 %then &temp2;
%mend UniqueandReduncant;
%*test if a folder exists;
%macro FolderExist(dir = );
	%let rc = %sysfunc(filename(fileref, &dir));
	%let did = %sysfunc(dopen(&fileref));
	%let rc = %sysfunc(dclose(&did));
	&did
%mend FolderExist;
