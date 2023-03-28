#!/bin/bash

init_dir=$(pwd)
raw_dir=360-raw
out_dir=360-ready
spatialmedia_dir=/home/deck/Downloads/google360metaInjector/spatial-media/
exiftool_dir=/home/deck/Downloads/Image-ExifTool-12.56/

jpg_mask_1=masks/mask_2896_1.png
mp4_mask_1=masks/mask_1440_1.png
jpg_mask_2=masks/mask_2896_2.png
mp4_mask_2=masks/mask_1440_2.png

for i in $raw_dir/*.JPG
do
  cd $init_dir
  ffmpeg -threads 6 -y -i  "$i" -i $init_dir/$jpg_mask_1 -i $init_dir/$jpg_mask_2 -filter_complex  "[0]v360=dfisheye:e:id_fov=271:yaw=180:interp=lanc,unsharp[s];  [s][1]blend=all_mode='softlight':all_opacity=0.7[b];[b][2]blend=all_mode='softlight':all_opacity=0.5" -q:v 1 -qmin:v 1 $init_dir/temp.jpg

  cd $exiftool_dir
  exiftool -ProjectionType="equirectangular"  -UsePanoramaViewer="True" $init_dir/temp.jpg -o $out_dir/"${i##*/}"
  exiftool -TagsFromFile "$i" $out_dir/"${i##*/}"

  rm -f $out_dir/*_original
done

for i in $raw_dir/*.MP4
do
  cd $init_dir
  ffmpeg -threads 6 -y -real_time 6 -hwaccel auto -i "$i" -i $init_dir/$mp4_mask_1 -i $init_dir/$mp4_mask_2 -filter_complex  "[0]v360=dfisheye:e:id_fov=271:yaw=180:interp=lanc,unsharp[s];  [s][1]blend=all_mode='softlight':all_opacity=0.7[b];[b][2]blend=all_mode='softlight':all_opacity=0.5" -c:v libx264 -profile:v high -preset:v medium -tune:v film -movflags +faststart -maxrate 25M $init_dir/temp.mp4

  cd $spatialmedia_dir
  python spatialmedia -i --stereo=left-right $init_dir/temp.mp4 $out_dir/"${i##*/}"

  cd $exiftool_dir
  exiftool -TagsFromFile "$i" $out_dir/"${i##*/}"

  rm -f $out_dir/*_original
done

