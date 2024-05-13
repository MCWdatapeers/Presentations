*----------------------------------------------------------------------------------------*
* Downloaded on 4/20/2011 from http://browncancercenter.louisville.edu/biostats/sas-macros
* Zang Xiong 2008/03/04 %yamgast for Pharmasug
* Jianmin Pan made change from SD to SE and corrected the mistake in 95% CI on 10/12/2009   
* Xiaobin Yuan: remove "%" from table and add "(%)" under each column's total and subtotal on 06/30/2010 
* Aniko Szabo on 5/1/2011: 
*    added - 'ordfreq' summary type that runs Wilcoxon/Kruskal-Wallis on the categories 
*          - testlbl defaults to 'yes' and adds it description to the footnote 
*          - different label for t-test and ANOVA 
*          - column percents are counted among non-missing 
*          - fix SE: divide by sqrt(non-missing) by using stderr instead of std/sqrt(n)
*          - changed names of statistics to more meaningful meanSE, meanSD, meanCI, medR, medQ
* Aniko Szabo on 5/9/2011:
*          - fixed bug in group sample size calculation (introduced by me)
*          - allowed longer variable labels (up to 162 characters) 
* Aniko Szabo on 5/24/2012:
*          - fixed bug with hard-coded p-value format instead of &pfmt
*	   - added maxtime to exact chi-square test	
* Aniko Szabo on 7/11/2012:
*	       - fixed bug with %freq macro overwriting group labels
* Aniko Szabo on 8/17/2012:
*	       - eliminated error message for too wide column in listing output
*		- minimum sample size &small1 is now checked for non-missing values separately for each variable 
* Aniko Szabo on 12/16/2013:
*	- added option to specify separator for ranges
* 	- added checks for zero denominator in frequencies
* Aniko Szabo on 3/10/2014:
*	- fixed bug with meaningless p-values shown for variables with only one unique outcome
*----------------------------------------------------------------------------------------*;

/*****************************************************************************/
/*  %YAMGAST: Yet Another Macro to Generate a Summary Table                  */ 
/*%yamgast (                                                                 */
/*          dat=, grp=, vlist=,                                              */
/*          total=yes, test=yes, exacttest=yes, small1=30, small2=5,         */
/*          ncont=no, pct=col, missing=no,                                   */
/*          pctfmt=5.1, pfmt=pvalue5.3, alpha=0.05, rangeSep=" - ",          */
/*          w1=4cm, w2=3.5cm, w3=2cm,                                        */
/*          orient=portrait, ps=35, style=,                                  */
/*          title=%str(), footnote=%str(), file=);                           */
/*                                                                           */
/*Required parameters:                                                       */
/*  dat = Working SAS data set.                                              */
/*  grp = Group/column variable. Observation with missing group variable will not be summarized in the table.              */
/*  vlist = Name and the desired summary statistics for the variables which will be listed in the table.                   */
/*          Use \ to separate the variable names and statistics. For each variable, multiple statistics are allowed.   */
/*          The test statistics will be based on the first statistics statement of that variable. The valid values for     */
/*          summary statistics and their corresponding output are listed here:                                             */
/*      meanSE Mean +/- SE                                                    */
/*      meanSD Mean +/- SD                                                    */
/*      meanCI Mean (LowerCL - UpperCL)                                       */
/*      medR Median (Min - Max)                                              */
/*      medQ Median (Q1 - Q3)                                                */
/*      freq Frequency (Percentage %) (Percentage can be row or column percentage) */
/*      ordfreq Frequency, but Wilcoxon/Kruskal-Wallis test will be used     */
/*              expects a numeric variable (can have a format)               */
/*      Example: vlist =  age_at_dx\medR meanSE\                              */
/*                        gender\freq\                                       */
/*                        height\medQ\                                       */
/*  file = Path and file name of the RTF file                                */
/*                                                                           */
/*Optional statements:                                                       */
/*  test =  Specify whether to perform and report the test p-values.         */
/*          yes (default)/no                                                 */
/*          If grp variable has only 1 level, no test will be performed.     */
/*  exacttest = Specify whether to automatically choose exact test for each variable.           */
/*          yes (default)/no                                                                    */
/*          If yes, all the exact p-values will have a single dagger (.) as superscript.        */
/*  small1 = Specify the smallest sample size cut off for continuous variable. Default: 30.     */
/*  small2 = Specify the smallest cell count cut off for categorical variable. Default: 5.      */
/*  total = Specify whether to report the summary statistics for the entire cohort when         */
/*          there are more than 1 group.                                                        */
/*          yes (default)/no                                                                    */
/*  pct = Specify row or column percentage for categorical variables.                           */
/*        col: column percentage (default); row: row percentage                                 */
/*  ncont = Specify whether or not to report number of non missing observations for each        */
/*          continuous variables in each group.                                                 */
/*          yes /no (default)                                                                   */
/*  missing = Specify whether or not to report number of missing observations for each variables*/ 
/*              (both continuous and categorical) in each group.                                  */
/*          yes /no (default)                                                                   */
/*  testlbl = Specify whether the label of the test performed should be put into the footnote   */
/*  pctfmt = Specify the format for all percentages. Default is 5.1.                            */
/*  pfmt = Specify the format for all p-values. Default is pvalue5.3.                           */
/*  alpha = Specify the alpha level for calculating the confidence interval. Default is 0.05.   */
/*  rangeSep = Specify the separator used for ranges (medR, medQ, meanCI).                      */
/*             Needs to include any required spacing. Default is a dash: " - "                  */
/*  w1 = Specify the width of the first column. Default is 4cm.                                 */
/*  w2 = Specify the width of the column other than the first column and the column for p values.*/ 
/*       Default is 3.5cm.                                                                      */
/*  w3 = Specify the width of the column for p-values. Default is 2cm.                          */
/*  orient = Specify the orientation of the page.                                               */
/*          portrait (default)/landscape                                                        */
/*  ps = Specify the maximum number of rows per page. Default is 35.                            */
/*  style = Specify the style of RTF file.                                                      */
/*  title = Specify the title for the table.                                                    */
/*  footnote = Specify the footnote for the summary table.                                      */
/************************************************************************************************/

