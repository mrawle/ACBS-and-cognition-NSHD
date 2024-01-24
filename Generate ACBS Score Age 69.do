*************STATA SCRIPT START************* 
 
*USE DATA (NO AMYLOID)
use "S:\LHA_MR1021\skylark_baskets\R Analysis - Antichol Amyloid\antichol-noamyloid.dta", clear

*************RECODE CONFOUNDERS START************* 

recode ghq99_sumrec (-9=.) (-7=.) (-6=.)
recode ghq99_caseness (-7=.) (-6=.) (2=.)
recode ghq15_sumxrec (-9=.) (-7=.)
recode ghq15_casenessx (2=.) (-7=.)
recode ghq09rec (-9=.) (-7=.)
recode ghq09_v2 (77=.) (99=.)
gen ghq09_caseness=0
replace ghq09_caseness=1 if ghq09_v2>=5
replace ghq09_caseness=. if ghq09rec==.
label variable ghq09_caseness "Derived: GHQ caseness (5+)"
label values ghq09_caseness ghq09_caseness
label define ghq09_caseness 1 "GHQ Score 5+" 0 "GHQ score <5"

*************RECODE MEDICATION START************* 

*recode medication variables.
recode med*n15x (999995=.) (999996=.) (999997=.) (999999=.) (999998=0)
recode med*n09 (77777777=.) (88888888=0) (99999999=0)
recode med*77 (-9999=.) (8=.)
recode ohom (2=0)
recode ohom89 (9=.)
recode meds77 (9=.)

replace meds77 = 1 if nshdid_ntag1 == 14149223
replace meds77 = 0 if nshdid_ntag1 == 13376529
replace meds77 = 0 if nshdid_ntag1 == 13487326
replace meds77 = 0 if nshdid_ntag1 == 13788928
replace meds77 = 0 if nshdid_ntag1 == 14407723
replace meds77 = 0 if nshdid_ntag1 == 14862729
replace meds77 = 0 if nshdid_ntag1 == 17910825
replace meds77 = 0 if nshdid_ntag1 == 19017611

replace medn15x = 1 if nshdid_ntag1 == 18493715
replace nummeds15x = 3 if nshdid_ntag1 == 18493715
replace med1n15x = 43455 if nshdid_ntag1 == 18493715
replace med2n15x = 96253 if nshdid_ntag1 == 18493715
replace med3n15x = 13551 if nshdid_ntag1 == 18493715
foreach v of varlist med4n15x-med21n15x {
replace `v' = 0 if nshdid_ntag1 == 18493715
}

replace med1n15x = med2n15x if nshdid_ntag1 == 10215718
replace med2n15x = med3n15x if nshdid_ntag1 == 10215718
replace med3n15x = med4n15x if nshdid_ntag1 == 10215718
replace med4n15x = med5n15x if nshdid_ntag1 == 10215718
replace med5n15x = med6n15x if nshdid_ntag1 == 10215718
replace med6n15x = med7n15x if nshdid_ntag1 == 10215718
replace med7n15x = med8n15x if nshdid_ntag1 == 10215718

****************************************CODE ANTICHOLINERGIC VARIABLES FOR AGE 69 START************************************************ 

*GENERATE ANTICHOLINERGIC BURDEN SCORES
*AGE 69
gen antichol_69x=.

foreach x of varlist med*n15x {                                                                
replace antichol_69x=0 if `x'==0
}

