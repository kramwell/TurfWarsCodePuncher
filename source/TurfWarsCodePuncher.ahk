;26/APRIL/2012 - Written by KramWell.com
;Easy to use program to auto input 'invite codes' into the popular game TurfWars, developed to mimic real world typing.

;#Warn  ; Recommended for catching common errors.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#SingleInstance IGNORE

VerNo = v0.6.8

;setvars
LineNumber1=0
LineNumber2=1
LineNumber3=0
first_line=
last_line=
first_line1=
last_line1=
last_line2=
last_line3=
;320x480

;outside the loop we need to pick 1-5 random numbers between 7-100
rad5 = "0"
rad6 = "0"
rad7 = "0"
rad10 = "0"
rad11 = "0"

;gets a random number of mistakes
Random, rad4, 2, 5

if (rad4 = "2")
{
Random, rad5, 7, 100
Random, rad6, 12, 100

}
else if (rad4 = "3")
{
Random, rad5, 7, 100
Random, rad6, 12, 100
Random, rad7, 12, 100

}
else if (rad4 = "4")
{
Random, rad5, 7, 100
Random, rad6, 12, 100
Random, rad7, 12, 100
Random, rad10, 12, 100

}
else if (rad4 = "5")
{
Random, rad5, 7, 100
Random, rad6, 12, 100
Random, rad7, 12, 100
Random, rad10, 12, 100
Random, rad11, 12, 100
}

Loop, read, %A_ScriptDir%\codes.txt
{
    LineNumber1 = %A_Index%
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
	if(LineNumber1 = 1)
	{
	first_line := A_LoopReadLine  ; When loop starts, this will hold the first line.
	}
	 last_line := A_LoopReadLine  ; When loop finishes, this will hold the last line.
	}
}

;gets the tempcode first and last line
Loop, read, %A_ScriptDir%\temps.txt
{
    LineNumber2 = %A_Index%

}
EnvSub, LineNumber2, 1
Loop, read, %A_ScriptDir%\temps.txt
{
    LineNumber3 = %A_Index%
    Loop, parse, A_LoopReadLine, %A_Tab%
    {
	if(LineNumber3 = 1)
	{
	first_line1 := A_LoopReadLine  ; When loop starts, this will hold the first line.
	}
	
	if(LineNumber3 = LineNumber2)
	{
	 last_line1 := A_LoopReadLine  ; When loop finishes, this will hold the last line.
	}
	}
}

;start the gui interface
Gui, Show , w260 h210, TWCP %VerNo%


if(LineNumber1 <> "")
{
	Gui, Add, Text, x10 y5 w240 Left, + codes.txt loaded! contains %LineNumber1% lines
}else{
	Gui, Add, Text, x10 y5 w240 Left, + codes.txt NOT loaded!
}

if(LineNumber3 <> "")
{
	Gui, Add, Text, x10 y20 w240 Left, + temps.txt loaded! contains %LineNumber2% lines
}else{
	Gui, Add, Text, x10 y20 w240 Left, + temps.txt NOT loaded!
}

Gui, Add, Button, x200 y10 w50 h20 gRELOAD,Reload

;codes

Gui, Add, GroupBox, x10 y45 w110 h80, Mob Codes

if(LineNumber1 <> "")
{
	Gui, Add, Button, x40 y65 w50 h20 gTWCP,Go
}
;Gui, Add, Button, x105 y60 w50 h20 gDELETE,Delete
Gui, Add, Button, x40 y95 w50 h20 ,Website

Gui, Add, Text, x20 y137 w120 Left,F: %first_line%
Gui, Add, Text, x20 y157 w120 Left,L: %last_line%


Gui, Add, GroupBox, x140 y45 w110 h80, Temp Codes

if(LineNumber3 <> "")
{
	Gui, Add, Button, x170 y65 w50 h20 gTW-TCP,Go
}
Gui, Add, Button, x170 y95 w50 h20 gTC_UPDATE,Update

Gui, Add, Text, x165 y137 w120 Left,F: %first_line1%
Gui, Add, Text, x165 y157 w120 Left,L: %last_line1%

;Gui, Add, Edit, w50 h19 x10 y30 vNUMBER Left, 