%macro yamgast(dat=, grp=, vlist=, 
		total=yes, test=yes, exacttest=yes, small1=30, small2=5, ncont=no, pct=col, missing=no, testlbl=yes,
		pctfmt=5.1, pfmt=pvalue5.3, alpha=0.05, rangeSep=" - ",  
		w1=4.1cm, w2=3.0cm, w3=2cm,   /* 3 groups*/
		/*w1=5cm, w2=3.5cm, w3=3cm, /* 2 groups*/
		orient=portrait, ps=35, style=custom2bn, record=yes,
		title=, footnote=%str(), file=);

	data _null_;
		ci = right(left(trim(put(round((1-&alpha)*100, 1.), 2.0))));
		call symput('ci', ci);
	run;

	data _report; set _null_; run;

	ods output variables = _content;
		proc contents data = &dat;
		run;
	ods output close;

	data _content; 
		length format $20 label $100;  * ensure there is enough space;
		set _content;
		if upcase(type) = 'CHAR' and format = ' ' then format = '$30.';
		if upcase(type) = 'NUM' and format = ' ' then format = '8.1';
		if label = ' ' then label = propcase(variable);
	run;
	
	proc sql noprint; select label into :grplbl from _content where upcase(variable) = "%upcase(&grp)"; quit;
	proc sql noprint; select format into :grpfmt from _content where upcase(variable) = "%upcase(&grp)"; quit;

	data _dat; set &dat; where &grp is not missing; 
		_grp = left(''||left(put(&grp, &grpfmt)));
	run;

	proc sql noprint; select count(*) into :ntotal from _dat; quit;
	%let ntotal = %sysevalf(&ntotal);

	proc sql noprint; select count(*) into :ngrp from (select distinct _grp from _dat); quit;
	%let ngrp = %sysevalf(&ngrp);

	%if &ngrp = 1 %then %do;
		%let test = no;
		%let total = no;
	%end; 
	%if %substr(%upcase(test),1,1) = 'N' %then 
		%let testlbl = 'no';
	
	proc sort data = _dat; by &grp; run;
	proc sql noprint; select distinct &grp into :grp1-:grp&ngrp from _dat; quit;
	
	%let _I=1;
	%do %while (%scan(&vlist, &_I, %str(\)) NE );
		%let var=%scan(&vlist, &_I, %str(\));
		%let display=%scan(&vlist, %eval(&_I+1), %str(\));
		%let firstmacro=%scan(&display, 1, %str( ));
		%let _exacttest = 0;
		proc sql noprint; select type into :vartype from _content where upcase(variable) = "%upcase(&var)"; quit;
		proc sql noprint; select label into :varlbl from _content where upcase(variable) = "%upcase(&var)"; quit;
		proc sql noprint; select format into :varfmt from _content where upcase(variable) = "%upcase(&var)"; quit;

		*** check if exact continuous test is needed ***;
		proc sql noprint; select count(&var) into :nnonmiss from _dat where &var is not missing; quit;
		%let exactwilcox = no;
		%if &nnonmiss < &small1 %then %let exactwilcox = yes;

		*** get p-value corresponding to first summary statistic ***;
		%nametest;

		%if %upcase(%substr(&firstmacro, 1, 1)) = %str(M) and %upcase(%substr(&ncont, 1, 1)) = %str(Y) %then %do;
			%count;		
		%end;

		%let _J = 1;
		%do %while (%scan(&display, &_J, %str( )) NE );
			%let macro = %scan(&display, &_J, %str( ));
			%&macro;
			%let _J = %eval(&_J + 1);
		%end;

		%if %upcase(%substr(&firstmacro, 1, 1)) = %str(M) and %upcase(%substr(&missing, 1, 1)) = %str(Y) %then %do;
			%missing;		
		%end;

		%let _I=%eval(&_I+2);
	%end;

	data _report; set _report;
		_one = 1;
		retain mypage 1 nrowprint &ps;
		counter = _n_;
		if counter > nrowprint then do;
			nrowprint = nrowprint + &ps;
		end;
		mypage = nrowprint/&ps;
	run;

	proc sql noprint; select max(mypage) into :maxpage from _report; quit;

	%do i = 1 %to &ngrp;
		proc sql noprint; select count(*) into :ngrp&i from _dat where _grp = "&&grp&i"; quit;
		%let ngrp&i = %eval(&&ngrp&i);
	%end;

	title ' ';
	footnote ' ';
	footnote2 ' ';
	options  orientation=&orient nocenter;
	ods rtf file = "&file" bodytitle startpage=yes style=&style;
	ods noptitle;
	ods escapechar='^';

	%do _ii = 1 %to &maxpage;
		%if &_ii = 1 %then %do;
			title "^S={just=left font_size = 12pt font_weight=bold} &title";
			%_report;
		%end;
		%else %do;
			title "^S={just=left font_size = 12pt font_weight=bold} &title (cont.)";
			%_report;
		%end;
	%end;
	ods rtf close;

