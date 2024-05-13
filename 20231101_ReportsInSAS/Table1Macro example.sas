
%include '~/Consulting/Table1Macro/Table1Macro.sas'; /* Change the path for where the macro is located*/
%Table1Macro(dsn = ourlib.mergedv1,
coplist = age_ofMekitrt CA_19_9v2 ,
calist =Sex  Albumin_at_MEK_ Neut_Lymp_ratio_at_Mekiintv1
Maximum_tolerated_dose__mg__of_M Type_of_MEK_inhibitor_based_trea Line_of_treatment_for_advanced_d ECOG_at_MEK_inh_based_treatment
HCQ_scheduling HCQ_titration_plan_duration_for Maximum_tolerated_dose_of_HCQ,
copmain = mean,
copsupplement = std ,
copdec = 2,
cadec = 2
cononpdec = 2,
notest = yes,
caincludemissing = yes,
copincludemissing = yes,
tabletitle = Table 2 - Patient and tumor characteristics of patients on MEKI based treatment and evaluable response by imaging,
overall = yes);
