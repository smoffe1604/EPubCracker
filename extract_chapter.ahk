#Requires AutoHotkey v2.0

; Press Escape to exit the script
Esc::ExitApp

; Toggle script on/off with F1
F1::Pause

SetTitleMatchMode(2)

ClickDialogButton(dialogWindow, labels) {
    dialogTitle := "ahk_id " dialogWindow

    try {
        for controlName in WinGetControls(dialogTitle) {
            controlText := ControlGetText(controlName, dialogTitle)
            cleanText := StrReplace(controlText, "&")

            for label in labels {
                if (cleanText = label || InStr(cleanText, label)) {
                    ControlClick(controlName, dialogTitle)
                    return true
                }
            }
        }
    }

    return false
}

ConfirmOverwriteIfShown(timeoutMs := 2000) {
    confirmTitleParts := ["Confirm", "Bekræft", "Replace", "Erstat"]
    yesButtonLabels := ["Yes", "Ja", "Replace", "Erstat"]
    deadline := A_TickCount + timeoutMs

    while (A_TickCount < deadline) {
        activeWindow := WinExist("A")

        if activeWindow {
            try {
                activeClass := WinGetClass("ahk_id " activeWindow)
                activeTitle := WinGetTitle("ahk_id " activeWindow)
            } catch {
                Sleep(50)
                continue
            }

            if (activeClass = "#32770") {
                for titlePart in confirmTitleParts {
                    if InStr(activeTitle, titlePart) {
                        Sleep(100)
                        if ClickDialogButton(activeWindow, yesButtonLabels) {
                            return true
                        }

                        ; In standard overwrite prompts, Button1 is the affirmative button.
                        try {
                            ControlClick("Button1", "ahk_id " activeWindow)
                            return true
                        }
                    }
                }
            }
        }

        Sleep(50)
    }

    return false
}

; Wait 5 seconds before starting
Sleep(5000)

; Variable to track direction
moveRight := true

; Main loop
Loop {
    if (moveRight) {
        ; Move right
        MouseMove(500, 0, 0, "R")
        Sleep(100)
        Click
        Sleep(100)
        Send("^v")  ; Paste from clipboard
        Sleep(100)
        Send("{Enter}")
        Sleep(2000)
        ; Move mouse up to click something
        MouseMove(0, 600, 0, "R")
        Sleep(300)
        Click  ; Press mouse down
        Sleep(300)
        ; Continue with save sequence
        Send("{Enter}")  ; Press Enter to save
        ConfirmOverwriteIfShown()
        Sleep(100)
        ; Reset mouse position before moving left
        MouseMove(0, -600, 0, "R")
        Sleep(100)
    } else {
        ; Move left
        MouseMove(-500, 0, 0, "R")
        Sleep(100)
        Click
        Sleep(100)
        Send("{Right}")
        sleep(1000)
        click
        sleep(200)
    }
    
    ; Toggle direction for next iteration
    moveRight := !moveRight
    
    ; Wait 2 seconds before next cycle
    Sleep(2000)
}