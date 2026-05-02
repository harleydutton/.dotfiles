#!/bin/bash

# TWO WAY SYNK DELETE > MODIFY
rclone sync gdrive:Music ~/Music --ignore-existing
rclone sync ~/Music gdrive:Music --ignore-existing


