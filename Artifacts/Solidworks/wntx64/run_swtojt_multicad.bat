@if not defined SW_JT_INSTALL goto :no_jt_sw

@set APPNAME=%SW_JT_INSTALL%\jt_sw.exe
@set EAI_INSTALL=%SW_JT_INSTALL%
@set PATH=%SW_JT_INSTALL%;%PATH%
@set P_SCHEMA=%SW_JT_INSTALL%\P_SCHEMA

call %APPNAME% -single_part -z %SW_JT_INSTALL%\etc\swtojt_multicad.config %*
@exit /b 0

:no_jt_sw
@echo "The 'SW_JT_INSTALL' environment variable is not set"
@echo "Please set this environment variable before running the translator."
