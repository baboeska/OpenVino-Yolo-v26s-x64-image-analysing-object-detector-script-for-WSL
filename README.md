# AI BIPOD for Yolo 26s Openvino.

## Batch image processor with object detection.

This program processes a directory of images for various objects, and then outputs the sorted images into a different directory. It copies, not deletes, so does require slightly greater free space than the size of images to be processed.

Work in progress currently, may be glitchy re model placement.

I had a bit of trouble getting the model to load properly, try talking to deepseek or chatgpt or your favourite ai buddy for fine tuning.

*** point --model at the directory, not the .xml, and export with nms=False to dodge the mask-shape error. ***

Approx 5.5-6 fps on Ryzen 4650u, definitely potential to speed up if you make your own model, etc, but, sufficient for batch jobs over night.

Intended usage: Processing large volumes of security related images for objects, ie, turn on time lapse, and process later.
Or, as a plugin for motioneye upon detection to parse detections into sub-categories to save human time, however, this is less likely.

No warrantee, may not work for you without a little time and learning, please, if you build off this code, share and share alike.

Thanks and kind regards to deepseek ai, chatgpt, and google search ai :)


    sudo apt update && sudo apt upgrade -y

#Install python3

    sudo apt install python3-full

## Create and activate virtual environment

    python3 -m venv bipod-yolo26s-ov

    source bipod-yolo26s-ov/bin/activate


## Install core dependencies (note: INT8 quantization requires nncf)

    pip install ultralytics openvino opencv-python tqdm

## If you need INT8 acceleration, additionally install:
## pip install nncf

    python3 -c "from ultralytics import YOLO; YOLO('yolo26n.pt').export(format='openvino', imgsz=640, nms=False)"

## Download and export YOLO26s (disable end-to-end to ensure output format compatibility)

    model = YOLO("yolo26s.pt")

    model.export(format="openvino", imgsz=640, nms=False)

## After export, you will get a directory like yolo26s_openvino_model/


## Dry run test (recommended to validate on a small sample first)

    python bipod-ov.py -i ~/Pictures -o ~/Pictures_Sorted -m ./yolo26s_openvino_model/ --dry-run

## Formal run

    python bipod-ov.py -i ~/Pictures -o ~/Pictures_Sorted -m ./yolo26s_openvino_model/ --conf 0.4
