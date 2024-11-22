"""
Created by: Jun Zhao @ UofA
Date: 11/21/24
Description: For questions or issues, please refer to zhaojun@arizona.edu.

"""
import json

# Define the choice map
choice_map = {1: "walk", 2: "bike", 3: "transit", 4: "car"}

# Load JSON data
with open('/Users/junzhao/Documents/UArizona/papers/AI_survey/src/LLM_Survey/survey/model/survey-05-transportation-choice-gpt-claude-zero.jsonl', 'r') as file:
    data = [json.loads(line) for line in file]

# Initialize counters
model_names = ["claude_sonet", "claude_haiku", "gpt4o", "gpt3.5"]
accuracy_counts = {model: 0 for model in model_names}
total_predictions = len(data)

# Calculate accuracy for each model
for entry in data:
    correct_mode = entry["output"]["original_transportation_choice"]  # Correct answer in text
    for model in model_names:
        predicted_choice_number = int(entry[model]["transportation_choice"][0])  # Get number
        predicted_mode = choice_map[predicted_choice_number]  # Map to text
        if predicted_mode == correct_mode:  # Compare prediction with correct answer
            accuracy_counts[model] += 1

# Compute accuracy percentages
accuracy_rates = {model: (count / total_predictions) * 100 for model, count in accuracy_counts.items()}

# Print results
print("Accuracy Rates:")
for model, accuracy in accuracy_rates.items():
    print(f"{model}: {accuracy:.2f}%")