*BURDEN SCORE 1
*Alimemazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==34162
}
*Alverine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==12006 | `x'==12053
}
*Alprazolam
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==41201
}
*Atenolol
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==24002 | `x'==24007 | `x'==24009 | `x'==24012 | `x'==24015 | `x'==24017 | `x'==24022 | `x'==24052
}
*Brompheniramine maleate
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==34107
}
*Bupropion hydrochloride : NONE IN NSHD.
*Captopril
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==25501 | `x'==25506 | `x'==25551
}
*Chlorthalidone
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==24053
}
*Cimetidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==13102 | `x'==13104 | `x'==13106 | `x'==13152
}
*Ranitidine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==13101 | `x'==13109 | `x'==13151
}
*Clorazepate
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==41208
}
*Codine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==14252 | `x'==39152 | `x'==39153 | `x'==47102 | `x'==47103 | `x'==47107 | `x'==47108 | `x'==47112 | `x'==47113 | `x'==47114 | `x'==47118 | `x'==47121 | `x'==47152 | `x'==47157 | `x'==47252
}
*Colchicine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==101453
}
*Coumadin
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==28201 | `x'==28251
}
*Diazepam
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==41202 | `x'==41206 | `x'==41253 | `x'==48251 | `x'==102254 
}
*Digoxin
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==21101 | `x'==21151
}
*Dipyridamole
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==29001 | `x'==29006 | `x'==29051
}
*Disopyramide phosphate
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==23201 | `x'==23251
}
*Fentanyl: NONE IN NSHD.
*Furosemide
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==22201 | `x'==22251 | `x'==22405 | `x'==22407 | `x'==22409 | `x'==22414 | `x'==22454 | `x'==22804 | `x'==25904
}
*Fluvoxamine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==43404
}
*Haloperidol
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==42154
}
*Hydralazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==25152
}
*Hydrocortisone
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==63401 | `x'==63452
}
*Isosorbide
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==26101 | `x'==26105 | `x'==26109 | `x'==26112 | `x'==26113 | `x'==26115 | `x'==26116 | `x'==26152
}
*Loperamide
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==14201 | `x'==14251
}
*Metoprolol
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==24008 | `x'==24020 | `x'==24059
}
*Morphine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==14203 | `x'==14254 | `x'==47203 | `x'==47208 | `x'==47210 | `x'==47217 | `x'==47253 | `x'==47254 | `x'==47259
}
*Nifedipine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==26201 | `x'==26203 | `x'==26205 | `x'==26209 | `x'==26212 | `x'==26216 | `x'==26228 | `x'==26253
}
*Prednisolone
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==63451
}
*Quinidine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==23254
}
*Risperidone
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==42104 | `x'==42162
}
*Theophylline
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==31302 | `x'==31303 | `x'==31305 | `x'==31352 | `x'==39210
}
*Trazodone
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==43112 | `x'==43160
}
*Triamterene
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==22353
}
*2012 UPDATE
*Aripiprazole
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==42109 | `x'==42163
}
*Asenapine: NONE IN NSHD
*Cetirizine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==34105 | `x'==34154
}
*Clidinium: NONE IN NSHD
*Desloratadine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==34117 | `x'==34160
}
*Iloperidone: NONE IN NSHD
*Levocetirizine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==34163
}
*Loratadine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==34103 | `x'==34156
}
*Paliperidone: NONE IN NSHD
*Venlafaxine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +1) if `x'==43456 | `x'==43407
}


*BURDEN SCORE 2
*Amantadine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +2) if `x'==49154
}
*Belladone alkaloids: NONE IN NSHD.
*Carbamazapine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +2) if `x'==42352 | `x'==47351 | `x'==48102 | `x'==48106 | `x'==48114 | `x'==48152
}
*Cyclobenzaprine: NONE IN NSHD.
*Cyproheptadine: NONE IN NSHD.
*Empracet: NONE IN NSHD.
*Loxapine: NONE IN NSHD.
*Meperidine: LISTED UNDER PETHIDINE IN NSHD.
*Methotrimeprazine: NONE IN NSHD.
*Molindone: NONE IN NSHD.
*Oxcarbazepine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +2) if `x'==48165
}
*Pethidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +2) if `x'==47255
}
*Pimozide
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +2) if `x'==42107
}
*2012 UPDATE
*Nefopam
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +2) if `x'==47156
}


*BURDEN SCORE 3
*Amitriptyline
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43102 | `x'==43113 | `x'==43116 | `x'==43154
}
*Amoxapine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43109
}
*Atropine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==14202 | `x'==14253
}
*Benztropine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==49252
}
*Brompheniramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==39205
}
*Carbinoxamine: NONE IN NSHD.
*Chlorpheniramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==34102 | `x'==34152 | `x'==39208
}
*Chlorpromazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42106 | `x'==42151
}
*Clemastine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==34111 | `x'==34157
}
*Clomipramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43106 | `x'==43152
}
*Clozapine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42159
}
*Darifenacin: NONE IN NSHD.
*Desipramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43161
}
*Dicyclomine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==12003
}
*Dimenhydrinate
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==39211 | `x'==34109 | `x'==34114 | `x'==34112
}
*Diphenhydramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==34109 | `x'==34112 | `x'==34114 | `x'==34112
}
*Doxepin
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43103 | `x'==43108 | `x'==43156
}
*Flavoxate
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==74202 | `x'==74255
}
*Hydroxyzine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==34106 | `x'==34153
}
*Hyoscyamine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==12052
}
*Imipramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43114 | `x'==43158
}
*Meclizine: NONE IN NSHD.
*Nortriptyline
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43110 | `x'==43117 | `x'==43118 | `x'==43159 | `x'==43301
}
*Olanzapine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42157
}
*Orphenadrine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==47129 | `x'==49202 | `x'==49253
}
*Oxybutynin
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==74201 | `x'==74251
}
*Paroxetine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43111
}
*Perphenazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42108
}
*Procyclidine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==49203 | `x'==49251
}
*Promazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42153
}
*Promethazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==34108 | `x'==39203 | `x'==39208
}
*Propentheline
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==12009
}
*Propiverine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==74256
}
*Quetiapine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42161
}
*Scopolamine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==12001
}
*Thioridazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42102 | `x'==42152
}
*Tolterodine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==74203 | `x'==74252
}
*Trifluoperazine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==42101 | `x'==42164 | `x'==46055
}
*Trihexyphenidy
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==49201 | `x'==49252
}
*Trimipramine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==43104 | `x'==43157
}
*2012 UPDATE
*Doxylamine
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==34158 | `x'==47112
}
*Fesoterodine: NONE IN NSHD
*Solifenacin
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==74254  | `x'==74204
}
*Trospium
foreach x of varlist med*n15x {                                                                
replace antichol_69x=(antichol_69x +3) if `x'==74253
}

label values antichol_69x antichol_69x
label variable antichol_69x "Derived: Anticholinergic burden age 69"

*GENERATE ACBS 1 SUBSCORES
*AGE 69
gen antichol1count_69x=.

foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=0 if `x'==0
}

