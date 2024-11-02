*::::Cordula Hinkes, CAU Kiel, Master Thesis 2016
*::Preparation and Factor analysis (& Hausman test)

********Factor Analysis

*****CETSCALE
***Cronbach's Alpha
***2-factor solution
alpha v_13-v_22, item
***Principal-component factor analysis (PCF)
factor v_13-v_22, pcf factors(2) blanks(0.4)
***Rotation
rotate, promax(3) oblique blanks(0.4)
***Kaiser-Meyer-Olkin (KMO)measure
estat kmo
***1-factor solution
alpha v_13-v_22, item
***Principal-component factor analysis (PCF)
factor v_13-v_22, pcf factors(1) blanks(0.4)
***Kaiser-Meyer-Olkin (KMO)measure
estat kmo
predict CETSCALE

*****Country Image
alpha v_99 v_100 v_101 v_120 v_121 v_122 v_125 v_126 v_127 v_130 v_131 v_132
factor v_99 v_100 v_101 v_120 v_121 v_122 v_125 v_126 v_127 v_130 v_131 v_132, factors(3) blanks(0.4)
rotate, blanks(0.4)
estat kmo
*1.factor: social&env. standards for B and V, 2. factor: quality&food safety for B and V, 3. factor: Germany complete
predict CIstandardsBV CIquality_safetyBV CI_Germany
label var CIstandardsBV "Social&Env standards Bangladesh & Vietnam"
label var CIquality_safetyBV "Product quality & food safety Bangladesh & Vietnam"
label var CI_Germany "Country Image Germany"

*****Aquaculture Statements
***Cronbach's alpha
alpha aqua1-aqua6, item
factor aqua1-aqua6
***KMO measure
estat kmo
***Repeat calculation for only the positively-keyed items (aqua1-aqua3)
alpha aqua1-aqua3, item
factor aqua1-aqua3
predict aqua
label var aqua "Factor for aqua1-aqua3"

*****Concern about sustainability of food production
***Cronbach's alpha
alpha v_170-v_183, item
factor v_170-v_183, factors(1) blanks(0.4)
estat kmo
predict sust_concern
label var sust_concern "Factor for concern about sustainability of food production"

*****Hausman test

*Hausman test using -suest- instead of -hausman-
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price CE_Germany CE_Bangladesh CI_B_1 CI_B_2 aqua_optout concern_ASC concern_Naturland concern_Fair knowledge_Naturland knowledge_ASC knowledge_Fair age_ASC age_Naturland age_Fair female_ASC female_Naturland female_Fair high_pur_optout low_pur_optout, group(Case)
estimates store m1, title(complete model)
quietly clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price CE_Germany CE_Bangladesh CI_B_1 CI_B_2 aqua_optout concern_ASC concern_Naturland concern_Fair knowledge_Naturland knowledge_ASC knowledge_Fair age_ASC age_Naturland age_Fair female_ASC female_Naturland female_Fair high_pur_optout low_pur_optout if Alt!=2, group(Case)
estimates store m2, title(without alternative 2)
quietly clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price CE_Germany CE_Bangladesh CI_B_1 CI_B_2 aqua_optout concern_ASC concern_Naturland concern_Fair knowledge_Naturland knowledge_ASC knowledge_Fair age_ASC age_Naturland age_Fair female_ASC female_Naturland female_Fair high_pur_optout low_pur_optout if Alt!=3, group(Case)
estimates store m3, title(without alternative 3)
suest m1 m2
test [m1_Choice_Dummy = m2_Choice_Dummy], common
test [m1_Choice_Dummy = m3_Choice_Dummy], common

*Hausman test using -rhausman-
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price, group(Case) vce(cluster ID)
estimates store m1, title(complete model)
quietly clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price if Alt!=2, group(Case) vce(cluster ID)
estimates store m2, title(without alternative 2)
quietly clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price if Alt!=3, group(Case) vce(cluster ID)
estimates store m3, title(without alternative 3)
rhausman m1 m2, cluster
rhausman m1 m3, cluster

