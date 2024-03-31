import os
import base64
import requests

####### MODIFY THIS ########
api_key = "YOUR_OPENAI_API_KEY"  # Replace with your actual API key
directory = "Path_to_folder"  # Folder where the screenshots are located

# Function to encode the image and convert PNG to JPEG if necessary
def encode_image(image_path):
  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode('utf-8')

# Function to get a new name from GPT-4 Vision
def get_new_name(api_key, base64_image):
  headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}"
  }

  payload = {
    "model": "gpt-4-vision-preview",
    "messages": [
      {
        "role": "user",
        "content": [
          {"type": "text", "text": "Describe the content of this screenshot in a maximum 5 words to rename the file"},
          {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{base64_image}", "detail": "low"}} #detail is set to low to minimize token cost
        ]
      }
    ],
    "max_tokens": 300
  }

  response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
  print(f"Response Status Code: {response.status_code}")  # Debugging line
  print(f"Response Content: {response.json()}")  # Debugging line
  if response.status_code == 200:
    result = response.json()
    # Corrected line here
    description = result['choices'][0]['message']['content']
    return description.strip().replace(" ", "_") + ".png"
  else:
    print(f"Error processing image: {response.text}")
    return None

# Function to rename screenshots in the directory
def rename_screenshots(directory, api_key):
  print(f"Scanning directory: {directory}")
  files_found = os.listdir(directory)
  print(f"Files found: {files_found}")
  for filename in files_found:
    if filename.startswith("Capture") and filename.endswith('.png'):  # Ensure this matches your files
      print(f"Processing file: {filename}")
      file_path = os.path.join(directory, filename)
      base64_image = encode_image(file_path)
      new_name = get_new_name(api_key, base64_image)
      if new_name:
        new_file_path = os.path.join(directory, new_name)
        print(f"Attempting to rename '{filename}' to '{new_name}'")
        os.rename(file_path, new_file_path)
      else:
        print(f"Could not get a new name for {filename}")

# Example usage
rename_screenshots(directory, api_key)
