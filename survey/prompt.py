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
Healthtransportation
22. Population preferencesfor breast cancer screening
23. Preferences for HIV testing services
'''

prompt_templates = {
    5:  """You are a student deciding how to travel to school. Consider the following factors:

- distance: {distance} km to school
- school_location: School is on {school_location} of river Elbe
- same_shore: School and city bike station are on {same_shore}
- cb_location: Nearest city bike station is {cb_location} away from river Elbe
- grade: You are in grade {grade}
- age: You are {age} years old 
- gender: You are a {gender} student
- car_availability: {car_availability} is available for your use
- season: It's currently {season}
- effort: Physical effort needed to bike to school is {effort} KJ

Based on these factors, which mode of transportation would you choose to maximize your personal utility?
Respond with:
1 for walk
2 for bike
3 for transit
4 for car

Please also rank the top 3 factors in your decision with the order of importance from the following:
distance, school_location, same_shore, cb_location, grade, age, gender, car_availability, season, and effort.

Output your result in JSON format, and do not output other information. 
{{
    "transportation_choice": <mode>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}""",

    # add reasoning
    502:  """You are a student deciding how to travel to school. Consider the following factors:

- distance: {distance} km to school
- school_location: School is on {school_location} of river Elbe
- same_shore: School and city bike station are on {same_shore}
- cb_location: Nearest city bike station is {cb_location} away from river Elbe
- grade: You are in grade {grade}
- age: You are {age} years old 
- gender: You are a {gender} student
- car_availability: {car_availability} is available for your use
- season: It's currently {season}
- effort: Physical effort needed to bike to school is {effort} KJ

Based on these factors, think step-by-step to evaluate the situation and make a reasoned decision. Start by:
	1.	Considering how each factor (e.g., distance, age, and season) influences the decision-making process.
	2.	Comparing the suitability of each transportation mode (walk, bike, transit, car) based on the student’s circumstances.
	3.	Ranking the top three factors that most significantly affect the decision, explaining why they matter the most.

After reasoning through the steps, which mode of transportation would you choose to maximize your personal utility?
Respond with:
1 for walk
2 for bike
3 for transit
4 for car

Please also rank the top 3 factors in your decision with the order of importance from the following:
distance, school_location, same_shore, cb_location, grade, age, gender, car_availability, season, and effort.

Output your result in JSON format, and do not output other information. 
{{
    "reasoning": "<step-by-step explanation>",
    "transportation_choice": <mode>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}""",

    # add some basic rules
    503:  """You are a student deciding how to travel to school. Consider the following factors:

- distance: {distance} km to school
- school_location: School is on {school_location} of river Elbe
- same_shore: School and city bike station are on {same_shore}
- cb_location: Nearest city bike station is {cb_location} away from river Elbe
- grade: You are in grade {grade}
- age: You are {age} years old 
- gender: You are a {gender} student
- car_availability: {car_availability} is available for your use
- season: It's currently {season}
- effort: Physical effort needed to bike to school is {effort} KJ

Using a discrete choice framework, think step-by-step to evaluate the utility of each transportation mode (walk, bike, transit, car) and choose the one that maximizes your personal utility. Consider the following steps in your decision-making process:

1. Evaluate how each factor (e.g., distance, car availability, and effort) influences the utility of each transportation mode. Be specific about how each factor contributes positively or negatively to the perceived utility.
2. Compare the transportation modes by calculating their relative utility based on your circumstances.
3. Choose the mode with the maximum utility result as your answer.

After reasoning through the steps, which mode of transportation would you choose to maximize your personal utility?
Respond with:
1 for walk
2 for bike
3 for transit
4 for car

Please also rank the top 3 factors in your decision with the order of importance from the following:
distance, school_location, same_shore, cb_location, grade, age, gender, car_availability, season, and effort.

Output your result in JSON format, and do not output other information. 
{{
    "reasoning": "<step-by-step explanation>",
    "transportation_choice": <mode>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}""",


    # add results from the paper modeling
    504:  """You are a student deciding how to travel to school. Consider the following factors:

- distance: {distance} km to school
- school_location: School is on {school_location} of river Elbe
- same_shore: School and city bike station are on {same_shore}
- cb_location: Nearest city bike station is {cb_location} away from river Elbe
- grade: You are in grade {grade}
- age: You are {age} years old 
- gender: You are a {gender} student
- car_availability: {car_availability} is available for your use
- season: It's currently {season}
- effort: Physical effort needed to bike to school is {effort} KJ

Key Considerations are:
1. During winter, students are more likely to prefer cars or public transport due to the higher risk and discomfort of walking or biking in cold or icy conditions. However, for short distances (<3 km), walking remains a viable alternative.
2. Effort-related factors (such as energy expenditure or altitude variance) significantly impact mode choices for biking and walking, reducing their utility with higher effort.
3. Distance impacts vary by mode and season: the utility of walking declines more steeply per km in summer than in winter, while biking utility shows similar declines across seasons.
4. Gender differences influence mode choice; female students are generally less likely to choose biking due to perceived risks.
5. Older students (higher grades) are more likely to bike, as they are considered more responsible and capable of managing risks.
6. If the student and school are on the same side of the river (same shore), biking becomes more attractive, particularly for distances <7 km, due to reduced expected delays.

Based on these factors, think step-by-step to evaluate the situation and make a reasoned decision. Start by:
	1.	Considering how each factor (e.g., distance, age, and season) influences the decision-making process.
	2.	Comparing the suitability of each transportation mode (walk, bike, transit, car) based on the student’s circumstances.
	3.	Ranking the top three factors that most significantly affect the decision, explaining why they matter the most.

After reasoning through the steps, which mode of transportation would you choose to maximize your personal utility?
Respond with:
1 for walk
2 for bike
3 for transit
4 for car

Please also rank the top 3 factors in your decision with the order of importance from the following:
distance, school_location, same_shore, cb_location, grade, age, gender, car_availability, season, and effort.

Output your result in JSON format, and do not output other information. 
{{
    "reasoning": "<step-by-step explanation>",
    "transportation_choice": <mode>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}""",


#comments for #9:
#3. **Key Findings:**
  # - For each additional $1.00 that one pays per ounce of beer, an individual is willing to pay a premium of 7.4 cents per ounce for the sustainable version.
  # - Personal demographics: only about 9% of the R-squared; statistically insignificant in predicting WTP.
   #- Younger individuals, with lower levels of education: willing to pay more for sustainable beer.
  # - Contrary to other studies, factors having children or  location of residence  not significantly influence WTP.
#Based on these findings, consider the following questions:
#1. What attributes define a sustainable consumer?
#2. personal demographics influence the WTP for sustainable beer?
#1. **Dependent Variable:** The dependent variable in this analysis is the amount per ounce that a respondent would be willing to pay above the typical price of their favorite beer, referred to as WTP for sustainable beer (in $/oz).
#- Environmental awareness
#- Consumption habits
#- Other relevant attributes
#- Demographic factors (e.g., age, gender, education, political leaning, marital status, household residency, and whether you live in a rural, urban, or suburban setting):
    9: """Suppose you are participating a survey which aims to investigate your willingness to pay for sustainable beer. Willingness-to-pay (WTP) for sustainable beer is binary, with WTP values of 0 or 1, where a value of 1 indicates willingness to pay for sustainable beer, and a value of 0 indicates a lack of willingness.

How does your WTP for sustainable beer vary across different independent variables? Consider the following factors:
- Age category: {age_category}  
- Educational attainment: {education_summary}
- Income: {income_summary}
- Recycling behavior: {Recycle_Yes}
- Number of beers you report consuming: {buying_descriptions}
- Environmental contributions: {environmental_contribution_descriptions}

Please also rank the top 3 factors in your decision with the order of importance from the following:
age_category, education_summary, income_summary, Recycling behavior, buying_descriptions, and environmental_contribution_descriptions.

Output your result in JSON format, and do not output other information. 
{{
    "WTP_choice": <1 or 0>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}
  """,

#16: 
#for price: there were five levels: baseline, 10%, 20%, 30% and 40% more expensive
# page #5:  3 attributes: 1. labelling, 2.functionality, 3.price. 
    16:"""Suppose you are participating a survey which aims to investigate your willingness to purchase an IoT device, and the presence of security labels may influence your decision. There are other attributes, including device information and your demographics, that might affect your decision to buy or not buy an IoT device. Please consider the following factors:
Device Information:
- device_name: The IoT device name is {device_name}
- security_label: The device {security_label}
- label_condition: The device's security grade is {label_condition}
- functionality: The device offers {functionality}
- price: The IoT device costs ${price}
- alternative: {alternative} option type


Your Demographic Information:
- age: {age} years old
- gender: {gender}
- education: {education} level

Please assess the influence of the following attributes—labeling, functionality, and price—on your purchasing decision.

Based on this information, please indicate:
1. Whether you would choose to purchase this IoT device (1 for 'Yes', 0 for 'No').
2. Rank the top 3 factors that influenced your decision from the following options: device_name, security_label, functionality, price, age, gender, education, and alternative.

Format your response as follows in JSON, and do not output additional information:
{{
    "purchase_choice": <1 for 'Yes', 0 for 'No'>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}
 """,

    41: """Suppose you are a student deciding how to travel to school. Consider the following factors:

- distance to school: {distance} km.
- car_availability: {car_availability} (yes or no).
- school_location: {school_location}
- weather: The weather is {season} (fair or bad).
- age: The student is {age} years old.
- effort: Physical effort needed to bike to school: {effort} KJ.

Based on the influence of the above variables, what is your commuting mode choice? Respond with:
1 for walking
2 for cycling
3 for public transport
4 for car/motorcycle
    Please also rank the top 3 factors in your decision with the order of importance from the following:
distance, car_availability, school_location,  season,age, and effort.

Output your result in JSON format, and do not output other information. 
{{
    "transportation_choice": <mode>,
    "top_factors": [
        "<factor_1>",
        "<factor_2>",
        "<factor_3>"
    ]
}}

""",
#------------------------------------------------------------------------------------------------


    
    26: "", #SKIPPED: Dataset is not compatible/matching
    14: "", # PAPER Missed; completed 16
    15:"", #Missed #15
    21: "", #Data Does not make sense
    29: "", # SKIPPED: DATASET IS IN GERMAN
    38: """Suppose you are a resident of {user_state}. You are choosing between two different energy plans to provide electricity for your home: Plan 1 and Plan 2. Consider the following factors:

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
    39: """Suppose you are the head of a household in the Indian state of {state}. You currently own a traditional stove and use it to cook food. Suppose you are choosing between two improved cooking stoves to purchase: Stove 1 and Stove 2. Consider the following factors:

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