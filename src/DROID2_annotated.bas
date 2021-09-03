REM Androidz Redux (DROID2)
REM By Stephen Scott 1993, 2021
REM Annotated version
*FX3
IFPAGE<>&E00:PROCrelocate
R%=&100
H%=&130
PROCinit
MODE2
VDU23,1,0;0;0;0;
REM The high point of the game code mustnt 
REM go beyond this memory location, otherwise 
REM game data is overwritten.
HIMEM=&2763
REM Disable the Escape key
*FX229,1
REM Change the delay of the flashing colours
REM 9 and 10 in the MODE 2 palette
*FX9,4
*FX10,4
REM === Main loop ===
REPEAT
    PROCsetup
    PROCbox
    PROCbuild_characters
    PROCbuild_level
    PROCplace_robots
    PROCplace_player
    REPEAT
        PROCdisplay_score
        PROCkeys
        PROCmove_robots
        IF DE% PROCdead:IF LI%>0 DE%=0:PROCclean:PROCplace_player
        IF fire:PROCmove_bullet
        IF rfire:PROCmove_robot_bullet
        IFRND(V%)=3:PROCstart_robot_bullet
    UNTIL MN%=0 OR LI%<1
    IF MN%=0 PROCdone:PROCd(10)
UNTIL LI%<1 OR LE%>20:REM loop ends when you lose all lives, or complete game
PROCd(100)
IF LI%<1 PROCgame_over
IF LE%>20 PROCwin
*FX15
REM convert score to string, and store in memory location &900
$&900=STR$(sc)
MODE7
HIMEM=&2763
PAGE=&1900
OSCLI"DISC"
CHAIN"DROID3"
END
REM === Main initialisation (pre-game) ===
DEFPROCinit
Q=RND(-TIME)        :REM randomise the random number generator (this improves randomness)
DIM RX%9,RY%9       :REM robot position array
sc=0                :REM score
LI%=5               :REM Lives/tally counter
DE%=0               :REM Have I been hit? flag
LE%=1               :REM Level number
V%=10
ENDPROC
REM === Initialisation of game level ===
DEFPROCsetup
MN%=10              :REM number of robots
RD%=0               :REM direction of travel of robot
F%=0                :REM Have I fired my gun? flag
DE%=0               :REM Have I been hit? flag
FD%=1               :REM which direction is my bullet going?
FX%=0               :REM Bullet x coordinate
FY%=0               :REM Bullet y coordinate
fire=0              :REM Have I fired?
rfire=0             :REM Has a robot fired?
M%=0                :REM hmm
ENDPROC
REM === Detect keypresses and take appropriate action ===
DEFPROCkeys
IF INKEY-84:IFfire=0:PROCstart_bullet
IF INKEY-68 PROCmv(-1)
IF INKEY-83 PROCmv(1)
IF INKEY-67 PROCmh(1)
IF INKEY-98 PROCmh(-1)
IF INKEY-56 VDU31,7,27,17,7:PRINT"Paused":REPEATUNTILINKEY-54:VDU31,7,27:PRINTSPC6
IF INKEY-17 VDU31,5,28,17,7:PRINT"Quiet Mode":*FX210,1
IF INKEY-82 VDU31,5,28,17,7:PRINTSPC10:*FX210,0
ENDPROC
REM === Move player horizontally left or right depending on value of h% ===
DEFPROCmh(h%)
D%=2                :REM assume player is moving right
IF h%=-1:D%=4       :REM if h%=-1 though, player is moving left
PROCP(0)            :REM Erase player sprite at current x,y coordinate
PROCF
VDU 31,X%+h%,Y%     :REM we need to check whether player can move in that direction
CALL H%:IF ?&72=128:VDU10:REM if there is a space in that direction, we can update the x coordinate
CALL H%:IF ?&72=128:X%=X%+h%
PROCP(7)            :REM Print the player
ENDPROC
REM === Move player vertically up or down depending on value of v% ===
DEFPROCmv(v%)
D%=3                :REM assume player is moving down
IF v%=-1:D%=1       :REM if v%=-1 though, player is moving up
PROCP(0)            :REM Erase player sprite at current x,y coordinate
PROCF
IF v%=1:VDU31,X%Y%+2:ELSEVDU31,X%,Y%+v%
CALL H%:IF ?&72=128:Y%=Y%+v%
PROCP(7)
ENDPROC
REM === Wait for t% milliseconds ===
DEFPROCd(t%)
t%=TIME+t%:REPEAT UNTIL TIME>t%
ENDPROC
REM === Print or delete player character, based on value of c% ===
DEFPROCP(c%)
J%=0                :REM reset local variables to determine which character numbers we need
K%=0
IFD%=0 J%=224:K%=236                :REM D% of 0 means standing still
IFD%=1 J%=227:K%=225+F%             :REM player moving up
IFD%=2 J%=232+(F%*2):K%=233+(F%*2)  :REM player moving right
IFD%=3 J%=224:K%=225+F%             :REM player moving down
IFD%=4 J%=228+(F%*2):K%=229+(F%*2)  :REM player moving left
VDU17,c%,31,X%Y%J%,10,8,K%          :REM display relevant character numbers within J% and K% at x,y coordinates
ENDPROC
REM === Determine frame number of player character (each direction has 2 frames of animation) ===
DEFPROCF
IF F%=0 F%=1:ELSE F%=0
ENDPROC
REM === set up player bullet next to player position ===
DEFPROCstart_bullet
fire=-1             :REM set fired flag to TRUE
SOUND3,7,170,1
FX%=X%              :REM set bullet coordinates to same position as player
FY%=Y%
IF D%=0 ENDPROC
FD%=D%              :REM set bullet direction to same as player direction
IF FD%=1:FY%=FY%-1
IF FD%=2:FX%=FX%+1
IF FD%=3:FY%=FY%+2
IF FD%=4:FX%=FX%-1
ch%=FNchk(FX%,FY%)  :REM check position bullet is about to move to
IF ch%>241:fire=0:SOUND0,2,22,1:ENDPROC:REM hit a wall, so make a ricochet sound and set fire flag to FALSE
IF ch%=240 OR ch%=241:PROCkill:ENDPROC:REM bullet has hit a robot, so jump to PROCkill
ENDPROC
REM === move bullet, check for wall or robot before printing bullet in chosen direction ===
DEFPROCmove_bullet
VDU31,FX%FY%,32
PROCP(7)            :REM we have to reprint the player, due to old bullet position matching that of player.
IF FD%=1:FY%=FY%-1
IF FD%=2:FX%=FX%+1
IF FD%=3:FY%=FY%+1
IF FD%=4:FX%=FX%-1
ch%=FNchk(FX%,FY%)
IF ch%>241:fire=0:SOUND0,2,22,1:ENDPROC
IF ch%=240 OR ch%=241:PROCkill:ENDPROC
VDU17,12,31,FX%FY%  :REM print bullet at updated coordinates
IF FD%=1 OR FD%=3:VDU237:ELSE VDU238
ENDPROC
REM === print robots in random positions within level ===
DEFPROCplace_robots
FOR z%=0 TO 9       :REM Loop 10 times, according to number of robots
    RX%?z%=0            :REM set dead flag to 0
    RY%?z%=0
    REPEAT              :REM loop to pick a random coordinate for the robot that matches a space
        rx=FNrndx
        ry=FNrndy
    UNTIL FNchk(rx,ry)=128: REM we've found an empty space
    RX%?z%=rx
    RY%?z%=ry
    ?&70=C%:REM colour of top half of robot
    ?&71=G%:REM colour of bottom half of robot
    VDU 31,RX%?z%,RY%?z%:
    CALL R%: REM print robot
    SOUND 1,1,(100+z%*5),5
    PROCd(25)