*BURDEN SCORE 1
*Alimemazine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==34162
}
*Alverine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==12006 | `x'==12053
}
*Alprazolam
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==41201
}
*Atenolol
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==24002 | `x'==24007 | `x'==24009 | `x'==24012 | `x'==24015 | `x'==24017 | `x'==24022 | `x'==24052
}
*Brompheniramine maleate
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==34107
}
*Bupropion hydrochloride : NONE IN NSHD.
*Captopril
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==25501 | `x'==25506 | `x'==25551
}
*Chlorthalidone
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==24053
}
*Cimetidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==13102 | `x'==13104 | `x'==13106 | `x'==13152
}
*Ranitidine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==13101 | `x'==13109 | `x'==13151
}
*Clorazepate
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==41208
}
*Codine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==14252 | `x'==39152 | `x'==39153 | `x'==47102 | `x'==47103 | `x'==47107 | `x'==47108 | `x'==47112 | `x'==47113 | `x'==47114 | `x'==47118 | `x'==47121 | `x'==47152 | `x'==47157 | `x'==47252
}
*Colchicine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==101453
}
*Coumadin
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==28201 | `x'==28251
}
*Diazepam
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==41202 | `x'==41206 | `x'==41253 | `x'==48251 | `x'==102254 
}
*Digoxin
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==21101 | `x'==21151
}
*Dipyridamole
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==29001 | `x'==29006 | `x'==29051
}
*Disopyramide phosphate
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==23201 | `x'==23251
}
*Fentanyl: NONE IN NSHD.
*Furosemide
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==22201 | `x'==22251 | `x'==22405 | `x'==22407 | `x'==22409 | `x'==22414 | `x'==22454 | `x'==22804 | `x'==25904
}
*Fluvoxamine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==43404
}
*Haloperidol
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==42154
}
*Hydralazine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==25152
}
*Hydrocortisone
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==63401 | `x'==63452
}
*Isosorbide
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==26101 | `x'==26105 | `x'==26109 | `x'==26112 | `x'==26113 | `x'==26115 | `x'==26116 | `x'==26152
}
*Loperamide
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==14201 | `x'==14251
}
*Metoprolol
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==24008 | `x'==24020 | `x'==24059
}
*Morphine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==14203 | `x'==14254 | `x'==47203 | `x'==47208 | `x'==47210 | `x'==47217 | `x'==47253 | `x'==47254 | `x'==47259
}
*Nifedipine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==26201 | `x'==26203 | `x'==26205 | `x'==26209 | `x'==26212 | `x'==26216 | `x'==26228 | `x'==26253
}
*Prednisolone
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==63451
}
*Quinidine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==23254
}
*Risperidone
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==42104 | `x'==42162
}
*Theophylline
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==31302 | `x'==31303 | `x'==31305 | `x'==31352 | `x'==39210
}
*Trazodone
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==43112 | `x'==43160
}
*Triamterene
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==22353
}
*2012 UPDATE
*Aripiprazole
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==42109 | `x'==42163
}
*Asenapine: NONE IN NSHD
*Cetirizine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==34105 | `x'==34154
}
*Clidinium: NONE IN NSHD
*Desloratadine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==34117 | `x'==34160
}
*Iloperidone: NONE IN NSHD
*Levocetirizine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==34163
}
*Loratadine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==34103 | `x'==34156
}
*Paliperidone: NONE IN NSHD
*Venlafaxine
foreach x of varlist med*n15x {                                                                
replace antichol1count_69x=(antichol1count_69x +1) if `x'==43456 | `x'==43407
}

label values antichol1count_69x antichol1count_69x
label variable antichol1count_69x "Derived: Count of ACBS1 Drugs age 69"

*GENERATE ACBS 2 SUBSCORES
*AGE 69

gen antichol2count_69x=.

foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=0 if `x'==0
}

*BURDEN SCORE 2
*Amantadine
foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=(antichol2count_69x +1) if `x'==49154
}
*Belladone alkaloids: NONE IN NSHD.
*Carbamazapine
foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=(antichol2count_69x +1) if `x'==42352 | `x'==47351 | `x'==48102 | `x'==48106 | `x'==48114 | `x'==48152
}
*Cyclobenzaprine: NONE IN NSHD.
*Cyproheptadine: NONE IN NSHD.
*Empracet: NONE IN NSHD.
*Loxapine: NONE IN NSHD.
*Meperidine: LISTED UNDER PETHIDINE IN NSHD.
*Methotrimeprazine: NONE IN NSHD.
*Molindone: NONE IN NSHD.
*Oxcarbazepine
foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=(antichol2count_69x +1) if `x'==48165
}
*Pethidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=(antichol2count_69x +1) if `x'==47255
}
*Pimozide
foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=(antichol2count_69x +1) if `x'==42107
}
*2012 UPDATE
*Nefopam
foreach x of varlist med*n15x {                                                                
replace antichol2count_69x=(antichol2count_69x +1) if `x'==47156
}

