#!/usr/bin/wish -f
#
# this is text Hello World, Tk-style

set filename "usrfile.pwd";

proc splitf { str index } {
    set y [ split $str | ];
    list  $y;
    set w [ lindex $y $index ];
    return $w;
}

proc checkinfo {name pwd} {
    global filename;
    set iflag 0;
    set isUser 0;
    
    if { $name eq "" || $pwd eq "" } {
        return 005;
    }

    set fileId [ open $filename r ];   
    while { [ gets $fileId line ] >= 0 } {
        set nameInfile [ splitf $line 0 ];
        set cmp [ string compare $name $nameInfile ];

        if { $cmp != 0 } {
            set isUser [ expr $isUser + 1 ];
        } elseif { $cmp == 0 } {
            set pwdInfile [ splitf $line 1 ];
            set cmp [ string compare $pwd $pwdInfile ];
            if { $cmp == 0 } {
                close $fileId; 
                return 001; #login successful 
            } else {
                close $fileId;
                return 004; #err user pwd
            } 
        }
        set iflag [ expr $iflag + 1 ];
    }
    close $fileId;

    if { $iflag == 0 } {
        return 002; #file is null,creat user;
    }
    if { $iflag == $isUser } {
        return 002; #creat user
    }
}

proc process { uname pwd } {
    global filename;
    set returnCheck [ checkinfo $uname $pwd ];
    switch -- $returnCheck {
        001 { tk_messageBox -type ok -message "you are login successful" }
        002 { set answer [ tk_messageBox -type yesno -icon question \
                 -message "you need creat a user" ] ;
                switch -- $answer {
                    no { }
                    yes { puts stdout [ createusr $uname $pwd ] }
                }
            }
        //003 { tk_messageBox -type ok -icon warning -message "$filename file is null" }  
        004 { tk_messageBox -type ok -icon error -message "input err of user pwd" }
        005 { tk_messageBox -type ok -icon info -message "user and pwd is not null" }
        default { tk_messageBox -type ok -icon error -message "system err" }
    }
}

proc createusr { uname pwd } {
    global filename;
    set fileId [ open $filename a ];
    puts $fileId "$uname|$pwd" ;
    close $fileId;
    return 1; 
}
wm title . LOGIN
wm maxsize . 500 300
wm minsize . 500 300
wm resizable . 500 300
wm geometry . 500x300+300+200

label .ulname -text "userName"

entry .tuname -textvariable name 

label .ulpwd -text "userPwd"

entry .tupwd -textvariable pwd
 
button .bOK -text OK \
  -command { puts stdout [ process $name $pwd] }

button .bExit -text Exit \
  -command {exit}
 

place .ulname -x 110 -y 50 
place .tuname -x 200 -y 50 
place .ulpwd -x 110 -y 100 
place .tupwd -x 200 -y 100 

place .bOK -x 150 -y 150  
place .bExit -x 280 -y 150

