10REM Androidz - Verdict Report
20REM By Stephen Scott
30REM August 1993 - November 2021
50:
60sc=VAL($&900)
70PROCverdict
80PAGE=&1100:CHAIN"DROID2"
90END
100:
110DEFPROCverdict
111FORI=0TO1:PRINTTAB(0,I)CHR$141"Incident Report";:NEXT
112PRINTTAB(24)CHR$140CHR$135"4th June, 2050";:PRINTCHR$145STRING$(39,CHR$172)
113PRINT " Your tally:";CHR$136;sc;"%"
114PRINT'" FURTHER COMMENTS";CHR$145STRING$(22,CHR$172);
120IF sc<11 m$=" Abysmal performance! You're out of the  force!"
130IF sc>10 AND sc<31 m$=" For a member of the elite R.A.U., you   did a really poor job. An utter         shambles. You have been demoted to the  rank of constable."
140IF sc>30 AND sc<51 m$=" Not a bad performance for a newcomer to the R.A.U. But you had the potential to finish the job. I hope you do better    next time!"
150IF sc>50 AND sc<71 m$=" You've managed the average number of    kills for an experienced officer, and   we hope you improve to a true marksman  on your next assignment."
160IF sc>70 AND sc<91 m$=" Well! For a beginner you did a very     good performance, particularly on those last few levels. You are getting better all the time."
170IF sc>90 AND sc<100m$=" A magnificent job. You very nearly did  all the factories. You are a true       member of the R.A.U."
180IF sc>99 m$=" Congratulations! I was astounded by the job you did today. You have earned the  respect of the entire force, and will   be duly recommended for promotion."
190PRINT
200FOR a=1 TO LEN(m$)
210PRINT;MID$(m$,a,1);:TIME=0:REPEATUNTILTIME=5
220NEXT
230PRINTTAB(0,19)CHR$145STRING$(39,CHR$172);TAB(14,20)"Chief Superintendent Scott";:PRINTCHR$145STRING$(39,CHR$172)
240PRINTTAB(0,22)CHR$136"Press SPACEBAR to play again.";
250REPEATUNTILGET=32
260ENDPROC
