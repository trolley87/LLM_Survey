from prompt import *
import pandas as pd

def convert5():
    # Insert the code that generates the prompts based on paper #5 survey data
    pass

def convert41():
    pass

def convert9():
    pass

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
    with open("output/29.csv", "w",  encoding="utf-8", newline = '') as outfile:
        df.to_csv(outfile, index = False)

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

def main():
    # Maybe in future we can use command line arguments to specify which papers we convert
    convert5()
    convert41()
    convert9()
    convert26()
    convert14()
    convert15()
    convert21()
    convert29()
    convert38()
    convert39()
    convert24()
    #convert27()
    convert22()
    convert23()

if __name__ == "__main__":
    main()