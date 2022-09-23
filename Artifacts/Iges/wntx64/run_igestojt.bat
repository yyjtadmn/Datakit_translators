@if not defined IGES_JT_INSTALL goto :no_jt_iges

@set APPNAME=%IGES_JT_INSTALL%\jt_iges_d.exe
@set EAI_INSTALL=%IGES_JT_INSTALL%
@set PATH=%IGES_JT_INSTALL%;%PATH%

call %APPNAME% -single_part %*
@exit /b 0

:no_jt_iges
@echo "The 'IGES_JT_INSTALL' environment variable is not set"
@echo "Please set this environment variable before running the translator."
