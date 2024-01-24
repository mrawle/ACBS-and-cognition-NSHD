 /*DATA PREPARATION
*Load initial data
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\antichol-JULY+phys.dta", clear
*Note derived variables in this dataset
*"cogchild" is a composite measure, cog8h replaced with cog11h if missing, replaced with cog15h if still missing.
-> 
gen cogchild=cog8h
replace cogchild=cog11h if cog8h==.
replace cogchild=cog15h if cog8h==. & cog11h==.
label variable cogchild "Derived: Maximise childhood cognition sample"
label values cogchild cogchild
*"ACC_*" is a three level categorical variable, defined at four waves (age 43, 53, 60-64 [labeled as 63] and 69), a value of 0 is no medications with a positive rating on the Anticholinergic Cognitive Burden Scale (ACBS), a value of 1 is 1-2 points worth of ACBS medications, a value of 2 is 3+ points of ACBS medications. It has been renamed for ease of use in longitudinal models. See additional Github file for example code of ACBS generation @ age 69 (Generate ACBS Score Age 69.do). Code for generation of ACC_* at other ages available on request.
*"PP_*" is a sensitvity analysis and imputation variable, defined at four waves as above. It is a binary variable, with a positive rating if an individual has polypharmacy (ie 5 or more prescribed medications).
*"VR_*" and "SS_*" are scores for verbal recall and search speed, relabeled from their respective tests at all four waves, for the purposes of easier longitudinal analysis.

*Relevel chronic disease count to reduce reportable analyses
recode chron19tot15x (4=3) (5=3)
label define chron19tot15x 3 "3+", replace
gen chrondisease_69=chron19tot15x

*Recode disability variables
gen disa_43=disa89
gen disa_53=disa99
gen disa_63=disa09
gen disa_69=disa15x
gen depress_53=ghq99_caseness
gen depress_63=ghq09_caseness
gen depress_69=ghq15_casenessx

*recode cognitive variables for use in regression analyses.
recode vsp15x (-9=.) (-8=.) (-7=.)
recode wlt15x (-9=.) (-8=.) (-7=.)
recode acetotfin15x (-99=.) (-88=.) (-77=.) (-66=.)

*PSF variable
gen depress_43=cmd43or4
recode depress_43 (1=0) (2=0) (3=0) (4=1) (-9=.)

*Drop unneeded variables
keep VR_* SS_* acetotfin15x ACC_* PP_* chrondisease_* disa_* depress_* attain_26 cogchild sex nshdid_ntag1

save "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\complete case.dta", replace

*Generate variables to allow analysis of not imputed outcomes
gen nomiss_vr69=1 if VR_69!=.
gen nomiss_ss69=1 if SS_69!=.
gen nomiss_ace=1 if acetotfin15x!=.
gen nomiss_vr63=1 if VR_63!=.
gen nomiss_ss63=1 if SS_63!=.
gen nomiss_vr53=1 if VR_53!=.
gen nomiss_ss53=1 if SS_53!=.
gen nomiss_vr43=1 if VR_43!=.
gen nomiss_ss43=1 if SS_43!=.
gen nomiss_ss=0
replace nomiss_ss=1 if nomiss_ss69==1
replace nomiss_ss=1 if nomiss_ss63==1
replace nomiss_ss=1 if nomiss_ss53==1
gen nomiss_vr=0
replace nomiss_vr=1 if nomiss_vr69==1
replace nomiss_vr=1 if nomiss_vr63==1
replace nomiss_vr=1 if nomiss_vr53==1

recode sex (-9=.)
drop if sex==.

*Create imputed dataset
mi set flong
mi register imputed cogchild attain_26 ACC_* PP_* VR_* SS_* disa* chrondisease_* depress_* acetotfin15x 
mi impute chained (regress) cogchild (logit) PP_* disa* depress_* (ologit) attain_26 ACC_* chrondisease_* (pmm, knn(10)) VR_* SS_* acetotfin15x = sex, rseed(270186) add(15)
save "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", replace

*ADDITIONAL CODE EXPLORING RELATIONSHIPS IN VARIABLES NOT PROVIDED HERE AS UNFORMATTED FOR EASE OF READING, INSTEAD REPORTED IN ORIGINAL MANUSCRIPT AND AVAILABLE ON REQUEST*/

**************************************************************TABLES FOR PAPER************************************************************
*Descriptives
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\complete case.dta", clear
recode sex (-9=.)
drop if sex==.

