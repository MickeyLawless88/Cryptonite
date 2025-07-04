1 PRINT " *********************************************************** "
2 PRINT " *                                                         * "
3 PRINT " *  ###  ####  #   # ####  #####  ###  #   # # ##### ##### * "
4 PRINT " * #   # #   #  # #  #   #   #   #   # ##  # #   #   #     * "
5 PRINT " * #     ####    #   ####    #   #   # # # # #   #   ###   * "
6 PRINT " * #   # #   #   #   #       #   #   # #  ## #   #   #     * "
7 PRINT " *  ###  #   #   #   #       #    ###  #   # #   #   ##### * "
8 PRINT " *                                                         * "
9 PRINT " *********************************************************** "
12 GOTO 69
13 OPEN "O",#1,"COPY.DAT"       ' DECODE LOOP
14 OPEN "I",#2,NME$
15 PRINT:PRINT "DECODING";NME$  ' DECODE STRING
16 PRINT:PRINT
17 WHILE NOT EOF(2)
18 LINE INPUT #2,CDD$
19 X=LEN(CDD$)
20 FOR T=1 TO X
21 T$=MID$(CDD$,T,1)
22 STRT=ASC(T$)
23 IF ASC(T$)>126 OR ASC(T$)<32 THEN UCDD=ASC(T$):GOTO 28
24 UCDD=STRT-PWD-T
25 IF UCDD<-250 THEN UCDD=UCDD+282:GOTO 27
26 IF UCDD<-156 THEN UCDD=UCDD+188
27 IF UCDD<32 THEN UCDD=UCDD+94:GOTO 27
28 UCDD$=UCDD$+CHR$(UCDD)
29 NEXT T
30 LNE=LNE+1
31 PRINT CHR$(13);"Line:";LNE;
32 PRINT #1,UCDD$
33 UCDD$=""
34 WEND
35 CLOSE #2
36 KILL NME$
37 CLOSE #1
38 NAME "COPY.DAT" AS NME$
39 PRINT:PRINT "DECODING COMPLETE"
40 PRINT:PRINT "-> Coder <-":END
41 OPEN "O",#1,"COPY.DAT"               'ENCODE LOOP
42 OPEN "I",#2,NME$
43 PRINT:PRINT "Encoding ";NME$
44 PRINT : PRINT
45 WHILE NOT EOF(2)
46 LINE INPUT #2,UCDD$
47 X=LEN(UCDD$)
48 FOR T=1 TO X
49 T$=MID$(UCDD$,T,1)
50 STRT=ASC(T$)
51 IF ASC(T$)>126 OR ASC(T$)<32 THEN CDD=ASC(T$):GOTO 55
52 CDD=STRT+PWD+T
53 IF CDD>220 THEN CDD=CDD-188:GOTO 53
54 IF CDD>126 THEN CDD=CDD-94:GOTO 54
55 CDD$=CDD$+CHR$(CDD)
56 NEXT T
57 LNE=LNE+1
58 PRINT CHR$(13);"Line:";LNE;
59 PRINT #1,CDD$
60 CDD$=""
61 WEND
62 CLOSE #2
63 KILL NME$
64 CLOSE #1
65 NAME "COPY.DAT" AS NME$
66 PRINT:PRINT "Encoding Complete!"
67 PRINT:PRINT "-> Coder <-"
68 END
69 PRINT
70 A=&H7F
71 A=A+&H1
72 B=PEEK(A)
73 IF B THEN A=A+&H1:GOTO 75
74 GOTO 103     ' NO COMMAND LINE PRESENT
75 A=A+&H1
76 B=PEEK(A)
77 IF B THEN CMM$=CMM$+CHR$(B):GOTO 75
78 GOTO 79      ' THE COMMAND LINE IS IN CMM$
79 T=T+1
80 T$=MID$(CMM$,T,1)
81 IF T$ <> " " THEN MD$=MD$+T$:GOTO 79
82 IF MD$ <> "DECODE" AND MD$<> "ENCODE" THEN 103
83 T=T+1
84 T$=MID$(CMM$,T,1) 
85 IF T$ <> " " THEN NME$=NME$+T$:GOTO 83
86 T=T+1
87 T$=MID$(CMM$,T,1)
88 IF T$ <> "" THEN PWD$=PWD$+T$:PWD=PWD+ASC(T$):GOTO 86
89 PRINT : PRINT "-> Coder <-  v2.0    June 27 2021 Mickey L."
90 PRINT
91 PRINT "Mode:       ";MD$
92 PRINT "Filename:   ";NME$
93 PRINT "Password:   ";PWD$
94 PRINT
95 PRINT "Is this correct? (Y/N)? ";
96 A$=""
97 A$=INKEY$:IF A$="" THEN 97
98 IF A$="Y" OR A$="y" THEN PRINT "Yes":GOTO 101
99 IF A$="N" OR A$="n" THEN PRINT "No":END
100 GOTO 97
101 IF MD$="DECODE" GOTO 13
102 IF MD$="ENCODE" GOTO 41
103 PRINT:PRINT "-> Coder <-   v2.0	June 27 2021 Mickey L."
104 PRINT
105 PRINT
106 PRINT "This program will encode, and then decode an ASCII file"
107 PRINT
108 PRINT "Usage: CDR mode filename.ext password"
109 PRINT
110 PRINT "Example: CDR DECODE MYFILE.TXT MYPASSWORD"
111 PRINT "         CDR ENCODE MYFILE.TXT MYPASSWORD"
112 END
 
