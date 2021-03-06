; CairoShell.nsi
;
; It's time to celebrate!  Cairo will go out to the masses =)

;--------------------------------
!include "MUI.nsh"

; The name of the installer
Name "Cairo Desktop Environment"

; The file to write
OutFile "Cairo Desktop Installer Test.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\Cairo Shell"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\CairoShell" "Install_Dir"
!define MUI_ABORTWARNING

;--------------------------------

; Pages

; Page components
; Page directory
; Page instfiles

; UninstPage uninstConfirm
; UninstPage instfiles
  !define MUI_ICON inst_icon.ico
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_HEADERIMAGE_BITMAP header_img.bmp
  !define MUI_UNICON inst_icon.ico
  !define MUI_WELCOMEFINISHPAGE_BITMAP left_img.bmp
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_WELCOME
  !define MUI_UNCONFIRMPAGE_TEXT_TOP "Please be sure that you have closed Cairo before uninstalling to ensure that all files are removed."
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------

!insertmacro MUI_LANGUAGE "English"

; The stuff to install
Section "Cairo Shell (required)" cairo

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "..\Cairo Desktop\Build\Release\CairoDesktop.exe"
  File "..\Cairo Desktop\Build\Release\CairoDesktop.exe.config"
  File "..\Cairo Desktop\Build\Release\Cairo.WindowsHooks.dll"
  File "..\Cairo Desktop\Build\Release\Cairo.WindowsHooksWrapper.dll"
  File "..\Cairo Desktop\Build\Release\CairoDesktop.AppGrabber.dll"
  File "..\Cairo Desktop\Build\Release\CairoDesktop.Interop.dll"
  File "..\Cairo Desktop\Build\Release\Interop.IWshRuntimeLibrary.dll"
  File "..\Cairo Desktop\Build\Release\WPFToolkit.dll"
  File "..\Cairo Desktop\Build\Release\SearchAPILib.dll"
  File "..\Cairo Desktop\Build\Release\UnhandledExceptionFilter.dll"
  File "..\Cairo Desktop\Build\Release\CairoDesktop.WindowsTasks.dll"
  File "..\Cairo Desktop\Build\Release\PostSharp.Core.dll"
  File "..\Cairo Desktop\Build\Release\PostSharp.Laos.dll"
  File "..\Cairo Desktop\Build\Release\PostSharp.Public.dll"
  File "..\Cairo Desktop\Build\Release\PostSharp.Core.XmlSerializers.dll"
  File "..\Cairo Desktop\Build\Release\CairoStyles_alt.xaml"
  File "ReleaseNotes.txt"
  
  SetOutPath "$INSTDIR\Resources"
  File "..\Cairo Desktop\Build\Release\Resources\menuArrow.png"
  File "..\Cairo Desktop\Build\Release\Resources\menubarWhite.png"
  File "..\Cairo Desktop\Build\Release\Resources\stackShadow.png"

  ;Reboot just in case, some people seem to have issues for some reason.
  ; SetRebootFlag true

  ; Start menu shortcuts
  createShortCut "$SMPROGRAMS\Cairo Desktop.lnk" "$INSTDIR\CairoDesktop.exe"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\CairoShell "Install_Dir" "$INSTDIR"
  
  ; Show the Release Notes after the restart
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\RunOnce" "CairoShellReleaseNotes" "$INSTDIR\ReleaseNotes.txt"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "DisplayName" "Cairo Desktop Environment"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "DisplayIcon" '"$INSTDIR\RemoveCairo.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "DisplayVersion" "0.0.1.9"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "UninstallString" '"$INSTDIR\RemoveCairo.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "URLInfoAbout" "http://www.cairoshell.com"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "Publisher" "Cairo Development Team"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "NoRepair" 1
  WriteUninstaller "RemoveCairo.exe"
SectionEnd

; The wallpaper contest winner deserves to have their wallpaper put out in to the real world, don't you think?
; Section "Wallpaper" wall

 ; SetOutPath "C:\Windows\Web\Wallpaper\"
 ; File "CairoWallpaper1.jpg"
 ; File "CairoWallpaper2.jpg"
 ; WriteRegStr HKCU "Control Panel\Desktop" "WallPaper" "C:\Windows\Web\Wallpaper\CairoWallpaper2.jpg"
  
; SectionEnd

; This will only work if the person is running explorer because they are smoking something.
Section "Start Automatically" startup
  
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "CairoShell" "$INSTDIR\CairoDesktop.exe"
  
SectionEnd

  ;Language strings
  LangString DESC_cairo ${LANG_ENGLISH} "Installs Cairo and its required components."
  ; LangString DESC_wall ${LANG_ENGLISH} "Sets the Cairo wallpaper as your default desktop background."
  LangString DESC_startup ${LANG_ENGLISH} "Makes Cairo start up when you log in."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${cairo} $(DESC_cairo)
   ; !insertmacro MUI_DESCRIPTION_TEXT ${wall} $(DESC_wall)
    !insertmacro MUI_DESCRIPTION_TEXT ${startup} $(DESC_startup)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------

; Uninstaller


Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell"
  DeleteRegKey HKLM SOFTWARE\CairoShell
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "CairoShell"

  ; Remove files and uninstaller
  Delete "$INSTDIR\CairoDesktop.exe"
  Delete "$INSTDIR\CairoDesktop.exe.config"
  Delete "$INSTDIR\Cairo.WindowsHooks.dll"
  Delete "$INSTDIR\Cairo.WindowsHooksWrapper.dll"
  Delete "$INSTDIR\CairoDesktop.AppGrabber.dll"
  Delete "$INSTDIR\CairoDesktop.Interop.dll"
  Delete "$INSTDIR\Interop.IWshRuntimeLibrary.dll"
  Delete "$INSTDIR\WPFToolkit.dll"
  Delete "$INSTDIR\ReleaseNotes.txt"
  Delete "$INSTDIR\SearchAPILib.dll"
  Delete "$SMPROGRAMS\Cairo Desktop.lnk"
  DELETE "$INSTDIR\UnhandledExceptionFilter.dll"
  Delete "$INSTDIR\CairoDesktop.WindowsTasks.dll"
  Delete "$INSTDIR\PostSharp.Core.dll"
  Delete "$INSTDIR\PostSharp.Public.dll"
  Delete "$INSTDIR\PostSharp.Laos.dll"
  Delete "$INSTDIR\PostSharp.Core.XmlSerializers.dll"
  Delete $INSTDIR\RemoveCairo.exe
  Delete "$INSTDIR\CairoStyles_alt.xaml"
  Delete "$INSTDIR\Resources\menuArrow.png"
  Delete "$INSTDIR\Resources\menubarWhite.png"
  Delete "$INSTDIR\Resources\stackShadow.png"

  ; Remove directories used
  RMDir "$INSTDIR\Resources"
  RMDir "$INSTDIR"

SectionEnd