table (var) (ACC_69), statistic (mean cogchild acetotfin15x VR_69 SS_69) statistic (sd cogchild acetotfin15x VR_69 SS_69) statistic (fvfrequency sex attain_26 chrondisease_69 disa_69 depress_69) statistic (fvpercent sex attain_26 chrondisease_69 disa_69 depress_69) nformat (%6.2f mean sd)
collect levelsof result
collect style header result, level(hide)
collect style row stack, nobinder spacer
collect style cell border_block, border(right, pattern(nil))
collect recode result fvfrequency=mean fvpercent=sd
collect layout (var) (ACC_69[0 1 2 ]#result)
collect style cell result[sd]#var[sex attain_26 chrondisease_69 disa_69 depress_69], sformat("%s%%")
collect style cell result[sd]#var[cogchild acetotfin15x VR_69 SS_69], sformat("(%s)")
collect style cell result[mean]#var[sex attain_26 chrondisease_69 disa_69 depress_69], nformat(%4.0f)

collect export tableS169_24.docx, replace

table (var) (ACC_63), statistic (mean cogchild acetotfin15x VR_63 SS_63) statistic (sd cogchild acetotfin15x VR_63 SS_63) statistic (fvfrequency sex attain_26 chrondisease_63 disa_63 depress_63) statistic (fvpercent sex attain_26 chrondisease_63 disa_63 depress_63) nformat (%6.2f mean sd)
collect levelsof result
collect style header result, level(hide)
collect style row stack, nobinder spacer
collect style cell border_block, border(right, pattern(nil))
collect recode result fvfrequency=mean fvpercent=sd
collect layout (var) (ACC_63[0 1 2 .]#result)
collect style cell result[sd]#var[sex attain_26 chrondisease_63 disa_63 depress_63], sformat("%s%%")
collect style cell result[sd]#var[cogchild acetotfin15x VR_63 SS_63], sformat("(%s)")
collect style cell result[mean]#var[sex attain_26 chrondisease_63 disa_63 depress_63], nformat(%4.0f)

collect export tableS263_24.docx, replace

table (var) (ACC_53), statistic (mean cogchild acetotfin15x VR_53 SS_53) statistic (sd cogchild acetotfin15x VR_53 SS_53) statistic (fvfrequency sex attain_26 chrondisease_53 disa_53 depress_53) statistic (fvpercent sex attain_26 chrondisease_53 disa_53 depress_53) nformat (%6.2f mean sd)
collect levelsof result
collect style header result, level(hide)
collect style row stack, nobinder spacer
collect style cell border_block, border(right, pattern(nil))
collect recode result fvfrequency=mean fvpercent=sd
collect layout (var) (ACC_53[0 1 2 ]#result)
collect style cell result[sd]#var[sex attain_26 chrondisease_53 disa_53 depress_53], sformat("%s%%")
collect style cell result[sd]#var[cogchild acetotfin15x VR_53 SS_53], sformat("(%s)")
collect style cell result[mean]#var[sex attain_26 chrondisease_53 disa_53 depress_53], nformat(%4.0f)

collect export tableS353_24.docx, replace

*Cross sectional
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16.dta", clear
drop *_43
save "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", replace

*clear collection
collect clear

*create collection model for table
collect create ex1

*regressions, _b coefficient _ci confidence interval in multiple models
*p_d p_e creat extra variables based on p values from testparm
collect _r_b _r_ci, tag(model[(1)]): mi estimate: regress acetotfin15x i.ACC_69 sex if nomiss_ace==1
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_69 2.ACC_69
collect _r_b _r_ci, tag(model[(2)]): mi estimate: regress acetotfin15x i.ACC_69 sex cogchild i.attain_26 if nomiss_ace==1
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_69 2.ACC_69
collect _r_b _r_ci, tag(model[(3)]): mi estimate: regress acetotfin15x i.ACC_69 sex cogchild i.attain_26 i.chrondisease_69 disa_69 depress_69 if nomiss_ace==1
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_69 2.ACC_69
collect _r_b _r_ci, tag(model[(1)]): mi estimate: regress acetotfin15x i.ACC_63 sex if nomiss_ace==1
collect p_e=r(p), tag(model[(1)]): mi test 1.ACC_63 2.ACC_63
collect _r_b _r_ci, tag(model[(2)]): mi estimate: regress acetotfin15x i.ACC_63 sex cogchild i.attain_26 if nomiss_ace==1
collect p_e=r(p), tag(model[(2)]): mi test 1.ACC_63 2.ACC_63
collect _r_b _r_ci, tag(model[(3)]): mi estimate: regress acetotfin15x i.ACC_63 sex cogchild i.attain_26 i.chrondisease_63 disa_63 depress_63 if nomiss_ace==1
collect p_e=r(p), tag(model[(3)]): mi test 1.ACC_63 2.ACC_63
collect _r_b _r_ci, tag(model[(1)]): mi estimate: regress acetotfin15x i.ACC_53 sex if nomiss_ace==1
collect p_f=r(p), tag(model[(1)]): mi test 1.ACC_53 2.ACC_53
collect _r_b _r_ci, tag(model[(2)]): mi estimate: regress acetotfin15x i.ACC_53 sex cogchild i.attain_26 if nomiss_ace==1
collect p_f=r(p), tag(model[(2)]): mi test 1.ACC_53 2.ACC_53
collect _r_b _r_ci, tag(model[(3)]): mi estimate: regress acetotfin15x i.ACC_53 sex cogchild i.attain_26 i.chrondisease_53 disa_53 depress_53 if nomiss_ace==1
collect p_f=r(p), tag(model[(3)]): mi test 1.ACC_53 2.ACC_53
collect _r_b _r_ci, tag(model[(4)]): mi estimate: regress acetotfin15x i.ACC_69 i.ACC_63 i.ACC_53 sex cogchild i.attain_26 i.chrondisease_69 disa_69 depress_69 i.chrondisease_63 disa_63 depress_63 i.chrondisease_53 disa_53 depress_53 if nomiss_ace==1
collect p_d=r(p), tag(model[(4)]): mi test 1.ACC_69 2.ACC_69
collect p_e=r(p), tag(model[(4)]): mi test 1.ACC_63 2.ACC_63
collect p_f=r(p), tag(model[(4)]): mi test 1.ACC_53 2.ACC_53

collect layout (colname[1.ACC_69 2.ACC_69]#result result[p_d] colname[1.ACC_63 2.ACC_63]#result result[p_e] colname[1.ACC_53 2.ACC_53]#result result[p_f]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f], level(label)
collect label levels result p_d "p-value for ACBS score (age 69)" p_e "p-value for ACBS score (age 60-64)" p_f "p-value for ACBS score (age 53)"
collect style cell result [p_d p_e p_f], nformat(%5.3f) /*minimum(0.001)*/
collect stars p_d p_e p_f 0.01 "***" 0.05 "** " 0.1 "*  ", attach(p_d p_e p_f) /*shownote*/
collect style showbase off
/*collect title "Cross sectional linear associations between ACBS (ages 53, 60-64 and 69) and ACE-III (age 69)"*/

collect export tablecrossFINAL.docx, replace

*Longitudinal
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", clear
keep SS_* VR_* ACC_* attain_26 cogchild chrondisease_* disa_* sex PP_* nshdid_ntag1 _mi_* depress_*
mi reshape long SS_ VR_ ACC_ PP_ chrondisease_ disa_ depress_, i(nshdid_ntag1) j(wave)
gen phase = .
replace phase = 1 if wave==53
replace phase = 2 if wave==63
replace phase = 3 if wave==69
mi xtset nshdid_ntag1 phase
collect clear
collect create exl1
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): mi test 1.L.ACC_ 2.L.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d] colname[1.L.ACC_ 2.L.ACC_]#result result[p_e]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score"
collect style cell result [p_d p_e], nformat(%5.3f) /*minimum(0.001)*/
collect stars p_d p_e 0.01 "***" 0.05 "** " 0.1 "*  ", attach(p_d p_e) /*shownote*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2vr.docx, replace

collect clear
collect create exl1
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): mi test 1.L.ACC_ 2.L.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d] colname[1.L.ACC_ 2.L.ACC_]#result result[p_e]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score"
collect style cell result [p_d p_e], nformat(%5.3f) /*minimum(0.001)*/
collect stars p_d p_e 0.01 "***" 0.05 "** " 0.1 "*  ", attach(p_d p_e) /*shownote*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Search Speed (ages 53-69)"*/
collect export table2ss.docx, replace

collect clear
collect create exl1
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex, fe
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26, fe
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): mi test 1.L.ACC_ 2.L.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d] colname[1.L.ACC_ 2.L.ACC_]#result result[p_e]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score"
collect style cell result [p_d p_e], nformat(%5.3f) /*minimum(0.001)*/
collect stars p_d p_e 0.01 "***" 0.05 "** " 0.1 "*  ", attach(p_d p_e) /*shownote*/
collect style showbase off
/*collect title "Longitudinal fixed effects panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2vrFE.docx, replace

collect clear
collect create exl1
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex, fe
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26, fe
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): mi test 1.L.ACC_ 2.L.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d] colname[1.L.ACC_ 2.L.ACC_]#result result[p_e]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score"
collect style cell result [p_d p_e], nformat(%5.3f) /*minimum(0.001)*/
collect stars p_d p_e 0.01 "***" 0.05 "** " 0.1 "*  ", attach(p_d p_e) /*shownote*/
collect style showbase off
/*collect title "Longitudinal fixed effects panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2ssFE.docx, replace

******************************************************************PRODUCE GRAPHS************************************************************
**Coefficient plots for cross sectional and longitudinal models (robust and non-robust)
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", clear

mi estimate: regress acetotfin15x i.ACC_69 i.ACC_63 i.ACC_53 sex cogchild i.attain_26 i.chrondisease_69 disa_69 depress_69 i.chrondisease_63 disa_63 depress_63 i.chrondisease_53 disa_53 depress_53 if nomiss_ace==1
estimates store A
mi estimate: regress acetotfin15x i.ACC_69 sex cogchild i.attain_26 i.chrondisease_69 disa_69 depress_69 if nomiss_ace==1
estimates store B
mi estimate: regress acetotfin15x i.ACC_63 sex cogchild i.attain_26 i.chrondisease_63 disa_63 depress_63 if nomiss_ace==1
estimates store C
mi estimate: regress acetotfin15x i.ACC_53 sex cogchild i.attain_26 i.chrondisease_53 disa_53 depress_53 if nomiss_ace==1
estimates store D

coefplot (B C D, label(Model 3) offset(0.2)) (A, label(Model 4) offset (-0.2) m(S)), keep(0.ACC_69 1.ACC_69 2.ACC_69 0.ACC_63 1.ACC_63 2.ACC_63 0.ACC_53 1.ACC_53 2.ACC_53 showbaseline) xline(0) ciopts(recast(rcap)) xtitle("ACE-III Score") coeflabels(0.ACC_69 = "ACBS 0 (age 69)" 1.ACC_69 = "ACBS 1-2 (age 69)" 2.ACC_69 = "ACBS 3+ (age 69)" 0.ACC_63 = "ACBS 0 (age 60-64)" 1.ACC_63 = "ACBS 1-2 (age 60-64)" 2.ACC_63 = "ACBS 3+ (age 60-64)" 0.ACC_53 = "ACBS 0 (age 53)" 1.ACC_53 = "ACBS 1-2 (age 53)" 2.ACC_53 = "ACBS 3+ (age 53)") graphregion(col(white)) bgcol(white)

/*coefplot B C D, bylabel(Model 3)) || A, bylabel(Model 4)) ||, keep(1.ACC_69 2.ACC_69 1.ACC_63 2.ACC_63 1.ACC_53 2.ACC_53) xline(0) ciopts(recast(rcap)) xtitle("ACE-III Score") ytitle("Anticholinergic Burden") title("Figure 1: Coefficient plot of associations between ACBS score and ACE-III score at age 69", size(2))*/

