import base64
import os
import re
from typing import Optional

import requests

####### MODIFY THIS ########
api_key = "YOUR_OPENAI_API_KEY"  # Replace with your actual API key
directory = "Path_to_folder"  # Folder where the screenshots are located


def encode_image(image_path: str) -> str:
  """Return a base64 encoded representation of the provided image."""

  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode("utf-8")


def _limit_and_sanitize_description(text: str) -> Optional[str]:
  """Return a filesystem-friendly, five-word-or-fewer description."""

  if not text:
    return None

  words = re.findall(r"[\w'-]+", text)
  if not words:
    return None

  limited_words = words[:5]
  sanitized = "_".join(limited_words)
  return sanitized.strip("._") or None


def get_new_name(api_key: str, base64_image: str) -> Optional[str]:
  headers = {
    "Authorization": f"Bearer {api_key}",
    "Content-Type": "application/json",
  }

  payload = {
    "model": "gpt-4o-mini",
    "input": [
      {
        "role": "user",
        "content": [
          {
            "type": "input_text",
            "text": "Describe the content of this screenshot in at most five words for a filename.",
          },
          {
            "type": "input_image",
            "image_base64": base64_image,
          },
        ],
      }
    ],
    "max_output_tokens": 30,
  }

  response = requests.post(
    "https://api.openai.com/v1/responses", headers=headers, json=payload, timeout=30
  )
  print(f"Response Status Code: {response.status_code}")  # Debugging line
  try:
    response_data = response.json()
  except ValueError:
    print(f"Non-JSON response: {response.text}")
    return None

  print(f"Response Content: {response_data}")  # Debugging line

  if response.status_code != 200:
    print(f"Error processing image: {response.text}")
    return None

  try:
    description = response_data["output"][0]["content"][0]["text"]
  except (KeyError, IndexError, TypeError) as error:
    print(f"Unexpected response structure: {error}")
    return None

  return _limit_and_sanitize_description(description)

# Function to rename screenshots in the directory
def rename_screenshots(directory: str, api_key: str) -> None:
  print(f"Scanning directory: {directory}")
  files_found = os.listdir(directory)
  print(f"Files found: {files_found}")
  for filename in files_found:
    if filename.startswith("Capture"):
      file_path = os.path.join(directory, filename)
      if not os.path.isfile(file_path):
        continue

      name_root, extension = os.path.splitext(filename)
      if not extension:
        print(f"Skipping '{filename}' because it has no extension")
        continue

      print(f"Processing file: {filename}")
      base64_image = encode_image(file_path)
      description = get_new_name(api_key, base64_image)
      if description:
        new_filename = f"{description}{extension}"
        new_file_path = os.path.join(directory, new_filename)
        print(f"Attempting to rename '{filename}' to '{new_filename}'")
        os.rename(file_path, new_file_path)
      else:
        print(f"Could not get a new name for {filename}")

if __name__ == "__main__":
  rename_screenshots(directory, api_key)
