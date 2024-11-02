*::::Cordula Hinkes, CAU Kiel, Master Thesis 2016
*::Effects coding and data analysis


***Effects coding of dummy variables
replace Pangasius =-1 if Pangasius==0 & Alt!=3
*Achtung! 3 levels für COO
replace Bangladesh =-1 if Bangladesh==0 & Germany==0 & Alt!=3
replace Germany =-1 if Bangladesh==-1 & Alt!=3
*Achtung! 3 levels für Ecolabel
replace ASC=-1 if ASC==0 & Naturland==0 & Alt!=3
replace Naturland=-1 if ASC==-1 & Alt!=3
replace Brand=-1 if Brand==0 & Alt!=3
replace FairLabel=-1 if FairLabel==0 & Alt!=3
replace optoutvar=-1 if optoutvar==0

label var Pangasius "1: Pangasius; -1: Tilapia"
label var Bangladesh "1: Bangladesh; 0: Germany; -1: Vietnam"
label var Germany "1: Germany; 0: Bangladesh; -1: Vietnam"
label var ASC "1: ASC; 0: Naturland; -1: no ecolabel"
label var Brand "1: COSTA; -1: no brand"
label var FairLabel "1: fair trade; -1: no fair trade"

***make variable names shorter
clonevar CIBV1 = CIstandardsBV
label var CIBV1 "country image for social & env. standards, B&V"
clonevar CIBV2 = CIquality_safetyBV
label var CIBV2 "country image for quality & safety, B&V"
clonevar Naturland_know = Naturland_knowledge
clonevar Fair_know = Fairtrade_knowledge

***household income | reference level: low income (-1) | no information: 0 
*generate low_income=.
*replace low_income=0
*replace low_income=1 if hh_income==1 | hh_income==2
*label var low_income "Dummy | 1:monthly HH income up to EUR 1500; 0:other"
generate medium_income=.
replace medium_income=0
replace medium_income=1 if hh_income==3 | hh_income==4 | hh_income==5
replace medium_income=-1 if hh_income==1 | hh_income==2
generate high_income=.
replace high_income=0
replace high_income=1 if hh_income==6
replace high_income=-1 if hh_income==1 | hh_income==2
***"keine Angabe" --> hat 0 in allen Dummy (effects coded) Variablen
***low income --> hat -1 in allen effects coded Variablen (high income & medium income)

***effects coding of dummy variables (compare "datenaufbereitung" do-file)
replace Naturland_know=-1 if Naturland_know==0
replace ASC_knowledge=-1 if ASC_knowledge==0
replace Fair_know=-1 if Fair_know==0
replace female=-1 if female==0
replace degree=-1 if degree==0



***Zum Testen ausprobiert, aber dann nicht angewendet --> kann ignoriert werden
generate ecolabel =.
replace ecolabel = -1
replace ecolabel = 1 if ASC==1 | Naturland==1
replace ecolabel = 0 if Alt==3
label var ecolabel "Dummy | 1: ASC oder Naturland; -1: weder ASC noch Naturland"


***mean-centering of continuous variables 
*****--> wichtig für interaction effects, wg. multicollinearity
egen age_mean = mean(age) if Case!=.
generate c_age = age - age_mean if Case!=.
egen price_mean = mean(Price) if Case!=.
generate c_Price = Price - price_mean if Case!=.


***Estimation of different models

**conditional logit model, main effects only 
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price, group(Case) vce(cluster ID)
***mit means-centered Preis (macht keinen Unterschied in den Ergebnissen für main effects only Modell)
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel c_Price, group(Case) vce(cluster ID)


***marginal effects, keeping other variables fixed at their means
**estimate clogit first
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price, group(Case) vce(cluster ID)
margins, dydx(*) predict(pu0) atmeans
margins, dydx(*) predict(pu0)

**odds ratios (option: or)
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price, group(Case) vce(cluster ID) or


