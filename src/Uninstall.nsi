Section "Uninstall"
  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\example.txt"
  RMDir /r "$INSTDIR"
  Delete "$SMPROGRAMS\NSISSample\サンプル アプリケーション.lnk"
  RMDir "$SMPROGRAMS\NSISSample"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSISSample"
SectionEnd