%mend;

%macro _report;
	proc report data = _report nowd headline split='#' box;
		where mypage = &_ii;
		column	
		(
		col0 
		(%if &ngrp > 1 %then %do;
			"&grplbl"
			%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
				total 
			%end;
		 %end;
		%do i = 1 %to &ngrp;
			col&i 	
		%end;
		)
		%if %upcase(%substr(&test, 1, 1)) = %str(Y) and &ngrp > 1 %then %do;
			pvalue 
		%end;
		)
		;

		define col0/display '^S={just=left}Variables' style(column)=[cellwidth=&w1 just=left leftmargin=10pt] width=30;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			define total/display "^S={just=center}Total#N=&ntotal(%)"  style(column)=[cellwidth=&w2 just=c]  width=30;
		%end;
		%do i = 1 %to &ngrp;
			define col&i /display "^S={just=center}&&grp&i.#N=&&ngrp&i(%)"  style(column)=[cellwidth=&w2 just=c]  width=30;
		%end;
		%if %upcase(%substr(&test, 1, 1)) = %str(Y) and &ngrp > 1 %then %do;
			define pvalue /display "^S={just=center}P Value" style(column)=[cellwidth=&w3 just=c font_style=italic]  width=30;
		%end;
*		define mypage/order noprint;

		%if %upcase(%substr(&exacttest, 1, 1)) = %str(Y) or &footnote ^= %str() or %upcase(%substr(&record, 1, 1)) = %str(Y) 
        or %upcase(%substr(&testlbl, 1, 1)) = %str(Y) %then %do;
			compute after _page_/style={just=l font_size=8pt};
				%if %upcase(%substr(&record, 1, 1)) = %str(Y) %then %do;
					line ' ';
					line "^S={protectspecialchars = off just=left}Date: &sysdate."; 
				%end;
				%if %upcase(%substr(&exacttest, 1, 1)) = %str(Y) and %upcase(%substr(&test, 1, 1)) = %str(Y) %then %do;
					line "^{super +}Exact test";
				%end;
				%if %upcase(%substr(&testlbl, 1, 1)) = %str(Y) and %upcase(%substr(&test, 1, 1)) = %str(Y) %then %do;
				  %if (&ngrp = 2) %then
					  line "^{super T}t-test; ^{super C}Chi-square test; ^{super W}Wilcoxon rank-sum test";
				  %else
					  line "^{super A}ANOVA F-test; ^{super C}Chi-square test; ^{super K}Kruskal-Wallis test";
				  ;
  			%end;
				%if &footnote ^= %str() %then %do;
					%let _I = 1;
					%do %while (%scan(&footnote, &_I, %str(\)) NE );
						%let text=%scan(&footnote, &_I, %str(\));
						line "&text";
						%let _I = %eval(&_I + 1);
					%end;
				%end;
			endcomp;
		%end;

