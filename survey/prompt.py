''' Papers (Gabriel does papers 29, 38, 39, 24, , 27, 22, and 23. Parisa does others):
Mode choice:
5. Ride to the hills, ride to your school
41. Travel to school mode choice
Pay for food
9. Willingness to pay for sustainable beer
26. Consumer attitudes toward pangasius and tilapia
Pay for goods
14. 
15.
Pay for environment
21. Economic valuation of urban greening
29. Investigating peoples preferennces for car-free city centers
Pay for energy
38. Consumer willingness to pay for renewable and nuclear energy
39. Preferences for improved cook stoves
Pay for car
24. 
27. Role of fuel cost info in car sales
    coefficients on page 8
Health
22. Population preferencesfor breast cancer screening
23. Preferences for HIV testing services
'''

# Map paper number label to its prompt template
prompt_templates = {
    5:  """You are a student deciding how to travel to school. Consider the following factors:

- Distance to your school is {distance}
- Your school is located {school_location} of the river Elbe
- The nearest city bike station is {cb_location} of the river Elbe
- Your school and nearest city bike station are on {same_shore}
- You are in grade {grade}
- You are {age} years old and {gender}
- {car_availability} is available for your use
- It's currently {season}

Based on these factors, which mode of transportation would you choose?
Respond with:
1 for walk
2 for bike
3 for transit
4 for car""",
    41: """We like to analyze the influence of the variables: distance, car availability, and season (or weather) on commuting mode choice. 
Age is also considered as an explanatory variable, although it has been found to be not significant for public transport.
- Distance to school is {distance} km.
- Car availability is {car_availability}.
- The weather is {season} (fair or bad).
- The student is {age} years old.

Based on the influence of the above variables, what is your commuting mode choice? Respond with:
1 for walking
2 for cycling
3 for public transport
4 for car/motorcycle.""",
#------------------------------------------------------------------------------------------------
#comments for #9:
#3. **Key Findings:**
  # - For each additional $1.00 that one pays per ounce of beer, an individual is willing to pay a premium of 7.4 cents per ounce for the sustainable version.
  # - Personal demographics account for only about 9% of the R-squared decomposition and are statistically insignificant in predicting WTP.
   #- Younger individuals and those with lower levels of education are willing to pay more for sustainable beer.
  # - Contrary to other studies, factors such as having children or the location of residence do not significantly influence WTP.
#Based on these findings, consider the following questions:
#1. What attributes define a sustainable consumer in the context of this study?
#2. How do personal demographics influence the willingness to pay for sustainable beer, if at all?
#3. What implications do these findings have for breweries looking to market sustainable beer to different consumer segments?
#4. How can the insights from this analysis inform future research on consumer behavior regarding sustainable products?
#1. **Dependent Variable:** The dependent variable in this analysis is the amount per ounce that a respondent would be willing to pay above the typical price of their favorite beer, referred to as WTP for sustainable beer (in $/oz).
#- Environmental awareness
#- Consumption habits
#- Other relevant attributes
#- Demographic factors (e.g., age, gender, education, political leaning, marital status, household residency, and whether you live in a rural, urban, or suburban setting):
    9: """Willingness-to-pay (WTP) for sustainable beer is binary WTP (0 or 1), where a value of 1 indicates that you are willing to pay for sustainable beer, and a value of 0 indicates that you are not. 
How does your WTP for sustainable beer vary across different independent variables? Consider the following aspects:
Your age category is {age_category}.  
Your educational attainment is as follows: {education_summary}.
Your income is {income_summary}.

Recycling behavior: whether you recycle (Recycle_Yes).
Number of beers you report consuming: {buying_descriptions}.
You have indicated the following regarding your environmental contributions: {environmental_contribution_descriptions}.
Respond with 1 if you are willing to pay for sustainable beer, and a value of 0 if you are not.

  """,

    
    26: "",
    14: "",
    15: "",
    21: "",
    29: "", # SKIPPED: DATASET IS IN GERMAN
    38: """You are a resident of {user_state}. You are choosing between two different energy plans to provide electricity for your home: Plan 1 and Plan 2. Consider the following factors:

- cost: Plan 1 will cost you ${price1} per month. Plan 2 will cost you ${price2} per month.
- emissions: Compared to your current energy plan, Plan 1 will result in {gas1}% lower emissions, while Plan 2 will result in {gas2}% lower emissions.
- hydroelectric_energy: For both Plan 1 and Plan 2, 10% of your energy will be derived from hydroelectic sources.
- nuclear_energy: For Plan 1, {nuc1}% of your energy will be derived from nuclear sources. For Plan 2, {nuc2}% of your energy will be derived from nuclear sources.
- renewable_energy: For Plan 1, {ren1}% of your energy will be derived from renewable sources. For Plan 2, {ren2}% of your energy will be derived from renewable sources.
- fossil_fuel_energy: For Plan 1, the remaining {fos1}% of your energy will be derived from fossil fuels. For Plan 2, the remaining {fos2}% of your fuel will be derived from fossil fuels.

Based on these factors, which energy plan would you prefer? Respond with 1 or 2.

Please also rank the top 3 factors in your decision in order of importance from the following:
cost, emissions, hydroelectric_energy, nuclear_energy, renewable_energy, and fossil_fuel_energy.

Output your result in JSON format, and do not output other information.
{{
  "energy_plan_choice": <plan>
  "top_factors": [
    "<factor_1>",
    "<factor_2>",
    "<factor_3>",
  ]
}}""",
    39: """"Suppose you are the head of a household in the Indian state of {state}. You currently own a traditional stove and use it to cook food. Suppose you are choosing between two improved cooking stoves to purchase: Stove 1 and Stove 2. Consider the following factors:

- cost: Stove 1 costs {price1} Rupees. Stove 2 costs {price2} Rupees.
- fuel_consumption: Stove 1 consumes {fuel1} your current stove. Stove 2 consumes {fuel2} your current stove.
- smoke_emissions: Stove 1 emits {smoke1} your current stove. Stove 2 emits {smoke2} your current stove.
- num_burners: Your current stove has {pots3} burners. Stove 1 has {pots1} burners. Stove 2 has {pots2} burners.

Based on these factors, which stove would you prefer? Respond with 1 if you would purchase Stove 1, 2 if you would purchase Stove 2, or 3 if you would purchase neither stove.

Please also rank the top 3 factors in your decision in order of importance from the following:
cost, fuel_consumption, smoke_emissions, and num_burners.

Output your result in JSON format, and do not output other information.
{{
  "stove_choice": <stove>
  "top_factors": [
    "<factor_1>",
    "<factor_2>",
    "<factor_3>",
  ]
}}""",
    24: "", # SKIPPED: PAPER IS MISSING
    27: """Suppose you are a person deciding on a new car to purchase. You have two cars to choose from: Car 1 and Car 2. Consider the following factors:

- cost: Car 1 costs {price1} dollars. Car 2 costs {price2} dollars.
- storage_space: Car 1 has {capacity1} liters of storage space. Car 2 has {capacity2} liters of storage space.
- fuel_consumption: Car 1 uses {energy1} liters of gasoline per 10 km of travel. Car 2 uses {energy2} liters of gasoline per 10 km of travel.
- safety_score: Car 1 achieves a safety score of {safety1}% based on the European New Car Assessment Programme. Car 2 achieves a safety score of {safety2}% from the same test.

Based on these factors, which car would you choose? Respond with 1 if you would purchase Car 1, 2 if you would purchase Car 2, or 3 if you would purchase neither car.

Please also rank the top 3 factors in your decision in order of importance from the following:
cost, storage_space, fuel_consumption, and safety_score.

Output your result in JSON format, and do not output other information.
{{
  "car_choice": <car>
  "top_factors": [
    "<factor_1>",
    "<factor_2>",
    "<factor_3>",
  ]
}}""",
    22: """Suppose you are a woman choosing between two different breast cancer screening programs: Program 1 and Program 2. Consider the following factors:

- invitation_modality: With Program 1, you will be invited to participate in the screening via a {invitation1}. With Program 2, you will be invited via a {invitation2}.
- immediate_appt_arrangement_possibility: With Program 1, when invited, you will {appt1}. With Program 2, when invited, you will {appt2}.
- explanation: Program 1's invitation will contain {detail1} explanation of the screening. Program 2's invitation will contain {detail2} explanation of the screening.
- combination_possibility: With Program 1, you {combine1} be able to combine this screening with other relevant health visits. With Program 2, you {combine2} be able to combine this screening with other health visits.
- travel_time: With Program 1, it will take {travel_time1} minutes to get to the clinic. With Program 2, it will take {travel_time2} minutes to get to the clinic.
- waiting_time: In Program 1's clinic, you will have to wait in line for {wait_time1} minutes. In Program 2's clinic, you will have to wait in line for {wait_time2} minutes.
- doctor: Program 1's doctor is someone {doctor1}. Program 2's doctor is someone {doctor2}.
- screening_modality: Program 1's doctor will examine your breast by {examine1}. Program 2's doctor will examine your breast by {examine2}.
- test_sensitivity: Program 1's screening will accurately detect cancer in {accuracy1} out of 100 women. Program 2's screening will accurately detect cancer in {accuracy2} out of 100 women.
- cost: Program 1 will cost you {cost1}. Program 2 will cost you {cost2}.

Based on these factors, which program would you prefer? Response with 1 if you prefer Program 1, 2 if you prefer Program 2, or 3 if you would opt-out of testing entirely.

Please also rank the top 3 factors in your decision in order of importance from the following:
invitation_modality, immediate_appt_arrangement_possibility, explanation, combination_possibility, travel_time, waiting_time, doctor, screening_modality, test_sensitivity, and cost.

Output your result in JSON format, and do not output other information.
{{
  "program_choice": <program>
  "top_factors": [
    "<factor_1>",
    "<factor_2>",
    "<factor_3>",
  ]
}}""",
    23: """Suppose you are a man who, yesterday, had condomless anal sex with someone whose HIV status you're unsure of. Consider the foilowing factors of two different HIV testing plans: Test 1 and Test 2:

- wait_time: You will have to wait {selfWindow} weeks before you can take Test 1. You will have to wait 4 weeks before you can take Test 2.
- test_location: Test 1 will be located somewhere conventient such as your home. Test 2 will be located at {HCPLoc}.
- sampling_method: Test 1 will be taken using {selfSample}. Test 2 will be taken using {HCPSample}.
- obtain_method: You will obtain the Test 1 by {selfObtain}. 2: You will obtain Test 2 by {HCPObtain}.
- test_results_delay: {selfWait}. 2: {HCPWait}.
- test_results_advice: {selfResults}. 2: {HCPResults}.
- accuracy: Test 1 is {selfAccuracy}% accurate. Test 2 {HCPAccuracy}% accurate.
- combination_possibility: With Test 1, you will {selfInfect}be able to test for other STI at the same time. With Test 2, you will {HCPInfect}be able to test for other STI at the same time.
- cost: Test 1 will {selfCost}. Test 2 will be free.

Based on these factors, which test would you prefer? Respond with 1 if you would prefer Test 1, 2 if you would prefer Test 2, or 3 if you would opt out of testing entirely.

Please also rank the top 3 factors in your decision in order of importance from the following:
wait_time, test_location, sampling_method, obtain_method, test_results_delay, test_results_advice, accuracy, combination_possibility, and cost.

Output your result in JSON format, and do not output other information.
{{
  "test_choice": <test>
  "top_factors": [
    "<factor_1>",
    "<factor_2>",
    "<factor_3>",
  ]
}}"""
 }