use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", clear
keep SS_* VR_* ACC_* attain_26 cogchild chrondisease_* disa_* sex PP_* nshdid_ntag1 _mi_* depress_* nomiss_*
mi reshape long SS_ VR_ ACC_ PP_ chrondisease_ disa_ depress_, i(nshdid_ntag1) j(wave)
gen phase = .
replace phase = 1 if wave==43
replace phase = 2 if wave==53
replace phase = 3 if wave==63
replace phase = 4 if wave==69
mi xtset nshdid_ntag1 phase

mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, vce(robust)
estimates store vrA
mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe vce(robust)
estimates store vrFE
mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_ vce(robust)
estimates store ssA
mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe vce(robust)
estimates store ssFE

coefplot (vrA, label(Random Effects)) (vrFE, label(Mixed Effects) m(S)), bylabel(Verbal Recall) || (ssA, label(Mixed Effects)) (ssFE, label(Fixed Effects) m(S)), bylabel(Search Speed)||, keep(1.ACC_ 2.ACC_ 1L.ACC_ 2L.ACC_) xline(0) ciopts(recast(rcap)) byopts(xrescale) coeflabels(1.ACC_ = "Contemp. ACBS 1-2" 2.ACC_ = "Contemp. ACBS 3+" 1L.ACC_ = "Lagged ACBS 1-2" 2L.ACC_ = "Lagged ACBS 3+") subtitle(, fcolor(white) lcolor(black)) graphregion(col(white)) bgcol(white)

