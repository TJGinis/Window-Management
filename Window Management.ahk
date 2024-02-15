#Requires AutoHotkey v2.0+
#SingleInstance Force
Persistent()
InstallKeybdHook

;hotkey to toggle AlwaysOnTop status of last active window
#+w::{
    myWindow := WinExist('A')
    myWindowTitle := WinGetTitle(myWindow)
    WinSetAlwaysOnTop(-1, myWindowTitle)
}

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
;ahk_class Shell_TrayWnd