from prompt import *
from googletrans import Translator
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
    df = pd.read_stata("datasets/29.dta")
    # dataset is in German, convert it to English
    translator = Translator()
    inputfile = open("datasets/29.csv")
    input = inputfile.readlines()
    
    with open("output/29_english.csv", "w", encoding="utf-8", newline="") as outfile:
        i = 0
        for line in input:
            if i == 0:
                i = 1
                continue
            print(type(line))
            print(line)
            translation = translator.translate(line, src="de", dest="en").text
            outfile.write(translation)
            outfile.write("\n")
    #with open("output/29.csv", "w",  encoding="utf-8", newline = '') as outfile:
    #    df.to_csv(outfile, index = False)

def convert38():
    '''dataset explanation
        attributes of the choice experiment (explained on page 3 of paper)
        USD: monthly electric bill payment in USD/Yen {90,100,110,120}
        GAS: percentage reduction of air emissions {0, 20, 40, 60}
        nuc: percentage of electricity generated by nuclear {0, 10, 20, 30}
        ren: percentage of electricity generated by renewable {0, 10, 20, 30}
        percentage of hydroelectic power used is fixed at 10%
        percentage of fossil fuel power used is 100 - hydro - nuc - ren
    '''
    file_names = ["38_1_california_us2012.csv", "38_2_Michigan_us2012.csv", "38_3_NewYork_us2012.csv", "38_4_Texas_us2012.csv"]
    states = ["California", "Michigan", "New York", "Texas"]
    for state in range(len(file_names)):
        df = pd.read_csv("datasets/" + file_names[state])
        df["Prompt"] = ""
        with open("output/38_" + states[state] + ".csv", "w", newline='') as outfile:
            for i in range(0, len(df.index), 2):
                row1 = df.iloc[i]
                row2 = df.iloc[i+1]
                nuc1data = row1["nuc"]
                nuc2data = row2["nuc"]
                ren1data = row1["ren"]
                ren2data = row2["ren"]
                fos1data = str(90 - int(nuc1data) - int(ren1data))
                #print("nuc " + str(nuc1data) + " ren " + str(ren1data) + " fos " + str(fos1data))
                fos2data = str(90 - int(nuc2data) - int(ren2data))
                prompt = prompt_templates[38].format(user_state=states[state],
                                                    price1=row1["USD"], price2=row2["USD"],
                                                    gas1=row1["GAS"], gas2=row2["GAS"],
                                                    nuc1=nuc1data, nuc2=nuc2data,
                                                    ren1=ren1data, ren2=ren2data,
                                                    fos1=fos1data, fos2=fos2data)
                df.at[i+1,"Prompt"] = prompt
            df.to_csv(outfile, index = False)

