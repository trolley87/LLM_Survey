''' Papers:
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
Health
22. Population preferencesfor breast cancer screening
23. Preferences for HIV testing services
'''

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
    9: """Willingness-to-pay(WTP) for sustainable beer is binary, where a value of 1 indicates that customers are willing to pay for sustainable beer, and a value of 0 indicates that they are not. WTP(0 or 1)
How does the WTP for sustainable beer vary across different independent variables? Consider the following aspects:
- Demographic factors (e.g., age, gender, education, political leaning, marital status, household residency, and whether the respondent lives in a rural, urban, or suburban setting.):
The age of the respondent is {age_category}.  
The educational attainment of the respondent is as follows: {education_summary}.
The income is {income_summary}

Recycling behavior: whether the respondent recycles (Recycle_Yes).
Number of beers respondent reports consuming {buying_descriptions}
The respondent has indicated the following regarding their environmental contributions: {environmental_contribution_descriptions}.
Respond with 1 if you are willing to pay for sustainable beer, and a value of 0 if you are not.

  """,

    
    26: "",
    14: "",
    15: "",
    21: "",
    29: "",
    38: "",
    39: "",
    24: "",
    27: "Suppose you are a person deciding on a new car to purchase. You have two cars to choose from. \
- Car 1 costs {price1} dollars, and Car 2 costs {price2} dollars. \
- Car 1 has {capacity1} liters of storage space, and Car 2 has {capacity2} liters of storage space. \
- Car 1 uses {energy1} liters of gasoline per 10 km of travel, and Car 2 uses {energy2} liters of gasoline per 10 km of travel. \
- Car 1 achieves a safety score of {safety1}% based on the European New Car Assessment Programme, and Car 2 achieves a safety score of {safety2}% from the same test. \
Respond with 1 if you would purchase Car 1, 2 if you would purchase Car 2, or 3 if you would purchase neither car.",
    22: "",
    23: ""
 }