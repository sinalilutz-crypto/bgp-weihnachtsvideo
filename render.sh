#!/usr/bin/env bash
set -e

W=1920
H=1080
FPS=30
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

ffmpeg \
-f lavfi -i "color=c=#F6EB14:s=${W}x${H}:d=6:r=${FPS}" \
-loop 1 -t 6 -i "bgp logo gelb.png" \
-f lavfi -i "color=c=#0B0B0B:s=${W}x${H}:d=6:r=${FPS}" \
-loop 1 -t 6 -i "gruppe.jpg" \
-f lavfi -i "color=c=#0B0B0B:s=${W}x${H}:d=6:r=${FPS}" \
-loop 1 -t 3 -i "1.JPG" \
-loop 1 -t 3 -i "2.jpg" \
-loop 1 -t 3 -i "3.jpg" \
-loop 1 -t 3 -i "4.JPG" \
-filter_complex "
[1:v]scale=1200:-1:force_original_aspect_ratio=decrease,format=rgba[logo];
[0:v][logo]overlay=(W-w)/2:(H-h)/2,format=yuv420p,setsar=1,fps=${FPS}[v0];

[2:v]drawtext=fontfile=${FONT}:text='Wir wünschen euch frohe Festtage\nund einen guten Rutsch in ein\ngesundes und erfolgreiches 2026':x=(w-text_w)/2:y=(h-text_h)/2:fontsize=54:fontcolor=white:line_spacing=10,format=yuv420p,setsar=1,fps=${FPS}[v1];

[3:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},format=yuv420p,setsar=1,
drawtext=fontfile=${FONT}:text='2026':x=(w-text_w)/2:y=h*0.85:fontsize=64:fontcolor=white,fps=${FPS}[v2];

[4:v]drawtext=fontfile=${FONT}:text='Danke für das entgegengebrachte Vertrauen':x=(w-text_w)/2:y=(h-text_h)/2:fontsize=58:fontcolor=white,format=yuv420p,setsar=1,fps=${FPS}[v3];

[5:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},format=yuv420p,setsar=1,fps=${FPS}[p1];
[6:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},format=yuv420p,setsar=1,fps=${FPS}[p2];
[7:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},format=yuv420p,setsar=1,fps=${FPS}[p3];
[8:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},format=yuv420p,setsar=1,fps=${FPS}[p4];

[v0][v1][v2][v3][p1][p2][p3][p4]concat=n=8:v=1:a=0,format=yuv420p,setsar=1[v]
" \
-map "[v]" \
-r ${FPS} \
-c:v libx264 -pix_fmt yuv420p \
-movflags +faststart \
bgp_weihnachten_linkedin_2025.mp4