use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", clear
keep SS_* VR_* ACC_* attain_26 cogchild chrondisease_* disa_* sex PP_* nshdid_ntag1 _mi_* depress_* nomiss_*
mi reshape long SS_ VR_ ACC_ PP_ chrondisease_ disa_ depress_, i(nshdid_ntag1) j(wave)
gen phase = .
replace phase = 1 if wave==43
replace phase = 2 if wave==53
replace phase = 3 if wave==63
replace phase = 4 if wave==69
mi xtset nshdid_ntag1 phase

mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
estimates store vrA
mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
estimates store vrFE
mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
estimates store ssA
mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
estimates store ssFE

coefplot (vrA, label(Random Effects)) (vrFE, label(Mixed Effects) m(S)), bylabel(Verbal Recall) || (ssA, label(Mixed Effects)) (ssFE, label(Fixed Effects) m(S)), bylabel(Search Speed)||, keep(1.ACC_ 2.ACC_ 1L.ACC_ 2L.ACC_) xline(0) ciopts(recast(rcap)) byopts(xrescale) coeflabels(1.ACC_ = "Contemp. ACBS 1-2" 2.ACC_ = "Contemp. ACBS 3+" 1L.ACC_ = "Lagged ACBS 1-2" 2L.ACC_ = "Lagged ACBS 3+") subtitle(, fcolor(white) lcolor(black)) graphregion(col(white)) bgcol(white)

