import os
import base64

import requests

####### MODIFY THIS ########
API_KEY = "YOUR_OPENAI_API_KEY"  # Replace with your actual API key
DIRECTORY = "Path_to_folder"  # Folder where the screenshots are located
MODEL_NAME = "gpt-4o-mini"  # Vision-capable Responses API model
MAX_OUTPUT_TOKENS = 60  # Keep responses short to minimize cost


def encode_image(image_path: str) -> str:
  """Return a base64-encoded representation of an image."""
  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode("utf-8")


def _extract_description(result: dict) -> str:
  """Extract the first text response from a Responses API payload."""
  text_fragments = []
  for item in result.get("output", []):
    for content in item.get("content", []):
      if content.get("type") == "output_text":
        text_fragments.append(content.get("text", ""))
  return "".join(text_fragments).strip()


def get_new_name(
  api_key: str,
  base64_image: str,
  model_name: str = MODEL_NAME,
  max_output_tokens: int = MAX_OUTPUT_TOKENS,
) -> str:
  """Call the OpenAI Responses API to generate a short description."""
  headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}",
  }

  payload = {
    "model": model_name,
    "input": [
      {
        "role": "user",
        "content": [
          {
            "type": "input_text",
            "text": "Describe this screenshot in 5 words or fewer for a filename.",
          },
          {
            "type": "input_image",
            "image_url": f"data:image/png;base64,{base64_image}",
          },
        ],
      }
    ],
    "max_output_tokens": max_output_tokens,
  }

  response = requests.post(
    "https://api.openai.com/v1/responses", headers=headers, json=payload, timeout=30
  )
  response.raise_for_status()
  result = response.json()
  description = _extract_description(result)
  if not description:
    raise ValueError(f"No description returned for image. Full response: {result}")
  return description.replace(" ", "_").replace("/", "-") + ".png"


def rename_screenshots(directory: str, api_key: str) -> None:
  """Rename screenshots in the directory based on model responses."""
  for filename in os.listdir(directory):
    if filename.startswith("Capture") and filename.endswith(".png"):
      file_path = os.path.join(directory, filename)
      base64_image = encode_image(file_path)
      try:
        new_name = get_new_name(api_key, base64_image)
      except Exception as exc:  # pylint: disable=broad-except
        print(f"Could not get a new name for {filename}: {exc}")
        continue
      new_file_path = os.path.join(directory, new_name)
      os.rename(file_path, new_file_path)
      print(f"Renamed '{filename}' to '{new_name}'")


if __name__ == "__main__":
  rename_screenshots(DIRECTORY, API_KEY)
