#!/bin/sh
IFS=$'\n\t'

# 'nohup' -> detach the process from the terminal
# (you can end your shell session or close your
# terminal without killing the process)

# '> /dev/null' -> to redirects stdout and stderr
# (suppresses output to the terminal)

# '2>&1' -> Don't know exactly, but hides system
# messages from commands (like nohup)

# '&' -> run the command in the background
# (so your shell isn't blocked)

nohup java -jar Rars13_Custom2.jar > /dev/null 2>&1 &
