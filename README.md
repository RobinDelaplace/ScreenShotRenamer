# ScreenshotRenamer

## Description

This Python script automates the renaming of screenshot files within a specified directory using OpenAI's GPT-4o mini vision-capable model. The tool now calls the Responses API, which offers lower per-screenshot pricing compared to the legacy Chat Completions workflow while still producing concise, descriptive filenames for quick organization.

## Getting Started

### Prerequisites

- Python 3.x installed on your system.
- An OpenAI API key with access to GPT-4o mini or another compatible Responses API model.

### Dependencies

Install the single runtime dependency with pip:

```bash
pip install requests
```

### Setup

1. **Insert Your API Key**

   Open `main.py` and replace the placeholder with your actual API key:

   ```python
   API_KEY = "YOUR_OPENAI_API_KEY"
   ```

   - Log in to your OpenAI account, create a key from the API dashboard, and keep it secret.
   - Consider loading the key from an environment variable when running in production scripts.

2. **Point to Your Screenshot Folder**

   Update the `DIRECTORY` constant so the script scans the correct location:

   ```python
   DIRECTORY = "Path_to_folder"
   ```

   - Use an absolute path for clarity, such as `"C:\\Users\\YourName\\Pictures\\Screenshots"` on Windows or `"/home/yourname/Pictures/Screenshots"` on Linux/macOS.

3. **Choose the Model and Token Limits**

   The default configuration targets the cost-efficient `gpt-4o-mini` model and keeps generations brief:

   ```python
   MODEL_NAME = "gpt-4o-mini"
   MAX_OUTPUT_TOKENS = 60
   ```

   - Supply another Responses API vision model if you need different capabilities.
   - Short prompts plus a small `MAX_OUTPUT_TOKENS` value help minimize token usage and cost per rename.
   - You can adjust `MAX_OUTPUT_TOKENS` if you need longer filenames—just remember that higher limits may increase spend.

4. **Run the Script**

   From the project directory, execute:

   ```bash
   python main.py
   ```

   Every screenshot that begins with `Capture` and ends with `.png` will be renamed with a concise description returned by GPT-4o mini. Modify the logic in `rename_screenshots` if your screenshots follow a different naming pattern.

## How It Works

1. Each screenshot is base64-encoded.
2. The encoded image plus a short text prompt are sent to the Responses API (`https://api.openai.com/v1/responses`).
3. GPT-4o mini responds with a five-word (or shorter) description.
4. The script sanitizes the text and renames the file accordingly.

With the switch to the Responses API, you keep image processing costs low while benefiting from GPT-4o mini's fast multimodal understanding.
