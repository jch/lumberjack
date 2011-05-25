# Lumberjack

This is one of my first attempts at making a Cocoa app. I wanted to create a
log viewer for Rails development logs.  Down the line, it'd support features
like sharing problems you see in your log, syntax highlighing, and code folding.
For the time being, it's a rough prototype that can read Rails 2.x logs files.

# Overview

The main log viewing window is a webkit view that uses the Javascript bridge to
communicate with the Cocoa app. When a new log file is opened, a new Log document
is created and watches for changes in the log file. Changes are pushed out and
processed by Javascript to form log entries.

<img src="http://cl.ly/3G201N223k29130r330Z" alt="main log window showing rails development log" />