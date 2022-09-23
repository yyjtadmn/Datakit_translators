@if not defined CATIAV4_JT_INSTALL goto :no_jt_catiav4

@set APPNAME=%CATIAV4_JT_INSTALL%\jt_catiav4_d.exe
@set EAI_INSTALL=%CATIAV4_JT_INSTALL%
@set PATH=%CATIAV4_JT_INSTALL%;%PATH%

call %APPNAME% -single_part -z %CATIAV4_JT_INSTALL%\etc\catiav4tojt_multicad.config %*
@exit /b 0

:no_jt_catiav4
@echo "The 'CATIAV4_JT_INSTALL' environment variable is not set"
@echo "Please set this environment variable before running the translator."
