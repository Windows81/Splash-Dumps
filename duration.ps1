ls dump -filter "*_01_*" -name|%{echo((ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "dump/$_").PadLeft(9,'0')+" "+$_)}|sort