NEXT
ENDPROC
REM === read ASCII character at x,y coordinate ===
DEFFNchk(x%,y%)
VDU31,x%,y%
CALL H%
=?&72
REM === pick random number between 1 and 18 ===
DEFFNrndx
=RND(17)+1
REM === pick random number between 1 and 11, then multiply by 2 ===
DEFFNrndy
=RND(11)*2
DEFPROCclean
chk%=FNchk(X%,Y%)
VDU31,X%Y%
IF chk%=240 OR chk%=241:VDU 17,3,240,10,8,241 ELSE VDU32,10,8,32
ENDPROC
REM === pick a random position for the player ===
DEFPROCplace_player
PROCd(15)
D%=3
FD%=D%
REPEAT
    X%=FNrndx
    Y%=FNrndy
UNTIL FNchk(X%,Y%)=128
FOR i%=1 TO 6
    SOUND 1,-10,120,2
    PROCP(7)
    PROCd(15)
    PROCP(0)
    PROCd(15)
NEXT
PROCP(7)
ENDPROC
REM === move robot M% of 10 ===
DEFPROCmove_robots
M%=M%+1:IF M%=10 M%=0
IF RX%?M%=99 ENDPROC:REM if robot M%'s x coordinate is 99, the robot is non existent, so exit
PROCR(0)
IF X%>RX%?M% PROCrmh(1)
IF X%<RX%?M% PROCrmh(-1)
IF Y%>RY%?M% PROCrmv(1)
IF Y%<RY%?M% PROCrmv(-1)
PROCR(1)
IF FNchk(FX%,FY%)=240 OR FNchk(FX%,FY%)=241 PROCkill:REM check bullet position - if it matches a robot kill it
ENDPROC
REM === move robot horizontally, if there is a space adjacent in chosen direction ===
DEFPROCrmh(h%)
IF FNchk(RX%?M%+h%,RY%?M%)=128:VDU10:CALL H%:IF ?&72=128:RX%?M%=RX%?M%+h%
RD%=4:IF h%=1:RD%=2
ENDPROC
REM === move robot vertically, if there is a space adjacent in chosen direction ===
DEFPROCrmv(v%)
vp%=v%
IF v%=1:vp%=2
IF FNchk(RX%?M%,RY%?M%+vp%)=128:RY%?M%=RY%?M%+v%
RD%=1
IF v%=1:RD%=3
ENDPROC
REM === print (or erase, if c%=0) robot ===
DEFPROCR(c%)
?&70=0
?&71=0
IF c%=1:?&70=C%:?&71=G%
VDU 31,RX%?M%,RY%?M%
CALL R%
ENDPROC
REM === check bullet coordinate against every robot coordinate, and destroy matching robot ===
DEFPROCkill
FOR k%=0 TO 9
    IF FX%=RX%?k%:IF FY%=RY%?k% OR FY%=RY%?k%+1:MN%=MN%-1:SOUND 0,3,54,1:sc=sc+0.5:PROCdisplay_score:fire=0:VDU17,8,31,RX%?k%,RY%?k%,254,10,8,17,15,255:FORY=0TO169:NEXT:VDU31,RX%?k%,RY%?k%,32,10,8,32:FX%=0:FY%=0:RX%?k%=99:RY%?k%=99:k%=100
