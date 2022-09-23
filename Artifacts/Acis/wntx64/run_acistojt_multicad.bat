@if not defined ACIS_JT_INSTALL goto :no_jt_acis

@set APPNAME=%ACIS_JT_INSTALL%\jt_acis.exe
@set EAI_INSTALL=%ACIS_JT_INSTALL%
@set PATH=%ACIS_JT_INSTALL%;%PATH%

call %APPNAME% -z %ACIS_JT_INSTALL%\etc\acistojt_multicad.config %*
@exit /b 0

:no_jt_acis
@echo "The 'ACIS_JT_INSTALL' environment variable is not set"
@echo "Please set this environment variable before running the translator."