*		break after mypage/page;
	run;
%mend;

%macro nametest;
	%let &var._p = NA;

	%if %upcase(%substr(&firstmacro, 1, 4)) = %str(MEAN) and &ngrp > 1 and %upcase(%substr(&test, 1, 1)) = %str(Y) %then %do;
		%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y) %then %do;
			%put WARNING: Sample size is less than 30;
		%end;
		ods output modelanova = _test;
			proc glm data = _dat; 
				class _grp;
				model &var = _grp;
			run; quit;
		ods output close;
		data _null_; set _test;
			if hypothesistype = 3 then do;
				%if %upcase(%substr(&testlbl, 1, 1)) = %str(Y) %then %do;
				  %if (&ngrp = 2) %then
					  p = put(probf, &pfmt)||' ^{super T}';
			    %else
			      p = put(probf, &pfmt)||' ^{super A}';
	        ;
				%end;
				%else %do;
					p = put(probf, &pfmt);
				%end;
				call symput("&var._p", p);
			end;
		run;
		proc datasets; delete _test; run; quit;
	%end;

	%if (%upcase(%substr(&firstmacro, 1, 3)) = %str(MED) or %upcase(&firstmacro) = %str(ORDFREQ))
       and &ngrp > 1 and %upcase(%substr(&test, 1, 1)) = %str(Y) %then %do;
		proc npar1way data=_dat;
			class _grp;
			var &var;
			%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y) %then %do;
			exact wilcoxon;
			%end;
			output out = p1	WILCOXON ;
		run;
		data _null_; set p1;
			%if &ngrp = 2 %then %do;
				%if %upcase(%substr(&testlbl, 1, 1)) = %str(Y) %then %do;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(N) %then %do;
						p = put(p2_wil, &pfmt)||' ^{super W}';
					%end;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y) %then %do;
						p = put(xp2_wil, &pfmt)||' ^{super W}';
					%end;
				%end;
				%else %do;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(N) %then %do;
						p = put(p2_wil, &pfmt);
					%end;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y) %then %do;
						p = put(xp2_wil, &pfmt);
					%end;
				%end;
			%end;
			%if &ngrp > 2 %then %do;
				%if %upcase(%substr(&testlbl, 1, 1)) = %str(Y) %then %do;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(N) %then %do;
						p = put(p_kw, &pfmt)||' ^{super K}';
					%end;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y) %then %do;
						if not missing(xp2_wil) then 
							p = put(xp2_wil, &pfmt)||' ^{super W}';  ** should only happen with missing data;
						else
							p = put(xp_kw, &pfmt)||' ^{super K}';
					%end;
				%end;
				%else %do;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(N) %then %do;
						p = put(p_kw, &pfmt);
					%end;
					%if %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y) %then %do;
						if not missing(xp2_wil) then
							p = put(xp2_wil, &pfmt); ** should only happen with missing data;
						else 
							p = put(xp_kw, &pfmt);
					%end;
				%end;
			%end;
			call symput("&var._p", p);
		run;
	%end;

	%if &firstmacro = %str(freq) and &ngrp > 1 and %upcase(%substr(&test, 1, 1)) = %str(Y) %then %do;
		
		*** check whether outcome has only on unique value ***;
		proc sql noprint; select count(*) into :nvalues from (select distinct &var from _dat); quit;
		%let nvalues = %sysevalf(&nvalues);