**************************************************************SENSITIVITY ANALYSES TABLES************************************************************
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\complete case.dta", clear
merge 1:1 nshdid_ntag1 using "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\D&A extra variables.dta"
drop if sex==.
gen nomissace = 0
replace nomissace = 1 if acetotfin15x!=.
recode *_modsev (-9=.)

*COMPLETE CASE, CROSS SECTIONAL
*clear collection
collect clear

*create collection model for table
collect create ex1

*regressions, _b coefficient _ci confidence interval in multiple models
*p_d p_e creat extra variables based on p values from testparm
collect _r_b _r_ci, tag(model[(1)]): regress acetotfin15x i.ACC_69 sex
collect p_d=r(p), tag(model[(1)]): testparm 1.ACC_69 2.ACC_69
collect _r_b _r_ci, tag(model[(2)]): regress acetotfin15x i.ACC_69 sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): testparm 1.ACC_69 2.ACC_69
collect _r_b _r_ci, tag(model[(3)]): regress acetotfin15x i.ACC_69 sex cogchild i.attain_26 i.chrondisease_69 disa_69 depress_69
collect p_d=r(p), tag(model[(3)]): testparm 1.ACC_69 2.ACC_69
collect _r_b _r_ci, tag(model[(1)]): regress acetotfin15x i.ACC_63 sex if nomissace==1
collect p_e=r(p), tag(model[(1)]): testparm 1.ACC_63 2.ACC_63
collect _r_b _r_ci, tag(model[(2)]): regress acetotfin15x i.ACC_63 sex cogchild i.attain_26 if nomissace==1
collect p_e=r(p), tag(model[(2)]): testparm 1.ACC_63 2.ACC_63
collect _r_b _r_ci, tag(model[(3)]): regress acetotfin15x i.ACC_63 sex cogchild i.attain_26 i.chrondisease_63 disa_63 depress_63
collect p_e=r(p), tag(model[(3)]): testparm 1.ACC_63 2.ACC_63
collect _r_b _r_ci, tag(model[(1)]): regress acetotfin15x i.ACC_53 sex if nomissace==1
collect p_f=r(p), tag(model[(1)]): testparm 1.ACC_53 2.ACC_53
collect _r_b _r_ci, tag(model[(2)]): regress acetotfin15x i.ACC_53 sex cogchild i.attain_26 if nomissace==1
collect p_f=r(p), tag(model[(2)]): testparm 1.ACC_53 2.ACC_53
collect _r_b _r_ci, tag(model[(3)]): regress acetotfin15x i.ACC_53 sex cogchild i.attain_26 i.chrondisease_53 disa_53 depress_53
collect p_f=r(p), tag(model[(3)]): testparm 1.ACC_53 2.ACC_53
collect _r_b _r_ci, tag(model[(4)]): regress acetotfin15x i.ACC_69 i.ACC_63 i.ACC_53 sex cogchild i.attain_26 i.chrondisease_69 disa_69 depress_69 i.chrondisease_63 disa_63 depress_63 i.chrondisease_53 disa_53 depress_53
collect p_d=r(p), tag(model[(4)]): testparm 1.ACC_69 2.ACC_69
collect p_e=r(p), tag(model[(4)]): testparm 1.ACC_63 2.ACC_63
collect p_f=r(p), tag(model[(4)]): testparm 1.ACC_53 2.ACC_53

