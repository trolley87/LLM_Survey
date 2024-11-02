*::::Cordula Hinkes, CAU Kiel, Master Thesis 2016
*::Structuring and preparation of data

***Do-File: Daten umstrukturieren
doedit "C:\Users\fsc\Dropbox\Master SSE\Master Thesis\STATA\datenaufbereitung.do" 
log using "C:\Users\fsc\Dropbox\Master SSE\Master Thesis\STATA\log_1.smcl"
use "C:\Users\fsc\Dropbox\Master SSE\Master Thesis\STATA\Daten_bereinigt_.dta", clear

set more off

*** missing values umwandeln in missing values in STATA Sprache
mvdecode _all, mv(-77)
mvdecode _all, mv(-99)

*** ID wurde vorher schon in SPSS generiert

***1. Schritt: 
***Umbenennung der Variablen der Welle 1
***1. Ziffer: Welle; 2. Ziffer: Block; 3. Ziffer: Choice Set
rename v_282 choice111
rename v_283 choice112
rename v_284 choice113
rename v_285 choice114
rename v_286 choice115
rename v_287 choice116
rename v_288 choice117
rename v_289 choice118

rename v_290 choice121
rename v_291 choice122
rename v_292 choice123
rename v_293 choice124
rename v_294 choice125
rename v_295 choice126
rename v_296 choice127
rename v_297 choice128

rename v_298 choice131
rename v_299 choice132
rename v_300 choice133
rename v_301 choice134
rename v_302 choice135
rename v_303 choice136
rename v_304 choice137
rename v_305 choice138

rename v_306 choice141
rename v_307 choice142
rename v_308 choice143
rename v_309 choice144
rename v_310 choice145
rename v_311 choice146
rename v_312 choice147
rename v_313 choice148

rename v_314 choice151
rename v_315 choice152
rename v_316 choice153
rename v_317 choice154
rename v_318 choice155
rename v_319 choice156
rename v_320 choice157
rename v_321 choice158

rename v_322 choice161
rename v_323 choice162
rename v_324 choice163
rename v_325 choice164
rename v_326 choice165
rename v_327 choice166
rename v_328 choice167
***v_329 scheint zu fehlen
rename v_330 choice168

rename v_331 choice171
rename v_332 choice172
rename v_333 choice173
rename v_334 choice174
rename v_335 choice175
rename v_336 choice176
rename v_337 choice177
rename v_338 choice178

rename v_339 choice181
rename v_340 choice182
rename v_341 choice183
rename v_342 choice184
rename v_343 choice185
rename v_344 choice186
rename v_353 choice187
rename v_354 choice188

rename v_345 choice191
rename v_346 choice192
rename v_347 choice193
rename v_348 choice194
rename v_349 choice195
rename v_350 choice196
rename v_351 choice197
rename v_352 choice198

***Umbenennen der Variablen der Welle 2
rename v_585 choice211
rename v_586 choice212
rename v_587 choice213
rename v_588 choice214
rename v_589 choice215
rename v_590 choice216
rename v_591 choice217
rename v_592 choice218

rename v_593 choice221
rename v_594 choice222
rename v_595 choice223
rename v_596 choice224
rename v_597 choice225
rename v_598 choice226
rename v_599 choice227
rename v_600 choice228

rename v_601 choice231
rename v_602 choice232
rename v_603 choice233
rename v_604 choice234
rename v_605 choice235
rename v_606 choice236
rename v_607 choice237
rename v_608 choice238

rename v_609 choice241
rename v_610 choice242
rename v_611 choice243
rename v_612 choice244
rename v_613 choice245
rename v_614 choice246
rename v_615 choice247
rename v_616 choice248

rename v_617 choice251
rename v_618 choice252
rename v_619 choice253
rename v_620 choice254
rename v_621 choice255
rename v_622 choice256
rename v_623 choice257
rename v_624 choice258

rename v_625 choice261
rename v_626 choice262
rename v_627 choice263
rename v_628 choice264
rename v_629 choice265
rename v_630 choice266
rename v_631 choice267
rename v_632 choice268

rename v_633 choice271
rename v_634 choice272
rename v_635 choice273
rename v_636 choice274
rename v_637 choice275
rename v_638 choice276
rename v_639 choice277
rename v_640 choice278

rename v_641 choice281
rename v_642 choice282
rename v_643 choice283
rename v_644 choice284
rename v_645 choice285
rename v_646 choice286
rename v_647 choice287
rename v_648 choice288

rename v_649 choice291
rename v_650 choice292
rename v_651 choice293
rename v_652 choice294
rename v_653 choice295
rename v_654 choice296
rename v_655 choice297
rename v_656 choice298

***2. Schritt:Befehl zur Umformung der Daten von wide -> long (Panelform)
***sortiert zuerst nach ID und dann nach ChoiceBlock.
***ChoiceBlock ist eine neue Variable, die sich aus den vorher umbenannten Choice Set Variablen zusammensetzt,
***die alle mit "choice" beginnen (daher "choice@")
reshape long choice@, i(ID) j(ChoiceBlock)

***Die Spalte mit Variable 'choice' vor die Spalte mit Variable 'lfdn' setzen
order choice , before( lfdn )
***Die neue Variable ChoiceBlock mit Label beschriften
label var ChoiceBlock "111=Welle1 Block1 ChoiceSet1, ... 298=Welle2 Block9 ChoiceSet8"
***Variable 'choice' umbenennen und mit Label beschriften
rename choice Choice
label var Choice "Alternative (1=Angebot1, 2=Angebot2, 3=OptOut)"

***neue Variablen erstellen(erst mal leer)
generate Species=.
label var Species "Fish Species (0: Pangasius, 1: Tilapia)"
generate COO=.
label var COO "Country of Origin (0: Germany, 1: Bangladesh, 2: Vietnam)"
generate SustLabel=.
label var SustLabel "Sustainability Certification/Label (0: no label, 1: ASC, 2: Naturland)"
generate Brand=.
label var Brand "Brand (0: no brand, 1: COSTA)"
generate FairLabel=.
label var FairLabel "Fair Trade Certification/Label (0: no label, 1: fair trade label)"
generate Price=.
label var Price "Price (per 500g package)"

***Excel-Datei mit ID, ChoiceBlock und Alt importieren und im STATA-Format abspeichern (Vorbereitung für Merger)
***Hier gab es Probleme. Der m:m Merger nach ID hat nicht funktioniert, daher m:1 Merger nach ID und ChoiceBlock
import excel "C:\Users\fsc\Dropbox\Master SSE\Master Thesis\STATA\Alt_for_import.xlsx", sheet("Sheet1") firstrow
save "C:\Users\fsc\Dropbox\Master SSE\Master Thesis\STATA\Alt_for_import.dta", replace
merge m:1 ID ChoiceBlock using "C:\Users\fsc\Dropbox\Master SSE\Master Thesis\STATA\Daten_mergen.dta"

