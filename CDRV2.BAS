1 PRINT " *********************************************************** "
2 PRINT " *                                                         * "
3 PRINT " *  ###  ####  #   # ####  #####  ###  #   # # ##### ##### * "
4 PRINT " * #   # #   #  # #  #   #   #   #   # ##  # #   #   #     * "
5 PRINT " * #     ####    #   ####    #   #   # # # # #   #   ###   * "
6 PRINT " * #   # #   #   #   #       #   #   # #  ## #   #   #     * "
7 PRINT " *  ###  #   #   #   #       #    ###  #   # #   #   ##### * "
8 PRINT " *                                                         * "
9 PRINT " *********************************************************** "
10 PRINT

REM === READ COMMAND LINE FROM PSP ===
11 LEN = PEEK(&H80)
12 CMM$ = ""
13 FOR I = 1 TO LEN
14   B = PEEK(&H80 + I)
15   CMM$ = CMM$ + CHR$(B)
16 NEXT I

REM === PARSE COMMAND LINE ===
17 T = 1: MD$ = "": NME$ = "": PWD$ = "": PWD = 0
18 T$ = MID$(CMM$, T, 1)
19 WHILE T$ = " ": T = T + 1: T$ = MID$(CMM$, T, 1): WEND
20 WHILE T$ <> " " AND T <= LEN
21   MD$ = MD$ + T$: T = T + 1: IF T <= LEN THEN T$ = MID$(CMM$, T, 1)
22 WEND
23 WHILE T$ = " ": T = T + 1: T$ = MID$(CMM$, T, 1): WEND
24 WHILE T$ <> " " AND T <= LEN
25   NME$ = NME$ + T$: T = T + 1: IF T <= LEN THEN T$ = MID$(CMM$, T, 1)
26 WEND
27 WHILE T$ = " ": T = T + 1: T$ = MID$(CMM$, T, 1): WEND
28 WHILE T <= LEN
29   PWD$ = PWD$ + T$: PWD = PWD + ASC(T$)
30   T = T + 1: IF T <= LEN THEN T$ = MID$(CMM$, T, 1)
31 WEND

PRINT : PRINT "-> Coder <-  v2.0    June 27 2021 Mickey L."
PRINT "Mode:     "; MD$
PRINT "Filename: "; NME$
PRINT "Password: "; PWD$
PRINT

IF MD$ = "DECODE" THEN GOTO 1000
IF MD$ = "ENCODE" THEN GOTO 2000
GOTO 9000

REM === DECODE MODE ===
1000 OPEN "O", #1, "COPY.DAT"
1010 OPEN "I", #2, NME$
1020 PRINT : PRINT "DECODING "; NME$
1030 LNE = 0
1040 WHILE NOT EOF(2)
1050   LINE INPUT #2, CDD$
1060   X = LEN(CDD$): UCDD$ = ""
1070   FOR T = 1 TO X
1080     T$ = MID$(CDD$, T, 1)
1090     STRT = ASC(T$)
1100     IF STRT > 126 OR STRT < 32 THEN UCDD = STRT: GOTO 1130
1110     UCDD = STRT - PWD - T
1120     IF UCDD < -250 THEN UCDD = UCDD + 282: GOTO 1120
1121     IF UCDD < -156 THEN UCDD = UCDD + 188: GOTO 1121
1122     IF UCDD < 32 THEN UCDD = UCDD + 94: GOTO 1122
1130     UCDD$ = UCDD$ + CHR$(UCDD)
1140   NEXT T
1150   LNE = LNE + 1
1160   PRINT CHR$(13); "Line:"; LNE;
1170   PRINT #1, UCDD$
1180 WEND
1190 CLOSE #2: KILL NME$: CLOSE #1
1200 NAME "COPY.DAT" AS NME$
1210 PRINT : PRINT "DECODING COMPLETE"
1220 PRINT : PRINT "-> Coder <-"
1230 END

REM === ENCODE MODE ===
2000 OPEN "O", #1, "COPY.DAT"
2010 OPEN "I", #2, NME$
2020 PRINT : PRINT "ENCODING "; NME$
2030 LNE = 0
2040 WHILE NOT EOF(2)
2050   LINE INPUT #2, UCDD$
2060   X = LEN(UCDD$): CDD$ = ""
2070   FOR T = 1 TO X
2080     T$ = MID$(UCDD$, T, 1)
2090     STRT = ASC(T$)
2100     IF STRT > 126 OR STRT < 32 THEN CDD = STRT: GOTO 2130
2110     CDD = STRT + PWD + T
2120     IF CDD > 220 THEN CDD = CDD - 188: GOTO 2120
2121     IF CDD > 126 THEN CDD = CDD - 94: GOTO 2121
2130     CDD$ = CDD$ + CHR$(CDD)
2140   NEXT T
2150   LNE = LNE + 1
2160   PRINT CHR$(13); "Line:"; LNE;
2170   PRINT #1, CDD$
2180 WEND
2190 CLOSE #2: KILL NME$: CLOSE #1
2200 NAME "COPY.DAT" AS NME$
2210 PRINT : PRINT "ENCODING COMPLETE!"
2220 PRINT : PRINT "-> Coder <-"
2230 END

REM === HELP / USAGE ===
9000 PRINT : PRINT "-> Coder <-   v2.0    June 27 2021 Mickey L."
9010 PRINT : PRINT
9020 PRINT "This program will encode or decode an ASCII file."
9030 PRINT : PRINT "Usage:"
9040 PRINT "    CDR ENCODE myfile.txt password"
9050 PRINT "    CDR DECODE myfile.txt password"
9060 END
