#Requires AutoHotkey v2.0+
#SingleInstance Force
Persistent()
InstallKeybdHook

LButton::return
Hotkey("LButton", "Off")

;hotkey to toggle AlwaysOnTop status of last active window
#+w::{
    myWindow := WinExist('A')
    myWindowTitle := WinGetTitle(myWindow)
    WinSetAlwaysOnTop(-1, myWindowTitle)
}

CapsLock & 3:: Pos_Helper()

CapsLock & 4:: Pos_Helper("Screen")

CapsLock & 5:: Pos_Helper("Window")

;Change a window title's tab name to whatever you want it to be - windows that change the title back like google chrome when switching tabs
;if you change to a different tab the window title will change names very briefly but then switch back 
#!w::{
    myWindow := WinExist('A')
    myWindowID := WinGetPID(myWindow)
    myWindowTitle := WinGetTitle(myWindow)
    newTitle := InputBox("What would you like to rename the window?", "Rename Window").Value
    WinSetTitle(newTitle, "ahk_pid " myWindowID)
    loop{
        WinWaitActive(myWindowTitle)
        if WinActive(myWindowTitle){
            WinSetTitle(newTitle, "ahk_pid " myWindowID)
        }
    }

}

>!.::Transparent_Window()

;if the mouse is hovering over the toolbar in the system tray, scrolling up/down will raise or lower the system volume
#HotIf MouseIsOver("ahk_class Shell_TrayWnd", "ToolbarWindow323") ; For MouseIsOver, see #HotIf example 1.
WheelUp:: Send("{Volume_Up}")     ; Wheel over taskbar: increase/decrease volume.
WheelDown:: Send("{Volume_Down}")

MouseIsOver(WinTitle, ctrl) {
    Try {
        MouseGetPos( ,, &win, &control)
        if WinExist(Wintitle " ahk_id " win){
            if IsSet(ctrl) && control = ctrl
                return true   
        }
    }
    return false
}

Transparent_Window(){
    myWindow := WinExist('A')
    myWindowID := WinGetPID(myWindow)
    myWindowTitle := WinGetTitle(myWindow)
    WinSetTransparent 200, myWindowTitle
}

Pos_Helper(Mode?){
    Mode := Mode ?? "Client"
    CoordMode("Mouse", Mode) ;Default CoordMode is Client, unless PosHelper is called with "Screen" or "Window"
    MouseGetPos(&x, &y)
    MouseToolTip("Please click the starting position",,, 1)
    Hotkey("Lbutton", "On")
    KeyWait("LButton", "D")
    MouseToolTip("",, true,1)
    MouseGetPos(&starting_x, &starting_y)
    sleep 100
    MouseToolTip("Drag to the end position of your desired object",,, 2)
    KeyWait("LButton","U")
    MouseToolTip("",,true,2)
    Hotkey("Lbutton", "Off")
    MouseGetPos(&ending_x, &ending_y)
    width := ending_x - starting_x
    height := ending_y - starting_y
    MsgBox("CoordMode: " Mode
    . "`n" . "X Pos: " starting_x
    . "`n" . "Y Pos: " starting_y
    . "`n" . "Width: " width
    . "`n" . "Height: " height)
}
;ahk_class Shell_TrayWnd

MouseToolTip(Text?, TimeOut:=5, Disable?, WhichToolTip?){
    SetTimer(ToolTipSub.Bind(Text?, A_TickCount+TimeOut*1000, WhichToolTip?), 50)

    ToolTipSub(Text?,TimeTarget?,WhichToolTip?){
        try if (Disable)
            TimeTarget-=50,000
            
        if (A_TickCount>TimeTarget){
            ToolTip("",,,WhichToolTip?)
            SetTimer(,0)
        } else {
            ToolTip(Text?,,, WhichToolTip?)
        }
    }
}

