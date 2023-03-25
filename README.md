Gear 360 Stitcher, using ffmpeg.

Requirements: ffmpeg, exiftool, pyhton, google spatial media injector


How to:
1. Edit 360stitch.sh for exiftool and spatialmedia paths (you can also edit raw_dir and out_dir)
2. Copy jpg and mp4 files to 360-raw directoy
3. Run 360stitch.sh


What the script does:
It first stitches the equicircular to equirectangular. Then applies 2 masks to correct edge darkness. Lastly it applies the 360 metaata and corrects capture date.


Limitation:
There is no attempt to make brightness the same between front and rear images if hey exposed differently bu the camera. It does not align edge lines.


Currently tested on a steamdeck. You should be able to run it in Android via termux (it can install ffmpeg, exiftool and python). Encoder is libx264 but you can edit the ffmpeg parameters if you want to use hardware acceleration.