***Choice_Dummy generieren (analog zu "Wahl" in Nina Purwins' do-file)
***Dependent Variable
generate Choice_Dummy=.
label var Choice_Dummy "(0=Alt not chosen, 1=Alt chosen, NV=ChoiceSet not shown to participant)"
order Choice_Dummy , before( lfdn )
replace Choice_Dummy=0 if Choice>=1
replace Choice_Dummy=. if Choice==.
replace Choice_Dummy=1 if Choice==1& Alt==1
replace Choice_Dummy=1 if Choice==2& Alt==2
replace Choice_Dummy=1 if Choice==3& Alt==3

***Die ursprüngliche Choice Set Nummerierung wiederherstellen (Block-unabhängig)
generate ChoiceSet=.
label var ChoiceSet "Choice Set Nummer"
order ChoiceSet , before ( Alt )
***Block 1
replace ChoiceSet = 3 if ChoiceBlock==111 | ChoiceBlock==211
replace ChoiceSet = 21 if ChoiceBlock==112 | ChoiceBlock==212
replace ChoiceSet = 25 if ChoiceBlock==113 | ChoiceBlock==213
replace ChoiceSet = 35 if ChoiceBlock==114 | ChoiceBlock==214
replace ChoiceSet = 38 if ChoiceBlock==115 | ChoiceBlock==215
replace ChoiceSet = 56 if ChoiceBlock==116 | ChoiceBlock==216
replace ChoiceSet = 63 if ChoiceBlock==117 | ChoiceBlock==217
replace ChoiceSet = 70 if ChoiceBlock==118 | ChoiceBlock==218
***Block 2
replace ChoiceSet = 12 if ChoiceBlock==121 | ChoiceBlock==221
replace ChoiceSet = 14 if ChoiceBlock==122 | ChoiceBlock==222
replace ChoiceSet = 23 if ChoiceBlock==123 | ChoiceBlock==223
replace ChoiceSet = 28 if ChoiceBlock==124 | ChoiceBlock==224
replace ChoiceSet = 40 if ChoiceBlock==125 | ChoiceBlock==225
replace ChoiceSet = 45 if ChoiceBlock==126 | ChoiceBlock==226
replace ChoiceSet = 53 if ChoiceBlock==127 | ChoiceBlock==227
replace ChoiceSet = 69 if ChoiceBlock==128 | ChoiceBlock==228
***Block 3
replace ChoiceSet = 5 if ChoiceBlock==131 | ChoiceBlock==231
replace ChoiceSet = 7 if ChoiceBlock==132 | ChoiceBlock==232
replace ChoiceSet = 18 if ChoiceBlock==133 | ChoiceBlock==233
replace ChoiceSet = 31 if ChoiceBlock==134 | ChoiceBlock==234
replace ChoiceSet = 47 if ChoiceBlock==135 | ChoiceBlock==235
replace ChoiceSet = 49 if ChoiceBlock==136 | ChoiceBlock==236
replace ChoiceSet = 58 if ChoiceBlock==137 | ChoiceBlock==237
replace ChoiceSet = 66 if ChoiceBlock==138 | ChoiceBlock==238
***Block 4
replace ChoiceSet = 6 if ChoiceBlock==141 | ChoiceBlock==241
replace ChoiceSet = 8 if ChoiceBlock==142 | ChoiceBlock==242
replace ChoiceSet = 16 if ChoiceBlock==143 | ChoiceBlock==243
replace ChoiceSet = 32 if ChoiceBlock==144 | ChoiceBlock==244
replace ChoiceSet = 46 if ChoiceBlock==145 | ChoiceBlock==245
replace ChoiceSet = 51 if ChoiceBlock==146 | ChoiceBlock==246
replace ChoiceSet = 60 if ChoiceBlock==147 | ChoiceBlock==247
replace ChoiceSet = 65 if ChoiceBlock==148 | ChoiceBlock==248
***Block 5
replace ChoiceSet = 1 if ChoiceBlock==151 | ChoiceBlock==251
replace ChoiceSet = 19 if ChoiceBlock==152 | ChoiceBlock==252
replace ChoiceSet = 26 if ChoiceBlock==153 | ChoiceBlock==253
replace ChoiceSet = 36 if ChoiceBlock==154 | ChoiceBlock==254
replace ChoiceSet = 37 if ChoiceBlock==155 | ChoiceBlock==255
replace ChoiceSet = 55 if ChoiceBlock==156 | ChoiceBlock==256
replace ChoiceSet = 62 if ChoiceBlock==157 | ChoiceBlock==257
replace ChoiceSet = 72 if ChoiceBlock==158 | ChoiceBlock==258
***Block 6
replace ChoiceSet = 10 if ChoiceBlock==161 | ChoiceBlock==261
replace ChoiceSet = 15 if ChoiceBlock==162 | ChoiceBlock==262
replace ChoiceSet = 24 if ChoiceBlock==163 | ChoiceBlock==263
replace ChoiceSet = 29 if ChoiceBlock==164 | ChoiceBlock==264
replace ChoiceSet = 42 if ChoiceBlock==165 | ChoiceBlock==265
replace ChoiceSet = 44 if ChoiceBlock==166 | ChoiceBlock==266
replace ChoiceSet = 52 if ChoiceBlock==167 | ChoiceBlock==267
replace ChoiceSet = 68 if ChoiceBlock==168 | ChoiceBlock==268
***Block 7
replace ChoiceSet = 11 if ChoiceBlock==171 | ChoiceBlock==271
replace ChoiceSet = 13 if ChoiceBlock==172 | ChoiceBlock==272
replace ChoiceSet = 22 if ChoiceBlock==173 | ChoiceBlock==273
replace ChoiceSet = 30 if ChoiceBlock==174 | ChoiceBlock==274
replace ChoiceSet = 41 if ChoiceBlock==175 | ChoiceBlock==275
replace ChoiceSet = 43 if ChoiceBlock==176 | ChoiceBlock==276
replace ChoiceSet = 54 if ChoiceBlock==177 | ChoiceBlock==277
replace ChoiceSet = 67 if ChoiceBlock==178 | ChoiceBlock==278
***Block 8
replace ChoiceSet = 4 if ChoiceBlock==181 | ChoiceBlock==281
replace ChoiceSet = 9 if ChoiceBlock==182 | ChoiceBlock==282
replace ChoiceSet = 17 if ChoiceBlock==183 | ChoiceBlock==283
replace ChoiceSet = 33 if ChoiceBlock==184 | ChoiceBlock==284
replace ChoiceSet = 48 if ChoiceBlock==185 | ChoiceBlock==285
replace ChoiceSet = 50 if ChoiceBlock==186 | ChoiceBlock==286
replace ChoiceSet = 59 if ChoiceBlock==187 | ChoiceBlock==287
replace ChoiceSet = 64 if ChoiceBlock==188 | ChoiceBlock==288
***Block 9
replace ChoiceSet = 2 if ChoiceBlock==191 | ChoiceBlock==291
replace ChoiceSet = 20 if ChoiceBlock==192 | ChoiceBlock==292
replace ChoiceSet = 27 if ChoiceBlock==193 | ChoiceBlock==293
replace ChoiceSet = 34 if ChoiceBlock==194 | ChoiceBlock==294
replace ChoiceSet = 39 if ChoiceBlock==195 | ChoiceBlock==295
replace ChoiceSet = 57 if ChoiceBlock==196 | ChoiceBlock==296
replace ChoiceSet = 61 if ChoiceBlock==197 | ChoiceBlock==297
replace ChoiceSet = 71 if ChoiceBlock==198 | ChoiceBlock==298

**Generate block variable
generate Block =.
replace Block = 1 if ChoiceSet==3 | ChoiceSet==21 | ChoiceSet==25 | ChoiceSet==35 | ChoiceSet==38 | ChoiceSet==56 | ChoiceSet==63 | ChoiceSet==70
replace Block = 2 if ChoiceSet==12 | ChoiceSet==14 | ChoiceSet==23 | ChoiceSet==28 | ChoiceSet==40 | ChoiceSet==45 | ChoiceSet==53 | ChoiceSet==69
replace Block = 3 if ChoiceSet==5 | ChoiceSet==7 | ChoiceSet==18 | ChoiceSet==31 | ChoiceSet==47 | ChoiceSet==49 | ChoiceSet==58 | ChoiceSet==66
replace Block = 4 if ChoiceSet==6 | ChoiceSet==8 | ChoiceSet==16 | ChoiceSet==32 | ChoiceSet==46 | ChoiceSet==51 | ChoiceSet==60 | ChoiceSet==65
replace Block = 5 if ChoiceSet==1 | ChoiceSet==19 | ChoiceSet==26 | ChoiceSet==36 | ChoiceSet==37 | ChoiceSet==55 | ChoiceSet==62 | ChoiceSet==72
replace Block = 6 if ChoiceSet==10 | ChoiceSet==15 | ChoiceSet==24 | ChoiceSet==29 | ChoiceSet==42 | ChoiceSet==44 | ChoiceSet==52 | ChoiceSet==68
replace Block = 7 if ChoiceSet==11 | ChoiceSet==13 | ChoiceSet==22 | ChoiceSet==30 | ChoiceSet==41 | ChoiceSet==43 | ChoiceSet==54 | ChoiceSet==67
replace Block = 8 if ChoiceSet==4 | ChoiceSet==9 | ChoiceSet==17 | ChoiceSet==33 | ChoiceSet==48 | ChoiceSet==50 | ChoiceSet==59 | ChoiceSet==64
replace Block = 9 if ChoiceSet==2 | ChoiceSet==20 | ChoiceSet==27 | ChoiceSet==34 | ChoiceSet==39 | ChoiceSet==57 | ChoiceSet==61 | ChoiceSet==71
order Block, before(ChoiceSet)

***Produktattribute nach vorne ziehen
order Species COO SustLabel Brand FairLabel Price, before( lfdn )

***Produktattribute einfügen
****Achtung! Bei Alternative 3 (Alt 3) bedeutet 0 etwas anderes als bei Alt 1 und Alt 2
****Alt 3 ist die "No Purchase" / "Opt out"-Alternative --> keine Attribute, da kein Produkt!

***Preis
********Block 1
replace Price=6.49 if ChoiceSet==3 & Alt==1
replace Price=2.49 if ChoiceSet==3 & Alt==2
replace Price=0 if ChoiceSet==3 & Alt==3

replace Price=4.49 if ChoiceSet==21 & Alt==1
replace Price=6.49 if ChoiceSet==21 & Alt==2
replace Price=0 if ChoiceSet==21 & Alt==3

replace Price=4.49 if ChoiceSet==25 & Alt==1
replace Price=4.49 if ChoiceSet==25 & Alt==2
replace Price=0 if ChoiceSet==25 & Alt==3

replace Price=10.49 if ChoiceSet==35 & Alt==1
replace Price=8.49 if ChoiceSet==35 & Alt==2
replace Price=0 if ChoiceSet==35 & Alt==3

replace Price=12.49 if ChoiceSet==38 & Alt==1
replace Price=8.49 if ChoiceSet==38 & Alt==2
replace Price=0 if ChoiceSet==38 & Alt==3

replace Price=2.49 if ChoiceSet==56 & Alt==1
replace Price=10.49 if ChoiceSet==56 & Alt==2
replace Price=0 if ChoiceSet==56 & Alt==3

replace Price=2.49 if ChoiceSet==63 & Alt==1
replace Price=12.49 if ChoiceSet==63 & Alt==2
replace Price=0 if ChoiceSet==63 & Alt==3

replace Price=8.49 if ChoiceSet==70 & Alt==1
replace Price=2.49 if ChoiceSet==70 & Alt==2
replace Price=0 if ChoiceSet==70 & Alt==3

********Block 2
replace Price=12.49 if ChoiceSet==12 & Alt==1
replace Price=12.49 if ChoiceSet==12 & Alt==2
replace Price=0 if ChoiceSet==12 & Alt==3

replace Price=6.49 if ChoiceSet==14 & Alt==1
replace Price=12.49 if ChoiceSet==14 & Alt==2
replace Price=0 if ChoiceSet==14 & Alt==3

replace Price=2.49 if ChoiceSet==23 & Alt==1
replace Price=2.49 if ChoiceSet==23 & Alt==2
replace Price=0 if ChoiceSet==23 & Alt==3

replace Price=12.49 if ChoiceSet==28 & Alt==1
replace Price=10.49 if ChoiceSet==28 & Alt==2
replace Price=0 if ChoiceSet==28 & Alt==3

replace Price=8.49 if ChoiceSet==40 & Alt==1
replace Price=12.49 if ChoiceSet==40 & Alt==2
replace Price=0 if ChoiceSet==40 & Alt==3

replace Price=10.49 if ChoiceSet==45 & Alt==1
replace Price=10.49 if ChoiceSet==45 & Alt==2
replace Price=0 if ChoiceSet==45 & Alt==3

replace Price=10.49 if ChoiceSet==53 & Alt==1
replace Price=6.49 if ChoiceSet==53 & Alt==2
replace Price=0 if ChoiceSet==53 & Alt==3

replace Price=4.49 if ChoiceSet==69 & Alt==1
replace Price=2.49 if ChoiceSet==69 & Alt==2
replace Price=0 if ChoiceSet==69 & Alt==3

********Block 3
replace Price=10.49 if ChoiceSet==5 & Alt==1
replace Price=4.49 if ChoiceSet==5 & Alt==2
replace Price=0 if ChoiceSet==5 & Alt==3

replace Price=8.49 if ChoiceSet==7 & Alt==1
replace Price=6.49 if ChoiceSet==7 & Alt==2
replace Price=0 if ChoiceSet==7 & Alt==3

replace Price=8.49 if ChoiceSet==18 & Alt==1
replace Price=10.49 if ChoiceSet==18 & Alt==2
replace Price=0 if ChoiceSet==18 & Alt==3

replace Price=2.49 if ChoiceSet==31 & Alt==1
replace Price=8.49 if ChoiceSet==31 & Alt==2
replace Price=0 if ChoiceSet==31 & Alt==3

replace Price=6.49 if ChoiceSet==47 & Alt==1
replace Price=4.49 if ChoiceSet==47 & Alt==2
replace Price=0 if ChoiceSet==47 & Alt==3

replace Price=12.49 if ChoiceSet==49 & Alt==1
replace Price=4.49 if ChoiceSet==49 & Alt==2
replace Price=0 if ChoiceSet==49 & Alt==3

replace Price=4.49 if ChoiceSet==58 & Alt==1
replace Price=8.49 if ChoiceSet==58 & Alt==2
replace Price=0 if ChoiceSet==58 & Alt==3

replace Price=6.49 if ChoiceSet==66 & Alt==1
replace Price=6.49 if ChoiceSet==66 & Alt==2
replace Price=0 if ChoiceSet==66 & Alt==3

********Block 4
replace Price=2.49 if ChoiceSet==6 & Alt==1
replace Price=6.49 if ChoiceSet==6 & Alt==2
replace Price=0 if ChoiceSet==6 & Alt==3

replace Price=12.49 if ChoiceSet==8 & Alt==1
replace Price=2.49 if ChoiceSet==8 & Alt==2
replace Price=0 if ChoiceSet==8 & Alt==3

replace Price=12.49 if ChoiceSet==16 & Alt==1
replace Price=12.49 if ChoiceSet==16 & Alt==2
replace Price=0 if ChoiceSet==16 & Alt==3

replace Price=6.49 if ChoiceSet==32 & Alt==1
replace Price=10.49 if ChoiceSet==32 & Alt==2
replace Price=0 if ChoiceSet==32 & Alt==3

replace Price=10.49 if ChoiceSet==46 & Alt==1
replace Price=6.49 if ChoiceSet==46 & Alt==2
replace Price=0 if ChoiceSet==46 & Alt==3

replace Price=4.49 if ChoiceSet==51 & Alt==1
replace Price=6.49 if ChoiceSet==51 & Alt==2
replace Price=0 if ChoiceSet==51 & Alt==3

replace Price=8.49 if ChoiceSet==60 & Alt==1
replace Price=10.49 if ChoiceSet==60 & Alt==2
replace Price=0 if ChoiceSet==60 & Alt==3

replace Price=10.49 if ChoiceSet==65 & Alt==1
replace Price=2.49 if ChoiceSet==65 & Alt==2
replace Price=0 if ChoiceSet==65 & Alt==3

********Block 5
replace Price=10.49 if ChoiceSet==1 & Alt==1
replace Price=4.49 if ChoiceSet==1 & Alt==2
replace Price=0 if ChoiceSet==1 & Alt==3

replace Price=8.49 if ChoiceSet==19 & Alt==1
replace Price=2.49 if ChoiceSet==19 & Alt==2
replace Price=0 if ChoiceSet==19 & Alt==3

replace Price=8.49 if ChoiceSet==26 & Alt==1
replace Price=6.49 if ChoiceSet==26 & Alt==2
replace Price=0 if ChoiceSet==26 & Alt==3

replace Price=2.49 if ChoiceSet==36 & Alt==1
replace Price=10.49 if ChoiceSet==36 & Alt==2
replace Price=0 if ChoiceSet==36 & Alt==3

replace Price=4.49 if ChoiceSet==37 & Alt==1
replace Price=10.49 if ChoiceSet==37 & Alt==2
replace Price=0 if ChoiceSet==37 & Alt==3

replace Price=6.49 if ChoiceSet==55 & Alt==1
replace Price=12.49 if ChoiceSet==55 & Alt==2
replace Price=0 if ChoiceSet==55 & Alt==3

replace Price=6.49 if ChoiceSet==62 & Alt==1
replace Price=8.49 if ChoiceSet==62 & Alt==2
replace Price=0 if ChoiceSet==62 & Alt==3

replace Price=12.49 if ChoiceSet==72 & Alt==1
replace Price=4.49 if ChoiceSet==72 & Alt==2
replace Price=0 if ChoiceSet==72 & Alt==3

********Block 6
replace Price=4.49 if ChoiceSet==10 & Alt==1
replace Price=8.49 if ChoiceSet==10 & Alt==2
replace Price=0 if ChoiceSet==10 & Alt==3

replace Price=10.49 if ChoiceSet==15 & Alt==1
replace Price=8.49 if ChoiceSet==15 & Alt==2
replace Price=0 if ChoiceSet==15 & Alt==3

replace Price=6.49 if ChoiceSet==24 & Alt==1
replace Price=4.49 if ChoiceSet==24 & Alt==2
replace Price=0 if ChoiceSet==24 & Alt==3

replace Price=4.49 if ChoiceSet==29 & Alt==1
replace Price=12.49 if ChoiceSet==29 & Alt==2
replace Price=0 if ChoiceSet==29 & Alt==3

replace Price=12.49 if ChoiceSet==42 & Alt==1
replace Price=8.49 if ChoiceSet==42 & Alt==2
replace Price=0 if ChoiceSet==42 & Alt==3

replace Price=2.49 if ChoiceSet==44 & Alt==1
replace Price=12.49 if ChoiceSet==44 & Alt==2
replace Price=0 if ChoiceSet==44 & Alt==3

replace Price=2.49 if ChoiceSet==52 & Alt==1
replace Price=2.49 if ChoiceSet==52 & Alt==2
replace Price=0 if ChoiceSet==52 & Alt==3

replace Price=8.49 if ChoiceSet==68 & Alt==1
replace Price=4.49 if ChoiceSet==68 & Alt==2
replace Price=0 if ChoiceSet==68 & Alt==3

********Block 7
replace Price=8.49 if ChoiceSet==11 & Alt==1
replace Price=10.49 if ChoiceSet==11 & Alt==2
replace Price=0 if ChoiceSet==11 & Alt==3

replace Price=2.49 if ChoiceSet==13 & Alt==1
replace Price=10.49 if ChoiceSet==13 & Alt==2
replace Price=0 if ChoiceSet==13 & Alt==3

replace Price=10.49 if ChoiceSet==22 & Alt==1
replace Price=6.49 if ChoiceSet==22 & Alt==2
replace Price=0 if ChoiceSet==22 & Alt==3

replace Price=8.49 if ChoiceSet==30 & Alt==1
replace Price=8.49 if ChoiceSet==30 & Alt==2
replace Price=0 if ChoiceSet==30 & Alt==3

replace Price=4.49 if ChoiceSet==41 & Alt==1
replace Price=10.49 if ChoiceSet==41 & Alt==2
replace Price=0 if ChoiceSet==41 & Alt==3

replace Price=6.49 if ChoiceSet==43 & Alt==1
replace Price=8.49 if ChoiceSet==43 & Alt==2
replace Price=0 if ChoiceSet==43 & Alt==3

replace Price=6.49 if ChoiceSet==54 & Alt==1
replace Price=4.49 if ChoiceSet==54 & Alt==2
replace Price=0 if ChoiceSet==54 & Alt==3

replace Price=12.49 if ChoiceSet==67 & Alt==1
replace Price=6.49 if ChoiceSet==67 & Alt==2
replace Price=0 if ChoiceSet==67 & Alt==3

********Block 8
replace Price=6.49 if ChoiceSet==4 & Alt==1
replace Price=2.49 if ChoiceSet==4 & Alt==2
replace Price=0 if ChoiceSet==4 & Alt==3

replace Price=4.49 if ChoiceSet==9 & Alt==1
replace Price=4.49 if ChoiceSet==9 & Alt==2
replace Price=0 if ChoiceSet==9 & Alt==3

replace Price=4.49 if ChoiceSet==17 & Alt==1
replace Price=8.49 if ChoiceSet==17 & Alt==2
replace Price=0 if ChoiceSet==17 & Alt==3

replace Price=10.49 if ChoiceSet==33 & Alt==1
replace Price=12.49 if ChoiceSet==33 & Alt==2
replace Price=0 if ChoiceSet==33 & Alt==3

replace Price=2.49 if ChoiceSet==48 & Alt==1
replace Price=2.49 if ChoiceSet==48 & Alt==2
replace Price=0 if ChoiceSet==48 & Alt==3

replace Price=8.49 if ChoiceSet==50 & Alt==1
replace Price=2.49 if ChoiceSet==50 & Alt==2
replace Price=0 if ChoiceSet==50 & Alt==3

replace Price=12.49 if ChoiceSet==59 & Alt==1
replace Price=12.49 if ChoiceSet==59 & Alt==2
replace Price=0 if ChoiceSet==59 & Alt==3

replace Price=2.49 if ChoiceSet==64 & Alt==1
replace Price=4.49 if ChoiceSet==64 & Alt==2
replace Price=0 if ChoiceSet==64 & Alt==3

********Block 9
replace Price=2.49 if ChoiceSet==2 & Alt==1
replace Price=6.49 if ChoiceSet==2 & Alt==2
replace Price=0 if ChoiceSet==2 & Alt==3

replace Price=12.49 if ChoiceSet==20 & Alt==1
replace Price=4.49 if ChoiceSet==20 & Alt==2
replace Price=0 if ChoiceSet==20 & Alt==3

replace Price=12.49 if ChoiceSet==27 & Alt==1
replace Price=2.49 if ChoiceSet==27 & Alt==2
replace Price=0 if ChoiceSet==27 & Alt==3

replace Price=6.49 if ChoiceSet==34 & Alt==1
replace Price=12.49 if ChoiceSet==34 & Alt==2
replace Price=0 if ChoiceSet==34 & Alt==3

replace Price=8.49 if ChoiceSet==39 & Alt==1
replace Price=12.49 if ChoiceSet==39 & Alt==2
replace Price=0 if ChoiceSet==39 & Alt==3

replace Price=10.49 if ChoiceSet==57 & Alt==1
replace Price=8.49 if ChoiceSet==57 & Alt==2
replace Price=0 if ChoiceSet==57 & Alt==3

replace Price=10.49 if ChoiceSet==61 & Alt==1
replace Price=10.49 if ChoiceSet==61 & Alt==2
replace Price=0 if ChoiceSet==61 & Alt==3

replace Price=4.49 if ChoiceSet==71 & Alt==1
replace Price=6.49 if ChoiceSet==71 & Alt==2
replace Price=0 if ChoiceSet==71 & Alt==3

***Species

*****Block 1
replace Species=0 if ChoiceSet==3 & Alt==1
replace Species=0 if ChoiceSet==3 & Alt==2
replace Species=0 if ChoiceSet==3 & Alt==3

replace Species=0 if ChoiceSet==21 & Alt==1
replace Species=1 if ChoiceSet==21 & Alt==2
replace Species=0 if ChoiceSet==21 & Alt==3

replace Species=1 if ChoiceSet==25 & Alt==1
replace Species=0 if ChoiceSet==25 & Alt==2
replace Species=0 if ChoiceSet==25 & Alt==3

replace Species=0 if ChoiceSet==35 & Alt==1
replace Species=0 if ChoiceSet==35 & Alt==2
replace Species=0 if ChoiceSet==35 & Alt==3

replace Species=1 if ChoiceSet==38 & Alt==1
replace Species=1 if ChoiceSet==38 & Alt==2
replace Species=0 if ChoiceSet==38 & Alt==3

replace Species=1 if ChoiceSet==56 & Alt==1
replace Species=0 if ChoiceSet==56 & Alt==2
replace Species=0 if ChoiceSet==56 & Alt==3

replace Species=0 if ChoiceSet==63 & Alt==1
replace Species=1 if ChoiceSet==63 & Alt==2
replace Species=0 if ChoiceSet==63 & Alt==3

replace Species=1 if ChoiceSet==70 & Alt==1
replace Species=1 if ChoiceSet==70 & Alt==2
replace Species=0 if ChoiceSet==70 & Alt==3

*****Block 2
replace Species=0 if ChoiceSet==12 & Alt==1
replace Species=0 if ChoiceSet==12 & Alt==2
replace Species=0 if ChoiceSet==12 & Alt==3

replace Species=1 if ChoiceSet==14 & Alt==1
replace Species=1 if ChoiceSet==14 & Alt==2
replace Species=0 if ChoiceSet==14 & Alt==3

replace Species=1 if ChoiceSet==23 & Alt==1
replace Species=0 if ChoiceSet==23 & Alt==2
replace Species=0 if ChoiceSet==23 & Alt==3

replace Species=1 if ChoiceSet==28 & Alt==1
replace Species=1 if ChoiceSet==28 & Alt==2
replace Species=0 if ChoiceSet==28 & Alt==3

replace Species=0 if ChoiceSet==40 & Alt==1
replace Species=0 if ChoiceSet==40 & Alt==2
replace Species=0 if ChoiceSet==40 & Alt==3

replace Species=1 if ChoiceSet==45 & Alt==1
replace Species=0 if ChoiceSet==45 & Alt==2
replace Species=0 if ChoiceSet==45 & Alt==3

replace Species=0 if ChoiceSet==53 & Alt==1
replace Species=1 if ChoiceSet==53 & Alt==2
replace Species=0 if ChoiceSet==53 & Alt==3

replace Species=1 if ChoiceSet==69 & Alt==1
replace Species=0 if ChoiceSet==69 & Alt==2
replace Species=0 if ChoiceSet==69 & Alt==3

*****Block 3
replace Species=1 if ChoiceSet==5 & Alt==1
replace Species=1 if ChoiceSet==5 & Alt==2
replace Species=0 if ChoiceSet==5 & Alt==3

replace Species=0 if ChoiceSet==7 & Alt==1
replace Species=1 if ChoiceSet==7 & Alt==2
replace Species=0 if ChoiceSet==7 & Alt==3

replace Species=1 if ChoiceSet==18 & Alt==1
replace Species=0 if ChoiceSet==18 & Alt==2
replace Species=0 if ChoiceSet==18 & Alt==3

replace Species=0 if ChoiceSet==31 & Alt==1
replace Species=1 if ChoiceSet==31 & Alt==2
replace Species=0 if ChoiceSet==31 & Alt==3

replace Species=1 if ChoiceSet==47 & Alt==1
replace Species=1 if ChoiceSet==47 & Alt==2
replace Species=0 if ChoiceSet==47 & Alt==3

replace Species=0 if ChoiceSet==49 & Alt==1
replace Species=0 if ChoiceSet==49 & Alt==2
replace Species=0 if ChoiceSet==49 & Alt==3

replace Species=0 if ChoiceSet==58 & Alt==1
replace Species=1 if ChoiceSet==58 & Alt==2
replace Species=0 if ChoiceSet==58 & Alt==3

replace Species=0 if ChoiceSet==66 & Alt==1
replace Species=0 if ChoiceSet==66 & Alt==2
replace Species=0 if ChoiceSet==66 & Alt==3

*****Block 4
replace Species=1 if ChoiceSet==6 & Alt==1
replace Species=1 if ChoiceSet==6 & Alt==2
replace Species=0 if ChoiceSet==6 & Alt==3

replace Species=0 if ChoiceSet==8 & Alt==1
replace Species=1 if ChoiceSet==8 & Alt==2
replace Species=0 if ChoiceSet==8 & Alt==3

replace Species=1 if ChoiceSet==16 & Alt==1
replace Species=0 if ChoiceSet==16 & Alt==2
replace Species=0 if ChoiceSet==16 & Alt==3

replace Species=0 if ChoiceSet==32 & Alt==1
replace Species=1 if ChoiceSet==32 & Alt==2
replace Species=0 if ChoiceSet==32 & Alt==3

replace Species=1 if ChoiceSet==46 & Alt==1
replace Species=1 if ChoiceSet==46 & Alt==2
replace Species=0 if ChoiceSet==46 & Alt==3

replace Species=0 if ChoiceSet==51 & Alt==1
replace Species=0 if ChoiceSet==51 & Alt==2
replace Species=0 if ChoiceSet==51 & Alt==3

replace Species=0 if ChoiceSet==60 & Alt==1
replace Species=1 if ChoiceSet==60 & Alt==2
replace Species=0 if ChoiceSet==60 & Alt==3

replace Species=0 if ChoiceSet==65 & Alt==1
replace Species=0 if ChoiceSet==65 & Alt==2
replace Species=0 if ChoiceSet==65 & Alt==3

*****Block 5
replace Species=0 if ChoiceSet==1 & Alt==1
replace Species=0 if ChoiceSet==1 & Alt==2
replace Species=0 if ChoiceSet==1 & Alt==3

replace Species=0 if ChoiceSet==19 & Alt==1
replace Species=1 if ChoiceSet==19 & Alt==2
replace Species=0 if ChoiceSet==19 & Alt==3

replace Species=1 if ChoiceSet==26 & Alt==1
replace Species=0 if ChoiceSet==26 & Alt==2
replace Species=0 if ChoiceSet==26 & Alt==3

replace Species=0 if ChoiceSet==36 & Alt==1
replace Species=0 if ChoiceSet==36 & Alt==2
replace Species=0 if ChoiceSet==36 & Alt==3

replace Species=1 if ChoiceSet==37 & Alt==1
replace Species=1 if ChoiceSet==37 & Alt==2
replace Species=0 if ChoiceSet==37 & Alt==3

replace Species=1 if ChoiceSet==55 & Alt==1
replace Species=0 if ChoiceSet==55 & Alt==2
replace Species=0 if ChoiceSet==55 & Alt==3

replace Species=0 if ChoiceSet==62 & Alt==1
replace Species=1 if ChoiceSet==62 & Alt==2
replace Species=0 if ChoiceSet==62 & Alt==3

replace Species=1 if ChoiceSet==72 & Alt==1
replace Species=1 if ChoiceSet==72 & Alt==2
replace Species=0 if ChoiceSet==72 & Alt==3

*****Block 6
replace Species=0 if ChoiceSet==10 & Alt==1
replace Species=0 if ChoiceSet==10 & Alt==2
replace Species=0 if ChoiceSet==10 & Alt==3

replace Species=1 if ChoiceSet==15 & Alt==1
replace Species=1 if ChoiceSet==15 & Alt==2
replace Species=0 if ChoiceSet==15 & Alt==3

replace Species=1 if ChoiceSet==24 & Alt==1
replace Species=0 if ChoiceSet==24 & Alt==2
replace Species=0 if ChoiceSet==24 & Alt==3

replace Species=1 if ChoiceSet==29 & Alt==1
replace Species=1 if ChoiceSet==29 & Alt==2
replace Species=0 if ChoiceSet==29 & Alt==3

replace Species=0 if ChoiceSet==42 & Alt==1
replace Species=0 if ChoiceSet==42 & Alt==2
replace Species=0 if ChoiceSet==42 & Alt==3

replace Species=1 if ChoiceSet==44 & Alt==1
replace Species=0 if ChoiceSet==44 & Alt==2
replace Species=0 if ChoiceSet==44 & Alt==3

replace Species=0 if ChoiceSet==52 & Alt==1
replace Species=1 if ChoiceSet==52 & Alt==2
replace Species=0 if ChoiceSet==52 & Alt==3

replace Species=1 if ChoiceSet==68 & Alt==1
replace Species=0 if ChoiceSet==68 & Alt==2
replace Species=0 if ChoiceSet==68 & Alt==3

*****Block 7
replace Species=0 if ChoiceSet==11 & Alt==1
replace Species=0 if ChoiceSet==11 & Alt==2
replace Species=0 if ChoiceSet==11 & Alt==3

replace Species=1 if ChoiceSet==13 & Alt==1
replace Species=1 if ChoiceSet==13 & Alt==2
replace Species=0 if ChoiceSet==13 & Alt==3

replace Species=1 if ChoiceSet==22 & Alt==1
replace Species=0 if ChoiceSet==22 & Alt==2
replace Species=0 if ChoiceSet==22 & Alt==3

replace Species=1 if ChoiceSet==30 & Alt==1
replace Species=1 if ChoiceSet==30 & Alt==2
replace Species=0 if ChoiceSet==30 & Alt==3

replace Species=0 if ChoiceSet==41 & Alt==1
replace Species=0 if ChoiceSet==41 & Alt==2
replace Species=0 if ChoiceSet==41 & Alt==3

replace Species=1 if ChoiceSet==43 & Alt==1
replace Species=0 if ChoiceSet==43 & Alt==2
replace Species=0 if ChoiceSet==43 & Alt==3

replace Species=0 if ChoiceSet==54 & Alt==1
replace Species=1 if ChoiceSet==54 & Alt==2
replace Species=0 if ChoiceSet==54 & Alt==3

replace Species=1 if ChoiceSet==67 & Alt==1
replace Species=0 if ChoiceSet==67 & Alt==2
replace Species=0 if ChoiceSet==67 & Alt==3

*****Block 8
replace Species=1 if ChoiceSet==4 & Alt==1
replace Species=1 if ChoiceSet==4 & Alt==2
replace Species=0 if ChoiceSet==4 & Alt==3

replace Species=0 if ChoiceSet==9 & Alt==1
replace Species=1 if ChoiceSet==9 & Alt==2
replace Species=0 if ChoiceSet==9 & Alt==3

replace Species=1 if ChoiceSet==17 & Alt==1
replace Species=0 if ChoiceSet==17 & Alt==2
replace Species=0 if ChoiceSet==17 & Alt==3

replace Species=0 if ChoiceSet==33 & Alt==1
replace Species=1 if ChoiceSet==33 & Alt==2
replace Species=0 if ChoiceSet==33 & Alt==3

replace Species=1 if ChoiceSet==48 & Alt==1
replace Species=1 if ChoiceSet==48 & Alt==2
replace Species=0 if ChoiceSet==48 & Alt==3

replace Species=0 if ChoiceSet==50 & Alt==1
replace Species=0 if ChoiceSet==50 & Alt==2
replace Species=0 if ChoiceSet==50 & Alt==3

replace Species=0 if ChoiceSet==59 & Alt==1
replace Species=1 if ChoiceSet==59 & Alt==2
replace Species=0 if ChoiceSet==59 & Alt==3

replace Species=0 if ChoiceSet==64 & Alt==1
replace Species=0 if ChoiceSet==64 & Alt==2
replace Species=0 if ChoiceSet==64 & Alt==3

*****Block 9
replace Species=0 if ChoiceSet==2 & Alt==1
replace Species=0 if ChoiceSet==2 & Alt==2
replace Species=0 if ChoiceSet==2 & Alt==3

replace Species=0 if ChoiceSet==20 & Alt==1
replace Species=1 if ChoiceSet==20 & Alt==2
replace Species=0 if ChoiceSet==20 & Alt==3

replace Species=1 if ChoiceSet==27 & Alt==1
replace Species=0 if ChoiceSet==27 & Alt==2
replace Species=0 if ChoiceSet==27 & Alt==3

replace Species=0 if ChoiceSet==34 & Alt==1
replace Species=0 if ChoiceSet==34 & Alt==2
replace Species=0 if ChoiceSet==34 & Alt==3

replace Species=1 if ChoiceSet==39 & Alt==1
replace Species=1 if ChoiceSet==39 & Alt==2
replace Species=0 if ChoiceSet==39 & Alt==3

replace Species=1 if ChoiceSet==57 & Alt==1
replace Species=0 if ChoiceSet==57 & Alt==2
replace Species=0 if ChoiceSet==57 & Alt==3

replace Species=0 if ChoiceSet==61 & Alt==1
replace Species=1 if ChoiceSet==61 & Alt==2
replace Species=0 if ChoiceSet==61 & Alt==3

replace Species=1 if ChoiceSet==71 & Alt==1
replace Species=1 if ChoiceSet==71 & Alt==2
replace Species=0 if ChoiceSet==71 & Alt==3

***Country of Origin

*****Block 1
replace COO=2 if ChoiceSet==3 & Alt==1
replace COO=0 if ChoiceSet==3 & Alt==2
replace COO=0 if ChoiceSet==3 & Alt==3

replace COO=0 if ChoiceSet==21 & Alt==1
replace COO=1 if ChoiceSet==21 & Alt==2
replace COO=0 if ChoiceSet==21 & Alt==3

replace COO=2 if ChoiceSet==25 & Alt==1
replace COO=2 if ChoiceSet==25 & Alt==2
replace COO=0 if ChoiceSet==25 & Alt==3

replace COO=1 if ChoiceSet==35 & Alt==1
replace COO=0 if ChoiceSet==35 & Alt==2
replace COO=0 if ChoiceSet==35 & Alt==3

replace COO=1 if ChoiceSet==38 & Alt==1
replace COO=0 if ChoiceSet==38 & Alt==2
replace COO=0 if ChoiceSet==38 & Alt==3

replace COO=0 if ChoiceSet==56 & Alt==1
replace COO=2 if ChoiceSet==56 & Alt==2
replace COO=0 if ChoiceSet==56 & Alt==3

replace COO=1 if ChoiceSet==63 & Alt==1
replace COO=1 if ChoiceSet==63 & Alt==2
replace COO=0 if ChoiceSet==63 & Alt==3

replace COO=2 if ChoiceSet==70 & Alt==1
replace COO=0 if ChoiceSet==70 & Alt==2
replace COO=0 if ChoiceSet==70 & Alt==3

*****Block 2
replace COO=0 if ChoiceSet==12 & Alt==1
replace COO=2 if ChoiceSet==12 & Alt==2
replace COO=0 if ChoiceSet==12 & Alt==3

replace COO=1 if ChoiceSet==14 & Alt==1
replace COO=1 if ChoiceSet==14 & Alt==2
replace COO=0 if ChoiceSet==14 & Alt==3

replace COO=2 if ChoiceSet==23 & Alt==1
replace COO=2 if ChoiceSet==23 & Alt==2
replace COO=0 if ChoiceSet==23 & Alt==3

replace COO=1 if ChoiceSet==28 & Alt==1
replace COO=0 if ChoiceSet==28 & Alt==2
replace COO=0 if ChoiceSet==28 & Alt==3

replace COO=0 if ChoiceSet==40 & Alt==1
replace COO=1 if ChoiceSet==40 & Alt==2
replace COO=0 if ChoiceSet==40 & Alt==3

replace COO=1 if ChoiceSet==45 & Alt==1
replace COO=0 if ChoiceSet==45 & Alt==2
replace COO=0 if ChoiceSet==45 & Alt==3

replace COO=2 if ChoiceSet==53 & Alt==1
replace COO=2 if ChoiceSet==53 & Alt==2
replace COO=0 if ChoiceSet==53 & Alt==3

replace COO=0 if ChoiceSet==69 & Alt==1
replace COO=2 if ChoiceSet==69 & Alt==2
replace COO=0 if ChoiceSet==69 & Alt==3

*****Block 3
replace COO=0 if ChoiceSet==5 & Alt==1
replace COO=2 if ChoiceSet==5 & Alt==2
replace COO=0 if ChoiceSet==5 & Alt==3

replace COO=2 if ChoiceSet==7 & Alt==1
replace COO=0 if ChoiceSet==7 & Alt==2
replace COO=0 if ChoiceSet==7 & Alt==3

replace COO=1 if ChoiceSet==18 & Alt==1
replace COO=1 if ChoiceSet==18 & Alt==2
replace COO=0 if ChoiceSet==18 & Alt==3

replace COO=0 if ChoiceSet==31 & Alt==1
replace COO=1 if ChoiceSet==31 & Alt==2
replace COO=0 if ChoiceSet==31 & Alt==3

replace COO=0 if ChoiceSet==47 & Alt==1
replace COO=1 if ChoiceSet==47 & Alt==2
replace COO=0 if ChoiceSet==47 & Alt==3

replace COO=2 if ChoiceSet==49 & Alt==1
replace COO=2 if ChoiceSet==49 & Alt==2
replace COO=0 if ChoiceSet==49 & Alt==3

replace COO=1 if ChoiceSet==58 & Alt==1
replace COO=1 if ChoiceSet==58 & Alt==2
replace COO=0 if ChoiceSet==58 & Alt==3

replace COO=2 if ChoiceSet==66 & Alt==1
replace COO=0 if ChoiceSet==66 & Alt==2
replace COO=0 if ChoiceSet==66 & Alt==3

*****Block 4
replace COO=1 if ChoiceSet==6 & Alt==1
replace COO=0 if ChoiceSet==6 & Alt==2
replace COO=0 if ChoiceSet==6 & Alt==3

replace COO=0 if ChoiceSet==8 & Alt==1
replace COO=1 if ChoiceSet==8 & Alt==2
replace COO=0 if ChoiceSet==8 & Alt==3

replace COO=2 if ChoiceSet==16 & Alt==1
replace COO=2 if ChoiceSet==16 & Alt==2
replace COO=0 if ChoiceSet==16 & Alt==3

replace COO=1 if ChoiceSet==32 & Alt==1
replace COO=2 if ChoiceSet==32 & Alt==2
replace COO=0 if ChoiceSet==32 & Alt==3

replace COO=1 if ChoiceSet==46 & Alt==1
replace COO=2 if ChoiceSet==46 & Alt==2
replace COO=0 if ChoiceSet==46 & Alt==3

replace COO=0 if ChoiceSet==51 & Alt==1
replace COO=0 if ChoiceSet==51 & Alt==2
replace COO=0 if ChoiceSet==51 & Alt==3

replace COO=2 if ChoiceSet==60 & Alt==1
replace COO=2 if ChoiceSet==60 & Alt==2
replace COO=0 if ChoiceSet==60 & Alt==3

replace COO=0 if ChoiceSet==65 & Alt==1
replace COO=1 if ChoiceSet==65 & Alt==2
replace COO=0 if ChoiceSet==65 & Alt==3

*****Block 5
replace COO=0 if ChoiceSet==1 & Alt==1
replace COO=1 if ChoiceSet==1 & Alt==2
replace COO=0 if ChoiceSet==1 & Alt==3

replace COO=1 if ChoiceSet==19 & Alt==1
replace COO=2 if ChoiceSet==19 & Alt==2
replace COO=0 if ChoiceSet==19 & Alt==3

replace COO=0 if ChoiceSet==26 & Alt==1
replace COO=0 if ChoiceSet==26 & Alt==2
replace COO=0 if ChoiceSet==26 & Alt==3

replace COO=2 if ChoiceSet==36 & Alt==1
replace COO=1 if ChoiceSet==36 & Alt==2
replace COO=0 if ChoiceSet==36 & Alt==3

replace COO=2 if ChoiceSet==37 & Alt==1
replace COO=1 if ChoiceSet==37 & Alt==2
replace COO=0 if ChoiceSet==37 & Alt==3

replace COO=1 if ChoiceSet==55 & Alt==1
replace COO=0 if ChoiceSet==55 & Alt==2
replace COO=0 if ChoiceSet==55 & Alt==3

replace COO=2 if ChoiceSet==62 & Alt==1
replace COO=2 if ChoiceSet==62 & Alt==2
replace COO=0 if ChoiceSet==62 & Alt==3

replace COO=0 if ChoiceSet==72 & Alt==1
replace COO=1 if ChoiceSet==72 & Alt==2
replace COO=0 if ChoiceSet==72 & Alt==3

*****Block 6
replace COO=1 if ChoiceSet==10 & Alt==1
replace COO=0 if ChoiceSet==10 & Alt==2
replace COO=0 if ChoiceSet==10 & Alt==3

replace COO=2 if ChoiceSet==15 & Alt==1
replace COO=2 if ChoiceSet==15 & Alt==2
replace COO=0 if ChoiceSet==15 & Alt==3

replace COO=0 if ChoiceSet==24 & Alt==1
replace COO=0 if ChoiceSet==24 & Alt==2
replace COO=0 if ChoiceSet==24 & Alt==3

replace COO=2 if ChoiceSet==29 & Alt==1
replace COO=1 if ChoiceSet==29 & Alt==2
replace COO=0 if ChoiceSet==29 & Alt==3

replace COO=1 if ChoiceSet==42 & Alt==1
replace COO=2 if ChoiceSet==42 & Alt==2
replace COO=0 if ChoiceSet==42 & Alt==3

replace COO=2 if ChoiceSet==44 & Alt==1
replace COO=1 if ChoiceSet==44 & Alt==2
replace COO=0 if ChoiceSet==44 & Alt==3

replace COO=0 if ChoiceSet==52 & Alt==1
replace COO=0 if ChoiceSet==52 & Alt==2
replace COO=0 if ChoiceSet==52 & Alt==3

replace COO=1 if ChoiceSet==68 & Alt==1
replace COO=0 if ChoiceSet==68 & Alt==2
replace COO=0 if ChoiceSet==68 & Alt==3

*****Block 7
replace COO=2 if ChoiceSet==11 & Alt==1
replace COO=1 if ChoiceSet==11 & Alt==2
replace COO=0 if ChoiceSet==11 & Alt==3

replace COO=0 if ChoiceSet==13 & Alt==1
replace COO=0 if ChoiceSet==13 & Alt==2
replace COO=0 if ChoiceSet==13 & Alt==3

replace COO=1 if ChoiceSet==22 & Alt==1
replace COO=1 if ChoiceSet==22 & Alt==2
replace COO=0 if ChoiceSet==22 & Alt==3

replace COO=0 if ChoiceSet==30 & Alt==1
replace COO=2 if ChoiceSet==30 & Alt==2
replace COO=0 if ChoiceSet==30 & Alt==3

replace COO=2 if ChoiceSet==41 & Alt==1
replace COO=0 if ChoiceSet==41 & Alt==2
replace COO=0 if ChoiceSet==41 & Alt==3

replace COO=0 if ChoiceSet==43 & Alt==1
replace COO=2 if ChoiceSet==43 & Alt==2
replace COO=0 if ChoiceSet==43 & Alt==3

replace COO=1 if ChoiceSet==54 & Alt==1
replace COO=1 if ChoiceSet==54 & Alt==2
replace COO=0 if ChoiceSet==54 & Alt==3

replace COO=2 if ChoiceSet==67 & Alt==1
replace COO=1 if ChoiceSet==67 & Alt==2
replace COO=0 if ChoiceSet==67 & Alt==3

*****Block 8
replace COO=2 if ChoiceSet==4 & Alt==1
replace COO=1 if ChoiceSet==4 & Alt==2
replace COO=0 if ChoiceSet==4 & Alt==3

replace COO=1 if ChoiceSet==9 & Alt==1
replace COO=2 if ChoiceSet==9 & Alt==2
replace COO=0 if ChoiceSet==9 & Alt==3

replace COO=0 if ChoiceSet==17 & Alt==1
replace COO=0 if ChoiceSet==17 & Alt==2
replace COO=0 if ChoiceSet==17 & Alt==3

replace COO=2 if ChoiceSet==33 & Alt==1
replace COO=0 if ChoiceSet==33 & Alt==2
replace COO=0 if ChoiceSet==33 & Alt==3

replace COO=2 if ChoiceSet==48 & Alt==1
replace COO=0 if ChoiceSet==48 & Alt==2
replace COO=0 if ChoiceSet==48 & Alt==3

replace COO=1 if ChoiceSet==50 & Alt==1
replace COO=1 if ChoiceSet==50 & Alt==2
replace COO=0 if ChoiceSet==50 & Alt==3

replace COO=0 if ChoiceSet==59 & Alt==1
replace COO=0 if ChoiceSet==59 & Alt==2
replace COO=0 if ChoiceSet==59 & Alt==3

replace COO=1 if ChoiceSet==64 & Alt==1
replace COO=2 if ChoiceSet==64 & Alt==2
replace COO=0 if ChoiceSet==64 & Alt==3

*****Block 9
replace COO=1 if ChoiceSet==2 & Alt==1
replace COO=2 if ChoiceSet==2 & Alt==2
replace COO=0 if ChoiceSet==2 & Alt==3

replace COO=2 if ChoiceSet==20 & Alt==1
replace COO=0 if ChoiceSet==20 & Alt==2
replace COO=0 if ChoiceSet==20 & Alt==3

replace COO=1 if ChoiceSet==27 & Alt==1
replace COO=1 if ChoiceSet==27 & Alt==2
replace COO=0 if ChoiceSet==27 & Alt==3

replace COO=0 if ChoiceSet==34 & Alt==1
replace COO=2 if ChoiceSet==34 & Alt==2
replace COO=0 if ChoiceSet==34 & Alt==3

replace COO=0 if ChoiceSet==39 & Alt==1
replace COO=2 if ChoiceSet==39 & Alt==2
replace COO=0 if ChoiceSet==39 & Alt==3

replace COO=2 if ChoiceSet==57 & Alt==1
replace COO=1 if ChoiceSet==57 & Alt==2
replace COO=0 if ChoiceSet==57 & Alt==3

replace COO=0 if ChoiceSet==61 & Alt==1
replace COO=0 if ChoiceSet==61 & Alt==2
replace COO=0 if ChoiceSet==61 & Alt==3

replace COO=1 if ChoiceSet==71 & Alt==1
replace COO=2 if ChoiceSet==71 & Alt==2
replace COO=0 if ChoiceSet==71 & Alt==3

***Sustainability Label
***0: kein Label, 1: ASC, 2: Naturland (jew. für Alt1 & Alt2)

*****Block 1
replace SustLabel=0 if ChoiceSet==3 & Alt==1
replace SustLabel=0 if ChoiceSet==3 & Alt==2
replace SustLabel=0 if ChoiceSet==3 & Alt==3

replace SustLabel=2 if ChoiceSet==21 & Alt==1
replace SustLabel=1 if ChoiceSet==21 & Alt==2
replace SustLabel=0 if ChoiceSet==21 & Alt==3

replace SustLabel=1 if ChoiceSet==25 & Alt==1
replace SustLabel=2 if ChoiceSet==25 & Alt==2
replace SustLabel=0 if ChoiceSet==25 & Alt==3

replace SustLabel=2 if ChoiceSet==35 & Alt==1
replace SustLabel=2 if ChoiceSet==35 & Alt==2
replace SustLabel=0 if ChoiceSet==35 & Alt==3

replace SustLabel=2 if ChoiceSet==38 & Alt==1
replace SustLabel=2 if ChoiceSet==38 & Alt==2
replace SustLabel=0 if ChoiceSet==38 & Alt==3

replace SustLabel=0 if ChoiceSet==56 & Alt==1
replace SustLabel=1 if ChoiceSet==56 & Alt==2
replace SustLabel=0 if ChoiceSet==56 & Alt==3

replace SustLabel=1 if ChoiceSet==63 & Alt==1
replace SustLabel=0 if ChoiceSet==63 & Alt==2
replace SustLabel=0 if ChoiceSet==63 & Alt==3

replace SustLabel=0 if ChoiceSet==70 & Alt==1
replace SustLabel=0 if ChoiceSet==70 & Alt==2
replace SustLabel=0 if ChoiceSet==70 & Alt==3

*****Block 2
replace SustLabel=0 if ChoiceSet==12 & Alt==1
replace SustLabel=2 if ChoiceSet==12 & Alt==2
replace SustLabel=0 if ChoiceSet==12 & Alt==3

replace SustLabel=1 if ChoiceSet==14 & Alt==1
replace SustLabel=0 if ChoiceSet==14 & Alt==2
replace SustLabel=0 if ChoiceSet==14 & Alt==3

replace SustLabel=1 if ChoiceSet==23 & Alt==1
replace SustLabel=1 if ChoiceSet==23 & Alt==2
replace SustLabel=0 if ChoiceSet==23 & Alt==3

replace SustLabel=2 if ChoiceSet==28 & Alt==1
replace SustLabel=1 if ChoiceSet==28 & Alt==2
replace SustLabel=0 if ChoiceSet==28 & Alt==3

replace SustLabel=2 if ChoiceSet==40 & Alt==1
replace SustLabel=2 if ChoiceSet==40 & Alt==2
replace SustLabel=0 if ChoiceSet==40 & Alt==3

replace SustLabel=2 if ChoiceSet==45 & Alt==1
replace SustLabel=1 if ChoiceSet==45 & Alt==2
replace SustLabel=0 if ChoiceSet==45 & Alt==3

replace SustLabel=1 if ChoiceSet==53 & Alt==1
replace SustLabel=0 if ChoiceSet==53 & Alt==2
replace SustLabel=0 if ChoiceSet==53 & Alt==3

replace SustLabel=0 if ChoiceSet==69 & Alt==1
replace SustLabel=2 if ChoiceSet==69 & Alt==2
replace SustLabel=0 if ChoiceSet==69 & Alt==3

*****Block 3
replace SustLabel=0 if ChoiceSet==5 & Alt==1
replace SustLabel=0 if ChoiceSet==5 & Alt==2
replace SustLabel=0 if ChoiceSet==5 & Alt==3

replace SustLabel=0 if ChoiceSet==7 & Alt==1
replace SustLabel=1 if ChoiceSet==7 & Alt==2
replace SustLabel=0 if ChoiceSet==7 & Alt==3

replace SustLabel=1 if ChoiceSet==18 & Alt==1
replace SustLabel=2 if ChoiceSet==18 & Alt==2
replace SustLabel=0 if ChoiceSet==18 & Alt==3

replace SustLabel=2 if ChoiceSet==31 & Alt==1
replace SustLabel=0 if ChoiceSet==31 & Alt==2
replace SustLabel=0 if ChoiceSet==31 & Alt==3

replace SustLabel=2 if ChoiceSet==47 & Alt==1
replace SustLabel=0 if ChoiceSet==47 & Alt==2
replace SustLabel=0 if ChoiceSet==47 & Alt==3

replace SustLabel=1 if ChoiceSet==49 & Alt==1
replace SustLabel=2 if ChoiceSet==49 & Alt==2
replace SustLabel=0 if ChoiceSet==49 & Alt==3

replace SustLabel=1 if ChoiceSet==58 & Alt==1
replace SustLabel=1 if ChoiceSet==58 & Alt==2
replace SustLabel=0 if ChoiceSet==58 & Alt==3

replace SustLabel=0 if ChoiceSet==66 & Alt==1
replace SustLabel=1 if ChoiceSet==66 & Alt==2
replace SustLabel=0 if ChoiceSet==66 & Alt==3

*****Block 4
replace SustLabel=1 if ChoiceSet==6 & Alt==1
replace SustLabel=1 if ChoiceSet==6 & Alt==2
replace SustLabel=0 if ChoiceSet==6 & Alt==3

replace SustLabel=1 if ChoiceSet==8 & Alt==1
replace SustLabel=2 if ChoiceSet==8 & Alt==2
replace SustLabel=0 if ChoiceSet==8 & Alt==3

replace SustLabel=2 if ChoiceSet==16 & Alt==1
replace SustLabel=0 if ChoiceSet==16 & Alt==2
replace SustLabel=0 if ChoiceSet==16 & Alt==3

replace SustLabel=0 if ChoiceSet==32 & Alt==1
replace SustLabel=1 if ChoiceSet==32 & Alt==2
replace SustLabel=0 if ChoiceSet==32 & Alt==3

replace SustLabel=0 if ChoiceSet==46 & Alt==1
replace SustLabel=1 if ChoiceSet==46 & Alt==2
replace SustLabel=0 if ChoiceSet==46 & Alt==3

replace SustLabel=2 if ChoiceSet==51 & Alt==1
replace SustLabel=0 if ChoiceSet==51 & Alt==2
replace SustLabel=0 if ChoiceSet==51 & Alt==3

replace SustLabel=2 if ChoiceSet==60 & Alt==1
replace SustLabel=2 if ChoiceSet==60 & Alt==2
replace SustLabel=0 if ChoiceSet==60 & Alt==3

replace SustLabel=1 if ChoiceSet==65 & Alt==1
replace SustLabel=2 if ChoiceSet==65 & Alt==2
replace SustLabel=0 if ChoiceSet==65 & Alt==3

*****Block 5
replace SustLabel=1 if ChoiceSet==1 & Alt==1
replace SustLabel=1 if ChoiceSet==1 & Alt==2
replace SustLabel=0 if ChoiceSet==1 & Alt==3

replace SustLabel=0 if ChoiceSet==19 & Alt==1
replace SustLabel=2 if ChoiceSet==19 & Alt==2
replace SustLabel=0 if ChoiceSet==19 & Alt==3

replace SustLabel=2 if ChoiceSet==26 & Alt==1
replace SustLabel=0 if ChoiceSet==26 & Alt==2
replace SustLabel=0 if ChoiceSet==26 & Alt==3

replace SustLabel=0 if ChoiceSet==36 & Alt==1
replace SustLabel=0 if ChoiceSet==36 & Alt==2
replace SustLabel=0 if ChoiceSet==36 & Alt==3

replace SustLabel=0 if ChoiceSet==37 & Alt==1
replace SustLabel=0 if ChoiceSet==37 & Alt==2
replace SustLabel=0 if ChoiceSet==37 & Alt==3

replace SustLabel=1 if ChoiceSet==55 & Alt==1
replace SustLabel=2 if ChoiceSet==55 & Alt==2
replace SustLabel=0 if ChoiceSet==55 & Alt==3

replace SustLabel=2 if ChoiceSet==62 & Alt==1
replace SustLabel=1 if ChoiceSet==62 & Alt==2
replace SustLabel=0 if ChoiceSet==62 & Alt==3

replace SustLabel=1 if ChoiceSet==72 & Alt==1
replace SustLabel=1 if ChoiceSet==72 & Alt==2
replace SustLabel=0 if ChoiceSet==72 & Alt==3

*****Block 6
replace SustLabel=1 if ChoiceSet==10 & Alt==1
replace SustLabel=0 if ChoiceSet==10 & Alt==2
replace SustLabel=0 if ChoiceSet==10 & Alt==3

replace SustLabel=2 if ChoiceSet==15 & Alt==1
replace SustLabel=1 if ChoiceSet==15 & Alt==2
replace SustLabel=0 if ChoiceSet==15 & Alt==3

replace SustLabel=2 if ChoiceSet==24 & Alt==1
replace SustLabel=2 if ChoiceSet==24 & Alt==2
replace SustLabel=0 if ChoiceSet==24 & Alt==3

replace SustLabel=0 if ChoiceSet==29 & Alt==1
replace SustLabel=2 if ChoiceSet==29 & Alt==2
replace SustLabel=0 if ChoiceSet==29 & Alt==3

replace SustLabel=0 if ChoiceSet==42 & Alt==1
replace SustLabel=0 if ChoiceSet==42 & Alt==2
replace SustLabel=0 if ChoiceSet==42 & Alt==3

replace SustLabel=0 if ChoiceSet==44 & Alt==1
replace SustLabel=2 if ChoiceSet==44 & Alt==2
replace SustLabel=0 if ChoiceSet==44 & Alt==3

replace SustLabel=2 if ChoiceSet==52 & Alt==1
replace SustLabel=1 if ChoiceSet==52 & Alt==2
replace SustLabel=0 if ChoiceSet==52 & Alt==3

replace SustLabel=1 if ChoiceSet==68 & Alt==1
replace SustLabel=0 if ChoiceSet==68 & Alt==2
replace SustLabel=0 if ChoiceSet==68 & Alt==3

*****Block 7
replace SustLabel=2 if ChoiceSet==11 & Alt==1
replace SustLabel=1 if ChoiceSet==11 & Alt==2
replace SustLabel=0 if ChoiceSet==11 & Alt==3

replace SustLabel=0 if ChoiceSet==13 & Alt==1
replace SustLabel=2 if ChoiceSet==13 & Alt==2
replace SustLabel=0 if ChoiceSet==13 & Alt==3

replace SustLabel=0 if ChoiceSet==22 & Alt==1
replace SustLabel=0 if ChoiceSet==22 & Alt==2
replace SustLabel=0 if ChoiceSet==22 & Alt==3

replace SustLabel=1 if ChoiceSet==30 & Alt==1
replace SustLabel=0 if ChoiceSet==30 & Alt==2
replace SustLabel=0 if ChoiceSet==30 & Alt==3

replace SustLabel=1 if ChoiceSet==41 & Alt==1
replace SustLabel=1 if ChoiceSet==41 & Alt==2
replace SustLabel=0 if ChoiceSet==41 & Alt==3

replace SustLabel=1 if ChoiceSet==43 & Alt==1
replace SustLabel=0 if ChoiceSet==43 & Alt==2
replace SustLabel=0 if ChoiceSet==43 & Alt==3

replace SustLabel=0 if ChoiceSet==54 & Alt==1
replace SustLabel=2 if ChoiceSet==54 & Alt==2
replace SustLabel=0 if ChoiceSet==54 & Alt==3

replace SustLabel=2 if ChoiceSet==67 & Alt==1
replace SustLabel=1 if ChoiceSet==67 & Alt==2
replace SustLabel=0 if ChoiceSet==67 & Alt==3

*****Block 8
replace SustLabel=2 if ChoiceSet==4 & Alt==1
replace SustLabel=2 if ChoiceSet==4 & Alt==2
replace SustLabel=0 if ChoiceSet==4 & Alt==3

replace SustLabel=2 if ChoiceSet==9 & Alt==1
replace SustLabel=0 if ChoiceSet==9 & Alt==2
replace SustLabel=0 if ChoiceSet==9 & Alt==3

replace SustLabel=0 if ChoiceSet==17 & Alt==1
replace SustLabel=1 if ChoiceSet==17 & Alt==2
replace SustLabel=0 if ChoiceSet==17 & Alt==3

replace SustLabel=1 if ChoiceSet==33 & Alt==1
replace SustLabel=2 if ChoiceSet==33 & Alt==2
replace SustLabel=0 if ChoiceSet==33 & Alt==3

replace SustLabel=1 if ChoiceSet==48 & Alt==1
replace SustLabel=2 if ChoiceSet==48 & Alt==2
replace SustLabel=0 if ChoiceSet==48 & Alt==3

replace SustLabel=0 if ChoiceSet==50 & Alt==1
replace SustLabel=1 if ChoiceSet==50 & Alt==2
replace SustLabel=0 if ChoiceSet==50 & Alt==3

replace SustLabel=0 if ChoiceSet==59 & Alt==1
replace SustLabel=0 if ChoiceSet==59 & Alt==2
replace SustLabel=0 if ChoiceSet==59 & Alt==3

replace SustLabel=2 if ChoiceSet==64 & Alt==1
replace SustLabel=0 if ChoiceSet==64 & Alt==2
replace SustLabel=0 if ChoiceSet==64 & Alt==3

*****Block 9
replace SustLabel=2 if ChoiceSet==2 & Alt==1
replace SustLabel=2 if ChoiceSet==2 & Alt==2
replace SustLabel=0 if ChoiceSet==2 & Alt==3

replace SustLabel=1 if ChoiceSet==20 & Alt==1
replace SustLabel=0 if ChoiceSet==20 & Alt==2
replace SustLabel=0 if ChoiceSet==20 & Alt==3

replace SustLabel=0 if ChoiceSet==27 & Alt==1
replace SustLabel=1 if ChoiceSet==27 & Alt==2
replace SustLabel=0 if ChoiceSet==27 & Alt==3

replace SustLabel=1 if ChoiceSet==34 & Alt==1
replace SustLabel=1 if ChoiceSet==34 & Alt==2
replace SustLabel=0 if ChoiceSet==34 & Alt==3

replace SustLabel=1 if ChoiceSet==39 & Alt==1
replace SustLabel=1 if ChoiceSet==39 & Alt==2
replace SustLabel=0 if ChoiceSet==39 & Alt==3

replace SustLabel=2 if ChoiceSet==57 & Alt==1
replace SustLabel=0 if ChoiceSet==57 & Alt==2
replace SustLabel=0 if ChoiceSet==57 & Alt==3

replace SustLabel=0 if ChoiceSet==61 & Alt==1
replace SustLabel=2 if ChoiceSet==61 & Alt==2
replace SustLabel=0 if ChoiceSet==61 & Alt==3

replace SustLabel=2 if ChoiceSet==71 & Alt==1
replace SustLabel=2 if ChoiceSet==71 & Alt==2
replace SustLabel=0 if ChoiceSet==71 & Alt==3

***Brand
*****(0: no brand; 1: COSTA)

*****Block 1
replace Brand=1 if ChoiceSet==3 & Alt==1
replace Brand=1 if ChoiceSet==3 & Alt==2
replace Brand=0 if ChoiceSet==3 & Alt==3

replace Brand=0 if ChoiceSet==21 & Alt==1
replace Brand=0 if ChoiceSet==21 & Alt==2
replace Brand=0 if ChoiceSet==21 & Alt==3

replace Brand=1 if ChoiceSet==25 & Alt==1
replace Brand=0 if ChoiceSet==25 & Alt==2
replace Brand=0 if ChoiceSet==25 & Alt==3

replace Brand=1 if ChoiceSet==35 & Alt==1
replace Brand=0 if ChoiceSet==35 & Alt==2
replace Brand=0 if ChoiceSet==35 & Alt==3

replace Brand=0 if ChoiceSet==38 & Alt==1
replace Brand=0 if ChoiceSet==38 & Alt==2
replace Brand=0 if ChoiceSet==38 & Alt==3

replace Brand=1 if ChoiceSet==56 & Alt==1
replace Brand=1 if ChoiceSet==56 & Alt==2
replace Brand=0 if ChoiceSet==56 & Alt==3

replace Brand=0 if ChoiceSet==63 & Alt==1
replace Brand=1 if ChoiceSet==63 & Alt==2
replace Brand=0 if ChoiceSet==63 & Alt==3

replace Brand=0 if ChoiceSet==70 & Alt==1
replace Brand=1 if ChoiceSet==70 & Alt==2
replace Brand=0 if ChoiceSet==70 & Alt==3

*****Block 2
replace Brand=0 if ChoiceSet==12 & Alt==1
replace Brand=1 if ChoiceSet==12 & Alt==2
replace Brand=0 if ChoiceSet==12 & Alt==3

replace Brand=1 if ChoiceSet==14 & Alt==1
replace Brand=1 if ChoiceSet==14 & Alt==2
replace Brand=0 if ChoiceSet==14 & Alt==3

replace Brand=0 if ChoiceSet==23 & Alt==1
replace Brand=0 if ChoiceSet==23 & Alt==2
replace Brand=0 if ChoiceSet==23 & Alt==3

replace Brand=1 if ChoiceSet==28 & Alt==1
replace Brand=0 if ChoiceSet==28 & Alt==2
replace Brand=0 if ChoiceSet==28 & Alt==3

replace Brand=1 if ChoiceSet==40 & Alt==1
replace Brand=0 if ChoiceSet==40 & Alt==2
replace Brand=0 if ChoiceSet==40 & Alt==3

replace Brand=0 if ChoiceSet==45 & Alt==1
replace Brand=0 if ChoiceSet==45 & Alt==2
replace Brand=0 if ChoiceSet==45 & Alt==3

replace Brand=1 if ChoiceSet==53 & Alt==1
replace Brand=0 if ChoiceSet==53 & Alt==2
replace Brand=0 if ChoiceSet==53 & Alt==3

replace Brand=1 if ChoiceSet==69 & Alt==1
replace Brand=1 if ChoiceSet==69 & Alt==2
replace Brand=0 if ChoiceSet==69 & Alt==3

*****Block 3
replace Brand=0 if ChoiceSet==5 & Alt==1
replace Brand=1 if ChoiceSet==5 & Alt==2
replace Brand=0 if ChoiceSet==5 & Alt==3

replace Brand=1 if ChoiceSet==7 & Alt==1
replace Brand=1 if ChoiceSet==7 & Alt==2
replace Brand=0 if ChoiceSet==7 & Alt==3

replace Brand=0 if ChoiceSet==18 & Alt==1
replace Brand=1 if ChoiceSet==18 & Alt==2
replace Brand=0 if ChoiceSet==18 & Alt==3

replace Brand=0 if ChoiceSet==31 & Alt==1
replace Brand=0 if ChoiceSet==31 & Alt==2
replace Brand=0 if ChoiceSet==31 & Alt==3

replace Brand=1 if ChoiceSet==47 & Alt==1
replace Brand=0 if ChoiceSet==47 & Alt==2
replace Brand=0 if ChoiceSet==47 & Alt==3

replace Brand=0 if ChoiceSet==49 & Alt==1
replace Brand=0 if ChoiceSet==49 & Alt==2
replace Brand=0 if ChoiceSet==49 & Alt==3

replace Brand=1 if ChoiceSet==58 & Alt==1
replace Brand=1 if ChoiceSet==58 & Alt==2
replace Brand=0 if ChoiceSet==58 & Alt==3

replace Brand=0 if ChoiceSet==66 & Alt==1
replace Brand=1 if ChoiceSet==66 & Alt==2
replace Brand=0 if ChoiceSet==66 & Alt==3

*****Block 4
replace Brand=0 if ChoiceSet==6 & Alt==1
replace Brand=1 if ChoiceSet==6 & Alt==2
replace Brand=0 if ChoiceSet==6 & Alt==3

replace Brand=1 if ChoiceSet==8 & Alt==1
replace Brand=1 if ChoiceSet==8 & Alt==2
replace Brand=0 if ChoiceSet==8 & Alt==3

replace Brand=0 if ChoiceSet==16 & Alt==1
replace Brand=1 if ChoiceSet==16 & Alt==2
replace Brand=0 if ChoiceSet==16 & Alt==3

replace Brand=0 if ChoiceSet==32 & Alt==1
replace Brand=0 if ChoiceSet==32 & Alt==2
replace Brand=0 if ChoiceSet==32 & Alt==3

replace Brand=1 if ChoiceSet==46 & Alt==1
replace Brand=0 if ChoiceSet==46 & Alt==2
replace Brand=0 if ChoiceSet==46 & Alt==3

replace Brand=0 if ChoiceSet==51 & Alt==1
replace Brand=0 if ChoiceSet==51 & Alt==2
replace Brand=0 if ChoiceSet==51 & Alt==3

replace Brand=1 if ChoiceSet==60 & Alt==1
replace Brand=1 if ChoiceSet==60 & Alt==2
replace Brand=0 if ChoiceSet==60 & Alt==3

replace Brand=0 if ChoiceSet==65 & Alt==1
replace Brand=1 if ChoiceSet==65 & Alt==2
replace Brand=0 if ChoiceSet==65 & Alt==3

*****Block 5
replace Brand=1 if ChoiceSet==1 & Alt==1
replace Brand=1 if ChoiceSet==1 & Alt==2
replace Brand=0 if ChoiceSet==1 & Alt==3

replace Brand=0 if ChoiceSet==19 & Alt==1
replace Brand=0 if ChoiceSet==19 & Alt==2
replace Brand=0 if ChoiceSet==19 & Alt==3

replace Brand=1 if ChoiceSet==26 & Alt==1
replace Brand=0 if ChoiceSet==26 & Alt==2
replace Brand=0 if ChoiceSet==26 & Alt==3

replace Brand=1 if ChoiceSet==36 & Alt==1
replace Brand=0 if ChoiceSet==36 & Alt==2
replace Brand=0 if ChoiceSet==36 & Alt==3

replace Brand=0 if ChoiceSet==37 & Alt==1
replace Brand=0 if ChoiceSet==37 & Alt==2
replace Brand=0 if ChoiceSet==37 & Alt==3

replace Brand=1 if ChoiceSet==55 & Alt==1
replace Brand=1 if ChoiceSet==55 & Alt==2
replace Brand=0 if ChoiceSet==55 & Alt==3

replace Brand=0 if ChoiceSet==62 & Alt==1
replace Brand=1 if ChoiceSet==62 & Alt==2
replace Brand=0 if ChoiceSet==62 & Alt==3

replace Brand=0 if ChoiceSet==72 & Alt==1
replace Brand=1 if ChoiceSet==72 & Alt==2
replace Brand=0 if ChoiceSet==72 & Alt==3

*****Block 6
replace Brand=0 if ChoiceSet==10 & Alt==1
replace Brand=1 if ChoiceSet==10 & Alt==2
replace Brand=0 if ChoiceSet==10 & Alt==3

replace Brand=1 if ChoiceSet==15 & Alt==1
replace Brand=1 if ChoiceSet==15 & Alt==2
replace Brand=0 if ChoiceSet==15 & Alt==3

replace Brand=0 if ChoiceSet==24 & Alt==1
replace Brand=0 if ChoiceSet==24 & Alt==2
replace Brand=0 if ChoiceSet==24 & Alt==3

replace Brand=1 if ChoiceSet==29 & Alt==1
replace Brand=0 if ChoiceSet==29 & Alt==2
replace Brand=0 if ChoiceSet==29 & Alt==3

replace Brand=1 if ChoiceSet==42 & Alt==1
replace Brand=0 if ChoiceSet==42 & Alt==2
replace Brand=0 if ChoiceSet==42 & Alt==3

replace Brand=0 if ChoiceSet==44 & Alt==1
replace Brand=0 if ChoiceSet==44 & Alt==2
replace Brand=0 if ChoiceSet==44 & Alt==3

replace Brand=1 if ChoiceSet==52 & Alt==1
replace Brand=0 if ChoiceSet==52 & Alt==2
replace Brand=0 if ChoiceSet==52 & Alt==3

replace Brand=1 if ChoiceSet==68 & Alt==1
replace Brand=1 if ChoiceSet==68 & Alt==2
replace Brand=0 if ChoiceSet==68 & Alt==3

*****Block 7
replace Brand=0 if ChoiceSet==11 & Alt==1
replace Brand=1 if ChoiceSet==11 & Alt==2
replace Brand=0 if ChoiceSet==11 & Alt==3

replace Brand=1 if ChoiceSet==13 & Alt==1
replace Brand=1 if ChoiceSet==13 & Alt==2
replace Brand=0 if ChoiceSet==13 & Alt==3

replace Brand=0 if ChoiceSet==22 & Alt==1
replace Brand=0 if ChoiceSet==22 & Alt==2
replace Brand=0 if ChoiceSet==22 & Alt==3

replace Brand=1 if ChoiceSet==30 & Alt==1
replace Brand=0 if ChoiceSet==30 & Alt==2
replace Brand=0 if ChoiceSet==30 & Alt==3

replace Brand=1 if ChoiceSet==41 & Alt==1
replace Brand=0 if ChoiceSet==41 & Alt==2
replace Brand=0 if ChoiceSet==41 & Alt==3

replace Brand=0 if ChoiceSet==43 & Alt==1
replace Brand=0 if ChoiceSet==43 & Alt==2
replace Brand=0 if ChoiceSet==43 & Alt==3

replace Brand=1 if ChoiceSet==54 & Alt==1
replace Brand=0 if ChoiceSet==54 & Alt==2
replace Brand=0 if ChoiceSet==54 & Alt==3

replace Brand=1 if ChoiceSet==67 & Alt==1
replace Brand=1 if ChoiceSet==67 & Alt==2
replace Brand=0 if ChoiceSet==67 & Alt==3

*****Block 8
replace Brand=0 if ChoiceSet==4 & Alt==1
replace Brand=1 if ChoiceSet==4 & Alt==2
replace Brand=0 if ChoiceSet==4 & Alt==3

replace Brand=1 if ChoiceSet==9 & Alt==1
replace Brand=1 if ChoiceSet==9 & Alt==2
replace Brand=0 if ChoiceSet==9 & Alt==3

replace Brand=0 if ChoiceSet==17 & Alt==1
replace Brand=1 if ChoiceSet==17 & Alt==2
replace Brand=0 if ChoiceSet==17 & Alt==3

replace Brand=0 if ChoiceSet==33 & Alt==1
replace Brand=0 if ChoiceSet==33 & Alt==2
replace Brand=0 if ChoiceSet==33 & Alt==3

replace Brand=1 if ChoiceSet==48 & Alt==1
replace Brand=0 if ChoiceSet==48 & Alt==2
replace Brand=0 if ChoiceSet==48 & Alt==3

replace Brand=0 if ChoiceSet==50 & Alt==1
replace Brand=0 if ChoiceSet==50 & Alt==2
replace Brand=0 if ChoiceSet==50 & Alt==3

replace Brand=1 if ChoiceSet==59 & Alt==1
replace Brand=1 if ChoiceSet==59 & Alt==2
replace Brand=0 if ChoiceSet==59 & Alt==3

replace Brand=0 if ChoiceSet==64 & Alt==1
replace Brand=1 if ChoiceSet==64 & Alt==2
replace Brand=0 if ChoiceSet==64 & Alt==3

*****Block 9
replace Brand=1 if ChoiceSet==2 & Alt==1
replace Brand=1 if ChoiceSet==2 & Alt==2
replace Brand=0 if ChoiceSet==2 & Alt==3

replace Brand=0 if ChoiceSet==20 & Alt==1
replace Brand=0 if ChoiceSet==20 & Alt==2
replace Brand=0 if ChoiceSet==20 & Alt==3

replace Brand=1 if ChoiceSet==27 & Alt==1
replace Brand=0 if ChoiceSet==27 & Alt==2
replace Brand=0 if ChoiceSet==27 & Alt==3

replace Brand=1 if ChoiceSet==34 & Alt==1
replace Brand=0 if ChoiceSet==34 & Alt==2
replace Brand=0 if ChoiceSet==34 & Alt==3

replace Brand=0 if ChoiceSet==39 & Alt==1
replace Brand=0 if ChoiceSet==39 & Alt==2
replace Brand=0 if ChoiceSet==39 & Alt==3

replace Brand=1 if ChoiceSet==57 & Alt==1
replace Brand=1 if ChoiceSet==57 & Alt==2
replace Brand=0 if ChoiceSet==57 & Alt==3

replace Brand=0 if ChoiceSet==61 & Alt==1
replace Brand=1 if ChoiceSet==61 & Alt==2
replace Brand=0 if ChoiceSet==61 & Alt==3

replace Brand=0 if ChoiceSet==71 & Alt==1
replace Brand=1 if ChoiceSet==71 & Alt==2
replace Brand=0 if ChoiceSet==71 & Alt==3

***Fair trade Label
*****(0: no label, 1: fair trade label)

*****Block 1
replace FairLabel=1 if ChoiceSet==3 & Alt==1
replace FairLabel=1 if ChoiceSet==3 & Alt==2
replace FairLabel=0 if ChoiceSet==3 & Alt==3

replace FairLabel=1 if ChoiceSet==21 & Alt==1
replace FairLabel=0 if ChoiceSet==21 & Alt==2
replace FairLabel=0 if ChoiceSet==21 & Alt==3

replace FairLabel=1 if ChoiceSet==25 & Alt==1
replace FairLabel=0 if ChoiceSet==25 & Alt==2
replace FairLabel=0 if ChoiceSet==25 & Alt==3

replace FairLabel=0 if ChoiceSet==35 & Alt==1
replace FairLabel=0 if ChoiceSet==35 & Alt==2
replace FairLabel=0 if ChoiceSet==35 & Alt==3

replace FairLabel=0 if ChoiceSet==38 & Alt==1
replace FairLabel=0 if ChoiceSet==38 & Alt==2
replace FairLabel=0 if ChoiceSet==38 & Alt==3

replace FairLabel=0 if ChoiceSet==56 & Alt==1
replace FairLabel=1 if ChoiceSet==56 & Alt==2
replace FairLabel=0 if ChoiceSet==56 & Alt==3

replace FairLabel=0 if ChoiceSet==63 & Alt==1
replace FairLabel=1 if ChoiceSet==63 & Alt==2
replace FairLabel=0 if ChoiceSet==63 & Alt==3

replace FairLabel=1 if ChoiceSet==70 & Alt==1
replace FairLabel=1 if ChoiceSet==70 & Alt==2
replace FairLabel=0 if ChoiceSet==70 & Alt==3

*****Block 2
replace FairLabel=0 if ChoiceSet==12 & Alt==1
replace FairLabel=0 if ChoiceSet==12 & Alt==2
replace FairLabel=0 if ChoiceSet==12 & Alt==3

replace FairLabel=1 if ChoiceSet==14 & Alt==1
replace FairLabel=0 if ChoiceSet==14 & Alt==2
replace FairLabel=0 if ChoiceSet==14 & Alt==3

replace FairLabel=0 if ChoiceSet==23 & Alt==1
replace FairLabel=1 if ChoiceSet==23 & Alt==2
replace FairLabel=0 if ChoiceSet==23 & Alt==3

replace FairLabel=0 if ChoiceSet==28 & Alt==1
replace FairLabel=1 if ChoiceSet==28 & Alt==2
replace FairLabel=0 if ChoiceSet==28 & Alt==3

replace FairLabel=1 if ChoiceSet==40 & Alt==1
replace FairLabel=1 if ChoiceSet==40 & Alt==2
replace FairLabel=0 if ChoiceSet==40 & Alt==3

replace FairLabel=1 if ChoiceSet==45 & Alt==1
replace FairLabel=0 if ChoiceSet==45 & Alt==2
replace FairLabel=0 if ChoiceSet==45 & Alt==3

replace FairLabel=0 if ChoiceSet==53 & Alt==1
replace FairLabel=0 if ChoiceSet==53 & Alt==2
replace FairLabel=0 if ChoiceSet==53 & Alt==3

replace FairLabel=0 if ChoiceSet==69 & Alt==1
replace FairLabel=0 if ChoiceSet==69 & Alt==2
replace FairLabel=0 if ChoiceSet==69 & Alt==3

*****Block 3
replace FairLabel=0 if ChoiceSet==5 & Alt==1
replace FairLabel=0 if ChoiceSet==5 & Alt==2
replace FairLabel=0 if ChoiceSet==5 & Alt==3

replace FairLabel=0 if ChoiceSet==7 & Alt==1
replace FairLabel=1 if ChoiceSet==7 & Alt==2
replace FairLabel=0 if ChoiceSet==7 & Alt==3

replace FairLabel=1 if ChoiceSet==18 & Alt==1
replace FairLabel=1 if ChoiceSet==18 & Alt==2
replace FairLabel=0 if ChoiceSet==18 & Alt==3

replace FairLabel=1 if ChoiceSet==31 & Alt==1
replace FairLabel=1 if ChoiceSet==31 & Alt==2
replace FairLabel=0 if ChoiceSet==31 & Alt==3

replace FairLabel=1 if ChoiceSet==47 & Alt==1
replace FairLabel=1 if ChoiceSet==47 & Alt==2
replace FairLabel=0 if ChoiceSet==47 & Alt==3

replace FairLabel=0 if ChoiceSet==49 & Alt==1
replace FairLabel=1 if ChoiceSet==49 & Alt==2
replace FairLabel=0 if ChoiceSet==49 & Alt==3

replace FairLabel=1 if ChoiceSet==58 & Alt==1
replace FairLabel=0 if ChoiceSet==58 & Alt==2
replace FairLabel=0 if ChoiceSet==58 & Alt==3

replace FairLabel=1 if ChoiceSet==66 & Alt==1
replace FairLabel=0 if ChoiceSet==66 & Alt==2
replace FairLabel=0 if ChoiceSet==66 & Alt==3

*****Block 4
replace FairLabel=0 if ChoiceSet==6 & Alt==1
replace FairLabel=0 if ChoiceSet==6 & Alt==2
replace FairLabel=0 if ChoiceSet==6 & Alt==3

replace FairLabel=0 if ChoiceSet==8 & Alt==1
replace FairLabel=1 if ChoiceSet==8 & Alt==2
replace FairLabel=0 if ChoiceSet==8 & Alt==3

replace FairLabel=1 if ChoiceSet==16 & Alt==1
replace FairLabel=1 if ChoiceSet==16 & Alt==2
replace FairLabel=0 if ChoiceSet==16 & Alt==3

replace FairLabel=1 if ChoiceSet==32 & Alt==1
replace FairLabel=1 if ChoiceSet==32 & Alt==2
replace FairLabel=0 if ChoiceSet==32 & Alt==3

replace FairLabel=1 if ChoiceSet==46 & Alt==1
replace FairLabel=1 if ChoiceSet==46 & Alt==2
replace FairLabel=0 if ChoiceSet==46 & Alt==3

replace FairLabel=0 if ChoiceSet==51 & Alt==1
replace FairLabel=1 if ChoiceSet==51 & Alt==2
replace FairLabel=0 if ChoiceSet==51 & Alt==3

replace FairLabel=1 if ChoiceSet==60 & Alt==1
replace FairLabel=0 if ChoiceSet==60 & Alt==2
replace FairLabel=0 if ChoiceSet==60 & Alt==3

replace FairLabel=1 if ChoiceSet==65 & Alt==1
replace FairLabel=0 if ChoiceSet==65 & Alt==2
replace FairLabel=0 if ChoiceSet==65 & Alt==3

*****Block 5
replace FairLabel=1 if ChoiceSet==1 & Alt==1
replace FairLabel=1 if ChoiceSet==1 & Alt==2
replace FairLabel=0 if ChoiceSet==1 & Alt==3

replace FairLabel=1 if ChoiceSet==19 & Alt==1
replace FairLabel=0 if ChoiceSet==19 & Alt==2
replace FairLabel=0 if ChoiceSet==19 & Alt==3

replace FairLabel=1 if ChoiceSet==26 & Alt==1
replace FairLabel=0 if ChoiceSet==26 & Alt==2
replace FairLabel=0 if ChoiceSet==26 & Alt==3

replace FairLabel=0 if ChoiceSet==36 & Alt==1
replace FairLabel=0 if ChoiceSet==36 & Alt==2
replace FairLabel=0 if ChoiceSet==36 & Alt==3

replace FairLabel=0 if ChoiceSet==37 & Alt==1
replace FairLabel=0 if ChoiceSet==37 & Alt==2
replace FairLabel=0 if ChoiceSet==37 & Alt==3

replace FairLabel=0 if ChoiceSet==55 & Alt==1
replace FairLabel=1 if ChoiceSet==55 & Alt==2
replace FairLabel=0 if ChoiceSet==55 & Alt==3

replace FairLabel=0 if ChoiceSet==62 & Alt==1
replace FairLabel=1 if ChoiceSet==62 & Alt==2
replace FairLabel=0 if ChoiceSet==62 & Alt==3

replace FairLabel=1 if ChoiceSet==72 & Alt==1
replace FairLabel=1 if ChoiceSet==72 & Alt==2
replace FairLabel=0 if ChoiceSet==72 & Alt==3

*****Block 6
replace FairLabel=0 if ChoiceSet==10 & Alt==1
replace FairLabel=0 if ChoiceSet==10 & Alt==2
replace FairLabel=0 if ChoiceSet==10 & Alt==3

replace FairLabel=1 if ChoiceSet==15 & Alt==1
replace FairLabel=0 if ChoiceSet==15 & Alt==2
replace FairLabel=0 if ChoiceSet==15 & Alt==3

replace FairLabel=0 if ChoiceSet==24 & Alt==1
replace FairLabel=1 if ChoiceSet==24 & Alt==2
replace FairLabel=0 if ChoiceSet==24 & Alt==3

replace FairLabel=0 if ChoiceSet==29 & Alt==1
replace FairLabel=1 if ChoiceSet==29 & Alt==2
replace FairLabel=0 if ChoiceSet==29 & Alt==3

replace FairLabel=1 if ChoiceSet==42 & Alt==1
replace FairLabel=1 if ChoiceSet==42 & Alt==2
replace FairLabel=0 if ChoiceSet==42 & Alt==3

replace FairLabel=1 if ChoiceSet==44 & Alt==1
replace FairLabel=0 if ChoiceSet==44 & Alt==2
replace FairLabel=0 if ChoiceSet==44 & Alt==3

replace FairLabel=0 if ChoiceSet==52 & Alt==1
replace FairLabel=0 if ChoiceSet==52 & Alt==2
replace FairLabel=0 if ChoiceSet==52 & Alt==3

replace FairLabel=0 if ChoiceSet==68 & Alt==1
replace FairLabel=0 if ChoiceSet==68 & Alt==2
replace FairLabel=0 if ChoiceSet==68 & Alt==3

*****Block 7
replace FairLabel=0 if ChoiceSet==11 & Alt==1
replace FairLabel=0 if ChoiceSet==11 & Alt==2
replace FairLabel=0 if ChoiceSet==11 & Alt==3

replace FairLabel=1 if ChoiceSet==13 & Alt==1
replace FairLabel=0 if ChoiceSet==13 & Alt==2
replace FairLabel=0 if ChoiceSet==13 & Alt==3

replace FairLabel=0 if ChoiceSet==22 & Alt==1
replace FairLabel=1 if ChoiceSet==22 & Alt==2
replace FairLabel=0 if ChoiceSet==22 & Alt==3

replace FairLabel=0 if ChoiceSet==30 & Alt==1
replace FairLabel=1 if ChoiceSet==30 & Alt==2
replace FairLabel=0 if ChoiceSet==30 & Alt==3

replace FairLabel=1 if ChoiceSet==41 & Alt==1
replace FairLabel=1 if ChoiceSet==41 & Alt==2
replace FairLabel=0 if ChoiceSet==41 & Alt==3

replace FairLabel=1 if ChoiceSet==43 & Alt==1
replace FairLabel=0 if ChoiceSet==43 & Alt==2
replace FairLabel=0 if ChoiceSet==43 & Alt==3

replace FairLabel=0 if ChoiceSet==54 & Alt==1
replace FairLabel=0 if ChoiceSet==54 & Alt==2
replace FairLabel=0 if ChoiceSet==54 & Alt==3

replace FairLabel=0 if ChoiceSet==67 & Alt==1
replace FairLabel=0 if ChoiceSet==67 & Alt==2
replace FairLabel=0 if ChoiceSet==67 & Alt==3

*****Block 8
replace FairLabel=0 if ChoiceSet==4 & Alt==1
replace FairLabel=0 if ChoiceSet==4 & Alt==2
replace FairLabel=0 if ChoiceSet==4 & Alt==3

replace FairLabel=0 if ChoiceSet==9 & Alt==1
replace FairLabel=1 if ChoiceSet==9 & Alt==2
replace FairLabel=0 if ChoiceSet==9 & Alt==3

replace FairLabel=1 if ChoiceSet==17 & Alt==1
replace FairLabel=1 if ChoiceSet==17 & Alt==2
replace FairLabel=0 if ChoiceSet==17 & Alt==3

replace FairLabel=1 if ChoiceSet==33 & Alt==1
replace FairLabel=1 if ChoiceSet==33 & Alt==2
replace FairLabel=0 if ChoiceSet==33 & Alt==3

replace FairLabel=1 if ChoiceSet==48 & Alt==1
replace FairLabel=1 if ChoiceSet==48 & Alt==2
replace FairLabel=0 if ChoiceSet==48 & Alt==3

replace FairLabel=0 if ChoiceSet==50 & Alt==1
replace FairLabel=1 if ChoiceSet==50 & Alt==2
replace FairLabel=0 if ChoiceSet==50 & Alt==3

replace FairLabel=1 if ChoiceSet==59 & Alt==1
replace FairLabel=0 if ChoiceSet==59 & Alt==2
replace FairLabel=0 if ChoiceSet==59 & Alt==3

replace FairLabel=1 if ChoiceSet==64 & Alt==1
replace FairLabel=0 if ChoiceSet==64 & Alt==2
replace FairLabel=0 if ChoiceSet==64 & Alt==3

*****Block 9
replace FairLabel=1 if ChoiceSet==2 & Alt==1
replace FairLabel=1 if ChoiceSet==2 & Alt==2
replace FairLabel=0 if ChoiceSet==2 & Alt==3

replace FairLabel=1 if ChoiceSet==20 & Alt==1
replace FairLabel=0 if ChoiceSet==20 & Alt==2
replace FairLabel=0 if ChoiceSet==20 & Alt==3

replace FairLabel=1 if ChoiceSet==27 & Alt==1
replace FairLabel=0 if ChoiceSet==27 & Alt==2
replace FairLabel=0 if ChoiceSet==27 & Alt==3

replace FairLabel=0 if ChoiceSet==34 & Alt==1
replace FairLabel=0 if ChoiceSet==34 & Alt==2
replace FairLabel=0 if ChoiceSet==34 & Alt==3

replace FairLabel=0 if ChoiceSet==39 & Alt==1
replace FairLabel=0 if ChoiceSet==39 & Alt==2
replace FairLabel=0 if ChoiceSet==39 & Alt==3

replace FairLabel=0 if ChoiceSet==57 & Alt==1
replace FairLabel=1 if ChoiceSet==57 & Alt==2
replace FairLabel=0 if ChoiceSet==57 & Alt==3

replace FairLabel=0 if ChoiceSet==61 & Alt==1
replace FairLabel=1 if ChoiceSet==61 & Alt==2
replace FairLabel=0 if ChoiceSet==61 & Alt==3

replace FairLabel=1 if ChoiceSet==71 & Alt==1
replace FairLabel=1 if ChoiceSet==71 & Alt==2
replace FairLabel=0 if ChoiceSet==71 & Alt==3

***Dummy-Variable für OptOut-Option generieren
***Alternative-specific constant (ASC)
***Damit Unterscheidung zwischen 0 für die Attribute bei OptOut (Alt3)
***und 0 für die Attribute bei Alt1 und Alt2 möglich wird
generate optoutvar=.
order optoutvar, before (Choice)
label var optoutvar "Alternative Specific Constant (ASC)"
replace optoutvar=0 if Choice>=1
replace optoutvar=. if Choice==.
replace optoutvar=1 if Alt==3 & Choice !=.

***Case-Variable generieren, sodass für best. Operationen jeder Teilnehmer nur einmal berücksichtigt wird
***generate case=.
***replace case=ID if ChoiceBlock==111 & Alt==1
***order case, before (ChoiceBlock)
***label var case "one dataset for each respondent"

*****Variable pro Teilnehmer generieren
egen tag_id=tag(ID)

***Ursprüngliche Case-Definition falsch; ein Case pro beantwortetem Choice Set benötigt
***cases: no. of respondents x no. of choice sets per respondent
egen Case = group (ID ChoiceBlock) if Choice!=.
order Case, before (Alt)

*****DUMMY-VARIABLEN ERSTELLEN

***Dummy-Variable 'female' für Geschlecht (weiblich) generieren
***(0: male, 1: female)
generate female=.
replace female=0
***(vorherige Definition 1: weiblich, 2: männlich)
replace female=1 if v_2==2
order female, before (v_2)
label var female "(dummy - 0: male, 1: female)"

***Dummy-Variablen für Produktattribute generieren
generate Pangasius=.
order Pangasius, before (COO)
replace Pangasius=0
replace Pangasius=1 if Species==0 & Alt!=3
label var Pangasius "(dummy - 0: Tilapia, 1: Pangasius)"

*****COO (Vietnam: wenn Bangladesh & Germany == 0)
generate Bangladesh=.
order Bangladesh, before (SustLabel)
replace Bangladesh=0
replace Bangladesh=1 if COO==1
label var Bangladesh "(dummy - 0: other, 1: Bangladesh)"

generate Germany=.
order Germany, before (SustLabel)
replace Germany=0
replace Germany=1 if COO==0 & Alt!=3
label var Germany "(dummy - 0: other, 1: Germany)"

*****Sustainability Label (no label: wenn ASC & Naturland == 0)
generate ASC=.
order ASC, before (Brand)
replace ASC=0
replace ASC=1 if SustLabel==1
label var ASC "(dummy - 0: other, 1: ASC)"

generate Naturland=.
order Naturland, before (Brand)
replace Naturland=0
replace Naturland=1 if SustLabel==2
label var Naturland "(dummy - 0: other, 1: Naturland)"

*****Datenaufbereitung für spezifische Angaben
***Zur Beschäftigung hatten einige Teilnehmer "sonstiges" angekreuzt und dann
***im Freitextfeld aber eine Angabe gemacht, die sich einer anderen Kategorie
***zuordnen lässt.
replace v_10=4 if ID==305
replace v_10=1 if ID==318
replace v_10=2 if ID==237
replace v_10=2 if ID==168

***CETSCALE score definieren (Mittelwert über die 10 Items)
egen CETSCALE_mean = rowmean(v_13-v_22)

***Copy & rename variables (für bessere Übersichtlichkeit)
***Create dummy variables instead of ordinal variables
clonevar hh_income = v_6
label var hh_income "household income"
generate low_income=.
replace low_income=0
replace low_income=1 if hh_income==1 | hh_income==2
label var low_income "Dummy | 1:monthly HH income up to EUR 1500; 0:other"
generate medium_income=.
replace medium_income=0
replace medium_income=1 if hh_income==3 | hh_income==4 | hh_income==5
label var medium_income "Dummy | 1: monthly HH income from EUR 1501 to EUR 3000; 0:other"
generate high_income=.
replace high_income=0
replace high_income=1 if hh_income==6
label var high_income "Dummy | 1: monthly HH income above EUR 3000; 0: other"
***"keine Angabe" --> hat 0 in allen Dummy Variablen

clonevar con_freq = v_23
label var con_freq "consumption frequency"
***Dummy variable for high consumption frequency (1: high | 0: low)
generate high_cons=.
replace high_cons=0
replace high_cons=1 if con_freq==4 | con_freq==5 | con_freq==6
label var high_cons "Dummy variable (0: low consumption; 1: high consumption"

clonevar pur_freq = v_98
label var pur_freq "purchase frequency"
***Dummy variable for high purchase frequency (1: high | 0: other)
generate high_pur=.
replace high_pur=0
replace high_pur=1 if pur_freq==5 | pur_freq==6 | pur_freq==7
label var high_pur "Dummy variable (0: other | 1: high purchase freq)"
***Dummy variable for low purchase frequency (1: low | 0: other)
***If neither high nor low: never purchase!
generate low_pur=.
replace low_pur=0
replace low_pur=1 if pur_freq==2 | pur_freq==3 | pur_freq==4
label var low_pur "Dummy variable (0: other | 1: low purchase freq"

***Aquaculture Statements - renaming of items and reverse-scoring of the negative-keyed items
rename v_52_new aqua1
rename v_53_new aqua2
rename v_97_new aqua3
generate aqua4 = 8 - v_54_new
generate aqua5 = 8 - v_55_new
generate aqua6 = 8 - v_96_new
order aqua1-aqua3, before(aqua4)
***"keine Einschätzung möglich" umkodieren
replace aqua1=4 if aqua1==.
replace aqua2=4 if aqua2==.
replace aqua3=4 if aqua3==.
replace aqua4=4 if aqua4==.
replace aqua5=4 if aqua5==.
replace aqua6=4 if aqua6==.

label var aqua4 "reverse-scoring applied"
label var aqua5 "reverse-scoring applied"
label var aqua6 "reverse-scoring applied"

***Formatierung Country Image
label var v_99 "Quality Bangladesh"
label var v_100 "Quality Germany"
label var v_101 "Quality Vietnam"
label var v_120 "Food Safety Bangladesh"
label var v_121 "Food Safety Germany"
label var v_122 "Food Safety Vietnam"
label var v_125 "Social Standards Bangladesh"
label var v_126 "Social Standards Germany"
label var v_127 "Social Standards Vietnam"
label var v_130 "Environmental Standards Bangladesh"
label var v_131 "Environmental Standards Germany"
label var v_132 "Environmental Standards Vietnam"

***Add dummy variable for DCE cycle
generate cycle1=.
order cycle1, before(ChoiceBlock)
replace cycle1=0
replace cycle1=1 if ChoiceBlock <= 198
label var cycle1 "Dummy | 1: 1st round of choice sets; 0: 2nd round of choice sets"

***Add dummy variable for college degree (higher education)
generate degree=.
replace degree=0
replace degree=1 if v_9==6 | v_9==7 | v_9==8
label var degree "Dummy | 1: college or university degree; 0: other"

***Add dummy variables for knowledge of relevant sustainability standards
generate Naturland_knowledge=.
replace Naturland_knowledge=0
*If respondents indicated to know the Naturland standard to some extent
replace Naturland_knowledge=1 if v_78==0
label var Naturland_knowledge "Dummy | 1: Knowledge of Naturland; 0: no knowledge"

generate ASC_knowledge=.
replace ASC_knowledge=0
replace ASC_knowledge=1 if v_79==0
label var ASC_knowledge "Dummy | 1: Knowledge of ASC; 0: no knowledge"

generate Fairtrade_knowledge=.
replace Fairtrade_knowledge=0
replace Fairtrade_knowledge=1 if v_184==0
label var Fairtrade_knowledge "Dummy | 1: Knowledge of Fairtrade; 0: no knowledge"

***Add dummy variable for ecolabel vs. no ecolabel
*(letztendlich nicht verwendet)
generate ecolabel =.
replace ecolabel = 0
replace ecolabel = 1 if ASC==1 | Naturland==1
label var ecolabel "Dummy | 1: ASC oder Naturland; 0: weder ASC noch Naturland"


