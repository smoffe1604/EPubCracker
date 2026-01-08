#Requires AutoHotkey v2.0

; Press Escape to exit the script
Esc::ExitApp

; Toggle script on/off with F1
F1::Pause

; Wait 5 seconds before starting
Sleep(5000)

; Variable to track direction
moveRight := true

; Main loop
Loop {
    if (moveRight) {
        ; Move right
        MouseMove(300, 0, 0, "R")
        Sleep(100)
        Click
        Sleep(100)
        Send("^v")  ; Paste from clipboard
        Sleep(100)
        Send("{Enter}")
        Sleep(2000)
        Send("{Enter}")  ; Press Enter to save
        Sleep(2000)
        Send("{Left}")   ; Press Left arrow
        Sleep(100)
        Send("{Enter}")  ; Press Enter again
        Sleep(1000)
    } else {
        ; Move left
        MouseMove(-300, 0, 0, "R")
        Sleep(100)
        Click
        Sleep(100)
        Send("{Right}")
    }
    
    ; Toggle direction for next iteration
    moveRight := !moveRight
    
    ; Wait 2 seconds before next cycle
    Sleep(2000)
}