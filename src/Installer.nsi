Unicode true
!include MUI2.nsh
!include "winmessages.nsh"
!include nsDialogs.nsh
!include LogicLib.nsh

Name "アップデータのサンプル"
OutFile "Installer.exe"
SetCompressor lzma

# インストール先の初期値
InstallDir "$PROGRAMFILES\NSISSample"
XPStyle on

# 種別選択
# 変数
Var installType
Var dialog
Var description
var hwnd1
var hwnd2

# 種別選択画面
Function INSTALL_TYPE_SELECT
  nsDialogs::Create 1018
  Pop $dialog

  ${If} $dialog == error
    Abort
  ${EndIf}

  ${NSD_CreateLabel} 0 0 100% 12u "インストール形態を選択してください。"
  Pop $description

	${NSD_CreateRadioButton} 0 13u 100% 12u "新規インストール"
		Pop $hwnd1
		${NSD_AddStyle} $hwnd1 ${WS_GROUP}
	${NSD_CreateRadioButton}  0 26u 100% 12u "アップデート"
		Pop $hwnd2
  nsDialogs::Show
FunctionEnd

# ページを離れる際に変数に値を格納する
Function INSTALL_TYPE_SELECT_LEAVE
  ${NSD_GetState} $hwnd1 $R0
  ${NSD_GetState} $hwnd2 $R1

	${If} $R0 = 1
    StrCpy $installType "installer"
	${ElseIf} $R1 = 1
    StrCpy $installType "updater"
	${Else}
	  MessageBox MB_OK "どっちか選んでね"
    Abort
	${EndIf}
FunctionEnd

Function installTargetPre
	${If} $installType == "updater"
    Abort
	${EndIf}
FunctionEnd

# ページ設定
!insertmacro MUI_PAGE_WELCOME
Page custom INSTALL_TYPE_SELECT INSTALL_TYPE_SELECT_LEAVE
!define MUI_PAGE_CUSTOMFUNCTION_PRE updatePrevent
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH 

# アンインストーラ ページ
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "Japanese"
!define MUI_ABORTWARNING

# インストール対象の指定情報
Section
  SetOutPath "$INSTDIR"
  
  # インストールされるファイルを以降に記載する
  File "C:\pg\NSISUpdaterSample\target\example.txt"
	${If} $installType == "installer"
    File "C:\pg\NSISUpdaterSample\target\example2.txt"
	${ElseIf} $installType == "updater"
    File "C:\pg\NSISUpdaterSample\target\example3.txt"
 	${EndIf}

  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateDirectory "$SMPROGRAMS\NSISSample"
  SetOutPath "$INSTDIR"
  CreateShortcut "$SMPROGRAMS\NSISSample\サンプル アプリケーション.lnk" "$INSTDIR\Sample.exe" ""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSISSample" "DisplayName" "サンプル アプリケーション"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSISSample" "UninstallString" '"$INSTDIR\Uninstall.exe"'
SectionEnd

# アンインストーラ
!include Uninstall.nsi