collect layout (colname[1.ACC_69 2.ACC_69]#result result[p_d] colname[1.ACC_63 2.ACC_63]#result result[p_e] colname[1.ACC_53 2.ACC_53]#result result[p_f]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f], level(label)
collect label levels result p_d "p-value for ACBS score (age 69)" p_e "p-value for ACBS score (age 60-64)" p_f "p-value for ACBS score (age 53)"
collect style cell result [p_d p_e p_f], nformat(%5.3f) /*minimum(0.001)*/
collect stars p_d p_e p_f 0.01 "***" 0.05 "** " 0.1 "*  ", attach(p_d p_e p_f) /*shownote*/
collect style showbase off
/*collect title "Cross sectional linear associations between ACBS (ages 53, 60-64 and 69) and ACE-III (age 69)"*/

collect export tablecrossFINALsense24.docx, replace

*FULL DISEASE COUNT (LONG IMUPTATION TIME)
/*mi set flong
mi register imputed cogchild attain_26 ACC_* PP_* VR_* SS_* *_modsev acetotfin15x 
mi impute chained (regress) cogchild (logit) PP_* *_modsev (ologit) attain_26 ACC_* (pmm, knn(10)) VR_* SS_* acetotfin15x = sex, rseed(270186) add(15) augment*/

use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\GitHub\full disease imputed.dta"

mi estimate: regress acetotfin15x i.ACC_69 sex attain_26 cogchild *_modsev if nomissace==1
mi test 1.ACC_69 2.ACC_69
mi estimate: regress acetotfin15x i.ACC_63 sex attain_26 cogchild *_modsev if nomissace==1
mi test 1.ACC_63 2.ACC_63
mi estimate: regress acetotfin15x i.ACC_53 sex attain_26 cogchild *_modsev if nomissace==1
mi test 1.ACC_53 2.ACC_53

*COMPLETE CASE (LONG)
*COMPLETE VERBAL RECALL
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\complete case.dta", clear
drop *_43
drop if VR_53==.
drop if VR_63==.
drop if VR_69==.

keep VR_* ACC_* attain_26 cogchild chrondisease_* disa_* depress_* sex PP_* nshdid_ntag1 
reshape long VR_ ACC_ PP_ disa_ chrondisease_ depress_, i(nshdid_ntag1) j(wave)

*Create phase variable to account for time difference
gen phase = .
replace phase = 1 if wave==53
replace phase = 2 if wave==63
replace phase = 3 if wave==69
collect clear
collect create exl1

*Set data for analysis
xtset nshdid_ntag1 phase

collect clear
collect create exl1

collect _r_b _r_ci _r_p, tag(model[(1)]): xtreg VR_ i.ACC_ L1.i.ACC_ sex
collect p_d=r(p), tag(model[(1)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): testparm 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(2)]): xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): testparm 1.L.ACC_ 2.L.ACC_
collect p_f=r(p), tag(model[(2)]): testparm 1.attain_26 2.attain_26
collect _r_b _r_ci _r_p, tag(model[(3)]): xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
collect p_d=r(p), tag(model[(3)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): testparm 1.L.ACC_ 2.L.ACC_
collect p_f=r(p), tag(model[(3)]): testparm 1.attain_26 2.attain_26
collect p_g=r(p), tag(model[(3)]): testparm 1.chrondisease_ 2.chrondisease_ 3.chrondisease_

collect layout (colname#result result[p_d p_e p_f p_g]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect levelsof cell_type
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
collect stars _r_p 0.01 "***" 0.05 "** " 0.1 "*  ", attach(_r_b) /*shownote*/
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f p_g], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score" p_f "p-value for education" p_g "p-value for chronic disease count"
collect style cell result [p_d p_e p_f p_g], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Verbal Recall (ages 53-69)"*/

collect export table2vrsense24CC.docx, replace

collect clear
collect create exl1fe

collect _r_b _r_ci _r_p, tag(model[(1)]): xtreg VR_ i.ACC_ L1.i.ACC_ sex, fe
collect p_d=r(p), tag(model[(1)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): testparm 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(2)]): xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26, fe
collect p_d=r(p), tag(model[(2)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): testparm 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(3)]): xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
collect p_d=r(p), tag(model[(3)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): testparm 1.L.ACC_ 2.L.ACC_
collect p_g=r(p), tag(model[(3)]): testparm 1.chrondisease_ 2.chrondisease_ 3.chrondisease_

collect layout (colname#result result[p_d p_e p_f p_g]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect levelsof cell_type
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
collect stars _r_p 0.01 "***" 0.05 "** " 0.1 "*  ", attach(_r_b) /*shownote*/
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f p_g], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score" p_f "p-value for education" p_g "p-value for chronic disease count"
collect style cell result [p_d p_e p_f p_g], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal fixed effects panel model associations between ACBS and Verbal Recall (ages 53-69)"*/

collect export table2vrFEsense24CC.docx, replace

use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\complete case.dta", clear
drop *_43
drop if SS_53==.
drop if SS_63==.
drop if SS_69==.

keep SS_* ACC_* attain_26 cogchild chrondisease_* disa_* depress_* sex PP_* nshdid_ntag1 
reshape long SS_ ACC_ PP_ disa_ chrondisease_ depress_, i(nshdid_ntag1) j(wave)

gen phase = .
replace phase = 1 if wave==53
replace phase = 2 if wave==63
replace phase = 3 if wave==69
collect clear
collect create exl1

*Set data for analysis
xtset nshdid_ntag1 phase

collect clear
collect create exl2

collect _r_b _r_ci _r_p, tag(model[(1)]): xtreg SS_ i.ACC_ L1.i.ACC_ sex
collect p_d=r(p), tag(model[(1)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): testparm 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(2)]): xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): testparm 1.L.ACC_ 2.L.ACC_
collect p_f=r(p), tag(model[(2)]): testparm 1.attain_26 2.attain_26
collect _r_b _r_ci _r_p, tag(model[(3)]): xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
collect p_d=r(p), tag(model[(3)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): testparm 1.L.ACC_ 2.L.ACC_
collect p_f=r(p), tag(model[(3)]): testparm 1.attain_26 2.attain_26
collect p_g=r(p), tag(model[(3)]): testparm 1.chrondisease_ 2.chrondisease_ 3.chrondisease_

collect layout (colname#result result[p_d p_e p_f p_g]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect levelsof cell_type
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
collect stars _r_p 0.01 "***" 0.05 "** " 0.1 "*  ", attach(_r_b) /*shownote*/
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f p_g], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score" p_f "p-value for education" p_g "p-value for chronic disease count"
collect style cell result [p_d p_e p_f p_g], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Search Speed (ages 53-69)"*/

collect export table2sssense24CC.docx, replace

collect clear
collect create exl2fe

collect _r_b _r_ci _r_p, tag(model[(1)]): xtreg SS_ i.ACC_ L1.i.ACC_ sex, fe
collect p_d=r(p), tag(model[(1)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): testparm 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(2)]): xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26, fe
collect p_d=r(p), tag(model[(2)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): testparm 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(3)]): xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
collect p_d=r(p), tag(model[(3)]): testparm 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): testparm 1.L.ACC_ 2.L.ACC_
collect p_g=r(p), tag(model[(3)]): testparm 1.chrondisease_ 2.chrondisease_ 3.chrondisease_