label values antichol2count_69x antichol2count_69x
label variable antichol2count_69x "Derived: Count of ACBS2 Drugs age 69"

*GENERATE ACBS 3 SUBSCORES
*AGE 69

gen antichol3count_69x=.

foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=0 if `x'==0
}

*BURDEN SCORE 3
*Amitriptyline
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43102 | `x'==43113 | `x'==43116 | `x'==43154
}
*Amoxapine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43109
}
*Atropine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==14202 | `x'==14253
}
*Benztropine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==49252
}
*Brompheniramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==39205
}
*Carbinoxamine: NONE IN NSHD.
*Chlorpheniramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==34102 | `x'==34152 | `x'==39208
}
*Chlorpromazine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42106 | `x'==42151
}
*Clemastine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==34111 | `x'==34157
}
*Clomipramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43106 | `x'==43152
}
*Clozapine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42159
}
*Darifenacin: NONE IN NSHD.
*Desipramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43161
}
*Dicyclomine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==12003
}
*Dimenhydrinate
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==39211 | `x'==34109 | `x'==34114 | `x'==34112
}
*Diphenhydramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==34109 | `x'==34112 | `x'==34114 | `x'==34112
}
*Doxepin
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43103 | `x'==43108 | `x'==43156
}
*Flavoxate
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==74202 | `x'==74255
}
*Hydroxyzine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==34106 | `x'==34153
}
*Hyoscyamine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==12052
}
*Imipramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43114 | `x'==43158
}
*Meclizine: NONE IN NSHD.
*Nortriptyline
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43110 | `x'==43117 | `x'==43118 | `x'==43159 | `x'==43301
}
*Olanzapine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42157
}
*Orphenadrine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==47129 | `x'==49202 | `x'==49253
}
*Oxybutynin
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==74201 | `x'==74251
}
*Paroxetine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43111
}
*Perphenazine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42108
}
*Procyclidine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==49203 | `x'==49251
}
*Promazine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42153
}
*Promethazine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==34108 | `x'==39203 | `x'==39208
}
*Propentheline
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==12009
}
*Propiverine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==74256
}
*Quetiapine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42161
}
*Scopolamine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==12001
}
*Thioridazine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42102 | `x'==42152
}
*Tolterodine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==74203 | `x'==74252
}
*Trifluoperazine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==42101 | `x'==42164 | `x'==46055
}
*Trihexyphenidy
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==49201 | `x'==49252
}
*Trimipramine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==43104 | `x'==43157
}
*2012 UPDATE
*Doxylamine
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==34158 | `x'==47112
}
*Fesoterodine: NONE IN NSHD
*Solifenacin
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==74254  | `x'==74204
}
*Trospium
foreach x of varlist med*n15x {                                                                
replace antichol3count_69x=(antichol3count_69x +1) if `x'==74253
}

label values antichol3count_69x antichol3count_69x
label variable antichol3count_69x "Derived: Count of ACBS3 Drugs age 69"

*GENERATE 'MOST SEVERE DRUG' ANTICHOLINERGIC BURDEN SCORES
*AGE 69
gen anticholcat_69x=.

foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=0 if `x'==0
}

*BURDEN SCORE 1
*Alimemazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==34162
}
*Alverine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==12006 | `x'==12053
}
*Alprazolam
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==41201
}
*Atenolol
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==24002 | `x'==24007 | `x'==24009 | `x'==24012 | `x'==24015 | `x'==24017 | `x'==24022 | `x'==24052
}
*Brompheniramine maleate
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==34107
}
*Bupropion hydrochloride : NONE IN NSHD.
*Captopril
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==25501 | `x'==25506 | `x'==25551
}
*Chlorthalidone
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==24053
}
*Cimetidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==13102 | `x'==13104 | `x'==13106 | `x'==13152
}
*Ranitidine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==13101 | `x'==13109 | `x'==13151
}
*Clorazepate
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==41208
}
*Codine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==14252 | `x'==39152 | `x'==39153 | `x'==47102 | `x'==47103 | `x'==47107 | `x'==47108 | `x'==47112 | `x'==47113 | `x'==47114 | `x'==47118 | `x'==47121 | `x'==47152 | `x'==47157 | `x'==47252
}
*Colchicine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==101453
}
*Coumadin
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==28201 | `x'==28251
}
*Diazepam
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==41202 | `x'==41206 | `x'==41253 | `x'==48251 | `x'==102254 
}
*Digoxin
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==21101 | `x'==21151
}
*Dipyridamole
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==29001 | `x'==29006 | `x'==29051
}
*Disopyramide phosphate
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==23201 | `x'==23251
}
*Fentanyl: NONE IN NSHD.
*Furosemide
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==22201 | `x'==22251 | `x'==22405 | `x'==22407 | `x'==22409 | `x'==22414 | `x'==22454 | `x'==22804 | `x'==25904
}
*Fluvoxamine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==43404
}
*Haloperidol
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==42154
}
*Hydralazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==25152
}
*Hydrocortisone
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==63401 | `x'==63452
}
*Isosorbide
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==26101 | `x'==26105 | `x'==26109 | `x'==26112 | `x'==26113 | `x'==26115 | `x'==26116 | `x'==26152
}
*Loperamide
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==14201 | `x'==14251
}
*Metoprolol
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==24008 | `x'==24020 | `x'==24059
}
*Morphine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==14203 | `x'==14254 | `x'==47203 | `x'==47208 | `x'==47210 | `x'==47217 | `x'==47253 | `x'==47254 | `x'==47259
}
*Nifedipine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==26201 | `x'==26203 | `x'==26205 | `x'==26209 | `x'==26212 | `x'==26216 | `x'==26228 | `x'==26253
}
*Prednisolone
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==63451
}
*Quinidine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==23254
}
*Risperidone
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==42104 | `x'==42162
}
*Theophylline
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==31302 | `x'==31303 | `x'==31305 | `x'==31352 | `x'==39210
}
*Trazodone
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==43112 | `x'==43160
}
*Triamterene
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==22353
}
*2012 UPDATE
*Aripiprazole
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==42109 | `x'==42163
}
*Asenapine: NONE IN NSHD
*Cetirizine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==34105 | `x'==34154
}
*Clidinium: NONE IN NSHD
*Desloratadine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==34117 | `x'==34160
}
*Iloperidone: NONE IN NSHD
*Levocetirizine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==34163
}
*Loratadine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==34103 | `x'==34156
}
*Paliperidone: NONE IN NSHD
*Venlafaxine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=1 if `x'==43456 | `x'==43407
}