%put "DEBUG: In dataset &dat variable &var has &nvalues unique values";
		
		%if &nvalues > 1 %then %do;  ** there is a default &var._p=NA at the beginning of the macro to catch the other case;

			ods output CrossTabFreqs = freqexpct PearsonChiSq = p1;
			proc freq data=_dat ;    
				exact chisq / maxtime=2;
			 	tables &var*_grp/expected chisq;                                                
			run;
			ods output close;

			*** check if exact Chi-square test is needed ***;
			%if %upcase(%substr(&exacttest, 1, 1)) = %str(Y) %then %do;
				data _null; set freqexpct;
					if . < expected < &small2 then do;
						call symput('_exacttest', 1); 
					end;
				run;
			%end;
			
			*** check if exact Chi-square test p-value is available (or calculation timed out) and revert to asymptotic test ***;
			%if &_exacttest = 1 %then %do;
				data _null; set p1;
					if Name1 = 'XP_PCHI';
					if missing(nValue1) then do;
						call symput('_exacttest', 0); 
					end;
				run;
			%end;

			*** extract appropriate p-value ***;
			data _null_; set p1;
				%if &_exacttest = 0 %then %do;
					if Name1 = 'P_PCHI' then do;
				%end;
				%if &_exacttest = 1 %then %do;
					if Name1 = 'XP_PCHI' then do;
				%end;
				%if %upcase(%substr(&testlbl, 1, 1)) = %str(Y) %then %do;
					p = put(nValue1, &pfmt)||' ^{super C}';
				%end;
				%else %do;
					p = put(nValue1, &pfmt);
				%end;
				call symput("&var._p", p); end;
			run;
			proc datasets; delete freqexpct p1; run; quit;
		%end;
	%end;

 	data _nametest; 
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = '^S={leftmargin=0pt font_weight=bold}'||"&varlbl";
		%if %upcase(%substr(&test, 1, 1)) = %str(Y) %then %do;
			%if (&firstmacro = %str(freq) and &_exacttest = 1) or 
			((%upcase(%substr(&firstmacro, 1, 3)) = %str(MED) or %upcase(&firstmacro) = %str(ORDFREQ)) 
          and %upcase(%substr(&exactwilcox, 1, 1)) = %str(Y)) %then %do;
				pvalue = "&&&var._p"||' ^{super +}';
			%end;
			%else %do;
				pvalue = "&&&var._p";
			%end;
		%end;
	run;		
	data _report; set _report _nametest; run;
	proc datasets; delete _nametest; run; quit;
%mend;


%macro count;

	%do i = 1 %to &ngrp;
		proc sql noprint; select count(&var) into :n&i from _dat where _grp = "&&grp&i" and &var is not missing; quit;
	%end;

	%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
		proc sql noprint; select count(&var) into :n0 from _dat where &var is not missing; quit;
	%end;

	%macro count_1;
		%do i = 1 %to &ngrp;
			n&i = &&n&i; 
			col&i = trim(left(put(n&i, 12.0)));
		%end;
	%mend;

	%macro count_2;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			n0 = &n0; 
			total = trim(left(put(n0, 12.0)));
		%end;
	%mend;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = 'N';
		%count_1;
		%count_2;
	run;

	data _report; set _report _sumstat; run;
	proc datasets nodetails nolist; delete _sumstat; run;
%mend;


