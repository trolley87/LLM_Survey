import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

from openai import OpenAI

# Load secrets from the file
SECRET_FILE = 'secrets.txt'
with open(SECRET_FILE) as f:
    lines = f.readlines()
    for line in lines:
        if line.split(',')[0].strip() == "openai_key":
            openai_key = line.split(',')[1].strip()

openai_client = OpenAI(api_key=openai_key)

# Function to call GPT model
def call_gpt4o_mini(message):
    """Call the GPT model for text information and return the response."""
    try:
        response = openai_client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": message}],
            temperature=0.0,
            max_tokens=4000
        )
        return response.choices[0].message.content
    except Exception as e:
        print(f"Error calling GPT: {e}")
        return None


# Function to call GPT-4o model
def call_gpt4o(message):
    """Call the GPT-4o model for text information and return the response."""
    try:
        response = openai_client.chat.completions.create(
            model="gpt-4o",
            messages=[{"role": "user", "content": message}],
            temperature=0.0,
            max_tokens=4000
        )
        return response.choices[0].message.content
    except Exception as e:
        print(f"Error calling GPT-4o: {e}")
        return None


# Worker function for parallel processing
def process_entry(entry, use_gpt4o_mini=True):
    try:
        input_message = entry['input']
        print(f"Processing entry ID: {entry['output']['id']} with {'GPT-4o-mini' if use_gpt4o_mini else 'GPT-4o'}")

        # Select the appropriate model
        response = call_gpt4o_mini(input_message) if use_gpt4o_mini else call_gpt4o(input_message)

        return {
            "id": entry["output"]["id"],
            "original_transportation_choice": entry["output"]["original_transportation_choice"],
            "gpt_response": response
        }
    except Exception as e:
        print(f"Error processing entry ID {entry['output']['id']}: {e}")
        return None


def main():
    # Load the input JSON file
    json_file = "/Users/junzhao/Documents/UArizona/papers/AI_survey/src/LLM_Survey/survey/Survey_0502_resample_2000_v1.json"
    with open(json_file, 'r') as f:
        data = json.load(f)

    print("Loaded JSON file successfully.")

    # Decide which model to use
    use_gpt4o_mini = True  # Set to False to use GPT-4o instead

    # Process the entries in parallel
    results = []
    total_entries = len(data)
    print(
        f"Starting to process {total_entries} entries in parallel using {'GPT-4o-mini' if use_gpt4o_mini else 'GPT-4o'}.")
    start_time = time.time()

    with ThreadPoolExecutor(max_workers=10) as executor:
        futures = {executor.submit(process_entry, entry, use_gpt4o_mini): entry for entry in data}
        for i, future in enumerate(as_completed(futures), 1):
            result = future.result()
            if result:
                results.append(result)
            if i % 100 == 0 or i == total_entries:
                print(f"Progress: {i}/{total_entries} entries processed.")

    end_time = time.time()
    print(f"All entries processed. Time taken: {end_time - start_time:.2f} seconds.")

    # Save the results to a new JSON file
    output_file = f"output_results_{'4o_mini' if use_gpt4o_mini else '4o'}_502.json"
    with open(output_file, 'w') as f:
        json.dump(results, f, indent=4)

    print(f"Processing complete. Results saved to {output_file}.")


if __name__ == "__main__":
    main()