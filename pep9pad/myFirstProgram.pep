;File: myFirstProgram.pep
;Sends "Hello, world!" to the output device
;
STRO    msg,d
STOP
msg:     .ASCII  "Hello, world!\n\x00"
.END
