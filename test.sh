ffmpeg -i /Users/plant/next/files/vod/origin/bunny/bunny.mp4 
-map 0:v -map 0:a -map 0:v -map 0:a 
-c:v libx264 -profile:v main 

-g 30 -crf 23 -r 30 -filter:v:0 scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:'('ow-iw')'/2:'('oh-ih')'/2 
-b:v:0 1500000 -maxrate:v:0 2500000 -bufsize:v:0 5000000 -s:v:0 1280x720 -c:a:0 aac -b:a:0 128000 -ac:0 2 -max_muxing_queue_size 1600 
-hls_time 10 -hls_list_size 0

-c:v libx264 -profile:v main 
-g 30 -crf 23 -r 30 -filter:v:1 scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:'('ow-iw')'/2:'('oh-ih')'/2 
-b:v:1 1500000 -maxrate:v:1 2500000 -bufsize:v:1 5000000 -s:v:1 640x360 -c:a:1 aac -b:a:1 128000 -ac:1 2 -max_muxing_queue_size 1600 
-hls_time 10 -hls_list_size 

-var_stream_map "v:0,a:0,name:720 v:1,a:1,name:360" 
-master_pl_name master.m3u8
-hls_segment_filename /Users/plant/next/files/vod/origin/bunny/output/%v/segment_%04d.ts /Users/plant/next/files/vod/origin/bunny/output/%v/playlist.m3u8