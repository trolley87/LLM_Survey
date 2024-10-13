import pandas as pd
import json
# the contribution to this literature is the special attention to school travel,
# Read the input data from DDModeChoice.txt
data = pd.read_csv('inputData/DDModeChoice.txt', sep='\t')
# Save the DataFrame as a .csv file
data.to_csv('inputData/DF_TransChoice.csv', index=False, header=True)
df = pd.read_csv('inputData/DF_TransChoice.csv')
df['same_shore'] = (df['School_location'] == df['CB_location']).astype(int)

# What is CB? The city bike station? or student's home?
#- What is Your academic performance (Leistung) is {leistung}?

prompt_template = """You are a student deciding how to travel to school. Consider the following factors:

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
4 for car"""
# Map values to natural language for better understanding by LLMs
choice_map = {1: "walk", 2: "bike", 3: "transit", 4: "car"} #paper page#9 Based on Train (2009), we assume that student n chooses the alternative i = {walk, bike, transit, car} & p#13
gender_map = {0: "male", 1: "female"}#paper page#9 table 2; = 1, if female otherwise 0
season_map = {1: "winter", 0: "summer"}#paper page#9 table 2; = 1, if winter season; otherwise 0
car_avail_map = {0: "No car", 1: "A car"}#paper table 2; = 1, if car is always available
school_location_map = {0: "non Same Shore", 1: "Same Shore"}  # paper table 3; Same Shore # page 9: different sides (shores) of the river Elbe
#page #9: We consider the dummy variable same shore that takes value 1, if student and school are located on the same side of the river. Table 2 displays the descriptive statistics of the variables used in the students’ utility function.
cb_location_map = {0: "not close", 1: "close"}  # Assuming 0 is not close and 1 is close
same_shore_map = {0: "different shores", 1: "same shore"}

# to create the JSON prompt
def create_json_prompt(row):
    gender_str = gender_map[row['Gender']]
    distance_str = round(row['Distance'], 2)
    car_avail_str = car_avail_map[row['CarAvail']]
    season_str = season_map[row['Season']]
    choice_str = choice_map[row['Choice']]
    school_location_str = school_location_map[row['School_location']]
    cb_location_str = cb_location_map[row['CB_location']]
    same_shore_str = same_shore_map[row['same_shore']]

    formatted_prompt = prompt_template.format(
        distance=f"{distance_str} KM",
        school_location= school_location_str,
        grade= row['Grade'], #paper page#9 grades are numbered: 5th, 6th, ..., 12th
        age= row['Age'], #paper page#9 aged between 10 and 19 years
        gender= gender_str,
        car_availability= car_avail_str,
        season= season_str,
        cb_location= cb_location_str,
        same_shore= same_shore_str,
        leistung= row['Leistung']
    )
    
    # Structure the prompt and result as a dictionary (JSON-like structure)
    json_prompt = {
        "input": formatted_prompt,
        "output": {
            "choice": choice_str
        }
    }
    return json_prompt

#  a list to store all JSON prompts
json_prompts = []

# Iterate through each row in the DataFrame
for _, row in df.iterrows():
    json_prompt = create_json_prompt(row)
    json_prompts.append(json_prompt)

# Convert the list of JSON prompts to a JSON string
json_output = json.dumps(json_prompts, indent=2)

# Print the JSON output
print(json_output)

#save the JSON output to a file
with open('transportation_choice_prompts.json', 'w') as f:
    f.write(json_output)

    