***probit model (hier nicht so sinnvoll, daher nicht verwendet)
asmprobit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price, alt(Alt) case(Case) casevars(c_age) vce(cluster ID)

***mixed logit model
mixlogit Choice_Dummy Price , rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel age_optout aqua_optout CE_Germany CE_Bangladesh) group (Case) id(ID)

***Mixlogit nach den zwei DCE Durchläufen aufgeteilt, 50 Halton draws
mixlogit Choice_Dummy Price if cycle1==1, rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel) group(Case) id(ID)
mixlogit Choice_Dummy Price if cycle1!=1, rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel) group(Case) id(ID)

mixlogit Choice_Dummy, rand(optoutvar Price Pangasius Bangladesh Germany Naturland ASC Brand FairLabel) group(Case) id(ID) nrep(100)

mixlogit Choice_Dummy, rand(optoutvar c_Price Pangasius Bangladesh Germany Naturland ASC Brand FairLabel) group(Case) id(ID) nrep(100)

****WILLINGNESS TO PAY (WTP) for different models
*****Calculate Willingness to Pay for main effects only models
***Results: wtp (marginal wtp), ll(lower limit), ul (upper limit) --> confidence intervals

*conditional logit
clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price, group(Case) vce(cluster ID)
wtp Price Pangasius Bangladesh Germany Naturland ASC Brand FairLabel

*mixed logit, Price fixed
mixlogit Choice_Dummy Price, rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel) group(Case) id(ID) nrep(100)
wtp Price Pangasius Bangladesh Germany Naturland ASC Brand FairLabel

*mixed logit, Price random (normal)
mixlogit Choice_Dummy, rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price) group(Case) id(ID) nrep(100)
wtp Price Pangasius Bangladesh Germany Naturland ASC Brand FairLabel

*Main effects only, Price random - lognormal
gen mprice=-1*Price
mixlogit Choice_Dummy, rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel mprice) group(Case) id(ID) nrep(100) ln(1)
*Main effects only, Price random - normal
mixlogit Choice_Dummy, rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel Price) group(Case) id(ID) nrep(100)

***Mixed logit model in willingness-to-pay space
mixlogitwtp Choice_Dummy, price(mprice) rand(optoutvar Pangasius Bangladesh Germany Naturland ASC Brand FairLabel) nrep(100) group(Case) id(ID)

*Model fit postestimation command
*displays AIC & BIC values
estat ic

