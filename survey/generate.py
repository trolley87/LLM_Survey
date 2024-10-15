from prompt import *
import pandas as pd
import json

def convert5():
    # Insert the code that generates the prompts based on paper #5 survey data
    pass

#def convert41():
  #  pass
#focus on secondary schools, particularly colleges (German = ‘‘Gymnasium”). College students are aged between 10 and 19 years
#page #9
#travel-to-school mode choice,
#analyze the influence of the variables distance, car availability, season or weather, respectively, on commuting mode choice.
#Age is considered as an explanatory variable as well, admittedly it turned out to be not significant for public transport.
#German regions
#adverse effects of school closures on transport mode choice the patterns of school choice specified first.
#most influencing factors are distance, car availability and weather.
#Fair weather= summer term and bad weather = winter term, (see Fig. 3).
#We assume a transport mode specific average speed for walking of 4 km/h and for cycling of 12 km/h (Federal EnvironmentAgency Germany, 2007).
#traffic lights, congestion average speed of 30 km/h 
#In this study we will focus on distance, the school profile and the authority responsible to determine the school location choice,
# choose a school with a different profile.
# we assume that profile and the authority responsible are two factors which influence the choice of a certain school.
#influence of the variables distance, car availability, season or weather, respectively, on commuting mode choice. Age is considered as an explanatory variable as well, 
#  Distance is a continuous variable measured in kilometers. Car availability (alltime/not all time) and weather (fair/bad) are dummy variables.
# Car availability means, whether the student has the possibility of travelling to school by car. Car availability equals 1, if the student has the possibility of commuting to school by car every day.
# there is a table 4 for coefficients in page #9 for waliking, Cycling, Public transport, Car/motorcycle
#page 10 results
#choice (a;1: walking, b;2: cycling, c;3: public transport, d;4: car/ motorcycle). fig 9
#def convert9 ():
    #We find that the majority of beer consumers are willing to pay more for sustainable beer.
    #This analysis studies whether consumers are willing to pay more for sustainable beer and what predicts consumers’ willingness-to-pay (WTP).
    #what attributes define a sustainable consumer?
    # what is dependent variable? Recycle_Yes?
    #The dependent variable is the amount per ounce that a respondent would be willing to pay above the typical price of his/her favorite beer.
    #Regression results with dependent variable WTP for sustainable beer (in $/oz). is $/oz is more sustainable
    #We include several categories of independent variables,
    #For each additional $1.00 that one pays per ounce of beer, an individual is willing to pay a premium of 7.4 cents per ounce for the sustainable version.
    #Personal demographics only account for about 9% of the R-squared decomposition and, as
#a variable grouping are statistically insignificant. Those who are younger and those with lower levels of education are willing to pay more for sustainable beer. Contrary to other studies’ findings about the importance of children or location of residence, we find no evidence that these conditions matter.
   # a col "choice" which is dependent variable WTP for sustainable beer (in $/oz).
   #of personal demographics: age, gender, education, political leaning, marriage status, household residency, and whether the respondent lives in a rural, urban, or suburban setting.
#To determine which factors are related to greater WTP for sustainable beer, we estimate an ordinary least squared regression with robust standard errors. 
  #  pass

def convert26():
    pass

def convert14():
    pass

def convert15():
    pass

def convert21():
    pass

def convert29():
    pass

def convert38():
    pass

def convert39():
    pass

def convert24():
    pass

def convert27():
    krone_to_dollar = 0.095 # as of 9/27/2024
    df = pd.read_csv("datasets/27.csv")
    df["Prompt"] = "" # add new Prompt column, defaults to empty string
    with open("output/27.csv", "w", newline = '') as outfile:
        for i in range(0, len(df.index), 3):
            row1 = df.iloc[i]
            row2 = df.iloc[i+1]
            price1Str = str(int(row1["Cost"]) * krone_to_dollar)
            price2Str = str(int(row2["Cost"]) * krone_to_dollar)
            prompt = prompt_templates[27].format(price1=price1Str,  price2=price2Str,
                                                 capacity1=row1["Capacity"], capacity2=row2["Capacity"],
                                                 energy1=row1["Energy"], energy2=row2["Energy"],
                                                 safety1=row1["Safety"], safety2=row2["Safety"])
            df.at[i+2,"Prompt"] = prompt
        df.to_csv(outfile, index = False)

def convert22():
    pass

def convert23():
    pass

def convert41():
    data = pd.read_csv('datasets/41.csv', delimiter='\t')  # Specify tab as the delimiter
    data.columns = data.columns.str.strip()  # Remove leading/trailing spaces
    print(data.columns) 
    choice_map = {1: "walking", 2: "cycling", 3: "public transport", 4: "car/ motorcycle"} 
    car_avail_map = {0: "available all time", 1: "available not all time"} # Car availability equals one, if the student has the possibility of commuting to school by car every day.
    season_map = {1: "Summer season/fair weather", 0: "Winter season/bad weather"}

    def create_json_prompt(row):
        distance_str = round(row['Distance'], 2)
        car_avail_str = car_avail_map[row['CarAvail']]
        season_str = season_map[row['Season']]
        choice_str = choice_map[row['Choice']]
   
        formatted_prompt = prompt_templates[41].format(
            distance=f"{distance_str} KM",
            age= row['Age'], #paper page#9 aged between 10 and 19 years
            car_availability= car_avail_str,
            season= season_str
        )
    
    # Structure the prompt and result as a dictionary (JSON-like structure)
        json_prompt = {
            "input": formatted_prompt,
             "output": {
                "choice": choice_str
        }
    }
        return json_prompt 
    json_prompts = []

    for _, row in data.iterrows():
        json_prompt = create_json_prompt(row)
        json_prompts.append(json_prompt)

    json_output = json.dumps(json_prompts, indent=2)

    print(json_output)

    with open('output/41.json', 'w') as f:
        f.write(json_output)

    pass

