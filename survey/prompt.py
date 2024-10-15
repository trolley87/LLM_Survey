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
    5: "",
    41: "",
    9: "",
    26: "",
    14: "",
    15: "",
    21: "",
    29: "", # SKIPPED: DATASET IS IN GERMAN
    38: "You are a resident of {user_state}. You are choosing between two different energy plans to provide electricity for your home: Plan 1 and Plan 2. The attributes of each plan are as follows: \
- Plan 1 will cost you ${price1} per month, while Plan 2 will cost you ${price2} per month. \
- Compared to your current energy plan, Plan 1 will result in {gas1}% lower emissions, while Plan 2 will result in {gas2}% lower emissions. \
- For both Plan 1 and Plan 2, 10% of your energy will be derived from hydroelectic sources. \
- For Plan 1, {nuc1}% of your energy will be derived from nuclear sources. For Plan 2, {nuc2}% of your energy will be derived from nuclear sources. \
- For Plan 1, {ren1}% of your energy will be derived from renewable sources. For Plan 2, {ren2}% of your energy will be derived from renewable sources. \
- For Plan 1, the remaining {fos1}% of your energy will be derived from fossil fuels. For Plan 2, the remaining {fos2}% of your fuel will be derived from fossil fuels. \
Based on these attributes, which energy plan would you prefer?",
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