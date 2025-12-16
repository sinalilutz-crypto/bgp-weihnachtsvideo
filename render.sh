#!/usr/bin/env bash
set -e

W=1920
H=1080
FPS=30
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

INTRO_D=6
TEXT_D=6
GRUPPE_D=6
DANKE_D=6
TEAM_START=24
TOTAL=36

ffmpeg \
-f lavfi -i color=c=#F6EB14:s=${W}x${H}:d=${TOTAL} \
-loop 1 -i "bgp logo gelb.png" \
-loop 1 -i "gruppe.jpg" \
-loop 1 -i "1.JPG" \
-loop 1 -i "2.jpg" \
-loop 1 -i "3.jpg" \
-loop 1 -i "4.JPG" \
-filter_complex "
[1:v]scale=iw*0.7:ih*0.7,format=rgba,zoompan=z='1.0+0.0007*n':d=$((${INTRO_D}*${FPS})):s=${W}x${H}[logo];

[0:v][logo]overlay=(W-w)/2:(H-h)/2:enable='between(t,0,${INTRO_D})'[s1];

[s1]drawtext=fontfile=${FONT}:text='Wir wünschen euch frohe Festtage\nund einen guten Rutsch in ein\ngesundes und erfolgreiches 2026':
x=(w-text_w)/2:y=(h-text_h)/2:
fontsize=54:fontcolor=white:line_spacing=10:
enable='between(t,${INTRO_D},$((${INTRO_D}+${TEXT_D})) )'[s2];

[s3]drawtext=fontfile=${FONT}:text='Danke für das entgegengebrachte Vertrauen':
x=(w-text_w)/2:y=(h-text_h)/2:
fontsize=58:fontcolor=white:
enable='between(t,$((${INTRO_D}+${TEXT_D}+${GRUPPE_D})),$((${INTRO_D}+${TEXT_D}+${GRUPPE_D}+${DANKE_D})) )'[s4];

[3:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},zoompan=z='1.0+0.0006*n':d=$((6*${FPS})):s=${W}x${H}[t1];
[4:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},zoompan=z='1.0+0.0006*n':d=$((6*${FPS})):s=${W}x${H}[t2];
[5:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},zoompan=z='1.0+0.0006*n':d=$((6*${FPS})):s=${W}x${H}[t3];
[6:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},zoompan=z='1.0+0.0006*n':d=$((6*${FPS})):s=${W}x${H}[t4];

[t1][t2]xfade=transition=fade:duration=1:offset=${TEAM_START}[x1];
[x1][t3]xfade=transition=fade:duration=1:offset=$((${TEAM_START}+4))[x2];
[x2][t4]xfade=transition=fade:duration=1:offset=$((${TEAM_START}+8))[x3];

[x3]eq=contrast=1.02:brightness=0.01:saturation=1.05,
colorbalance=rs=0.015:gs=0.005:bs=-0.010,
fade=t=in:st=0:d=0.8,
fade=t=out:st=$((${TOTAL}-1)):d=1
[v]
" \
-map "[v]" \
-t ${TOTAL} \
-c:v libx264 -pix_fmt yuv420p -r ${FPS} \
-movflags +faststart \
bgp_weihnachten_linkedin_2025.mp4