def convert9():
    data = pd.read_csv('datasets/9. Beer Data Full Dataset.csv')
    print(data.columns.tolist())  # Print column names for verification
    education_descriptions = []
    income_descriptions = []
    buying_descriptions = []
    environmental_contribution_descriptions = []
    
    choice_map = {
        1: "Willing to pay for sustainable beer (in $/oz).",
        0: "Not willing to pay for sustainable beer (in $/oz)."
    }

    def create_json_prompt(row):
        if row['Age_sub21']:
            age_category = "Age under 21"
        elif row['Age_21to24']:
            age_category = "Age 21 to 24"
        elif row['Age_25to34']:
            age_category = "Age 25 to 34"
        elif row['Age_35to44']:
            age_category = "Age 35 to 44"
        elif row['Age_45to54']:
            age_category = "Age 45 to 54"
        elif row['Age_55to64']:
            age_category = "Age 55 to 64"
        elif row['Age_65plus']:
            age_category = "Age 65 and above"
        else:
            age_category = "Unknown age category"

        if row['Educ_NoHSdip'] == 1:
            education_descriptions.append("Less than high school")
        if row['Educ_HSdip'] == 1:
            education_descriptions.append("High School")
        if row['Educ_College_NoDegree'] == 1:
            education_descriptions.append("Some College Education (No Degree)")
        if row['Educ_AAorBA'] == 1:
            education_descriptions.append("Associate's or Bachelor's Degree")
        if row['Educ_GradDegree'] == 1:
            education_descriptions.append("Graduate Degree")
        
        education_summary = ", ".join(education_descriptions) if education_descriptions else "No educational attainment specified"

        if row['Income_0to24999'] == 1:
            income_descriptions.append("Income $0 to $24,999")
        if row['Income_25to49999'] == 1:
            income_descriptions.append("Income $25,000 to $49,999")
        if row['Income_50to74999'] == 1:
            income_descriptions.append("Income $50,000 to $74,999")
        if row['Income_75to99999'] == 1:
            income_descriptions.append("Income $75,000 to $99,999")
        if row['Income_100plus'] == 1:
            income_descriptions.append("Income $100,000 and above")
        
        income_summary = ", ".join(income_descriptions) if income_descriptions else "No income category specified"

        if row['BuyBeer_Never'] == 1:
            buying_descriptions.append("Never buys beer")
        if row['BuyBeer_sub1permonth'] == 1:
            buying_descriptions.append("Buys beer less than once per month")
        if row['BuyBeer_1permonth'] == 1:
            buying_descriptions.append("Buys beer once per month")
        if row['BuyBeer_2or3permonth'] == 1:
            buying_descriptions.append("Buys beer 2 to 3 times per month")
        if row['BuyBeer_Weekly'] == 1:
            buying_descriptions.append("Buys beer weekly")
        if row['BuyBeer_PlusWeekly'] == 1:
            buying_descriptions.append("Buys beer more than once a week")
        
        buying_summary = ", ".join(buying_descriptions) if buying_descriptions else "No buying frequency specified"

        # Extract environmental contribution
        if row['EnvContribution_Yes'] == 1:
            environmental_contribution_descriptions.append("Contributes to environmental causes")
        if row['EnvContribution_IDK'] == 1:
            environmental_contribution_descriptions.append("Unsure about environmental contribution")
        if row['EnvContribution_PrefNoAnswer'] == 1:
            environmental_contribution_descriptions.append("Prefers not to answer about environmental contribution")
        
        environmental_contribution_summary = ", ".join(environmental_contribution_descriptions) if environmental_contribution_descriptions else "No environmental contribution information specified"
        choice_str = choice_map.get(row['Choice'], "Unknown choice")

        formatted_prompt = prompt_templates[9].format(
            age_category = age_category,
            education_summary = education_summary,
            income_summary = income_summary,
            buying_descriptions=buying_summary,
            environmental_contribution_descriptions=environmental_contribution_summary
    )

        json_prompt = {
            "input": formatted_prompt,
            "output": {
                "choice_WTP": choice_str
            }
        }
        return json_prompt

    json_prompts = []

    for _, row in data.iterrows():
        json_prompt = create_json_prompt(row)
        json_prompts.append(json_prompt)

    json_output = json.dumps(json_prompts, indent=2)

    print(json_output)

    with open('output/9.json', 'w') as f:
        f.write(json_output)

def main():
    # Maybe in future we can use command line arguments to specify which papers we convert
    #convert5()
    #convert41()
    convert9()
    #convert26()
    #convert14()
   # convert15()
    #convert21()
    #convert29()
    #convert38()
    #convert39()
    #convert24()
   # convert27()
    #convert22()
    #convert23()

if __name__ == "__main__":
    main()