*BURDEN SCORE 2
*Amantadine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=2 if `x'==49154
}
*Belladone alkaloids: NONE IN NSHD.
*Carbamazapine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=2 if `x'==42352 | `x'==47351 | `x'==48102 | `x'==48106 | `x'==48114 | `x'==48152
}
*Cyclobenzaprine: NONE IN NSHD.
*Cyproheptadine: NONE IN NSHD.
*Empracet: NONE IN NSHD.
*Loxapine: NONE IN NSHD.
*Meperidine: LISTED UNDER PETHIDINE IN NSHD.
*Methotrimeprazine: NONE IN NSHD.
*Molindone: NONE IN NSHD.
*Oxcarbazepine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=2 if `x'==48165
}
*Pethidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=2 if `x'==47255
}
*Pimozide
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=2 if `x'==42107
}
*2012 UPDATE
*Nefopam
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=2 if `x'==47156
}


*BURDEN SCORE 3
*Amitriptyline
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43102 | `x'==43113 | `x'==43116 | `x'==43154
}
*Amoxapine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43109
}
*Atropine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==14202 | `x'==14253
}
*Benztropine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==49252
}
*Brompheniramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==39205
}
*Carbinoxamine: NONE IN NSHD.
*Chlorpheniramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==34102 | `x'==34152 | `x'==39208
}
*Chlorpromazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42106 | `x'==42151
}
*Clemastine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==34111 | `x'==34157
}
*Clomipramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43106 | `x'==43152
}
*Clozapine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42159
}
*Darifenacin: NONE IN NSHD.
*Desipramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43161
}
*Dicyclomine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==12003
}
*Dimenhydrinate
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==39211 | `x'==34109 | `x'==34114 | `x'==34112
}
*Diphenhydramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==34109 | `x'==34112 | `x'==34114 | `x'==34112
}
*Doxepin
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43103 | `x'==43108 | `x'==43156
}
*Flavoxate
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==74202 | `x'==74255
}
*Hydroxyzine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==34106 | `x'==34153
}
*Hyoscyamine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==12052
}
*Imipramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43114 | `x'==43158
}
*Meclizine: NONE IN NSHD.
*Nortriptyline
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43110 | `x'==43117 | `x'==43118 | `x'==43159 | `x'==43301
}
*Olanzapine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42157
}
*Orphenadrine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==47129 | `x'==49202 | `x'==49253
}
*Oxybutynin
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==74201 | `x'==74251
}
*Paroxetine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43111
}
*Perphenazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42108
}
*Procyclidine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==49203 | `x'==49251
}
*Promazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42153
}
*Promethazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==34108 | `x'==39203 | `x'==39208
}
*Propentheline
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==12009
}
*Propiverine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==74256
}
*Quetiapine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42161
}
*Scopolamine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==12001
}
*Thioridazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42102 | `x'==42152
}
*Tolterodine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==74203 | `x'==74252
}
*Trifluoperazine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==42101 | `x'==42164 | `x'==46055
}
*Trihexyphenidy
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==49201 | `x'==49252
}
*Trimipramine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==43104 | `x'==43157
}
*2012 UPDATE
*Doxylamine
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==34158 | `x'==47112
}
*Fesoterodine: NONE IN NSHD
*Solifenacin
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==74254  | `x'==74204
}
*Trospium
foreach x of varlist med*n15x {                                                                
replace anticholcat_69x=3 if `x'==74253
}

label values anticholcat_69x anticholcat_69x
label variable anticholcat_69x "Derived: Most anticholinergic drug category prescribed at age 69"

*GENERATE EXTRA CATEGORICAL BURDEN SCORES
*AGE 69
gen antichol3_69x=.
replace antichol3_69x=1 if anticholcat_69x==3
replace antichol3_69x=0 if anticholcat_69x==2
replace antichol3_69x=0 if anticholcat_69x==1
replace antichol3_69x=0 if anticholcat_69x==0

label values antichol3_69x antichol3_69x
label variable antichol3_69x "Derived: Presence of ACBS score 3 medications at age 69"

gen antichol2_69x=.
replace antichol2_69x=1 if anticholcat_69x==2
replace antichol2_69x=0 if anticholcat_69x==3
replace antichol2_69x=0 if anticholcat_69x==1
replace antichol2_69x=0 if anticholcat_69x==0

label values antichol2_69 antichol2_69
label variable antichol2_69 "Derived: Presence of ACBS score 2 medications at age 69"

gen antichol1_69x=.
replace antichol1_69x=1 if anticholcat_69x==1
replace antichol1_69x=0 if anticholcat_69x==3
replace antichol1_69x=0 if anticholcat_69x==2
replace antichol1_69x=0 if anticholcat_69x==0

label values antichol1_69x antichol1_69x
label variable antichol1_69x "Derived: Presence of ACBS score 1 medications at age 69"

*GENERATE CATEGORICAL ACBS SCORES FROM CONTINOUS COUNTS
gen anticholcatA_69x=.
replace anticholcatA_69x=0 if antichol_69x==0
replace anticholcatA_69x=1 if antichol_69x==1
replace anticholcatA_69x=1 if antichol_69x==2
replace anticholcatA_69x=2 if antichol_69x>=3
replace anticholcatA_69x=. if antichol_69x==.

label values anticholcatA_69x anticholcatA_69x
label variable anticholcatA_69x "Derived: Categorical ACBS Burden at age 69 (two-tier 3+)"
label define anticholcatA_69x 0 "No Burden (ACBS 0)", modify
label define anticholcatA_69x 1 "Moderate Burden (ACBS 1-2)", modify
label define anticholcatA_69x 2 "High Burden (ACBS 3+)", modify

gen anticholcatA2_69x=.
replace anticholcatA2_69x=0 if antichol_69x==0
replace anticholcatA2_69x=1 if antichol_69x==1
replace anticholcatA2_69x=1 if antichol_69x==2
replace anticholcatA2_69x=1 if antichol_69x==3
replace anticholcatA2_69x=1 if antichol_69x==4
replace anticholcatA2_69x=2 if antichol_69x>=5
replace anticholcatA2_69x=. if antichol_69x==.

label values anticholcatA2_69x anticholcatA2_69x
label variable anticholcatA2_69x "Derived: Categorical ACBS Burden at age 69 (two-tier 5+)"
label define anticholcatA2_69x 0 "No Burden (ACBS 0)", modify
label define anticholcatA2_69x 1 "Moderate Burden (ACBS 1-4)", modify
label define anticholcatA2_69x 2 "High Burden (ACBS 5+)", modify

gen anticholcatA3_69x=.
replace anticholcatA3_69x=0 if antichol_69x==0
replace anticholcatA3_69x=1 if antichol_69x==1
replace anticholcatA3_69x=1 if antichol_69x==2
replace anticholcatA3_69x=2 if antichol_69x==3
replace anticholcatA3_69x=2 if antichol_69x==4
replace anticholcatA3_69x=3 if antichol_69x>=5
replace anticholcatA3_69x=. if antichol_69x==.

label values anticholcatA3_69x anticholcatA3_69x
label variable anticholcatA3_69x "Derived: Categorical ACBS Burden at age 69 (three-tier 3-4/5+)"
label define anticholcatA3_69x 0 "No Burden (ACBS 0)", modify
label define anticholcatA3_69x 1 "Mild Burden (ACBS 1-2)", modify
label define anticholcatA3_69x 2 "Moderate Burden (ACBS 3-4)", modify
label define anticholcatA3_69x 3 "High Burden (ACBS 5+)", modify

gen anticholcatB1_69x=.
replace anticholcatB1_69x=0 if antichol_69x<=2
replace anticholcatB1_69x=1 if antichol_69x>=3
replace anticholcatB1_69x=. if antichol_69x==.

label values anticholcatB1_69x anticholcatB1_69x
label variable anticholcatB1_69x "Derived: Categorical ACBS Burden at age 69 (binary 3+)"
label define anticholcatB1_69x 0 "No Burden (ACBS <=2)", modify
label define anticholcatB1_69x 1 "ACBS Burden (ACBS 3+)", modify

gen anticholcatB2_69x=.
replace anticholcatB2_69x=0 if antichol_69x<=4
replace anticholcatB2_69x=1 if antichol_69x>=5
replace anticholcatB2_69x=. if antichol_69x==.

label values anticholcatB2_69x anticholcatB2_69x
label variable anticholcatB2_69x "Derived: Categorical ACBS Burden at age 69 (binary 5+)"
label define anticholcatB2_69x 0 "No Burden (ACBS <=4)", modify
label define anticholcatB2_69x 1 "ACBS Burden (ACBS 5+)", modify

*************DRUG CLASS SUBSCORES AGE 69***********************

*GENERATE ANTICHOLINERGIC BURDEN SCORES
*AGE 69
*GI
gen anticholgi_69x=.

foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=0 if `x'==0
}

