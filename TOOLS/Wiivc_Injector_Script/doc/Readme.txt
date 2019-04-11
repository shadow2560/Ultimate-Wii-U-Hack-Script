:::::::::::::::::::::::::::::::::::::
::TeconMoon's WiiVC Injector Script::
:::::::::::::::::::::::::::::::::::::

Please check out the thread on gbatemp for support: https://gbatemp.net/threads/release-wiivc-injector-script.483577/
thread for the modified version: http://www.logic-sunrise.com/forums/topic/79223-shadow256-ultimate-wii-u-hack-script/

# THE BASICS
Put the following files in the SOURCE_FILES folder based on what you want to build and run the script (not required now but always available):

## MINIMUM REQUIRED FILES
1. Game file:
	A. Wii Retail Game: game.iso OR game.wdf OR game.wia OR game.ciso OR game.wbi OR game.wbfs (multiple wbfs files "game.wbfs", "game.wbf1"...)
	B. GC Retail Game: game.gcm OR game.iso
	C. GC Multi Disc: game.gcm & disc2.gcm OR game.iso & disc2.iso OR game.iso & disc2.gcm OR game.gcm & disc2.iso
	D. Wii Homebrew: boot.dol
	E. Wiivc_Chan_Booter: game.wad (be careful when installing a homebrew wad on v-wii, it need to be compatible with Wii U v-wii else could brick the v-wii side) (wad must be installed on v-wii nand)
	F. If none of files above is present, the script could create a Wiivc_Chan_Booter but during the script, you must specify the Title ID of the game/app you want to load. If you decide to not create it, you could also create a Nintendont forwarder channel easily.

## OPTIONAL FILES:
2. Game Icon: iconTex.png OR iconTex.tga at 128x128
3. TV Banner: bootTvTex.png OR bootTvTex.tga at 1280x720
4. GamePad Banner: bootDrcTex.png OR bootDrcTex.tga at 854x480
5. Company Logo: bootLogoTex.png OR bootLogoTex.tga at 170x42
6. Boot Sound: bootSound.wav OR bootSound.btsnd, 6 seconds maximum (will be trimmed if longer)
7. Wii cheats, only for Wii games: game.gct
8. Nintendont custom, only for Gamecube game: main.dol


# TROUBLESHOOTING
If you run into errors during the conversion process, please post the logs on the GBATemp thread where you downloaded this and I will take a look. For the modified version, post it on the Logic-sunrise thread.



# CREDITS
7zip 16.04: http://www.7-zip.org/
c2w_patcher 1.2: FIX94
GetExtTypePatcher 1.1: FIX94
GNU Win32 tools (Cut, Grep, Head, Tail, Wget): http://gnuwin32.sourceforge.net/
HomeBrew ISO Base: FIX94 & Ploggy
ImageMagick 7.0.7 (Convert): https://www.imagemagick.org/
JNUSTool 0.3b: Maschell
Nintendont Autoboot Forwarder 1.2: FIX94
nfs2iso2nfs 0.5.6: sabykos, piratesephiroth, FIX94, etc
NUSPacker: timogus, ihaveamac & FIX94
pngcheck: Alexander Lehmann, Andreas Dilger, Greg Roelofs
PNG to TGA 2.6: Easy2Convert Software
Sharpii 1.7.2: person66
SoX 14.4.2: cbagwell, robs, & uklauer
Wiivc_Chan_Booter 1.0: FIX94
Wii Video Mode Changer 2.2: Waninkoko
wav2btsnd 0.2: timogus & Zarklord
wbfs_file 2.6: oggzee & kwiirk
Wiimms ISO Tools 3.01a-r7464: Wiimms
WSTRT 1.54a: Wiimms
Wupclient and Wupserver: smealum for initial relise and mutch other people to thank

This script is just using all of the above tools, without which this wouldn't be possible.



# Changelog
## [2.2.6] = 2017-10-10
- Updated c2w_patcher to 1.2

## [2.2.5] = 2017-10-06
- Fixed broken variables for WBFS / Wii Homebrew DOL Injection

## [2.2.4] = 2017-10-06
- Adjusted placement of temporary files so that if Windows accidentally locks them for editing, they don't get packed into the encrypted package and blow up the file size
- Updated c2w_patcher build

## [2.2.3] = 2017-10-04
- Moved variable specification for Wii Title IDs later in the script to prevent discrepancies

