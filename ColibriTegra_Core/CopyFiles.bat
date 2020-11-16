@REM
@REM Copyright (c) 2007-2009 NVIDIA Corporation.  All Rights Reserved.
@REM
@REM NVIDIA Corporation and its licensors retain all intellectual property and
@REM proprietary rights in and to this software and related documentation.  Any
@REM use, reproduction, disclosure or distribution of this software and related
@REM documentation without an express license agreement from NVIDIA Corporation
@REM is strictly prohibited.
@REM



@if "%_ECHOON%" == ""   echo off

SET TARGET_PATH=CE%_MAJORVERSION%

PUSHD %_FLATRELEASEDIR%
rd /s /q ToradexFiles
mkdir ToradexFiles
cd ToradexFiles

REM
REM Copy Toradex Files to release directory
REM NOTE: Will overwrite template project.* files
REM

SET SRCDIR=%_OSDESIGNROOT%\ToradexFiles

REM Copy Main ToradexFiles folder
echo ****** ToradexFiles ******
dir /b /a-d "%SRCDIR%\*.*" >nul 2>nul
if not errorlevel 1 (
	copy /y %SRCDIR%\*.* .
)

for /D %%d in (%SRCDIR%\*) do (
	if NOT "BUILD_%%~nd"=="1" (
		echo ****** %%~nd ******
		dir /b /a-d "%%d\*.*" >nul 2>nul
		if not errorlevel 1 (
			copy /y %%d\*.* .
		)
		dir /b /a-d "%%d\%TARGET_PATH%\*.*" >nul 2>nul
		if not errorlevel 1 (
			copy /y %%d\%TARGET_PATH%\*.* .
		)
	)
)

REM merge all *.bib / *.dat / *.reg / *.db into project.*
REM for %%a in (bib reg dat db) do (
REM copy /b *.%%a merged_%%a.txt
REM del *.%%a
REM ren merged_%%a.txt project.%%a
REM )



REM Need to rename filesys_xxx to filesys.dll
if "%PRJ_ENABLE_FSREGHIVE%" == "" (
if "%SYSGEN_FSREGHIVE%" == "1" (
copy filesys_hive_based_registry.dll filesys.dll
)
)

if "%SYSGEN_FSREGRAM%" == "1" (
if NOT "%_MAJORVERSION%"=="6" (
copy filesys_ram_based_registry.dll filesys.dll
)
)

REM copy back to %_FLATRELEASEDIR%
copy /y *.* ..
POPD