*Alverine
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +1) if `x'==12006 | `x'==12053
}
*Cimetidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +1) if `x'==13102 | `x'==13104 | `x'==13106 | `x'==13152
}
*Ranitidine
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +1) if `x'==13101 | `x'==13109 | `x'==13151
}
*Loperamide
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +1) if `x'==14201 | `x'==14251
}
*Clidinium: NONE IN NSHD
*Dicyclomine
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +3) if `x'==12003
}
*Flavoxate
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +3) if `x'==74202 | `x'==74255
}
*Hyoscyamine
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +3) if `x'==12052
}
*Scopolamine
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +3) if `x'==12001
}
*Trihexyphenidy
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +3) if `x'==49201 | `x'==49252
}
*Propentheline
foreach x of varlist med*n15x {                                                                
replace anticholgi_69x=(anticholgi_69x +3) if `x'==12009
}

label values anticholgi_69x anticholgi_69x
label variable anticholgi_69x "Derived: GI anticholinergic burden age 69"

*GENERATE ANTICHOLINERGIC BURDEN SCORES
*AGE 69
*CARDIOLOGICAL
gen anticholcardio_69x=.

foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=0 if `x'==0
}

*Atenolol
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==24002 | `x'==24007 | `x'==24009 | `x'==24012 | `x'==24015 | `x'==24017 | `x'==24022 | `x'==24052
}
*Captopril
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==25501 | `x'==25506 | `x'==25551
}
*Chlorthalidone
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==24053
}
*Coumadin
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==28201 | `x'==28251
}
*Digoxin
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==21101 | `x'==21151
}
*Dipyridamole
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==29001 | `x'==29006 | `x'==29051
}
*Disopyramide phosphate
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==23201 | `x'==23251
}
*Furosemide
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==22201 | `x'==22251 | `x'==22405 | `x'==22407 | `x'==22409 | `x'==22414 | `x'==22454 | `x'==22804 | `x'==25904
}
*Hydralazine
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==25152
}
*Isosorbide
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==26101 | `x'==26105 | `x'==26109 | `x'==26112 | `x'==26113 | `x'==26115 | `x'==26116 | `x'==26152
}
*Metoprolol
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==24008 | `x'==24020 | `x'==24059
}
*Nifedipine
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==26201 | `x'==26203 | `x'==26205 | `x'==26209 | `x'==26212 | `x'==26216 | `x'==26228 | `x'==26253
}
*Quinidine
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==23254
}
*Triamterene
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +1) if `x'==22353
}
*Atropine
foreach x of varlist med*n15x {                                                                
replace anticholcardio_69x=(anticholcardio_69x +3) if `x'==14202 | `x'==14253
}