%macro meanSE;

	%do i = 1 %to &ngrp;
		proc sql noprint; select &var into :list&i separated by ',' from _dat where _grp = "&&grp&i"; quit;
	%end;

	%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
		proc sql noprint; select &var into :list separated by ',' from _dat; quit;
	%end;

	%macro meanSE_1;
		%do i = 1 %to &ngrp;
			mean&i = mean(&&list&i); se&i = stderr(&&list&i); 
			col&i = trim(left(put(mean&i, &varfmt)))||' '||'b1'x||' '||trim(left(put(se&i, &varfmt)));
			%let list&i = %str();
		%end;
	%mend;

	%macro meanSE_2;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			mean0 = mean(&list); se0 = stderr(&list);
			total = trim(left(put(mean0, &varfmt)))||' '||'b1'x||' '||trim(left(put(se0, &varfmt)));
		%end;
	%mend;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = 'Mean '||'b1'x||' SE';
		%meanSE_1;
		%meanSE_2;
	run;

	data _report; set _report _sumstat; run;
	proc datasets; delete _sumstat; run; quit;
%mend;


%macro meanSD;

	%do i = 1 %to &ngrp;
		proc sql noprint; select &var into :list&i separated by ',' from _dat where _grp = "&&grp&i"; quit;
	%end;

	%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
		proc sql noprint; select &var into :list separated by ',' from _dat; quit;
	%end;

	%macro meanSD_1;
		%do i = 1 %to &ngrp;
			mean&i = mean(&&list&i); sd&i = std(&&list&i); 
			col&i = trim(left(put(mean&i, &varfmt)))||' '||'b1'x||' '||trim(left(put(sd&i, &varfmt)));
			%let list&i = %str();
		%end;
	%mend;

	%macro meanSD_2;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			mean0 = mean(&list); sd0 = std(&list);
			total = trim(left(put(mean0, &varfmt)))||' '||'b1'x||' '||trim(left(put(sd0, &varfmt)));
		%end;
	%mend;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = 'Mean '||'b1'x||' SD';
		%meanSD_1;
		%meanSD_2;
	run;

	data _report; set _report _sumstat; run;
	proc datasets; delete _sumstat; run; quit;
%mend;


%macro meanCI;

	%do i = 1 %to &ngrp;
		proc sql noprint; select &var into :list&i separated by ',' from _dat where _grp = "&&grp&i"; quit;
	%end;

	%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
		proc sql noprint; select &var into :list separated by ',' from _dat; quit;
	%end;

	%macro meanCI_1;
		%do i = 1 %to &ngrp;
			mean&i = mean(&&list&i); lb&i = mean(&&list&i) - z*stderr(&&list&i); ub&i = mean(&&list&i) + z*stderr(&&list&i);
			col&i = trim(left(put(mean&i, &varfmt)))||' ('||trim(left(put(lb&i, &varfmt)))||&rangeSep||trim(left(put(ub&i, &varfmt)))||')';
			%let list&i = %str();
		%end;
	%mend;

	%macro meanCI_2;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			mean0 = mean(&list); lb0 = mean(&list) - z*stderr(&list); ub0 = mean(&list) + z*stderr(&list);
			total = trim(left(put(mean0, &varfmt)))||' ('||trim(left(put(lb0, &varfmt)))||&rangeSep||trim(left(put(ub0, &varfmt)))||')';
		%end;
	%mend;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = "Mean (&ci.% CI)";
		z = quantile('NORMAL',(1 - &alpha / 2));	
		%meanCI_1;
		%meanCI_2;
	run;

	data _report; set _report _sumstat; run;
	proc datasets; delete _sumstat; run; quit;
%mend;


%macro medR;

	%do i = 1 %to &ngrp;
		proc sql noprint; select &var into :list&i separated by ',' from _dat where _grp = "&&grp&i"; quit;
	%end;

	%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
		proc sql noprint; select &var into :list separated by ',' from _dat; quit;
	%end;

	%macro medR_1;
		%do i = 1 %to &ngrp;
			med&i = median(&&list&i); min&i = min(&&list&i); max&i = max(&&list&i);
			col&i = trim(left(put(med&i, &varfmt)))||' ('||trim(left(put(min&i, &varfmt)))||&rangeSep||trim(left(put(max&i, &varfmt)))||')';
			%let list&i = %str();
		%end;
	%mend;

	%macro medR_2;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			med0 =  median(&list); min0 = min(&list); max0 = max(&list);
			total = trim(left(put(med0, &varfmt)))||' ('||trim(left(put(min0, &varfmt)))||&rangeSep||trim(left(put(max0, &varfmt)))||')';
			%let list = %str();
		%end;
	%mend;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = 'Median (min' || &rangeSep || 'max)';
		%medR_1;
		%medR_2;
	run;

	data _report; set _report _sumstat; run;
	proc datasets; delete _sumstat; run; quit;
