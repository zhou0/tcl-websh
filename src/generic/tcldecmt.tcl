proc DoFile { fileName } { 
    global argv0
    # ----------------------------------------------------------------------------
    # try to open file
    # ----------------------------------------------------------------------------
    if {[file exists $fileName] } {
	set fileId [open $fileName "r"]
    } else {
	puts stderr "$argv0 --- cannot open $fileName."
	exit 1
    }

    # ----------------------------------------------------------------------------
    # read line by line to the end of the file
    # ----------------------------------------------------------------------------
    while {[eof $fileId] == 0} {

	gets $fileId tLine
	if { ![regexp "^$" $tLine] } {
	    if { ![regexp {^[^#]*#} $tLine] } {
		regsub -all {\s+} $tLine { } res
		set res [string map {\" \\\" \\ \\\\} $res]
		set tLine $res
		if { [regexp {^\s*(.*)} $tLine dum res] } {
		    puts $res
		} else {
		    puts $tLine
		}
	    }
	}
    }
}

if {$argc > 0 } {
    # prologue
    puts "/* Do not modify! This code is automatically generated by $argv0 */"
    puts "char script_h\[\] = \""
    foreach fileName $argv {
	DoFile $fileName
    }
    puts "\";"
} else {
    puts stderr "$argv0 --- usage: hdb2pab.tcl input.hdb."
    exit 1
}
