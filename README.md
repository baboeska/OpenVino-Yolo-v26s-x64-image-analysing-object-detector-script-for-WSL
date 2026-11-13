# AI BIPOD for Yolo 26s Openvino.

## Batch image processor with object detection.

This program processes a directory of images for various objects, and then outputs the sorted images into a different directory. It copies, not deletes, so does require slightly greater free space than the size of images to be processed.


5.5-6.6 fps on Ryzen 4650u, 10-13 fps on Core i9 13900H

*(Note: Tiling mode will be roughly 1.5–4×+ slower, but detects much smaller objects).*

Intended usage: Processing large volumes of security related images for objects, ie, turn on time lapse, and process later.
Or, as a plugin for motioneye upon detection to parse detections into sub-categories to save human time, however, this is less likely.

No warrantee, may not work for you without a little time and learning, please, if you build off this code, share and share alike.

Thanks and kind regards to deepseek ai, chatgpt, and google search ai :)



# How to:

    ./install-bipod-ov.sh
    source ~/openvino-env/bin/activate
    python3 bipod-ov.py -i=~/Pictures -o=~/Pictures_Sorted
    
# OR
    sudo apt update && sudo apt upgrade -y

## Install python3

    sudo apt install python3-full

## Create and activate virtual environment

    python3 -m venv bipod-yolo26s-ov

    source bipod-yolo26s-ov/bin/activate


## Install core dependencies (note: INT8 quantization requires nncf)

    pip install --upgrade pip
    pip install ultralytics openvino opencv-python tqdm supervision

## If you need INT8 acceleration, additionally install:
## pip install nncf


## Download and export YOLO26s (disable end-to-end to ensure output format compatibility)

    python3 - <<'EOF'
    from ultralytics import YOLO
    model = YOLO("yolo26s.pt")
    model.export(format="openvino", imgsz=640, nms=False)
    EOF
 
## After export, you will get a directory like yolo26s_openvino_model/


## Dry run test (recommended to validate on a small sample first) - Note: 

*** point --model at the directory, not the .xml, and export with nms=False to dodge the mask-shape error. ***

### You must activate the Python venv you created earlier prior to running;

    source ~/bipod-yolo26s-ov/bin/activate

## Test

    python bipod-ov.py -i ~/Pictures -o ~/Pictures_Sorted -m ./yolo26s_openvino_model/ --dry-run

## Formal run

    python bipod-ov.py -i ~/Pictures -o ~/Pictures_Sorted -m ./yolo26s_openvino_model/ --conf 0.4

# Advanced Features (Modes & Logging)

## By default, the script runs in --mode auto.

    Images smaller than 1000px will be quickly resized.

    Images larger than 1000px will be tiled into 640x640 overlapping squares to catch distant, small objects.

    Images larger than 4K (3840px) will be downscaled first so your RAM doesn't explode.

You can override this behaviour with flags:


Flag	What it does


--mode resize	Never tiles. Fastest, but misses small/distant objects.

--mode tile	Always tiles. Slower, but maximum accuracy for high-res images.

--mode auto	(Default) Resizes small images, tiles large ones.

--tile-threshold 1000	Change the threshold (in pixels) where auto switches to tiling.

--tile-size 640	Size of the tiles (should match your model's export resolution).

--tile-overlap 100	Overlap between tiles in pixels (prevents cutting objects in half).

--max-edge 3840	Downscale massive images to this maximum dimension before tiling.


## Logs and Output

At the end of a run, the script generates two files inside your output directory:


run_summary.txt: A text file detailing exactly how many images were scanned, how many contained detections, and the breakdown of classes.


failures.csv: A spreadsheet containing the path and exact error reason for any images that were corrupt, too large, or failed during processing.


If two files from different folders have the same name, the script will automatically append _1, _2 to the filename so you never overwrite data.


## Problems?

Raise an issue here, or, consult with your favourite AI, Google Search AI, Deepseek, and ChatGPT all contributed to this.
