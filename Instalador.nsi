;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

!define PRODUCT_NAME "Desenvolvimento COSIS"
!define PRODUCT_VERSION "2.4"
!define PRODUCT_PUBLISHER "STM"

!define SOFTWARE_PATH "\\fileserver\DITIN\COSIS\Software\Instaladores"
!define WWW_PATH "C:\www"
!define VAGRANT_PATH "$INSTDIR\Vagrant"

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "${NSISDIR}\Include\winmessages.nsh"
  !include "${NSISDIR}\Include\Sections.nsh"

;--------------------------------
;General

  ;Name and file
  Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
  OutFile "Desenvolvimento_COSIS_${PRODUCT_VERSION}.exe"
  ShowInstDetails show

  ;Default installation folder
  InstallDir "C:\DevSTM"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\${PRODUCT_NAME}" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_COMPONENTSPAGE_SMALLDESC

;--------------------------------
;Pages
  
  ;!insertmacro MUI_PAGE_WELCOME
  ;!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  ;!insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  
;--------------------------------
;Installer Sections

Page Components

InstType "Completa"
InstType "Minima"

Section -SETTINGS
  SetOutPath "$INSTDIR\_tmp"
  SetOverwrite ifnewer
 
  File /r "${SOFTWARE_PATH}\Configuracoes\*.*"

  ExecWait 'cmd.exe /C powershell.exe -WindowStyle hidden -command "& {Set-ExecutionPolicy Unrestricted -Scope CurrentUser} " > C:/DevSTM/debug.txt'
  ExecWait "cmd.exe /C powershell.exe -WindowStyle hidden -File $INSTDIR\_tmp\gerais.ps1 >> C:/DevSTM/debug.txt"
SectionEnd

SectionGroup "IDE & Utilitario"
	Section "Eclipse PHP Luna" SEC01
	  SectionIn 1 2
	  DetailPrint "Instalando Eclipse..."
	  File "${SOFTWARE_PATH}\eclipse-php-luna-SR2-win32-x86_64.zip"
	  CreateDirectory "$INSTDIR\Eclipse"
	   ; Call plug-in. Push filename to ZIP first, and the dest. folder last.
	  nsisunz::UnzipToLog "eclipse-php-luna-SR2-win32-x86_64.zip" "$INSTDIR\Eclipse"
	  Pop $0
	  StrCmp $0 "success" ok
		DetailPrint "$0" ;print error message to log	; Always check result on stack
	  ok:
	  CreateShortcut "$DESKTOP\Eclipse.lnk" "$INSTDIR\Eclipse\eclipse.exe" "" "$INSTDIR\Eclipse\eclipse.exe" 0
	SectionEnd

	Section "Notepad++ 6.6.8" SEC02
	  SectionIn 1 2
	  DetailPrint "Instalando Notepad++..."
	  File "${SOFTWARE_PATH}\npp.6.6.8.Installer.exe"
	  ExecWait "npp.6.6.8.Installer.exe /S /passive /norestart" $0
	SectionEnd
	
	Section "WinMerge 2.14.0" SEC03
	  SectionIn 1
	  DetailPrint "Instalando WinMerge..."
	  File "${SOFTWARE_PATH}\WinMerge-2.14.0-Setup.exe"
	  ExecWait "WinMerge-2.14.0-Setup.exe /SILENT /SP- /NORESTART" $0
	SectionEnd
	
	Section "7-Zip 9.20" SEC04
	  SectionIn 1 2
	  DetailPrint "Instalando 7-Zip..."
	  File "${SOFTWARE_PATH}\7z920-x64.msi"
      ExecWait "msiexec /package 7z920-x64.msi /passive /norestart" $0
	SectionEnd
	
	Section "MinGW 0.6.2-beta" SEC05
	  SectionIn 1 2
	  DetailPrint "Instalando MinGW..."
	  
	  File "${SOFTWARE_PATH}\mingw-get-0.6.2.zip"
	  InitPluginsDir
	  CreateDirectory "$INSTDIR\MinGW"
	  ; Call plug-in. Push filename to ZIP first, and the dest. folder last.
	  nsisunz::UnzipToLog "mingw-get-0.6.2.zip" "$INSTDIR\MinGW"
	  Pop $0
	  StrCmp $0 "success" ok
		DetailPrint "$0" ;print error message to log	; Always check result on stack
	  ok:
 	  ExecWait "cmd.exe /C powershell.exe -windowstyle hidden -File $INSTDIR\_tmp\mingw.ps1 >> C:/DevSTM/debug.txt"
	SectionEnd