## [2.2.2] = 2017-10-03
- Replaced nfs2iso2nfs with FIX94's fork version 0.5.5
- Made Wii Remote passthrough optional for Homebrew

## [2.2.1] = 2017-09-30
- Adjusted PING command to call full path instead of environmental variable
- If minimum required files aren't found in SOURCE_FILES, the "Hide extensions for known file types" File Explorer option is automatically turned off to ease with investigation

## [2.2.0] = 2017-09-30
- Added c2w patching support (REQUIRES patched titles to be installed to NAND launched with sign_c2w_patcher)
- Replaced nintendont forwarders with v1.2
- Replaced NUSPacker with FIX94's fork
- Called all JAR files using java -jar instead of assuming that Windows file associations are actually correct
- Added Internet Check before trying to use JNUSTool to prevent failures and more substantial checks for if all source files downloaded by JNUSTool actually exists
- Merged Standard logging with Error logging
- Cleaned up unnecessary WIT files

## [2.1.3] = 2017-09-22
- For GameCube game injection, a custom main.dol can now optionally be placed in the SOURCE_FILES folder to replace the Nintendont forwarder. Useful if you've compiled a forwarder with different options, or are testing a forwarder for FIX94

## [2.1.2] = 2017-09-21
- Multi-Disk GameCube games now supported, put your disc2 image in the SOURCE_FILES folder as disc2.gcm
- Replaced PNG Verification method, made error messages more clear
- Optional bootLogoTex now supported as either PNG or TGA
- Cleaned up scripting for Title Key and Common Key verification

## [2.1.1] = 2017-09-21
- Script can now be used offline, provided you've run through the script once online successfully (Checks if JNUSTool has already downloaded the needed files)
- PNG Check has been added, so that it will warn you if your PNG isn't valid

## [2.1.0] = 2017-09-20
- Replaced homebrew ISO base with one that doesn't cause issues (HUGE THANKS FIX94 & PLOGGY)
- Replaced Nintendont forwarders with 1.1 versions from FIX94 and added Autoboot and 4:3 options

## [2.0.0] = 2017-09-19
- Added GCM Injection Support (Requires Nintendont on SD Card)
- Added Homebrew DOL Injection Support
- Added support for more GamePad emulation modes
- Re-worked how WBFS files are handles for more stability


## [1.0.6] = 2017-09-16
- Updated NFS2ISO2NFS to 0.5.1
- Added logging support, now if the script fails it will be easier to pinpoint why
- Special characters no longer break folder creation
- Meta.xml Japanese publisher now uses correct variable
- Robocopy now called by its full path (since random machines are failing to call its environmental variable)
- Added failcheck for if WIT fails to rebuild the game file


## [1.0.5b] = 2017-09-11
- Changed base to Rhythm Heaven Fever, uses a newer revision of fw.img
- Integrated Title ID for RHF, as it's worthless without the Title Key
- Support for WBFS conversion if preferred over ISO
- Support for pre-built bootSound BNSTD if preferred over WAV
- If the wrong Title Key or Common key is specified, it will prompt you to re-enter them.
- If a space is accidentally included when you paste the Wii U Common Key, it will no longer break the script
-Lots of failchecks. Script will warn you if:
	1. Java isn't detected
	2. Script reliant folders aren't accessible by the script (permission issues)
	3. ROBOCOPY isn't supported on your OS
	4. The necessary code/meta files weren't downloaded or generated properly (This occurs before converting the game wbfs/iso files, so should show up very early in the process)
	5. Special characters that break folder creation are present
	6. NUSPacker fails to generate the installable package

## [1.0.4] = 2017-09-10
- Changed the output folder naming convention so that the resulting folder name includes the full Title ID for your package
- Fixed some flags breaking the script

## [1.0.3] = 2017-09-09
- Set maximum length for custom sound files to 6 seconds
- Added an option for sound looping

## [1.0.2] = 2017-09-09
- bootSound.wav will be converted from the SOURCE_FILES folder and used if it exists, otherwise the default bootSound will be used
- You can now choose to manually specify a Title/Group ID if desired instead of using a random one
- Allow usage of TGAs over PNGs if provided
- Changed Title ID layout from 0005000010XXXX00 to 0005000010XXXXFF to prevent 1/10000 chance a Title ID is generated that overwrites CBHC
- Updated the readme to be less redundant

## [1.0.1] - 2017-09-09
- Added a check for if the right Title ID was provided

## [1.0.0] - 2017-09-08
- Initial Release