10REM Androidz - Instructions
20REM By Stephen Scott
30REM August 1993 - August 2021
40*FX229,1
50MODE7:VDU23,1,0;0;0;0;
60*L. DRSCRN
70PRINTTAB(2,20)"(c) 1993,2020-21 (Redux)"
80PROCtunedata
90PROCassem
100TIME=0:REPEATUNTILTIME=300
110CLS:PROCchoose:PROCenv:PROCchars
120CLS:PRINT'"Hang in there, while I get ready..."
130CHAIN"DROID1"
140END
150DEFPROCchoose
160PRINTTAB(10,0)CHR$141CHR$133"ANDROIDZ (REDUX)"'TAB(10,1)CHR$141CHR$129"ANDROIDZ (REDUX)"
170PRINTTAB(11,2)CHR$131"By Stephen Scott"'" Additional level and sprite designs by"'CHR$134"Graeme Scott, Ian Long"CHR$135"and"CHR$134"Lee Wilson"
180PRINTSPC6"Sound effects from games by"'SPC5CHR$134"Mike Goldberg"CHR$135"and"CHR$134"Jon Perry"
190PRINT'SPC4"Thanks to 0xCODE and the Stardot"'SPC8"community for your help!"
200PROCappear(6,11,"Please select an option:",131)
210PRINT''SPC5"1. Quick instructions"
220PRINT''SPC5"2. Longer instructions"
230PRINT''SPC5"3. Play the game"
240PRINT''SPC5CHR$132"T:@sassquad"CHR$134"W:sassquad.net"
250REPEAT:A=GET:UNTILA>48AND A<52
260IFA=49:PROCsimple:ENDPROC
270IFA=50:PROCnovel:ENDPROC
280IFA=51:ENDPROC
290ENDPROC
300DEFPROCappear(x,y,m$,c)
310PRINTTAB(x-1,y)CHR$(c)
320FOR a=1 TO LEN(m$)
330b%=ASCMID$(m$,a,1)
340y2=22
350REPEAT
360VDU31,x,y2,b%,31,x,y2+1,32
370y2=y2-1
380UNTIL y2=y-1
390VDU31,x,y,b%
400x=x+1
410NEXT
420ENDPROC
430DEFPROCsimple
440CLS
450PRINT'CHR$134"Simple Instructions:"
460PRINT'" It is the year 2050. You are a member   of the police's"CHR$131"Robot Apprehension"'CHR$131"Unit (R.A.U.)."
470PRINT'CHR$135"A power surge has hit 20 factories,     whose robots have gone berserk. You     must destroy them with your laser gun."
480PRINT'" Beware! The robots can shoot back at    you! Later factories may be more        difficult to make safe."CHR$133"Good luck!"
490PRINT'" Keys:"
500PRINT'"  "CHR$130"Z"CHR$135"- Left    "CHR$130"S"CHR$135"- Sound ON"
510PRINT "  "CHR$130"X"CHR$135"- Right   "CHR$130"Q"CHR$135"- Sound OFF"
520PRINT "  "CHR$130"F"CHR$135"- Up      "CHR$130"P"CHR$135"- Pause"
530PRINT "  "CHR$130"C"CHR$135"- Down    "CHR$130"S"CHR$135"- Unpause"
540PRINT "  "CHR$130"G"CHR$135"- Fire"
550PRINT'CHR$136"Press SPACEBAR to play the game."
560REPEATUNTILGET=32
570ENDPROC
580DEFPROCnovel:CLS:PRINT'CHR$134"Long winded instructions:":PRINTTAB(10)"Press any key to scroll"
590VDU28,0,23,39,3
600PRINT''" It is the year 2050. Robots now         manufacture most of humanity's          commodities. Robots make use of neural  networks controlled by a mainframe"
610PRINT " computers. Technicians, however,        constantly monitor the manufacturing    process, dealing with routine problems  whenever they occur."
620PRINT''" However, for problems beyond their      remit, law enforcement's newly formed  "CHR$131"Robot Apprehension Unit (R.A.U.)"CHR$135"- is   called upon to deal with such"
630PRINT " incidents.":A=GET
640PRINT''" You have been newly recruited into the  R.A.U. There are very few officers,     and only the best candidates can join.  It's tough and dangerous work, but the  salary is extremely lucrative."
650PRINT''" While the department expands, new       recruits take time to get trained up.   The job is therefore very demanding,    and in recent weeks, a growing spate    of incidents has resulted in more"
660PRINT " staff falling ill from stress. It       falls to you to respond to incidents    as they are called in."
670A=GET
680PRINT''" The dreaded call comes in. A massive    power surge has knocked out the neural  networks of twenty nearby factories,    and the robots have run amok, killing   the maintainance crews with the laser"
690PRINT " welding instruments attached to them."'''" With nobody left to shut them down,     they would run on auxiliary power for   weeks even if the mainframe was taken   offline."
700A=GET:PRINT''" The only option is for the robots to    be destroyed. You must now rise to      the challenge. Lives are at stake,      and the reputation of the R.A.U.        rests on your shoulders."
710PRINT''" Failure is not an option."CHR$133"Good luck!"
720A=GET
730PRINT''" Use the"CHR$130"Z,X,F"CHR$135"and"CHR$130"C"CHR$135"keys to move about  each factory, destroying the robots     with your single firing laser gun,      activated by pressing"CHR$130"G."
740PRINT''" The robots can of course fire at you,   but they are also heat sensitive and    will home in on your position if you    linger around in one place for too      long."
750PRINT''" You must use the natural cover of the   factory walls and machinery to help     evade them, although some factories     are more spacious than others. Later"
760PRINT" factories may have machines that are    more difficult to destroy."
770A=GET:PRINT''" If you fail, then your tally is         assessed by the Chief Superintendent    and his report will appear on screen."
780PRINT''" Just think - if you complete the task   you will get your name trending on      social media, because what else is life for these days?!"
790PRINT''CHR$130"S"CHR$135"and"CHR$130"Q"CHR$135"toggle the sound output, while "CHR$130"P"CHR$135"and"CHR$130"U"CHR$135"pause and unpause the game."
800PRINT''CHR$136"Press SPACEBAR to play the game."
810REPEATUNTILGET=32:VDU26
820ENDPROC
830DEFPROCenv
840REM Plonk sound
850ENVELOPE1,1,5,50,5,4,4,4,126,-1,-1,-4,120,120
860REM Ricochet
870ENVELOPE2,1,1,-2,1,5,18,8,126,-1,-1,-8,120,90
880REM Destroy
890ENVELOPE3,1,-1,0,-5,0,0,0,50,-13,0,-2,108,74
900REM End
910ENVELOPE4,1,0,0,0,0,0,0,126,-1,0,-2,126,80
920ENVELOPE5,1,0,0,0,0,0,0,5,-1,0,-2,100,80
930ENVELOPE6,1,0,0,0,0,0,0,5,-1,0,-2,85,70
940REM Laser fire
950ENVELOPE7,129,-4,-3,0,20,10,20,127,-1,-1,-3,120,90
960REM Death
970ENVELOPE8,4,-4,-1,-1,20,20,20,1,0,0,0,1,1
980REM Bell
990ENVELOPE9,3,0,0,0,0,0,0,121,-10,-1,-2,120,120
1000ENDPROC
1010DEFPROCchars
1020VDU23,224,60,90,126,102,24,60,126,189,23,225,189,153,36,36,66,67,64,192,23,226,189,153,36,36,66,194,2,3,23,227,60,126,126,126,24,60,126,189
1030VDU23,228,24,44,60,28,8,24,20,20,23,229,28,28,24,8,8,8,8,24,23,230,24,44,60,28,8,24,20,12,23,231,12,28,24,52,34,35,97,33
1040VDU23,232,24,52,60,56,16,24,40,40,23,233,48,56,24,16,16,16,16,24,23,234,24,52,60,56,16,24,40,48
1050VDU23,235,48,60,24,44,68,196,134,132,23,236,189,153,36,36,66,66,66,195,23,237,0,0,24,24,24,24,0,0,23,238,0,0,0,60,60,0,0,0
1060VDU23,254,129,129,64,36,8,24,36,1,23,255,144,24,16,4,66,129,129,0
1070ENDPROC
1080DEFPROCtunedata
1090RESTORE1160:J%=&750:FORl%=0TO34*3+21*3-1:READJ%?l%:NEXT
1100ENDPROC
1110DEFPROCassem
1120P%=&100:[OPT2:LDA#17:JSR&FFEE:LDA&70:JSR&FFEE:LDA#240:JSR&FFEE:LDA#10:JSR&FFEE:LDA#8:JSR&FFEE:LDA#17:JSR&FFEE:LDA&71:JSR&FFEE:LDA#241:JSR&FFEE:RTS:]
1130P%=&130:[OPT2:LDA#135:JSR&FFF4:TXA:CLC:ADC#96:STA&72:RTS:]
1140ENDPROC
1150REM Tune data
1160DATA9,137,8,0,0,7,9,117,11,0,0,5,9,105,10,0,0,4,9,89,10,0,0,4,9,129,10,0,0,5,9,109,8,0,0,7,9,97,7,0,0,6,9,81,10,0,0,6,9,125,8,0,0,6,9,105,7,0,0,6
1170DATA9,93,7,0,0,5,9,77,8,0,0,7,9,117,8,0,0,7,9,97,7,0,0,6,9,85,9,0,0,5,9,69,10,0,0,6,9,77,11,0,0,76
1180DATA9,61,13,0,0,36,9,61,10,0,0,26,9,61,10,0,0,11,9,61,11,0,0,43,9,73,11,0,0,29,9,69,10,0,0,12,9,69,11,0,0,29,9,61,11,0,0,11,9,61,11,0,0,27,9,57,11,0,0,11,9,61,11
