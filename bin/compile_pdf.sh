#!/bin/bash

## Args:
##-------------------------
## png_folder_path
## outputfile
## Usage: 
##-------------------------
## ./compile_pdf.sh png_folder_path outputfile

PNG_FOLDER_PATH=$1
OUTPUT_PDF="$2.pdf"
TEMP_DIR="./tmp/temp_pdfs"

# Ensure mutool is installed
if ! command -v mutool &> /dev/null
then
    echo "Error: mutool is not installed. Install it first."
    exit 1
fi

echo "PNG_FOLDER_PATH: $PNG_FOLDER_PATH"
echo "OUTPUT_PDF: $OUTPUT_PDF"

# Create a temporary directory for intermediate PDFs
mkdir -p "$TEMP_DIR"

# Convert each PNG to an individual PDF
for img in $(ls "$PNG_FOLDER_PATH"/*.png | sort -V); do
    base_name=$(basename "$img" .png)
	echo "converting image $base_name .."
    mutool convert -o "$TEMP_DIR/$base_name.pdf" "$img"
done

echo "compiling pdf..."
# Merge all temporary PDFs into a single PDF
mutool merge -o "$OUTPUT_PDF" "$TEMP_DIR"/*.pdf


# Cleanup temporary files
echo "deleting temp files.."
rm -rf "$TEMP_DIR"

# Check if the final PDF was created successfully
if [ -f "$OUTPUT_PDF" ]; then
    echo "PDF successfully created: $OUTPUT_PDF"
else
    echo "Error: Failed to create the PDF."
fi
