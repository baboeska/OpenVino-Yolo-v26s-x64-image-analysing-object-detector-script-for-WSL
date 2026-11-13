#!/bin/bash
#
# Script Name: install_yolo.sh
# Description: Installs dependencies, sets up a virtual environment,
#              and exports a YOLO model to OpenVINO format.
#
# Note: This script assumes a Debian/Ubuntu-based Linux distribution.

# --- Setup ---
set -e

echo "================================================="
echo "STEP 1: System Update and Upgrade"
echo "================================================="
sudo apt update && sudo apt upgrade -y

echo "================================================="
echo "STEP 2: Install Python Environment and Dependencies"
echo "================================================="
# Install Python and venv
sudo apt install python3-full python3-venv -y

# --- Virtual Environment Setup ---
VENV_DIR="bipod-yolo26s-ov"
echo "Creating Python virtual environment at: ${VENV_DIR}"
python3 -m venv "${VENV_DIR}"

# Activate the virtual environment
echo "Activating virtual environment..."
source "${VENV_DIR}/bin/activate"

# --- Package Installation ---
echo "Installing core Python packages (pip upgrade and installs)..."
pip install --upgrade pip

# Install required libraries
pip install ultralytics openvino opencv-python tqdm supervision

echo "Package installation complete."
echo "Current environment activated."

# --- Model Export using Python ---
echo "================================================="
echo "STEP 3: Exporting YOLO Model to OpenVINO"
echo "================================================="

# Execute the Python code to export the model
python3 - <<'EOF'
import os
import sys
from ultralytics import YOLO

# Check if the correct virtual environment is active (optional sanity check)
if 'VIRTUAL_ENV' not in os.environ:
    print("ERROR: Virtual environment is not correctly activated.")
    sys.exit(1)

try:
    print("Downloading and loading YOLO model: yolo26s.pt")
    model = YOLO("yolo26s.pt")

    # Export the model to OpenVINO format
    print("Exporting model to OpenVINO format...")
    model.export(format="openvino", imgsz=640, nms=False)

    print("\n✅ SUCCESS: Model successfully exported to OpenVINO format!")

except Exception as e:
    print(f"An unexpected error occurred during model export: {e}")
    sys.exit(1)
EOF

echo "================================================="
echo "INSTALLATION COMPLETE!"
echo "================================================="
echo "Your OpenVINO model is ready in the current directory."
echo ""
echo "To start sorting images, run:"
echo "  source ${VENV_DIR}/bin/activate"
echo "  python bipod-ov.py -i ~/Pictures -o ~/Pictures_Sorted -m ./yolo26s_openvino_model/"
