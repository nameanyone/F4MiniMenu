﻿/*

General program settings GUI
Include for F4MiniMenu.ahk

*/

Settings:

Gui, Browse:Destroy


; Variables
SelectMenuPos:=MatchList.settings.MenuPos
Checked:=MatchList.settings.TCStart
FGHKey:=MatchList.settings.ForegroundHotkey
BGHKey:=MatchList.settings.BackgroundHotkey 

; Turn hotkeys off to be sure
HotKeyState:="Off"
Gosub, SetHotkeys

; Gui for general program settings
Gui, Add, GroupBox, x16 y7 w540 h45 , Menu
Gui, Add, Text, x25 y25 w309 h16 , &Selection menu appears
Gui, Add, DropDownList, x328 y20 w219 h25 r4 Choose%SelectMenuPos% vMenuPos AltSubmit, 1 - At Mouse cursor|2 - Centered in window|3 - Right next to current file|4 - Docked next to current file (opposite panel)

Gui, Add, GroupBox, x16 yp+40 w540 h45 , Files
Gui, Add, Text, x25 yp+20 w309 h16 , &Maximum number of files to be opened
Gui, Add, Edit, x328 yp-5 w219 h21 Number vMaxFiles, % MatchList.settings.Maxfiles ; %
	
Gui, Add, GroupBox, x16 yp+40 w540 h45 , Total Commander
Gui, Add, Checkbox, x25 yp+20 w200 h16 Checked%checked% vTCStart, Start Total Commander if not Running
Gui, Add, Text, xp+250 yp w50 h16 , TC Path
If !FileExist(MatchList.settings.TCPath)
	{
	 RegRead TCPath, HKEY_CURRENT_USER, Software\Ghisler\Total Commander, InstallDir
	 TCPath = %TCPath%\TotalCmd.exe
	 If FileExist(TCPath)
		MatchList[0,"TCPath"]:=TCPath
	 TCPath:=""	
	}
Gui, Add, Edit, xp+53  yp-5 w180 h21 vTCPath, % MatchList.settings.TCPath ; %
Gui, Add, Button, xp+187  yp   w30  h20 gSelectExe, >>

Gui, Add, GroupBox, x16 yp+40 w395 h90 , Hotkeys

Gui, Add, Text, x25 yp+25 w150 h16 , &Background mode (direct)
Gui, Add, Radio, xp+130 yp w45 h16  vBesc, Esc
Gui, Add, Radio, xp+45  yp w45 h16  vBWin, Win

; Always annoying to work around Hotkey control limit, use boxes for Win & Esc keys
If InStr(BGHKey,"#")
	{
	 StringReplace, BGHKey, BGHKey, #, , All
	 GuiControl, , BWin, 1
	}
If InStr(BGHKey,"Esc &")
	{
	 StringReplace, BGHKey, BGHKey, Esc &, , All
	 StringReplace, BGHKey, BGHKey, Esc &amp`;, , All
	 StringReplace, BGHKey, BGHKey, Esc &amp;, , All
	 StringReplace, BGHKey, BGHKey, %A_Space%, , All
	 GuiControl, , BEsc, 1
	}

Gui, Add, Hotkey, xp+50 yp-3 w140 h20 vBGHKey  , %BGHKey%

Gui, Add, Text, x25 yp+35 w150 h16 , &Foreground mode (menu)
Gui, Add, Radio, xp+130 yp w45 h16 vFesc, Esc
Gui, Add, Radio, xp+45  yp w45 h16 vFWin, Win

If InStr(FGHKey,"#")
	{
	 StringReplace, FGHKey, FGHKey, #, , All
	 GuiControl, ,FWin, 1
	}

If InStr(FGHKey,"Esc &")
	{
	 StringReplace, FGHKey, FGHKey, Esc &, , All
	 StringReplace, FGHKey, FGHKey, Esc &amp`;, , All
	 StringReplace, FGHKey, FGHKey, Esc &amp;, , All
	 StringReplace, FGHKey, FGHKey, %A_Space%, , All
	 GuiControl, , FEsc, 1
	}
	
Gui, Add, Hotkey, xp+50 yp-3 w140 h20 vFGHKey  , %FGHKey% 


Gui, Add, Button, xp+177 yp-48 w120 h25 gButtonOK, OK
Gui, Add, Button, xp     yp+30 w120 h25 gButtonClear, Clear Hotkeys
Gui, Add, Button, xp     yp+30 w120 h25 gGuiClose, Cancel

Gui, Add, Link,   x25 yp+35, F4MiniMenu %F4Version%: Minimalistic clone of the F4 Menu program for TC. More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>

Gui, Show, center w570 h295, Settings
Return

ButtonOK:
Gui, Submit, NoHide
MatchList.settings.MenuPos:=MenuPos
If (MaxFiles > 50)
	{
	 MsgBox, 36, Confirm, Are you sure you want to`nset the maximum at %MaxFiles% files?`n(No will set the maximum to 50)
	 IfMsgBox, No
		MaxFiles:=50
	}
MatchList.settings.MaxFiles:=MaxFiles
MatchList.settings.TCStart:=TCStart
MatchList.settings.TCPath:=TCPath

GuiControlGet, EscFG, , FEsc
GuiControlGet, WinFG, , FWin
GuiControlGet, EscBG, , BEsc
GuiControlGet, WinBG, , BWin

; Revert the boxes to the Hotkey def.
If WinFG
	FGHKey:="#" FGHKey
If (EscFG = 1) and (RegExMatch(FGHKey,"[\^\+\!\#]") = 0)
	FGHKey:="Esc & " FGHKey
If WinBG
	BGHKey:="#" BGHKey
If (EscBG = 1) and (RegExMatch(BGHKey,"[\^\+\!\#]") = 0)
	BGHKey:="Esc & " BGHKey

MatchList.settings.ForegroundHotkey:=FGHKey
MatchList.settings.BackgroundHotkey:=BGHKey

HotKeyState:="On"
Gosub, SetHotkeys

Gui, Destroy
Return

ButtonClear:
GuiControl, , FEsc, 0
GuiControl, , FWin, 0
GuiControl, , BEsc, 0
GuiControl, , BWin, 0
GuiControl, , BGHKey, 
GuiControl, , FGHKey, 
Return

GuiEscape:
GuiClose:
Gui, Destroy

HotKeyState:="On"
Gosub, SetHotkeys
Return