***Creation of interaction terms / interaction variables
generate ASC_Bangladesh = ASC*Bangladesh
generate ASC_Germany = ASC*Germany
generate Naturland_Bangladesh = Naturland*Bangladesh
generate Naturland_Germany = Naturland*Germany
generate Fair_Bangladesh = FairLabel*Bangladesh
generate Fair_Germany = FairLabel*Germany
generate CE_Germany = CETSCALE*Germany
generate CE_Bangladesh = CETSCALE*Bangladesh
generate CI_B_1 = CIstandardsBV*Bangladesh
generate CI_B_1_Ger = CIstandardsBV*Germany
generate CI_B_2 = CIquality_safetyBV*Bangladesh
generate CI_B_2_Ger = CIquality_safetyBV*Germany
generate CI_G = CI_Germany*Germany
generate CI_G_Bang = CI_Germany*Bangladesh
generate aqua_optout = aqua*optoutvar
generate concern_ASC = sust_concern*ASC
generate concern_Naturland = sust_concern*Naturland
generate concern_Fair = sust_concern*FairLabel
generate knowledge_Naturland = Naturland_knowledge*Naturland
generate knowledge_ASC = ASC_knowledge*ASC
generate knowledge_Fair = Fairtrade_knowledge*FairLabel
generate age_ASC = age*ASC
generate age_Naturland = age*Naturland
generate age_Fair = age*FairLabel
generate age_Germany = age*Germany
generate age_Bangladesh = age*Bangladesh
generate age_eco = age*eco
generate age_optout = age*optoutvar
generate c_age_ASC = c_age*ASC
generate c_age_Naturland = c_age*ASC
generate c_age_Fair = c_age*FairLabel
generate c_age_Germany = c_age*Germany
generate c_age_Bangladesh = c_age*Bangladesh
generate c_age_optout = c_age*optoutvar
generate c_age_eco = c_age*ecolabel
generate female_ASC = female*ASC
generate female_Naturland = female*Naturland
generate female_Fair = female*FairLabel
generate female_eco = female*ecolabel
generate degree_eco = degree*ecolabel
generate hi_eco = high_income*ecolabel
generate mi_eco = medium_income*ecolabel
generate li_eco = low_income*ecolabel
generate low_pur_optout = low_pur*optoutvar
generate high_pur_optout = high_pur*optoutvar
generate high_cons_optout = high_cons*optoutvar
generate degree_ASC = degree*ASC
generate degree_Naturland = degree*Naturland
generate degree_Fair = degree*FairLabel
generate degree_optout = degree*optoutvar
generate mi_optout = medium_income*optoutvar
generate hi_optout = high_income*optoutvar
generate high_cons_eco = high_cons*ecolabel
generate high_pur_eco = high_pur*ecolabel
generate low_pur_eco = low_pur*ecolabel
generate high_cons_fair = high_cons*FairLabel
generate high_pur_fair = high_pur*FairLabel
generate low_pur_fair = low_pur*FairLabel
generate mi_price = medium_income*Price
generate hi_price = high_income*Price
generate mi_c_price = medium_income*c_Price
generate hi_c_price = high_income*c_Price
generate female_Ger = female*Germany
generate hi_Naturland = high_income*Naturland
generate hi_ASC = high_income*ASC
generate hi_Fair = high_income*FairLabel
generate mi_ASC = medium_income*ASC
generate mi_Fair = medium_income*FairLabel
generate mi_Naturland = medium_income*Naturland
generate concern_optout = sust_concern*optoutvar
generate ASCBang = ASC*Bangladesh
generate NaturBang = Naturland*Bangladesh
generate FairBang = FairLabel*Bangladesh
generate ASC_Nat_know_ASC = ASC*ASC_Nat_know
generate ASC_Nat_know_Nat = Naturland*ASC_Nat_know

***define global variable for independent interaction variables
#delimit ;
global xvars 
CE_Germany
CE_Bangladesh
CI_B_1
CI_B_2
CI_G
aqua_optout
concern_ASC
concern_Naturland
concern_Fair
knowledge_ASC
knowledge_Naturland
knowledge_Fair
age_Fair
age_ASC
age_Naturland
age_optout
age_Germany
age_Bangladesh
high_cons_optout
high_pur_optout
low_pur_optout
high_cons_eco
high_pur_eco
low_pur_eco
age_eco
li_eco
mi_eco
hi_eco
high_cons_fair
high_pur_fair
low_pur_fair
degree_Fair
degree_optout
li_optout
mi_optout
hi_optout
li_price
mi_price
hi_price
female_Ger
female_Fair
female_ASC
female_Naturland
hi_Naturland
hi_ASC
hi_Fair
mi_ASC
mi_Fair
mi_Naturland
li_ASC
li_Fair
li_Naturland
degree_Fair
degree_ASC
degree_Naturland
;


***define global variable for independent variables
#delimit ;
global cxvars 
CE_Germany
CE_Bangladesh
CI_B_1
CI_B_2
CI_G
aqua_optout
concern_ASC
concern_Naturland
concern_Fair
knowledge_ASC
knowledge_Naturland
knowledge_Fair
c_age_Fair
c_age_ASC
c_age_Naturland
c_age_optout
c_age_Germany
c_age_Bangladesh
female_Fair
high_cons_optout
high_pur_optout
low_pur_optout
high_cons_eco
high_pur_eco
low_pur_eco
age_eco
li_eco
mi_eco
hi_eco
degree_eco
female_eco
high_cons_fair
high_pur_fair
low_pur_fair
degree_Fair
degree_optout
li_optout
mi_optout
hi_optout
li_c_price
mi_c_price
hi_c_price
female_Ger
;

