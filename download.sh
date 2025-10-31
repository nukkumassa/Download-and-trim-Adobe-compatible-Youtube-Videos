#! /bin/bash

link=$1

if [ -z "$link" ]; then
  echo "Error: no link given"
  exit 1
fi

yt-dlp -F "$link"

echo "Select audio format"

read audio_format

echo "Select video format: make sure to choose the avc1 codec (H264)"

read video_format

echo "Do you want to trim your video ? yes or no"

read val

video_title=$(yt-dlp --get-title "$link")

output_dir="$HOME/Desktop/Downloaded_yt_videos"

temp_file="$output_dir/temp_$(date +%s).mp4"

safe_title=$(echo "$video_title" | tr -cd '[:alnum:] _-')

if [ "$val" = "yes" ]; then
    echo "Enter start time (HH:MM:SS or MM:SS)"
    read start_time
    echo "Enter end time (HH:MM:SS or MM:SS)"
    read end_time

     yt-dlp -f "$video_format+$audio_format" \
            --merge-output-format mp4 \
	    --extractor-args "youtube:player-client=default,-tv_simply" \
           -o "$temp_file" \
           "$link"

     ffmpeg -ss "$start_time" -to "$end_time" -i "$temp_file" -c copy \
            "$output_dir/${safe_title}_trimmed.mp4"

     rm "$temp_file"
    
elif [ "$val" = "no" ]; then
    
    yt-dlp -f "$video_format+$audio_format" \
	   --merge-output-format mp4 \
	   --extractor-args "youtube:player-client=default,-tv_simply" \
	   -o "~/Desktop/Downloaded_yt_videos/%(title)s.%(ext)s" \
           "$link"

else
    echo "Invalid choice. Please type yes or no."
    exit 1
    
fi




