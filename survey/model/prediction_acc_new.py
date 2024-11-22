"""
Created by: Jun Zhao @ UofA
Date: 11/21/24
Description: For questions or issues, please refer to zhaojun@arizona.edu.

"""

import json
import glob
import os

# Define the choice map
choice_map = {1: "walk", 2: "bike", 3: "transit", 4: "car"}

# Directory where JSON files are located
directory = "."  # Replace with your directory path if different

# Find all JSON files starting with "output_results_4o_mini"
json_files = glob.glob(os.path.join(directory, "output_results_4o_mini*.json"))

# Initialize counters for overall accuracy calculation
total_correct_predictions = 0
total_predictions = 0

# Process each JSON file and calculate individual accuracy
file_accuracies = {}

for json_file in json_files:
    print(f"Processing file: {json_file}")
    correct_predictions = 0
    total_file_predictions = 0

    with open(json_file, 'r') as f:
        results = json.load(f)

    total_file_predictions = len(results)
    for entry in results:
        try:
            # Extract the correct answer and GPT response
            correct_choice = entry["original_transportation_choice"]
            gpt_response = json.loads(entry["gpt_response"])

            # Map the predicted transportation_choice to its string equivalent
            predicted_choice = choice_map[gpt_response["transportation_choice"]]

            # Compare the predicted choice to the correct choice
            if predicted_choice == correct_choice:
                correct_predictions += 1
        except Exception as e:
            print(f"Error processing entry ID {entry.get('id', 'unknown')}: {e}")

    # Calculate file-specific accuracy
    file_accuracy = correct_predictions / total_file_predictions if total_file_predictions > 0 else 0
    file_accuracies[json_file] = file_accuracy
    total_correct_predictions += correct_predictions
    total_predictions += total_file_predictions

# Print individual file accuracies
for file_name, accuracy in file_accuracies.items():
    print(f"Accuracy for {file_name}: {accuracy * 100:.2f}%")

# Calculate overall accuracy
overall_accuracy = total_correct_predictions / total_predictions if total_predictions > 0 else 0
print(f"\nOverall Accuracy: {overall_accuracy * 100:.2f}%")