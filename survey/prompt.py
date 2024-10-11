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
    coefficients on page 8
Health
22. Population preferencesfor breast cancer screening
23. Preferences for HIV testing services
'''

prompt_templates = {
    5: "",
    41: "",
    9: "",
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