Gui, Add, GroupBox, x10 y175 w240 h30,

;reads first line of text file
FileReadLine, doLoop, %A_Temp%\twcp.loop, 1
    if not ErrorLevel
		{
		;if it is a 1
		if doLoop = 1
			{
			chkLoop = 1
			}else{
			chkLoop = 0
			}
		}else{
			;create file tw.cp
			chkLoop = 0
		}

Gui, Add, Checkbox, x18 y185 w100 h15 gchkLoop1 vchkLoop Checked%chkLoop%, Loop codes.txt


		;if it is a 1, loop is enabled
		if chkLoop = 1
			{
				Goto, TWCP
			}

		
return

;if checkbox is selected
chkLoop1:
{
	Gui, submit, nohide

	If chkLoop = 1
	{
		;user selects looping enabled
		FileReadLine, doLoop, %A_Temp%\twcp.loop, 1
			if not ErrorLevel
			{
				;file found, delete and create new with 1 = on
				FileDelete, %A_Temp%\twcp.loop
				FileAppend, 1, %A_Temp%\twcp.loop
			}else{
				;file not found, create new,
				FileAppend, 1, %A_Temp%\twcp.loop
			}
		
	}else{
		;looping disabled
			FileDelete, %A_Temp%\twcp.loop
	}
}
return

codeLooping:
{
	;this changes codes(x).txt > codes.txt and reloads program

	if chkLoop = 1
	{
		;start loop
		reloadScript = 0
		1codeCount = 0
		;loop 100times to find next code
		Loop, 100
		{
			
			1codeCount++
			
			;check for codes(x).txt
			
			FileRead, readMe, %A_ScriptDir%\codes (%1codeCount%).txt
			if not ErrorLevel  ; Successfully loaded.
			{
				;rename to codes.txt
				FileDelete, %A_ScriptDir%\codes.txt
				Sleep, 5000
				FileCopy, %A_ScriptDir%\codes (%1codeCount%).txt, %A_ScriptDir%\codes.txt 
				Sleep, 5000
				FileDelete, %A_ScriptDir%\codes (%1codeCount%).txt
				reloadScript = 1
				Random, chillTime, 25000, 50000
				Sleep, %chillTime%
				TrayTip, TW.CP %VerNo%,Restarting..., 8, 1
				Sleep, 5000
				break
			}
		}
		if (reloadScript = 1)
		{
		RELOAD
		}
		if (1codeCount = 100)
		{
		msgbox, all codes entered... you rogue!
		exit
		}
			
	}else{
		;twcp=0
		
		msgbox, all codes entered!
				
	}


}
return

RELOAD:
reload
return

space::Pause
return