%mend;


%macro medQ;
	%do i = 1 %to &ngrp;
		proc sql noprint; select &var into :list&i separated by ',' from _dat where _grp = "&&grp&i"; quit;
	%end;

	%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
		proc sql noprint; select &var into :list separated by ',' from _dat; quit;
	%end;

	%macro medQ_1;
		%do i = 1 %to &ngrp;
			med&i = median(&&list&i); p25&i = pctl(25,&&list&i); p75&i = pctl(75,&&list&i);
			col&i = trim(left(put(med&i, &varfmt)))||' ('||trim(left(put(p25&i, &varfmt)))||&rangeSep||trim(left(put(p75&i, &varfmt)))||')';
			%let list&i = %str();
		%end;
	%mend;

	%macro medQ_2;
		%if %upcase(%substr(&total, 1, 1)) = %str(Y) %then %do;
			med0 = median(&list); p250 = pctl(25,&list); p750 = pctl(75,&list);
			total = trim(left(put(med0, &varfmt)))||' ('||trim(left(put(p250, &varfmt)))||&rangeSep||trim(left(put(p750, &varfmt)))||')';
		%end;
	%mend;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
		col0 = 'Median (q25' || &rangeSep || 'q75)';
		%medQ_1;
		%medQ_2;
	run;

	data _report; set _report _sumstat; run;
	proc datasets; delete _sumstat; run; quit;
%mend;

%macro freq;
	data _dat; set _dat; 
		length _&var $199.;
		_&var = left(''||left(put(&var, &varfmt)));
	run;

	data _dat1; set _dat; 
		where &var is not missing;
	run;
	proc sort data = _dat1; by &var; run;
	
	proc sql noprint; select count(*) into :nvar from (select distinct &var from _dat1); quit;
	%let nvar = %sysevalf(&nvar);

	proc sort data = _dat1; by &var; run;

	proc sql noprint; select distinct &var into :var1-:var&nvar from _dat1; quit;

	%do i = 1 %to &nvar;
		data _null_;
			temp = left("&&var&i");
			call symput ("var&i", temp);
		run;
		proc sql noprint; select count(*) into :nvar&i from _dat where _&var = left("&&var&i"); quit;
		%let nvar&i = %eval(&&nvar&i);
	%end;

        proc sql noprint; select count(*) into :ntotalnonmiss from _dat1; quit;
	%let ntotalnonmiss = %sysevalf(&ntotalnonmiss);


	%do i = 1 %to &ngrp;
/*		proc sql noprint; select count(*) into :ngrp&i from _dat where _grp = "&&grp&i"; quit; */
		proc sql noprint; select count(*) into :ngrp&i from _dat1 where _grp = "&&grp&i"; quit;
		%let ngrp&i = %eval(&&ngrp&i);
	%end;

	%do i = 1 %to &nvar;
		%do j = 1 %to &ngrp; 
			proc sql noprint; select count(*) into :nvar&i.&j from _dat where _&var = left("&&var&i") and _grp = "&&grp&j"; quit;
			%let nvar&i.&j = %eval(&&nvar&i.&j);
		%end;
	%end;
	
	%if %upcase(%substr(&missing,1,1)) = %str(Y) %then %do;
		proc sql noprint; select count(*) into :nvarmissing from _dat where &var is missing; quit;
		%let nvarmissing = %eval(&nvarmissing);
		%do i = 1 %to &ngrp;
			proc sql noprint; select count(*) into :nvarmissing&i from _dat where &var is missing and _grp = "&&grp&i"; quit;
			%let nvarmissing&i = %eval(&&nvarmissing&i);
		%end;
	%end;
	
	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;

		%do i = 1 %to &nvar;
			col0 = "&&var&i";
			%do j = 1 %to &ngrp;
				%if %upcase(%substr(&pct,1,3)) = %str(ROW) and &&nvar&i > 0 %then %do;
					pct&i.&j = &&nvar&i.&j/&&nvar&i * 100;
				%end;
				%if %upcase(%substr(&pct,1,3)) = %str(COL) and &&ngrp&j > 0 %then %do;
					pct&i.&j = &&nvar&i.&j/&&ngrp&j * 100;
				%end;
				col&j = trim(left(put(&&nvar&i.&j, 8.0)))||' ('||trim(left(put(pct&i.&j, &pctfmt)))||')';
			%end;
			%if %upcase(%substr(&total,1,1)) = %str(Y) and %upcase(%substr(&pct,1,3)) = %str(ROW) %then %do;
				total = trim(left(put(&&nvar&i, 8.0)))||' (100)';
			%end;
			%if %upcase(%substr(&total,1,1)) = %str(Y) and %upcase(%substr(&pct,1,3)) = %str(COL) %then %do;
				%if &ntotalnonmiss > 0 %then %do;
					pct&i = &&nvar&i/&ntotalnonmiss * 100;
				%end;
				total = trim(left(put(&&nvar&i, 8.0)))||' ('||trim(left(put(pct&i, &pctfmt)))||')';
			%end;
			output;
		%end;

		%if %upcase(%substr(&missing,1,1)) = %str(Y) %then %do;
			col0 = 'Missing';
			%do j = 1 %to &ngrp;