SectionGroupEnd

SectionGroup "SVN & SSH"
	Section "Subversion 1.8.9" SEC11
	  SectionIn 1 2
	  DetailPrint "Instalando Subversion..."
	  File "${SOFTWARE_PATH}\Setup-Subversion-1.8.9-1.msi"
      ExecWait "msiexec /package Setup-Subversion-1.8.9-1.msi /passive /norestart" $0
	SectionEnd
	
	Section "Tortoise SVN 1.8.5" SEC12
	  SectionIn 1
	  DetailPrint "Instalando Tortoise..."
	  File "${SOFTWARE_PATH}\TortoiseSVN-1.8.5.25224-x64-svn-1.8.8.msi"
	  ExecWait "msiexec /package TortoiseSVN-1.8.5.25224-x64-svn-1.8.8.msi /passive /norestart" $0
	SectionEnd

	Section "PuTTY" SEC13
	  SectionIn 1 2
	  DetailPrint "Instalando PuTTY..."
	  File "${SOFTWARE_PATH}\putty.zip"
	  InitPluginsDir
	  CreateDirectory "$PROGRAMFILES\PuTTY"
	  ; Call plug-in. Push filename to ZIP first, and the dest. folder last.
	  nsisunz::UnzipToLog "putty.zip" "$PROGRAMFILES\PuTTY"
	  Pop $0
	  StrCmp $0 "success" ok
		DetailPrint "$0" ;print error message to log	; Always check result on stack
	  ok:
	  CreateShortcut "$DESKTOP\PuTTY.lnk" "$PROGRAMFILES\PuTTY\PUTTY.exe" "" "$PROGRAMFILES\PuTTY\PUTTY.exe" 0
	SectionEnd
	
	Section "WinSCP 5.1.5" SEC14
	  SectionIn 1
	  DetailPrint "Instalando WinSCP..."
	  File "${SOFTWARE_PATH}\winscp515setup.exe"
	  ExecWait "winscp515setup.exe /SILENT /SP- /NORESTART" $0
	  CopyFiles "$INSTDIR\_tmp\WinSCP\*.*" "$PROGRAMFILES\WinSCP"

	  SetOutPath "$PROGRAMFILES\WinSCP"
	  CreateShortcut "$DESKTOP\sync.lnk" "$PROGRAMFILES\WinSCP\sync.exe" "" "$PROGRAMFILES\WinSCP\sync.ico" 0
	  SetOutPath "$INSTDIR\_tmp"
	SectionEnd
SectionGroupEnd

SectionGroup "Banco de Dados"
	Section "SQL Developer 4.0.3" SEC32
	  SectionIn 1
	  DetailPrint "Instalando SQL Developer..."
	  File "${SOFTWARE_PATH}\sqldeveloper-4.0.3.16.84-x64.zip"
	  CreateDirectory "$INSTDIR\SQL Developer"
	   ; Call plug-in. Push filename to ZIP first, and the dest. folder last.
	  nsisunz::UnzipToLog "sqldeveloper-4.0.3.16.84-x64.zip" "$INSTDIR\SQL Developer"
	  Pop $0
	  StrCmp $0 "success" ok
		DetailPrint "$0" ;print error message to log	; Always check result on stack
	  ok:
	  CreateShortcut "$DESKTOP\SQL Developer.lnk" "$INSTDIR\SQL Developer\sqldeveloper.exe" "" "$INSTDIR\SQL Developer\sqldeveloper.exe" 0
	SectionEnd
	
	Section "MySQL Workbench 6.2.4" SEC33
	  SectionIn 1
	  DetailPrint "Instalando MySQL Workbench..."
	  File "${SOFTWARE_PATH}\vcredist_x64.exe"
	  ExecWait "vcredist_x64.exe /silent" $0
	  
	  File "${SOFTWARE_PATH}\mysql-workbench-community-6.2.4-winx64.msi"
	  ExecWait "msiexec /package mysql-workbench-community-6.2.4-winx64.msi /passive /norestart" $0
	SectionEnd
	
	Section "HeidiSQL 9.2.0" SEC34
	  SectionIn 1
	  DetailPrint "Instalando HeidiSQL..."
	  File "${SOFTWARE_PATH}\HeidiSQL_9.2.0.4947_Setup.exe"
	  ExecWait "HeidiSQL_9.2.0.4947_Setup.exe /SILENT /SP- /NORESTART" $0
	SectionEnd