***define global variable for independent variables, without consumption/eco
#delimit ;
global xvars2 
CE_Germany
CE_Bangladesh
CI_B_1
CI_B_2
CI_G
aqua_optout
concern_ASC
concern_Naturland
concern_Fair
concern_optout
knowledge_ASC
knowledge_Naturland
knowledge_Fair
age_Fair
age_ASC
age_Naturland
age_optout
age_Germany
age_Bangladesh
high_cons_fair
high_pur_fair
low_pur_fair
li_optout
mi_optout
hi_optout
li_price
mi_price
hi_price
female_Ger
female_Fair
female_ASC
female_Naturland
hi_Naturland
hi_ASC
hi_Fair
mi_ASC
mi_Fair
mi_Naturland
li_ASC
li_Fair
li_Naturland
degree_Fair
degree_ASC
degree_Naturland
degree_optout
;


***define global variable for independent variables
#delimit ;
global cxvars 
CE_Germany
CE_Bangladesh
CI_B_1
CI_B_2
CI_G
aqua_optout
concern_ASC
concern_Naturland
concern_Fair
knowledge_ASC
knowledge_Naturland
knowledge_Fair
c_age_Fair
c_age_ASC
c_age_Naturland
c_age_optout
c_age_Germany
c_age_Bangladesh
female_Fair
high_cons_optout
high_pur_optout
low_pur_optout
high_cons_eco
high_pur_eco
low_pur_eco
age_eco
li_eco
mi_eco
hi_eco
degree_eco
female_eco
high_cons_fair
high_pur_fair
low_pur_fair
degree_Fair
degree_optout
li_optout
mi_optout
hi_optout
li_c_price
mi_c_price
hi_c_price
female_Ger
;

***define global variable for independent variables (hypotheses only)
#delimit ;
global hypvars 
CE_Germany
CE_Bangladesh
CI_B_1
CI_B_1_Ger
CI_B_2
CI_B_2_Ger
CI_G
CI_G_Bang
concern_ASC
concern_Naturland
concern_Fair
knowledge_ASC
knowledge_Naturland
knowledge_Fair
c_age_Fair
c_age_ASC
c_age_Naturland
female_Fair
female_ASC
female_Naturland
hi_Naturland
hi_ASC
hi_Fair
mi_ASC
mi_Fair
mi_Naturland
degree_Fair
degree_ASC
degree_Naturland
ASC_Bangladesh
ASC_Germany
Naturland_Bangladesh
Naturland_Germany
Fair_Bangladesh
Fair_Germany
;

clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel c_Price $hypvars, group(Case) vce(cluster ID)


***hypvars ohne insignifikante interactions
#delimit ;
global sig_hypvars 
CI_B_2
CI_B_2_Ger
CI_G
CI_G_Bang
knowledge_ASC
knowledge_Naturland
knowledge_Fair
;

clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland FairLabel c_Price $sig_hypvars, group(Case) vce(cluster ID)

***hypvars plus zusätzliche variablen, ohne insignifikante interactions
#delimit ;
global sig_hypvarsplus 
CI_B_2
CI_B_2_Ger
CI_G
CI_G_Bang
knowledge_ASC
knowledge_Naturland
knowledge_Fair
concern_optout
c_age_optout
aqua_optout
degree_optout
;

clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland FairLabel c_Price $sig_hypvarsplus, group(Case) vce(cluster ID)
*without brand:
mixlogit Choice_Dummy, rand(optoutvar c_Price Pangasius Bangladesh Germany Naturland ASC FairLabel $sig_hypvarsplus) group(Case) id(ID) nrep(100)