*				pctmissing&j = &&nvarmissing&j/&&ngrp&j * 100;
*				col&j = trim(left(put(&&nvarmissing&j, 8.0)))||' ('||trim(left(put(pctmissing&j, &pctfmt)))||')';
				col&j = trim(left(put(&&nvarmissing&j, 8.0)));
			%end;
			%if %upcase(%substr(&total,1,1)) = %str(Y) %then %do;
*				pctmissing = &nvarmissing/&ntotal * 100;
*				total = trim(left(put(&&nvarmissing, 8.0)))||' ('||trim(left(put(pctmissing, &pctfmt)))||')';
				total = trim(left(put(&&nvarmissing, 8.0)));
			%end;
			output;
		%end;
	run;

	data _report; set _report _sumstat; run;
proc print data=_sumstat;
run;
	proc datasets; delete _sumstat; run; quit;

%mend;

%macro ordfreq;
  %freq;
%mend;

%macro missing;
	proc sql noprint; select count(*) into :nvarmissing from _dat where &var is missing; quit;
	%let nvarmissing = %eval(&nvarmissing);
	%do i = 1 %to &ngrp;
		proc sql noprint; select count(*) into :nvarmissing&i from _dat where &var is missing and _grp = "&&grp&i"; quit;
		%let nvarmissing&i = %eval(&&nvarmissing&i);
	%end;

	data _sumstat;
		keep col0-col&ngrp total pvalue;
		length col0-col&ngrp total pvalue $199.;
			col0 = 'Missing';
			%do j = 1 %to &ngrp;
*				pctmissing&j = &&nvarmissing&j/&&ngrp&j * 100;
*				col&j = trim(left(put(&&nvarmissing&j, 8.0)))||' ('||trim(left(put(pctmissing&j, &pctfmt)))||')';
				col&j = trim(left(put(&&nvarmissing&j, 8.0)));
			%end;
			%if %upcase(%substr(&total,1,1)) = %str(Y) %then %do;
*				pctmissing = &nvarmissing/&ntotal * 100;
*				total = trim(left(put(&&nvarmissing, 8.0)))||' ('||trim(left(put(pctmissing, &pctfmt)))||')';
				total = trim(left(put(&&nvarmissing, 8.0)));
			%end;
			output;
	run;

	data _report; set _report _sumstat; run;
	proc datasets; delete _sumstat; run; quit;

%mend;
/*

%let grp = bmdgrp;
%let dat = test;
%let var = sex_new;
%let var = height__cm_;
%let total = no;
%let vlist = yearfromdxtoqct\meanSE meanCI medR medQ \;
%let i = 1;
%let test = Y;
%let pfmt = pvalue6.;
%let alpha = 0.05;
%let ci = %sysevalf(%sysevalf(1-&alpha)*100);
%let missing = no;
%let pct = col;
%let pctfmt = 5.1;
%let nrowperpage = 5;

title ' ';
footnote ' ';
footnote2 ' ';

*/