TWCP:
{

	CountCodes = 1

	;checks for vncviewer in explorer
	Process, Exist, vncviewer.exe
	PID := ErrorLevel

	If (PID <> 0)
	{
		WinActivate, ahk_pid %PID%
		
		PixelGetColor, OutputVar, 214, 364 ,RGB
		if (OutputVar <> "0x3866B3")
		{
			MsgBox, ERROR: Please make sure VNC is open
			Exit
		}

		Loop, read, %A_ScriptDir%\codes.txt
		{
			LineNumber = %A_Index%
			Loop, parse, A_LoopReadLine, %A_Tab%
			{

					
				;get invite code and set timer based on code lengh
				StringLen, countIt, A_LoopField

				;countIt contains the no of times to loop
				;loop the amount charactors in the string
				Loop, %countIt%
				{
					StringMid, the_word, A_LoopField, a_index, 1


					if (the_word = "£" or the_word = "$" or the_word = "@" or the_word = "%" or the_word = "?" or the_word = "!")
					{

						;gets a random waiting time milliseconds
						Random, rad3, 2000.000, 4000.000
						;holds the script for the set time - simulate typing the code
						Sleep,%rad3%
					}

				}

				;here is where we add the mistakes
				if (LineNumber = rad5)
				{
					if (countIt >= 5)
					{
						NewTemp = %countIt%
						NewTemp--
						Random, rad8, 3, NewTemp
						rad9 = %rad8%
						EnvSub, NewTemp, %rad9%
						StringTrimRight, OutputVar2, A_LoopField, %NewTemp%
						send %OutputVar2%
						;gets a random waiting time milliseconds
						Random, rad, 3000.000, 5000.000
						;holds the script for the set time - simulate typing the code
						Sleep,%rad%
						;sends the enter command
						Send {Enter}
						Random, bad, 1500.000, 2000.000
						;holds the script for the set time
						Sleep,%bad%

						;here is where the color script is
						progs = "0"

						Loop, 100
						{
							progs++

							PixelGetColor, OutputVar, 214, 364 ,RGB
							if (OutputVar <> "0x3866B3")
							{
								Random, bad1, 2000.000, 2000.000
								;holds the script for the set time
								Sleep,%bad1%
							}else{
								Break ;dont think this works
							}

							if (progs = "100")
							{
								MsgBox, Maximum number of attempts have been reached.
								;exit
								Pause
							}

						}
						
						;backspace
						;here is where we delete the text 15 times incase invalid
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
					}
				}

					if (LineNumber = rad6)
					{
						if (countIt >= 5)
						{
							NewTemp = %countIt%
							NewTemp--
							Random, rad8, 3, NewTemp
							rad9 = %rad8%
							EnvSub, NewTemp, %rad9%
							StringTrimRight, OutputVar2, A_LoopField, %NewTemp%
							send %OutputVar2%
							;gets a random waiting time milliseconds
							Random, rad, 3000.000, 5000.000
							;holds the script for the set time - simulate typing the code
							Sleep,%rad%
							;sends the enter command
							Send {Enter}
							Random, bad, 1500.000, 2000.000
							;holds the script for the set time
							Sleep,%bad%

							;here is where the color script is
							progs = "0"

							Loop, 100
							{
								progs++

								PixelGetColor, OutputVar, 214, 364 ,RGB
								if (OutputVar <> "0x3866B3")
								{
								Random, bad1, 2000.000, 2000.000
								;holds the script for the set time
								Sleep,%bad1%
								}else{
								Break ;dont think this works
								}

								if (progs = "100")
								{
								MsgBox, Maximum number of attempts have been reached.
								;exit
								Pause
								}

							}
							;backspace
							;here is where we delete the text 15 times incase invalid
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
							Send {Backspace}
						}
					}
					
				if (LineNumber = rad7)
				{
					if (countIt >= 5)
					{
						NewTemp = %countIt%
						NewTemp--
						Random, rad8, 3, NewTemp
						rad9 = %rad8%
						EnvSub, NewTemp, %rad9%
						StringTrimRight, OutputVar2, A_LoopField, %NewTemp%
						send %OutputVar2%
						;gets a random waiting time milliseconds
						Random, rad, 3000.000, 5000.000
						;holds the script for the set time - simulate typing the code
						Sleep,%rad%
						;sends the enter command
						Send {Enter}
						Random, bad, 1500.000, 2000.000
						;holds the script for the set time
						Sleep,%bad%

						;here is where the color script is
						progs = "0"

						Loop, 100
						{
							progs++

							PixelGetColor, OutputVar, 214, 364 ,RGB
							if (OutputVar <> "0x3866B3")
							{
								Random, bad1, 2000.000, 2000.000
								;holds the script for the set time
								Sleep,%bad1%
							}else{
								Break ;dont think this works
							}

							if (progs = "100")
							{
								MsgBox, Maximum number of attempts have been reached.
								;exit
								Pause
							}

						}
						;backspace
						;here is where we delete the text 15 times incase invalid
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
					}
				}
				if (LineNumber = rad10)
				{
					if (countIt >= 5)
					{
						NewTemp = %countIt%
						NewTemp--
						Random, rad8, 3, NewTemp
						rad9 = %rad8%
						EnvSub, NewTemp, %rad9%
						StringTrimRight, OutputVar2, A_LoopField, %NewTemp%
						send %OutputVar2%
						;gets a random waiting time milliseconds
						Random, rad, 3000.000, 5000.000
						;holds the script for the set time - simulate typing the code
						Sleep,%rad%
						;sends the enter command
						Send {Enter}
						Random, bad, 1500.000, 2000.000
						;holds the script for the set time
						Sleep,%bad%

						;here is where the color script is
						progs = "0"

						Loop, 100
						{
							progs++

							PixelGetColor, OutputVar, 214, 364 ,RGB
							if (OutputVar <> "0x3866B3")
							{
								Random, bad1, 2000.000, 2000.000
								;holds the script for the set time
								Sleep,%bad1%
							}else{
								Break ;dont think this works
							}

							if (progs = "100")
							{
								MsgBox, Maximum number of attempts have been reached.
								;exit
								Pause
							}

						}
						;backspace
						;here is where we delete the text 15 times incase invalid
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
					}
				}
				if (LineNumber = rad11)
				{
					if (countIt >= 5)
					{
						NewTemp = %countIt%
						NewTemp--
						Random, rad8, 3, NewTemp
						rad9 = %rad8%
						EnvSub, NewTemp, %rad9%
						StringTrimRight, OutputVar2, A_LoopField, %NewTemp%
						send %OutputVar2%
						;gets a random waiting time milliseconds
						Random, rad, 3000.000, 5000.000
						;holds the script for the set time - simulate typing the code
						Sleep,%rad%
						;sends the enter command
						Send {Enter}
						Random, bad, 1500.000, 2000.000
						;holds the script for the set time
						Sleep,%bad%

						;here is where the color script is
						progs = "0"

						Loop, 100
						{
							progs++

							PixelGetColor, OutputVar, 214, 364 ,RGB
							if (OutputVar <> "0x3866B3")
							{
								Random, bad1, 2000.000, 2000.000
								;holds the script for the set time
								Sleep,%bad1%
							}else{
								Break ;dont think this works
							}

							if (progs = "100")
							{
								MsgBox, Maximum number of attempts have been reached.
								;exit
								Pause
							}

						}
						;backspace
						;here is where we delete the text 15 times incase invalid
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
					}
				}

				;***************////////////////////////*********************************************************
				;***************////////////////////////*********************************************************

				CountCodes++

				;displays the invite code
				Send %A_LoopField%

				;here we need to see if the code is 8 or under charactors
				;if so it will take between 3 - 5 seconds
				;if it is over 8 charactors its between 5 - 7 seconds

				if (countIt <= 8)
				{
					;gets a random waiting time milliseconds
					Random, rad, 2000.000, 4000.000
					;holds the script for the set time - simulate typing the code
					Sleep,%rad%
				}else{
					;gets a random waiting time milliseconds
					Random, rad, 5000.000, 7000.000
					;holds the script for the set time - simulate typing the code
					Sleep,%rad%
				}

				;sends the enter command
				Send {Enter}

				Random, bad, 1500.000, 2000.000
				;holds the script for the set time
				Sleep,%bad%


				;here is where the color script is, checks and waits until the button is back to 'INVITE'
				progs = "0"

				Loop, 100
				{
					progs++

					PixelGetColor, OutputVar, 214, 364 ,RGB
					if (OutputVar <> "0x3866B3")
					{
						Random, bad1, 2000.000, 2000.000
						;holds the script for the set time
						Sleep,%bad1%
					}else{
						Break ;dont think this works
					}
				}

				if (progs = "100")
				{
					MsgBox, Maximum number of attempts have been reached.
					Pause
				}

				Gui, Add, Text, x100 y68 w40 Left, %CountCodes%

				;here is where we see if the code has cleared and is ready for the next one
				progs1 = "0"
				Loop, 100
				{
					progs1++

					PixelGetColor, OutputVar1, 18, 364 ,RGB
					if (OutputVar1 <> "0x426BF2")
					{

						;wait half a second then check again
						Random, bad2, 0500.000, 0500.000
						Sleep,%bad2%

						PixelGetColor, OutputVar1, 18, 364 ,RGB
						if (OutputVar1 <> "0x426BF2")
						{

						;invalid code detected
						;we need to delete it 15 times then wait based on lenth. and log.
						Random, bad2, 3000.500, 5320.000
						;holds the script for the set time
						Sleep,%bad2%

						;backspace
						;here is where we delete the text 15 times incase invalid
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}
						Send {Backspace}

						}

					}else{
						Break ;dont think this works
					}
				}

				if (progs = "100")
				{
					MsgBox, Maximum number of attempts have been reached 1.
					Pause
				}


			} ;end loop codes.txt
		} ;end loop codes.txt


		;here we need to check for loop in txtfile
		Goto, codeLooping


	}else{
		MsgBox,Oops! Please make sure the VNC window is open.
	} ;end winactive

}
return

