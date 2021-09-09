# Androidz Redux
A remastered version of my original arcade game written for the BBC Micro.

![Image of Androidz Redux](androidz-redux1.png)
![Image of Androidz Redux](androidz-redux2.png)
![Image of Androidz Redux](androidz-redux3.png)

## What's changed from the original?

* More colours (using MODE 2, rather than MODE 5)
* Some graphic improvements
* Various bugfixes
* Some improvements in sound
* An increase in difficulty towards the last few levels.

## Play Androidz Redux online
The game is available to play online, via the Javascript BBC Micro Emulator [jsBeeb](https://github.com/mattgodbolt/jsbeeb):

https://bbc.godbolt.org/?disc=https://www.sassquad.net/downloads/androidz/redux/Android.ssd&autoboot

## Watch a playthrough of Androidz Redux

https://youtu.be/TMmLhOP0IgY

## About the game

Androidz was originally written over a period of about two months from July to August 1993. I cobbled the code together from a variety of other type in game listings published over the years - my primary method of learning how to code at the time. A bit like Github, Codepen etc, but in paper form, and less shiny shiny.

Various periods between August 2020 and August 2021 were spent on this remastered version. The game now makes use of 8 colour MODE 2 (there are officially 16, but the last 8 are flashing combinations of the 8 colours) to improve the palette of the game considerably. However, this screen mode - unlike the original MODE 5 - occupies twice the memory (20k). This has meant the source code has had to be shoehorned considerably to get everything to fit into the remaining 12k.

99% of the code is written using BBC Basic, with a small amount of assembly language to enable faster rendering of the player character. Because of the lack of room, the 'DROID2' game code is quite hard to read. I'm hoping to create a more annotated version which can then be compressed as part of the build process.

## Description of code files

* `DROID0.bas` - displays the loading screen and instructions. Also, core graphics and envelope sounds are initialised. Music data is also saved to a key area of memory.
* `DROID1.bas` - if `PAGE` is not at &1100, the program reruns to prevent data corruption, while the file assembles some code for printing of the player character. Additionally, the map, graphics and assigned colours are also committed to specific areas of memory (&2764, &27DD and &950 respectively). `HIMEM` is then set to just below the location of the map data, before `DROID2.bas` is run.
* `DROID2.bas` - the main game code. The code is relocated in memory to run at &E00, before switching to MODE 2, and again, ensuring `HIMEM` remains at &2764, to prevent level data corruption. When the game ends, `*DISC` is set, which raises the `PAGE` back to &1900, before your score is assigned to memory address &900, and `DROID3.bas` is run.
* `DROID3.bas` - this issues some text based on your percentage score, retrieved from memory address &900. When you play again, `PAGE` is set back to &1100, before running `DROID2.bas` to run the game.

## How to build from source

Although the disc image is included here, there are files included to help you build your own copy of the game. You will require the following:

* [Beebasm](https://github.com/stardot/beebasm)
* [basictool](https://github.com/ZornsLemma/basictool)

On more recent versions of Mac OS, Beebasm must be rebuilt from source, in order to run in the 64-bit environment. 

This repo includes the build process employed on my Apple iMac, which not only includes a build of BeebAsm, but the following tools/software:

* [b2 emulator](https://github.com/tom-seddon/b2)
* [Visual Studio Code](https://github.com/microsoft/vscode) (using the [Beeb VSC extension](https://github.com/simondotm/beeb-vsc), which offers some BASIC syntax highlighting)

VS Code's Tasks feature is employed to good effect here, by allowing a 'build' and 'test' task. The former creates the disc image, while the latter boots up the b2 emulator and automatically runs the disc image, streamling the testing process.

On Mac OS, the task file makes use of shell scripts. `build.sh` kicks beebasm, containing the following script:

`beebasm -i Androidz-Redux.asm -do AndroidzRedux.ssd -opt 3 -title Androidz`

On Windows however, the full pathname of the emulator must be plugged in, and the command arguments spun out to seperate entities within the tasks file. The file itself is documented to show where this can be changed. It goes without saying, Your Milage May Vary in terms of your chosen development environment, and where your software is located on your computer.

The `Androidz-Redux.asm` file consists of the following:

```
PUTBASIC "src/DROID0.bas","DROID0"
PUTBASIC "src/DROID1.bas","DROID1"
PUTBASIC "src/DROID2.bas","DROID2"
PUTBASIC "src/DROID3.bas","DROID3"
PUTFILE "src/DRSCRN.bin","DRSCRN",&7C00,&7C00
PUTTEXT "src/BOOT.txt", "!BOOT",&FFFF
```

This takes the files within the `src` folder, and outputs them in the correct format, prior to building the disc image. Notably, this includes the MODE 7 teletext loading screen, which requires the screen address added in to ensure it displays accordingly. 

The invocation of the bootfile, to make the disc autorun, was until recently, the missing element from making this disc image complete. This is due to BeebAsm's normal staple being the building of 6502 code files, invoked via `*RUN`. This approach doesn't work with BASIC files, as these are normally run with the `CHAIN` command, so it required a bit more Googling to find the correct way to build the bootfile for the game. 

Essentially, the `beebasm` call includes the `-opt 3` flag, that enables the disc image to be executable. The following line:

`PUTTEXT "src/BOOT.txt", "!BOOT",&FFFF`

within `Androidz-Redux.asm`, ensures the bootfile is created with the correct hooks to allow it to work.

The bootfile itself is fairly standard:

```
*BASIC
PAGE=&1900
*FX21
CLOSE#0:CHAIN "DROID0"
```

This boot content appears on a lot of disc images within the BBC Micro Game Archive's disc images, and basically ensures the computer, or emulator is all set up correctly, and has no 'open' files to corrupt disc images, prior to running the disc image. At least, that's what I believe.

I have not yet performed this build on the Windows platform, so I will be performing some further amends if the `tasks.json` file is not set up correctly.

## Acknowledgements

This work was only possible, thanks to the input of various members of the [Stardot](https://www.stardot.org.uk) community.

The remastering process started in August 2020, eventually resulting in my starting [this topic, concerning level data compression](https://stardot.org.uk/forums/viewtopic.php?f=54&t=20285). Various other topics were created over the following months:

* [Memory Management techniques](https://stardot.org.uk/forums/viewtopic.php?f=54&t=21316)
* [Using a PC or Mac for games authoring](https://stardot.org.uk/forums/viewtopic.php?f=54&t=20455)

The following people within the Stardot community were very helpful in my endeavours to get this version of the game to fruition.

* [0xCODE](https://github.com/0xC0DE6502) (for helping with some annoying bugs which I couldn't seem to work out, thank you!)
* ChrisB and lurkio (for assistance in level and data compaction, plus input on which areas of memory to use for data storage)
* VectorEyes, tom_seddon and julie_m (for their input in creation of the build files and integration with the b2 emulator)
* tricky (for some pointers on bootfile creation)

Thanks for reading. I hope you enjoy playing the game!