collect layout (colname#result result[p_d p_e p_f p_g]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect levelsof cell_type
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
collect stars _r_p 0.01 "***" 0.05 "** " 0.1 "*  ", attach(_r_b) /*shownote*/
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f p_g], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score" p_f "p-value for education" p_g "p-value for chronic disease count"
collect style cell result [p_d p_e p_f p_g], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal fixed effects panel model associations between ACBS and Verbal Recall (ages 53-69)"*/

collect export table2ssFEsense24CC.docx, replace

**SENSITIVITY FOR DROPPING LAGGED FROM MODEL
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", clear
keep SS_* VR_* ACC_* attain_26 cogchild chrondisease_* disa_* sex PP_* nshdid_ntag1 _mi_* depress_*
mi reshape long SS_ VR_ ACC_ PP_ chrondisease_ disa_ depress_, i(nshdid_ntag1) j(wave)
gen phase = .
replace phase = 1 if wave==53
replace phase = 2 if wave==63
replace phase = 3 if wave==69
mi xtset nshdid_ntag1 phase
collect clear
collect create exl1
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg VR_ i.ACC_ sex
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg VR_ i.ACC_ sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg VR_ i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d], level(label)
collect label levels result p_d "p-value for ACBS score"
collect style cell result [p_d], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2vrSENSE24nolag.docx, replace

collect clear
collect create exl2
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg VR_ i.ACC_ sex, fe
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg VR_ i.ACC_ sex cogchild i.attain_26, fe
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg VR_ i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d], level(label)
collect label levels result p_d "p-value for ACBS score"
collect style cell result [p_d], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2vrSENSE24nolagFE.docx, replace