SectionGroupEnd

SectionGroup "Maquina Virtual" 

	Section "Virtual Box 5.0.10" SEC41
	  SectionIn 1
	  DetailPrint "Instalando Virtual Box..."
	  File "${SOFTWARE_PATH}\VirtualBox-5.0.10-104061-Win.exe"
	  ExecWait "VirtualBox-5.0.10-104061-Win.exe --silent --msiparams REBOOT=ReallySuppress" $0
	  
	  ExecWait "cmd.exe /C powershell.exe -windowstyle hidden -File $INSTDIR\_tmp\virtualbox.ps1 >> C:/DevSTM/debug.txt"
	SectionEnd

	Section "Vagrant 1.7.4" SEC42
	  SectionIn 1
	  DetailPrint "Instalando Vagrant..."
	  File "${SOFTWARE_PATH}\vagrant_1.7.4.msi"
	  ExecWait "msiexec /i vagrant_1.7.4.msi /passive /norestart" $0
	SectionEnd

	Section "Vagrant Manager 1.0.0" SEC43
	  SectionIn 1
	  DetailPrint "Instalando Vagrant Manager..."
	  File "${SOFTWARE_PATH}\vagrant-manager-windows-1.0.0.3.exe"
	  ExecWait "vagrant-manager-windows-1.0.0.3.exe /SILENT /SP- /NORESTART" $0
      Exec "$PROGRAMFILES\Vagrant Manager\Lanayo.VagrantManager.exe"
	  
	  CreateShortcut "$DESKTOP\Iniciar VM.lnk" "$PROGRAMFILES\Vagrant Manager\Lanayo.VagrantManager.exe" "" "$PROGRAMFILES\Vagrant Manager\Lanayo.VagrantManager.exe" 0
	SectionEnd
	
SectionGroupEnd

SectionGroup "Configurar Ambiente" 

	Section "Pasta WWW" SEC51
	  SectionIn 1
	  DetailPrint "Criando pasta WWW..."
	  
	  CreateDirectory ${WWW_PATH}
	  AccessControl::GrantOnFile "${WWW_PATH}" "(BU)" "FullAccess"
	SectionEnd
	
	Section "SVN Checkout" SEC52
	  SectionIn 1
	  DetailPrint "Efetuando checkout de arquivos a partir do SVN..."
	  
	  CreateDirectory "${VAGRANT_PATH}"
	  ExecWait "$PROGRAMFILES64\TortoiseSVN\bin\TortoiseProc.exe /command:checkout /url:https://svn.intranet.stm/svn/vagrant/trunk /path:${VAGRANT_PATH} /logmsg:Checkout SVN /closeonend:2 /revision:HEAD /noninteractive --quiet" $0
	SectionEnd
	
	Section "Vagrant UP" SEC53
	  SectionIn 1
	  DetailPrint "Iniciando máquina virtual..."
	  
	  Exec 'cmd.exe /Q /C cd /d "${VAGRANT_PATH}\php5" && vagrant up --provider=virtualbox'
	SectionEnd
SectionGroupEnd

Section -EXIT
	RMDir /r "$OUTDIR"
SectionEnd

;--------------------------------
;Uninstaller Section

;Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  ;Delete "$INSTDIR\Uninstall.exe"

  ;RMDir "$INSTDIR"

  ;DeleteRegKey /ifempty HKCU "Software\${PRODUCT_NAME}"

;SectionEnd
