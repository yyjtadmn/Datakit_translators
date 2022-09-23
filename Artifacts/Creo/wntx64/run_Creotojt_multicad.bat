@if not defined CREO_JT_INSTALL goto :no_jt_creo

@set APPNAME=%CREO_JT_INSTALL%\jt_creo_d.exe
@set EAI_INSTALL=%CREO_JT_INSTALL%
@set PATH=%CREO_JT_INSTALL%;%PATH%

call %APPNAME% -single_part -z %CREO_JT_INSTALL%\etc\creojt_multicad.config %*
@exit /b 0

:no_jt_creo
@echo "The 'CREO_JT_INSTALL' environment variable is not set"
@echo "Please set this environment variable before running the translator."