***Global variable definieren
***Interaktionsterme plus zusätzliche variablen, NUR SIGNIFIKANTE Interaction effects
#delimit ;
global sig_hypvarsplus2 
CI_B_2
CI_B_2_Ger
CI_G
CI_G_Bang
knowledge_ASC
knowledge_Naturland
knowledge_Fair
concern_optout
c_age_optout
aqua_optout
;
mixlogit Choice_Dummy, rand(optoutvar c_Price Pangasius Bangladesh Germany Naturland ASC FairLabel $sig_hypvarsplus2) group(Case) id(ID) nrep(100)

***define global variable for independent variables (hypotheses only)
#delimit ;
global hypvars2 
CE_Germany
CE_Bangladesh
CI_B_1
CI_B_2
CI_G
age_Fair
age_ASC
age_Naturland
female_Fair
female_eco
hi_eco
hi_Fair
mi_eco
mi_Fair
li_eco
li_Fair
degree_Fair
degree_eco
;


****Factor variables --> am Ende nicht angewendet, da zu komplex
***xi3 interaction variables (hypotheses only)
#delimit ;
global hypvarsxi3
CETSCALE*e.Germany
CETSCALE*e.Bangladesh
CIBV1*e.Bangladesh
CIBV2*e.Bangladesh
CI_Germany*e.Germany
sust_concern*e.ASC
sust_concern*e.Naturland
sust_concern*e.FairLabel
e.Naturland_know*e.Naturland
e.ASC_knowledge*e.ASC
e.Fair_know*e.FairLabel
age*e.ASC
age*e.Naturland
age*e.FairLabel
e.female*e.ASC
e.female*e.Naturland
e.female*e.FairLabel
e.degree*e.ASC
e.degree*e.Naturland
e.degree*e.FairLabel
e.high_income*e.ASC
e.high_income*e.Naturland
e.high_income*e.FairLabel
e.medium_income*e.ASC
e.medium_income*e.Naturland
e.medium_income*e.FairLabel
e.low_income*e.ASC
e.low_income*e.Naturland
e.low_income*e.FairLabel
;

***Stepwise forward and backward estimation
***ausprobiert, aber am Ende nicht verwendet
clogit Choice_Dummy e_optout Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $xvars2, group(Case) vce(cluster ID)
stepwise, pr(.1) pe(.05): clogit Choice_Dummy e_optout Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $xvars2, group(Case) vce(cluster ID)

clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $hypvars, group(Case) vce(cluster ID)
clogit Choice_Dummy e_optout Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $hypvars2, group(Case) vce(cluster ID)
stepwise, pr(.1) pe(.05): clogit Choice_Dummy e_optout Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $hypvars, group(Case) vce(cluster ID)

***clogit model fitting, forward selection 
**significance level for addition to the model: 0.2
stepwise, pe(.2): clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $xvars, group(Case) vce(cluster ID)

*stepwise forward, significance level for addition: 0.1 and deletion: 0.2
stepwise, pr(.2) pe(.1): clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $xvars, group(Case) vce(cluster ID)

*stepwise forward, significance level for addition: 0.05 and deletion: 0.1, centered continuous variables, effects coded optoutvar
stepwise, pr(.1) pe(.05): clogit Choice_Dummy e_optout Pangasius Bangladesh Germany ASC Naturland Brand FairLabel c_Price $cxvars, group(Case) vce(cluster ID)

*stepwise forward, significance level for addition: 0.05 and deletion: 0.1, effects coded optoutvar
stepwise, pr(.1) pe(.05): clogit Choice_Dummy e_optout Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $xvars, group(Case) vce(cluster ID)

stepwise, pr(.1) pe(.05): clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $xvars2, group(Case) vce(cluster ID)

stepwise, pr(.1) pe(.05): clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $hypvars, group(Case) vce(cluster ID)


xi3: clogit Choice_Dummy optoutvar Pangasius Bangladesh Germany ASC Naturland Brand FairLabel Price $hypvarsxi3, group(Case) vce(cluster ID)


