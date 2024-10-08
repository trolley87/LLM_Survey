import pandas as pd

'''ID: ID of the user who answered the survey question
Cost: price of car in NOK (Norwegian Kroner)
Energy: number of liters of gasoline used per 10 km of travel
Capacity: luggage space in liters
Safety: percentage safety score of the car'''

prompt_template = "Suppose you are a person deciding on a new car to purchase. You have two cars to choose from. \
Car 1 costs {price1} dollars, and Car 2 costs {price2} dollars. Car 1 has {capacity1} liters of storage space, \
and Car 2 has {capacity2} liters of storage space. Car 1 uses {energy1} liters of gasoline per 10 km of travel, \
and Car 2 uses {energy2} liters of gasoline per 10 km of travel. Car 1 has a safety score of {safety1}%, and \
Car 2 has a safety score of {safety2}%. Respond with 1 if you would purchase Car 1, 2 if you would purchase Car 2, \
or 3 if you would purchase neither car."

krone_to_dollar = 0.095 # as of 9/27/2024

def create_prompt(row1, row2):
    price1Str = str(int(row1["Cost"]) * krone_to_dollar)
    price2Str = str(int(row2["Cost"]) * krone_to_dollar)
    prompt = prompt_template.format(price1=price1Str,  price2=price2Str,
                                    capacity1=row1["Capacity"], capacity2=row2["Capacity"],
                                    energy1=row1["Energy"], energy2=row2["Energy"],
                                    safety1=row1["Safety"], safety2=row2["Safety"])
    return prompt

df = pd.read_csv("dataset.csv")
df["Prompt"] = "" # add new Prompt column, defaults to empty string

with open("output.csv","w", newline = '') as outfile:
    for i in range(0, len(df.index), 3):
        prompt = create_prompt(df.iloc[i], df.iloc[i+1])
        df.at[i+2,"Prompt"] = prompt
    df.to_csv(outfile, index = False)