TC_UPDATE:
{
	msgbox, No new temp codes available
}
return

TW-TCP:
{
	countTemp = 1

	;checks for ifunbox in explorer
	Process, Exist, vncviewer.exe
	PID := ErrorLevel

	If (PID <> 0)
	{
		WinActivate, ahk_pid %PID%

		PixelGetColor, OutputVar, 214, 364 ,RGB
		if (OutputVar <> "0x3866B3")
		{
			MsgBox, ERROR: Please make sure VNC is open
			Exit
		}

		Loop, read, %A_ScriptDir%\temps.txt
		{
			LineNumber4 = %A_Index%
			Loop, parse, A_LoopReadLine, %A_Tab%
			{

		if (A_LoopField = "BREAK")
		{
			;gets a random waiting time milliseconds
			Random, rad, 20000.000, 40000.000
			;holds the script for the set time - simulate typing the code
			Sleep,%rad%
		}else{

			;here we need to see if the code is 8 or under charactors
			;if so it will take between 2 - 4 seconds
			;if it is over 8 charactors script ends

			;get invite code and set timer based on code lengh
			StringLen, countIt, A_LoopField

			if (countIt <= 8)
			{
				;displays the invite code
				Send %A_LoopField%

				countTemp++

				;gets a random waiting time milliseconds
				Random, rad, 2000.000, 4000.000
				;holds the script for the set time - simulate typing the code
				Sleep,%rad%

			}else{
				MsgBox, All done!
				Exit
			}

			;sends the enter command
			Send {Enter}

			Random, bad, 1500.000, 2000.000
			;holds the script for the set time
			Sleep,%bad%

			;here is where the color script is
			progs = "0"

			Loop, 100
			{
				progs++

				PixelGetColor, OutputVar, 214, 364 ,RGB
				if (OutputVar <> "0x3866B3")
				{
					Random, bad1, 2000.000, 2500.000
					;holds the script for the set time
					Sleep,%bad1%
				}else{
					Break ;dont think this works
				}

				if (progs = "100")
				{
					MsgBox, Maximum number of attempts have been reached.
					Pause
				}

			}

			Gui, Add, Text, x225 y68 w40 Left, %CountTemp%


			;here is where we see if the code has cleared and is ready for the next one
			progs1 = "0"
			Loop, 100
			{
				progs1++

			PixelGetColor, OutputVar1, 18, 364 ,RGB
			if (OutputVar1 <> "0x426BF2")
			{

				;wait half a second then check again
				Random, bad2, 0500.000, 0500.000
				Sleep,%bad2%

				PixelGetColor, OutputVar1, 18, 364 ,RGB
				if (OutputVar1 <> "0x426BF2")
				{

					;invalid code detected
					;we need to delete it 15 times then wait based on lenth. and log.
					Random, bad2, 3000.500, 5320.000
					;holds the script for the set time
					Sleep,%bad2%

					;backspace
					;here is where we delete the text 15 times incase invalid
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}
					Send {Backspace}

				}

			}else{
				Break ;dont think this works
			}

				if (progs = "100")
				{
					MsgBox, Maximum number of attempts have been reached 1.
					Pause
				}
			}


		} ;ends if break is found in code list 

			}
		}

	}else{
		MsgBox,Oops! Please make sure the VNC window is open.
	} ;end winactive

}
return

#i::
TrayTip, TW.CP %VerNo%,Mistakes: %rad4% `n1:%rad5% `n2:%rad6% `n3:%rad7% `n4:%rad10% `n5:%rad11%, 8, 1
return

GuiClose: 
		;file found, deleteonclose
		FileDelete, %A_Temp%\twcp.loop
ExitApp
return 