label values anticholcardio_69x anticholcardio_69x
label variable anticholcardio_69x "Derived: Cardiological anticholinergic burden age 69"

*GENERATE ANTICHOLINERGIC BURDEN SCORES
*AGE 69
*UROLOGICAL
gen anticholuro_69x=.

foreach x of varlist med*n15x {                                                                
replace anticholuro_69x=0 if `x'==0
}

*Darifenacin: NONE IN NSHD.
*Oxybutynin
foreach x of varlist med*n15x {                                                                
replace anticholuro_69x=(anticholuro_69x +3) if `x'==74201 | `x'==74251
}
*Propiverine
foreach x of varlist med*n15x {                                                                
replace anticholuro_69x=(anticholuro_69x +3) if `x'==74256
}
*Tolterodine
foreach x of varlist med*n15x {                                                                
replace anticholuro_69x=(anticholuro_69x +3) if `x'==74203 | `x'==74252
}
*Fesoterodine: NONE IN NSHD
*Solifenacin
foreach x of varlist med*n15x {                                                                
replace anticholuro_69x=(anticholuro_69x +3) if `x'==74254  | `x'==74204
}
*Trospium
foreach x of varlist med*n15x {                                                                
replace anticholuro_69x=(anticholuro_69x +3) if `x'==74253
}


label values anticholuro_69x anticholuro_69x
label variable anticholuro_69x "Derived: Urological anticholinergic burden age 69"

*GENERATE DRUG CLASS SUBGROUP SCORES
*AGE 69
*NEURO
gen anticholneuro_69x=.

foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=0 if `x'==0
}