collect clear
collect create exl3
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg SS_ i.ACC_ sex
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg SS_ i.ACC_ sex cogchild i.attain_26
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg SS_ i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d], level(label)
collect label levels result p_d "p-value for ACBS score"
collect style cell result [p_d], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2ssSENSE24nolag.docx, replace

collect clear
collect create exl4
collect _r_b _r_ci, tag(model[(1)]): mi estimate: xtreg SS_ i.ACC_ sex, fe
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(2)]): mi estimate: xtreg SS_ i.ACC_ sex cogchild i.attain_26, fe
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect _r_b _r_ci, tag(model[(3)]): mi estimate: xtreg SS_ i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_, fe
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect layout (colname[1.ACC_ 2.ACC_]#result result[p_d]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d], level(label)
collect label levels result p_d "p-value for ACBS score"
collect style cell result [p_d], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal panel model associations between ACBS and Verbal Recall (ages 53-69)"*/
collect export table2ssSENSE24nolagFE.docx, replace

*POLYPHARMACY SENSITIVITY ANALYSIS
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\NSHD Anticholinergics FINAL ANALYSES\imputed-aug16b.dta", clear
keep SS_* VR_* ACC_* attain_26 cogchild chrondisease_* disa_* sex PP_* nshdid_ntag1 _mi_* depress_*
mi reshape long SS_ VR_ ACC_ PP_ chrondisease_ disa_ depress_, i(nshdid_ntag1) j(wave)
gen phase = .
replace phase = 1 if wave==53
replace phase = 2 if wave==63
replace phase = 3 if wave==69
mi xtset nshdid_ntag1 phase
collect clear
collect create exl1

collect _r_b _r_ci _r_p, tag(model[(1)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_ PP_
collect p_d=r(p), tag(model[(1)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(1)]): mi test 1.L.ACC_ 2.L.ACC_
collect p_f=r(p), tag(model[(1)]): mi test 1.attain_26 2.attain_26
collect p_g=r(p), tag(model[(1)]): mi test 1.chrondisease_ 2.chrondisease_ 3.chrondisease_
collect _r_b _r_ci _r_p, tag(model[(2)]): mi estimate: xtreg VR_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_ PP_, fe
collect p_d=r(p), tag(model[(2)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(2)]): mi test 1.L.ACC_ 2.L.ACC_
collect _r_b _r_ci _r_p, tag(model[(3)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_ PP_
collect p_d=r(p), tag(model[(3)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(3)]): mi test 1.L.ACC_ 2.L.ACC_
collect p_f=r(p), tag(model[(3)]): mi test 1.attain_26 2.attain_26
collect p_g=r(p), tag(model[(3)]): mi test 1.chrondisease_ 2.chrondisease_ 3.chrondisease_
collect _r_b _r_ci _r_p, tag(model[(4)]): mi estimate: xtreg SS_ i.ACC_ L1.i.ACC_ sex cogchild i.attain_26 i.chrondisease_ disa_ depress_ PP_, fe
collect p_d=r(p), tag(model[(4)]): mi test 1.ACC_ 2.ACC_
collect p_e=r(p), tag(model[(4)]): mi test 1.L.ACC_ 2.L.ACC_
collect layout (colname#result result[p_d p_e p_f p_g]) (model)
collect style cell, nformat(%5.2f)
collect style cell result [_r_ci], sformat("(%s)") cidelimiter(", ")
collect style cell result [_r_p], nformat(%5.3f)
collect style cell border_block, border(right, pattern(nil))
collect levelsof cell_type
collect style cell cell_type[item column-header], halign(center)
collect style header result, level(hide)
collect style column, extraspace(1)
collect style row stack, spacer delimiter(" x ")
collect stars _r_p 0.01 "***" 0.05 "** " 0.1 "*  ", attach(_r_b) /*shownote*/
/*collect notes : "*** p<0.01, ** p<0.05, * p<0.1"*/
collect style header result[p_d p_e p_f p_g], level(label)
collect label levels result p_d "p-value for ACBS score" p_e "p-value for lagged ACBS score" p_f "p-value for education" p_g "p-value for chronic disease count"
collect style cell result [p_d p_e p_f p_g], nformat(%5.3f) /*minimum(0.001)*/
collect style showbase off
/*collect title "Longitudinal fixed effects panel model associations between ACBS and Verbal Recall (ages 53-69)"*/

collect export table3-polypharm.docx, replace