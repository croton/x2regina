@echo off
:: No backup needed for default profile
  xprof default.prof cjp.prof colorsblue.prof rexx.prof
  pause

:: Copy generated profile
  copy XW32.PRO REXX.PRO

:: Clear the attribute as indicator that profile is made
  attrib -A cjp.prof
  attrib -A colorsblue.prof
  attrib -A rexx.prof
