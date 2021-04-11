# vsplit "./long movie.mp4" 30  # split movie into 30 second segments
# https://sattlers.org/2019/09/30/ffmpeg-split-and-cut-video-segments/
vsplit() {
	SRC="$1"
	SPAN=$( date -d@${2} -u +%H:%M:%S )
	ffmpeg -i "$SRC" -c:v libx264 -crf 22 -map 0 -segment_time $SPAN -g 9 \
		-sc_threshold 0 -force_key_frames "expr:gte(t,n_forced*9)" \
		-reset_timestamps 1 -f segment "segment_%03d.${SRC##*.}"
}