def convert39():
    '''dataset explanation
        25440 rows
        state_code: UP = Uttar Pradesh; UK = Uttarakhand
        female_hh: 0 if head of household (HH) is male, 1 if female
        educhh: HH number of years of education

        price - price of the stove in Rupees
        fuel - number of units of fuel required to power the stove
        smoke - number of units of smoke emitted by the stove
        pots - number of burners on the stove
            note: for fuel and smoke, 1 unit corresponds to a 33% decrease for smoke emissions and fuel requirement
    '''
    state_code_mappings = {
        "UP": "Uttar Pradesh",
        "UK": "Uttarakhand"
    }
    df = pd.read_csv("datasets/39.csv")
    df["Prompt"] = "" # add new Prompt column, defaults to empty string
    with open("output/39.csv", "w", newline = '') as outfile:
        for i in range(0, len(df.index), 3):
            row1 = df.iloc[i]
            row2 = df.iloc[i+1]
            row3 = df.iloc[i+2]

            # skip rows where fuel consumption is blank
            if pd.isna(row1["fuel"]) or pd.isna(row2["fuel"]) or pd.isna(row3["fuel"]):
                continue

            state_data = state_code_mappings[row1["state_code"]]
            
            pots1_data = int(row1["pots"])
            pots2_data = int(row2["pots"])
            pots3_data = int(row3["pots"])

            fuel1 = int(row1["fuel"])
            fuel2 = int(row2["fuel"])
            fuel3 = int(row3["fuel"])

            #print(str(fuel1) + " " + str(fuel2) + " " + str(fuel3))

            smoke1 = int(row1["smoke"])
            smoke2 = int(row2["smoke"])
            smoke3 = int(row3["smoke"])

            if fuel3 > fuel1:
                fuel1_diff = (fuel3 - fuel1) * 33
                fuel1_data = str(fuel1_diff)  + "% less fuel than"
            elif fuel3 < fuel1:
                fuel1_diff = (fuel1 - fuel3) * 33
                fuel1_data = str(fuel1_diff) + "% more fuel than"
            else:
                fuel1_data = "the same amount of fuel as"

            if fuel3 > fuel2:
                fuel2_diff = (fuel3 - fuel2) * 33
                fuel2_data = str(fuel2_diff) + "% less fuel than"
            elif fuel3 < fuel2:
                fuel2_diff = (fuel2 - fuel3) * 33
                fuel2_data = str(fuel2_diff) + "% more fuel than"
            else:
                fuel2_data = "the same amount of fuel as"

            if smoke3 > smoke1:
                smoke1_diff = (smoke3 - smoke1) * 33
                smoke1_data = str(smoke1_diff) + "% less smoke than"
            elif smoke3 < smoke1:
                smoke1_diff = (smoke1 - smoke3) * 33
                smoke1_data = str(smoke1_diff) + "% more smoke than"
            else:
                smoke1_data = "the same amount of smoke as"

            if smoke3 > smoke2:
                smoke2_diff = (smoke3 - smoke2) * 33
                smoke2_data = str(smoke2_diff) + "% less smoke than"
            elif smoke3 < smoke2:
                smoke2_diff = (smoke2 - smoke3) * 33
                smoke2_data = str(smoke2_diff) + "% more smoke than"
            else:
                smoke2_data = "the same amount of smoke as"

            prompt = prompt_templates[39].format(state=state_data,
                                                 pots1=pots1_data, pots2=pots2_data, pots3=pots3_data,
                                                 price1=int(row1["price"]),price2=int(row2["price"]),
                                                 fuel1=fuel1_data,fuel2=fuel2_data,
                                                 smoke1=smoke1_data,smoke2=smoke2_data)

            df.at[i+2,"Prompt"] = prompt
        df.to_csv(outfile, index = False)



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
    '''dataset explanation (page 10 of paper)
        d_att1_2: you will be invited to the screening via:
            1: telephone
            0 :mailed letter
        d_att2_2: when invited, you will
            1: be able to get to your appointment right away
            0: receive instructions on how to make an appointment
        d_att3_2: when invited, you will receive
            1: a detailed explanation of the screening
            0: no explanation of screening
        d_att4_2: the screening
            1: will be combined with other relevant health visi
            0: will not be combined with other health visits
        d_att5_2:
            1: Travel time to screening is 40 min
            0: 20 min
        d_att5_3:
            1: Travel time to screening is 60 min
            0: 20 min
        d_att5_4:
            1: Travel time to screening is 90 min
            0: 20 min
        d_att6_2: Waiting time at the screening will be
            1: 40 min
            0: 20 min
        d_att6_3: Waiting time at the screening will be
            1: 60 min
            0: 20 min
        d_att7_2: The doctor who will examine you is someone
            1: you don't know or heard positively about
            0: you know or heard positively about
        d_att8_2: The screening will be performed via
            1: mammography
            0: manual examination
        d_att8_3: The screening will be performed via
            1: mammography and manual examination
            0: manual examination only
        d_att9_2: The screening will accurately detect cancer in
            1: 70 out of 100 women
            0: 60 out of 100 women
        d_att9_3: The screening will accurately detect cancer in
            1: 80 out of 100 women
            0: 60 out of 100 women
        d_att9_4: The screening will accurately detect cancer in
            1: 90 out of 100 women
            0: 60 out of 100 women
        d_att10_2: Cost of the test is
            1: 20 Belarus Rubles
            0: free
        d_att10_3 Cost of the test is
            1: 40 Belarus Rubles
            0: free
    '''
    brb_to_dollar = 0.31 # conversion of Belarus Rubles to USD as of 10/19/2024
    df = pd.read_csv("datasets/22.csv")
    df["Prompt"] = "" # add new Prompt column, defaults to empty string
    with open("output/22.csv", "w", newline = '') as outfile:
        for i in range(0, len(df.index), 3):
            row1 = df.iloc[i]
            row2 = df.iloc[i+1]

            if row1["d_att1_2"] == 1:
                invitation1_data = "a telephone call"
            else:
                invitation1_data = "a mailed letter"
            if row2["d_att1_2"] == 1:
                invitation2_data = "a telephone call"
            else:
                invitation2_data = "a mailed letter"

            if row1["d_att2_2"] == 1:
                appt1_data = "be able to go to your appointment immediately"
            else:
                appt1_data = "be given instructions for scheduling your appointment"
            if row2["d_att2_2"] == 1:
                appt2_data = "be able to go to your appointment immediately"
            else:
                appt2_data = "be given instructions for scheduling your appointment"

            if row1["d_att3_2"] == 1:
                detail1_data = "a detailed"
            else:
                detail1_data = "no"
            if row2["d_att3_2"] == 1:
                detail2_data = "a detailed"
            else:
                detail2_data = "no"

            if row1["d_att4_2"] == 1:
                combine1_data = "will"
            else:
                combine1_data = "will not"
            if row2["d_att4_2"] == 1:
                combine2_data = "will"
            else:
                combine2_data = "will not"

            travel_time1_data = "20"
            if row1["d_att5_2"] == 1:
                travel_time1_data = "40"
            elif row1["d_att5_3"] == 1:
                travel_time1_data = "60"
            elif row1["d_att5_4"] == 1:
                travel_time1_data = "90"
            travel_time2 = "20"
            if row2["d_att5_2"] == 1:
                travel_time2_data = "40"
            elif row2["d_att5_3"] == 1:
                travel_time2_data = "60"
            elif row2["d_att5_4"] == 1:
                travel_time2_data = "90"

            wait_time1_data = "20"
            if row1["d_att6_2"] == 1:
                wait_time1_data = "40"
            elif row1["d_att6_3"] == 1:
                wait_time1_data = "60"
            wait_time2_data = "20"
            if row2["d_att6_2"] == 1:
                wait_time2_data = "40"
            elif row2["d_att6_3"] == 1:
                wait_time2_data = "60"

            if row1["d_att7_2"] == 1:
                doctor1_data = "you never met or heard positively of before"
            else:
                doctor1_data = "you know or heard positively about"
            if row2["d_att7_2"] == 1:
                doctor2_data = "you never met or heard positively of before"
            else:
                doctor2_data = "you know or heard positively about"

            examine1_data = "by manual examination"
            if row1["d_att8_2"] == 1:
                examine1_data = "by mammography"
            elif row1["d_att8_3"] == 1:
                examine1_data = "by mammography and manual examination"
            examine2_data = "by manual examination"
            if row2["d_att8_2"] == 1:
                examine2_data = "by mammography"
            elif row2["d_att8_3"] == 1:
                examine2_data = "by mammography and manual examination"

            accuracy1_data = "60"
            if row1["d_att9_2"] == 1:
                accuracy1_data = "70"
            elif row1["d_att9_3"] == 1:
                accuracy1_data = "80"
            elif row1["d_att9_4"] == 1:
                accuracy1_data = "90"
            accuracy2_data = "60"
            if row2["d_att9_2"] == 1:
                accuracy2_data = "70"
            elif row2["d_att9_3"] == 1:
                accuracy2_data = "80"
            elif row2["d_att9_4"] == 1:
                accuracy2_data = "90"

            cost1_data = "nothing"
            if row1["d_att10_2"] == 1:
                cost1_data = str(int(20 * brb_to_dollar)) + " dollars"
            elif row1["d_att10_3"] == 1:
                cost1_data = str(int(40 * brb_to_dollar)) + " dollars"
            cost2_data = "nothing"
            if row2["d_att10_2"] == 1:
                cost2_data = str(int(20 * brb_to_dollar)) + " dollars"
            elif row2["d_att10_3"] == 1:
                cost2_data = str(int(40 * brb_to_dollar)) + " dollars"

            prompt = prompt_templates[22].format(invitation1=invitation1_data, invitation2=invitation2_data,
                                                 appt1=appt1_data, appt2=appt2_data,
                                                 detail1=detail1_data, detail2=detail2_data,
                                                 combine1=combine1_data, combine2=combine2_data,
                                                 travel_time1=travel_time1_data, travel_time2=travel_time2_data,
                                                 wait_time1=wait_time1_data, wait_time2=wait_time2_data,
                                                 doctor1=doctor1_data, doctor2=doctor2_data,
                                                 examine1=examine1_data, examine2=examine2_data,
                                                 accuracy1=accuracy1_data, accuracy2=accuracy2_data,
                                                 cost1=cost1_data, cost2=cost2_data)
            df.at[i+2,"Prompt"] = prompt
        df.to_csv(outfile, index = False)

