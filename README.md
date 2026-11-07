Work in progress currently, likely to be challenging and glitchy re model placement, but pretty decent once it's done.

I had a bit of trouble getting the model to load properly, try talking to deepseek or chatgpt or your favourite ai buddy for fine tuning.

*** point --model at the directory, not the .xml, and export with nms=False to dodge the mask-shape error. ***

Approx 5.5-6 fps on Ryzen 4650u, definitely potential to speed up if you make your own model, etc, but, sufficient for batch jobs over night.

Intended usage: Processing large volumes of security related images for objects, ie, turn on time lapse, and process later.
Or, as a plugin for motioneye upon detection to parse detections into sub-categories to save human time, however, this is less likely.

No warrantee, may not work for you without a little time and learning, please, if you build off this code, share and share alike.

Thanks and kind regards to deepseek ai, chatgpt, and google search ai :)