*BURDEN SCORE 1
*Alprazolam
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==41201
}
*Bupropion hydrochloride : NONE IN NSHD.
*Clorazepate
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==41208
}
*Codine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==14252 | `x'==39152 | `x'==39153 | `x'==47102 | `x'==47103 | `x'==47107 | `x'==47108 | `x'==47112 | `x'==47113 | `x'==47114 | `x'==47118 | `x'==47121 | `x'==47152 | `x'==47157 | `x'==47252
}
*Diazepam
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==41202 | `x'==41206 | `x'==41253 | `x'==48251 | `x'==102254 
}
*Fentanyl: NONE IN NSHD.
*Fluvoxamine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==43404
}
*Haloperidol
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==42154
}
*Morphine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==14203 | `x'==14254 | `x'==47203 | `x'==47208 | `x'==47210 | `x'==47217 | `x'==47253 | `x'==47254 | `x'==47259
}
*Risperidone
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==42104 | `x'==42162
}
*Trazodone
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==43112 | `x'==43160
}
*2012 UPDATE
*Aripiprazole
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==42109 | `x'==42163
}
*Asenapine: NONE IN NSHD
*Iloperidone: NONE IN NSHD
*Paliperidone: NONE IN NSHD
*Venlafaxine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +1) if `x'==43456 | `x'==43407
}


*BURDEN SCORE 2
*Amantadine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +2) if `x'==49154
}
*Belladone alkaloids: NONE IN NSHD.
*Carbamazapine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +2) if `x'==42352 | `x'==47351 | `x'==48102 | `x'==48106 | `x'==48114 | `x'==48152
}
*Cyclobenzaprine: NONE IN NSHD.
*Empracet: NONE IN NSHD.
*Loxapine: NONE IN NSHD.
*Meperidine: LISTED UNDER PETHIDINE IN NSHD.
*Molindone: NONE IN NSHD.
*Oxcarbazepine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +2) if `x'==48165
}
*Pethidine hydrochloride
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +2) if `x'==47255
}
*Pimozide
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +2) if `x'==42107
}
*2012 UPDATE
*Nefopam
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +2) if `x'==47156
}


*BURDEN SCORE 3
*Amitriptyline
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43102 | `x'==43113 | `x'==43116 | `x'==43154
}
*Amoxapine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43109
}
*Benztropine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==49252
}
*Chlorpromazine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42106 | `x'==42151
}
*Clomipramine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43106 | `x'==43152
}
*Clozapine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42159
}
*Desipramine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43161
}
*Doxepin
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43103 | `x'==43108 | `x'==43156
}
*Nortriptyline
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43110 | `x'==43117 | `x'==43118 | `x'==43159 | `x'==43301
}
*Olanzapine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42157
}
*Orphenadrine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==47129 | `x'==49202 | `x'==49253
}
*Paroxetine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43111
}
*Perphenazine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42108
}
*Procyclidine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==49203 | `x'==49251
}
*Promazine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42153
}
*Promethazine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==34108 | `x'==39203 | `x'==39208
}
*Quetiapine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42161
}
*Thioridazine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42102 | `x'==42152
}
*Trifluoperazine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==42101 | `x'==42164 | `x'==46055
}
*Trimipramine
foreach x of varlist med*n15x {                                                                
replace anticholneuro_69x=(anticholneuro_69x +3) if `x'==43104 | `x'==43157
}

label values anticholneuro_69x anticholneuro_69x
label variable anticholneuro_69x "Derived: Neurological anticholinergic burden age 69"

*GENERATE ANTICHOLINERGIC BURDEN SCORES
*AGE 69
*IMMUNE
gen anticholimmune_69x=.

foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=0 if `x'==0
}

*BURDEN SCORE 1
*Alimemazine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==34162
}
*Brompheniramine maleate
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==34107
}
*Hydrocortisone
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==63401 | `x'==63452
}
*Prednisolone
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==63451
}
*2012 UPDATE
*Cetirizine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==34105 | `x'==34154
}
*Desloratadine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==34117 | `x'==34160
}
*Levocetirizine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==34163
}
*Loratadine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +1) if `x'==34103 | `x'==34156
}

*BURDEN SCORE 2
*Cyproheptadine: NONE IN NSHD.
*Methotrimeprazine: NONE IN NSHD.

*BURDEN SCORE 3
*Brompheniramine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +3) if `x'==39205
}
*Carbinoxamine: NONE IN NSHD.
*Chlorpheniramine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +3) if `x'==34102 | `x'==34152 | `x'==39208
}
*Clemastine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +3) if `x'==34111 | `x'==34157
}
*Dimenhydrinate
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +3) if `x'==39211 | `x'==34109 | `x'==34114 | `x'==34112
}
*Hydroxyzine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +3) if `x'==34106 | `x'==34153
}                                                                
*Meclizine: NONE IN NSHD.

*2012 UPDATE
*Doxylamine
foreach x of varlist med*n15x {                                                                
replace anticholimmune_69x=(anticholimmune_69x +3) if `x'==34158 | `x'==47112
}

label values anticholimmune_69x anticholimmune_69x
label variable anticholimmune_69x "Derived: Immune anticholinergic burden age 69"

*CREATE REPRESENTATIVE MEASURE OF ANTICHOLINERGIC USE


*****************************************CODE ANTICHOLINERGIC VARIABLES FOR AGE 69 END************************************************* 
 
*************STATA SCRIPT END************* 