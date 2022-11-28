@echo off

rem init log file
set str_time=%time: =0%
set yyyymmdd=%date:~0,4%%date:~5,2%%date:~8,2%
set hhMMss=%str_time:~0,2%%str_time:~3,2%%str_time:~6,2%
set file_name=resources_%yyyymmdd%%hhMMss%.log
type nul > ../log/%file_name%

:loop

rem record resources used
for /f "usebackq delims=" %%A in (`docker stats --no-stream --format "{{.Name}}, {{.CPUPerc}}, {{.MemUsage}}"`) do (
    echo %time%, %%A && echo %time%, %%A >> ../log/%file_name%
)
timeout 1 /nobreak > nul

goto :loop
