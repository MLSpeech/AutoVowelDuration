# auotovot predict VOTs by selecting a Sound object and a TextGrid object. 
# Then specify a tier in the TextGrid with intervals of the arround the stop consonants.
# 
# Written by Joseph Keshet (17 July 2014)
# joseph.keshet@biu.ac.il
#
# This script is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/>.

clearinfo

writeInfoLine: "AutoVowelDuration ver. 0.01"

# check OS X version
tmp_filename$ = temporaryDirectory$  + "/tmp.txt"
cmd_line$ = "uname -r > " + tmp_filename$
system 'cmd_line$'
os_version = readFile(tmp_filename$)
if os_version < 12.0
	appendInfoLine: "os_version=", os_version, " < 12.0"
	exitScript: "AutoVOT can run on OS X 10.8 or later."
endif

# save files to a temporary directory
if numberOfSelected ("Sound") <> 1
    exitScript: Please select a Sound object first.
endif

# keep the selected object safe
sound = selected ("Sound")

# get number of channels
selectObject: sound
nummebr_of_channels = Get number of channels

selectObject: sound
sound_name$ = selected$( "Sound")
sound_filename$ = temporaryDirectory$ + "/" + sound_name$ + ".wav"
#appendInfoLine: "Saving ", name$, " as ", sound_filename$
current_rate = Get sample rate
if current_rate <> 16000
	appendInfoLine: "Resampling Sound object to 16000 Hz."
	Resample... 16000 50
	Save as WAV file: sound_filename$
	Remove
else
	Save as WAV file: sound_filename$
endif

textgrid_filename$ = temporaryDirectory$  + "/" + sound_name$ + ".TextGrid"
csv_filename$ = temporaryDirectory$ + "/" + sound_name$ + ".csv"

# call prediction
log_filename$ = temporaryDirectory$  + "/cmd_line.log"
cmd_line$ = "cd " + preferencesDirectory$ + "/plugin_autovowelduration; python predict.py " 
cmd_line$ = cmd_line$ + sound_filename$ + " " + textgrid_filename$ 
cmd_line$ = cmd_line$ + " > " + log_filename$ + " 2>&1"
appendInfoLine: "Executing in the shell the following command:"
appendInfoLine: cmd_line$
system 'cmd_line$'
appendInfoLine: "Output:"
log_text$ = readFile$ (log_filename$)
appendInfoLine: log_text$
appendInfoLine: "Done."
appendInfoLine: " "
appendInfoLine: " send comments to keshet@biu.ac.il"

# read new TextGrid
Read from file... 'textgrid_filename$'
textgrid_obj_name$ = "TextGrid " + sound_name$
selectObject: sound, textgrid_obj_name$

# remove unecessary files
deleteFile: sound_filename$
deleteFile: textgrid_filename$

View & Edit