NEXT
ENDPROC
REM === set up robot bullet next to chosen robot ===
DEFPROCstart_robot_bullet
IF RD%=0 OR RX%?M%=99 OR rfire:ENDPROC
rfire=-1
SOUND3,7,220,1
RFD%=RD%
RFX%=RX%?M%
RFY%=RY%?M%
IF RFD%=1RFY%=RFY%-1
IF RFD%=2RFX%=RFX%+1
IF RFD%=3RFY%=RFY%+2
IF RFD%=4RFX%=RFX%-1
IF RFX%=X% AND RFY%=Y%:DE%=-1:ENDPROC
ch%=FNchk(RFX%,RFY%)
IF ch%>241rfire=0:SOUND0,2,22,1:ENDPROC
IF ch%=240 OR ch%=241rfire=0:?&70=C%:VDU31,RFX%RFY%:CALL R%:SOUND0,2,22,1:ENDPROC
ENDPROC
REM === move robot bullet, check for wall before printing robot bullet in chosen direction ===
DEFPROCmove_robot_bullet
VDU31,RFX%RFY%,32
IF RFD%=1 RFY%=RFY%-1
IF RFD%=2 RFX%=RFX%+1
IF RFD%=3 RFY%=RFY%+1
IF RFD%=4 RFX%=RFX%-1
ch%=FNchk(RFX%,RFY%)
IF ch%>241 rfire=0:SOUND0,2,22,1:ENDPROC
VDU17,12,31,RFX%RFY%
IF RFD%=1OR RFD%=3:VDU237:ELSEVDU238
IF RFX%=X% AND RFY%=Y%:DE%=-1:ENDPROC
ENDPROC
REM === You got killed ===
DEFPROCdead
SOUND1,8,150,45
SOUND0,-15,7,45
VDU5,18,0,15
REM === loop to reprint random mess, to mimic an explosion ===
FOR T=1TO30
MOVE X%*64,1020-(Y%*32)
VDU 23,239,RND(255),RND(255),RND(255),RND(255),RND(255),RND(255),RND(255),RND(255)
VDU 239,10,8,239,18,0,0
NEXT
VDU4,23,1,0;0;0;0;
LI%=LI%-1
PROCdisplay_lives
IF rfire:VDU31,RFX%RFY%,32:rfire=0:REM reset robot bullet
IF fire:VDU31,FX%FY%,32:fire=0:REM reset bullet
ENDPROC
REM === print status ===
DEFPROCbox
VDU17,3,31,0,27:PRINT;"TALLY"
VDU17,3,31,15,27:PRINT;"LIVES"
ENDPROC
REM === print score ===
DEFPROCdisplay_score
VDU17,2,31,0,29:PRINT;sc;"%  "
ENDPROC
REM === print lives ===
DEFPROCdisplay_lives
VDU17,2,31,19,29:PRINT;LI%
ENDPROC
REM === game over ===
DEFPROCgame_over
PROCdisplay_score
PROCdisplay_lives
PROCd(10)
VDU12,31,5,15:PRINT;"GAME  OVER"
PROCtune(2)
PROCd(300)
ENDPROC
REM === you've won the game ===
DEFPROCwin
PROCdisplay_score
PROCdisplay_lives
PROCd(20)
VDU26,12,17,3,31,2,15
PRINT"CONGRATULATIONS!"
VDU31,4,18
PRINT"You did it!!"
SOUND2,0,0,3
SOUND3,0,0,6
pi%=0
FORi%=0TO16
    FORD%=3TO5STEP1
        pi%=(pi%+D%*1)AND31
        SOUND1,4,pi%*4,2
        SOUND2,5,pi%*4,2
        SOUND3,6,pi%*4,2
    NEXT
