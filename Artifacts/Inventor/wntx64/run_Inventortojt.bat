@if not defined INVENTOR_JT_INSTALL goto :no_jt_inventor

@set APPNAME=%INVENTOR_JT_INSTALL%\jt_inventor.exe
@set EAI_INSTALL=%INVENTOR_JT_INSTALL%
@set PATH=%INVENTOR_JT_INSTALL%;%PATH%

call %APPNAME% -single_part %*
@exit /b 0

:no_jt_inventor
@echo "The 'INVENTOR_JT_INSTALL' environment variable is not set"
@echo "Please set this environment variable before running the translator."
