
# ScreenshotRenamer

## Description

This Python script automates the renaming of screenshot files within a specified directory using the GPT-4 Vision API. By analyzing the content of each image, the script generates a concise new filename, making file management more organized and meaningful.

## Getting Started

### Prerequisites

- Python 3.x installed on your system.
- An OpenAI API key.

### Dependencies

- requests library, which can be installed via pip:

```bash
pip install requests
```

### Setup

1. **Inserting Your API Key**

The script requires an OpenAI API key to communicate with the GPT-4 Vision API. You'll find a placeholder in the script where you can insert your key:

```python
api_key = "YOUR_OPENAI_API_KEY"  # Replace with your actual API key
```

- **Where to Find Your API Key:** Log in to your OpenAI account and navigate to the API section to find your key.
- **How to Insert Your Key:** Replace `"YOUR_OPENAI_API_KEY"` with your actual key, ensuring it's within quotes. For example:

```python
api_key = "sk-youractualapikeyhere"
```

2. **Specifying the Directory**

You need to specify the directory where your screenshots are located. There's a line in the script for this purpose:

```python
directory = "Path_to_folder"  # Folder where the screenshots are located
```

- **Finding the Path:** This is the path to the folder on your computer or server where the screenshots you want to rename are stored.
- **How to Insert the Path:** Replace `"Path_to_folder"` with the actual path to your directory. Use an absolute path for clarity.

For example, on a Windows system:

```python
directory = "C:\Users\YourName\Pictures\Screenshots"
```

Or on a Unix/Linux system:

```python
directory = "/home/yourname/Pictures/Screenshots"
```

3. **Understanding and Modifying the Code**

- **Encoding Images:** The encode_image function reads an image file, encodes it in base64 format, and returns the encoded string. This is required for the API request.

- **Renaming Logic:** The get_new_name function sends the encoded image to the GPT-4 Vision API and asks for a short description to use as a new filename. It handles the API response, extracting the description, and formats it as a valid filename.

- **Renaming Files:** The rename_screenshots function looks for files in the specified directory that match a naming pattern (default is files starting with "Capture" and ending with '.png'). It then processes each file, calls get_new_name to get a new name, and renames the file.

5. **Customization**

**File Naming Convention:** If your screenshots have a different naming convention, modify the conditions in the rename_screenshots function accordingly.
```python
 if filename.startswith("Capture") and filename.endswith('.png'): # Ensure this matches your files
```