def convert23():
    '''dataset explanation (based on Table 1 from paper)
    22320 rows
    Participants were presented with a series of HIV testing plan questions
    For each question, there were two plans for them to choose from, or they could opt out of testing entirely
    Plan A is always a remote test, done from the participant's home
    Plan B is done at a public location
    attributes:
        eS, eH, dS, dH
        S = self (remote test), left column of Table 1
        H = HCP (health care provider), right column of Table 1
    '''
    df = pd.read_csv("datasets/23.csv")
    df["Prompt"] = "" # add new Prompt column, defaults to empty string
    with open("output/23.csv", "w", newline = '') as outfile:
        for i in range(0, len(df.index), 3):
            row1 = df.iloc[i]       # self
            row2 = df.iloc[i+1]     # HCP

            if row1["dSWindow12"] == 1:
                selfWindow_data = "12 weeks"
            else:
                selfWindow_data = "4 weeks"

            if row2["dHLocGP"] == 1:
                HCPLoc_data = "a general practice"
            elif row2["dHLocMobile"] == 1:
                HCPLoc_data = "a mobile clinic based at a bar, club, or sauna"
            elif row2["dHLocComty"] == 1:
                HCPLoc_data = "a community location such as an HIV charity"
            else:
                HCPLoc_data = "a sexual health clinic"

            if row1["dSHowOral"] == 1:
                selfSample_data = "an oral swab"
            else:
                selfSample_data = "a blood drop via a skin prick"
            if row2["dHBloodDrop"] == 1:
                HCPSample_data = "a blood drop via a skin prick"
            else:
                HCPSample_data = "a blood sample via a syringe"
            
            if row1["dSGetOnline"] == 1:
                selfObtain_data = "ordering online and receiving the test in the mail"
            else:
                selfObtain_data = "\"clicking and collecting\" from a pharamacy or health clinic"
            if row2["dHGetBook"] == 1:
                HCPObtain_data = "booking and obtaining an appointment"
            else:
                HCPObtain_data = "dropping in and waiting"

            if row1["dSWait3days"] == 1:
                selfWait_data = "After taking the test, you will mail it and receive a call with your results in 3 days from a health care professional"
                selfResults_data = "Advice about your results will be available online and from the person who calls you"
            elif row1["dSWait7days"] == 1:
                selfWait_data = "After taking the test, you will mail it and receive a call with your results in 7 days from a health care professional"
                selfResults_data = "Advice about your results will be available online and from the person who calls you"
            elif row1["dSWait30mins"] == 1:
                selfWait_data = "After taking the test, you will get your results in 30 minutes"
                selfResults_data = "Advice about your results will be available online and from a health care professional accessible via a free phone number"
            else:
                selfWait_data = "After taking the test, you will get your results in 10 minutes"
                selfResults_data = "Advice about your results will be available online and from a health care professional accessible via a free phone number"

            if row2["dHWait3days"] == 1:
                HCPWait_data = "After taking the test, you will receive a call with your results in 3 days from a health care professional"
                HCPResults_data = "The person who calls you can give you advice about your results, and advice will be available online"
            elif row2["dHWaitSame"] == 1:
                HCPWait_data = "The same day you take the test, you will receive a call with your results from a health care professional"
                HCPResults_data = "The person who calls you can give you advice about your results, and advice will be available online."
            elif row2["dHWait30mins"] == 1:
                HCPWait_data = "After taking the test, you will result your results then and there in 30 minutes"
                HCPResults_data = "You will be able to receive advice from the person who gives you your result, and advice will be available online"
            else:
                HCPWait_data = "After taking the test, you will result your results then and there in 10 minutes"
                HCPResults_data = "You will be able to receive advice from the person who gives you your result, and advice will be available online"

            if row1["dSAccuracy99"] == 1:
                selfAccuracy_data = "99"
            else:
                selfAccuracy_data = "95"
            if row2["dHAccuracy99"] == 1:
                HCPAccuracy_data = "99"
            else:
                HCPAccuracy_data = "95"

            if row1["dSInfect"] == 1:
                selfInfect_data = ""
            else:
                selfInfect_data = "not "
            if row2["dHInfect"] == 1:
                HCPInfect_data = ""
            else:
                HCPInfect_data = "not "

            if row1["dSCostfree"] == 1:
                selfCost_data = "be free"
            elif row1["dSCost10"] == 1:
                selfCost_data = "cost 10 pounds"
            elif row1["dSCost20"] == 1:
                selfCost_data = "cost 20 pounds"
            else:
                selfCost_data = "cost 30 pounds"

            prompt = prompt_templates[23].format(selfWindow=selfWindow_data,
                                                 HCPLoc=HCPLoc_data,
                                                 selfSample=selfSample_data,HCPSample=HCPSample_data,
                                                 selfObtain=selfObtain_data,HCPObtain=HCPObtain_data,
                                                 selfWait=selfWait_data, HCPWait=HCPWait_data,
                                                 selfResults=selfResults_data, HCPResults=HCPResults_data,
                                                 selfAccuracy=selfAccuracy_data, HCPAccuracy=HCPAccuracy_data,
                                                 selfInfect=selfInfect_data, HCPInfect=HCPInfect_data,
                                                 selfCost=selfCost_data)

            df.at[i+2,"Prompt"] = prompt
        df.to_csv(outfile, index = False)




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
            education_descriptions = "Less than high school"
        elif row['Educ_HSdip'] == 1:
            education_descriptions = "High School"
        elif row['Educ_College_NoDegree'] == 1:
            education_descriptions = "Some College Education (No Degree)"
        elif row['Educ_AAorBA'] == 1:
            education_descriptions = "Associate's or Bachelor's Degree"
        elif row['Educ_GradDegree'] == 1:
            education_descriptions = "Graduate Degree"
        else:
            "No educational attainment specified"

        if row['Income_0to24999'] == 1:
            income_descriptions = "Income $0 to $24,999"
        elif row['Income_25to49999'] == 1:
            income_descriptions = "Income $25,000 to $49,999" 
        elif row['Income_50to74999'] == 1:
            income_descriptions = "Income $50,000 to $74,999"
        elif row['Income_75to99999'] == 1:
            income_descriptions = "Income $75,000 to $99,999" 
        elif row['Income_100plus'] == 1:
            income_descriptions = "Income $100,000 and above"
        else:
            "No income category specified"

        if row['BuyBeer_Never'] == 1:
            buying_descriptions = "Never buys beer"
        elif row['BuyBeer_sub1permonth'] == 1:
            buying_descriptions = "Buys beer less than once per month"
        elif row['BuyBeer_1permonth'] == 1:
            buying_descriptions = "Buys beer once per month"
        elif row['BuyBeer_2or3permonth'] == 1:
            buying_descriptions = "Buys beer 2 to 3 times per month" 
        elif row['BuyBeer_Weekly'] == 1:
            buying_descriptions = "Buys beer weekly" 
        elif row['BuyBeer_PlusWeekly'] == 1:
            buying_descriptions = "Buys beer more than once a week"
        else:
            "No buying frequency specified"
        environmental_contribution = ""
        # Extract environmental contribution
        if row['EnvContribution_Yes'] == 1:
            environmental_contribution = "Contributes to environmental causes"
        elif row['EnvContribution_IDK'] == 1:
            environmental_contribution = "Unsure about environmental contribution"
        elif row['EnvContribution_PrefNoAnswer'] == 1:
            environmental_contribution = "Prefers not to answer about environmental contribution"
        else:
            "No environmental contribution information specified"

        choice_str = choice_map.get(row['Choice'], "Unknown choice")

        formatted_prompt = prompt_templates[9].format(
            age_category = age_category,
            education_summary = education_descriptions,
            income_summary = income_descriptions,
            buying_descriptions = buying_descriptions,
            environmental_contribution_descriptions = environmental_contribution
    )

        json_prompt = {
            "input": formatted_prompt,
            "output": {
                "choice_WTP": choice_str
            }
        }
        return json_prompt

    json_prompts = []
    limit = 100
    for _, row in data.head(limit).iterrows(): 
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
    #convert9()
    #convert26()
    #convert14()
    #convert15()
    #convert21()
    #convert29()
    #convert38()
    #convert39()
    #convert24()
    #convert27()
    #convert22()
    convert23()

if __name__ == "__main__":
    main()