NEXT
PROCd(100)
ENDPROC
REM === poke memory for the character data based on the level ===
DEFPROCbuild_characters
O%=&27AD+(LE%*48)
FOR ch%=0 TO 5
    VDU23,(240+ch%),O%?0,O%?1,O%?2,O%?3,O%?4,O%?5,O%?6,O%?7
    O%=O%+8
NEXT
ENDPROC
REM === poke memory for the level data ===
DEFPROCbuild_level
O%=&2B67+(LE%*56)   :REM level data
ti%=&93C+(LE%*20)   :REM level title name
c%=&275E+(LE%*6)    :REM level colours for blocks and robots
C%=c%?4
G%=c%?5
PROCdisplay_score
PROCdisplay_lives
PRINTTAB(0,31);SPC(19);
VDU31,0,31:PRINT;$ti%;
FOR A=0 TO 19
    VDU31,A,0,17,c%?0,242,10,8,17,c%?1,243,11,31,A,24,17,c%?0,242,10,8,17,c%?1,243,11
NEXT
XX%=0
YY%=2
FOR A%=1 TO 55:REM Decode level data (see DROID1)
    D%=ASC(MID$($O%,A%,1))-46
    FOR Y%=0 TO 3
        J%=0
        K%=0
        W%=0
        Z%=0
        BL%=(D% MOD 3)
        VDU 31,XX%YY%
        IFBL%=0 J%=32:K%=32:W%=0:Z%=0
        IFBL%=1 J%=242:W%=c%?0:Z%=c%?1
        IFBL%>1 J%=244:W%=c%?2:Z%=c%?3
        IFBL%>0 K%=J%+1
        VDU31,XX%YY%,17,W%,J%,10,8,17,Z%,K%:IF BL%>0 VDU11
        D%=D% DIV 3
        XX%=XX%+1
        IF XX%>19 XX%=0:YY%=YY%+2
    NEXT
NEXT
ENDPROC
REM === play selected tune ===
DEFPROCtune(a)
IF a=1:E%=33:A%=&750:ELSE:E%=20:A%=&750+34*3
FOR B%=0 TO E%
    TIME=0
    IF?A%>0 REPEAT:SOUND&0011,?A%,A%?1,1:SOUND&0012,?A%,A%?1+1,1:UNTILTIME>=A%?2 ELSE REPEATUNTILTIME>=A%?2
    A%=A%+3
NEXT
ENDPROC
REM === finished level ===
DEFPROCdone
VDU 24,0;192;1279;1023;18,0,129,16,18,0,128,16,26,17,2,31,5,15
PRINT;"WELL DONE!"
PROCtune(1)
VDU 24,0;192;1279;1023;18,0,128,16,26
LE%=LE%+1
IF LE%>17 V%=3
ENDPROC
REM === relocate memory of program down to &E00 ===
DEFPROCrelocate
*T.
*FX138,0,128
*FX3,2
IFPAGE>&E00:*KEY0FORT%=0TOTOP-PAGE STEP4:T%!&E00=T%!PAGE:N.|MPAGE=&E00|MOLD|MRUN|M
REM === extra carriage return required for Beebasm to parse code ===
