if praatVersion < 5380
	writeInfoLine: "In order to use DeepWDM you need to download and install a more"
	appendInfoLine: "recent version of Praat (5.3.80 or later)."
else
	Add action command: "Sound", 1, "", 0, "", 0, "AutoVowelDuration", "", 0, "AutoVowelDuration.praat"
endif
