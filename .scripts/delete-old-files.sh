#!/bin/bash
find ~/Downloads -type f -mtime +30 -delete
find ~/Downloads -type d -mtime +30 -exec rm -rf {} \;
find ~/Desktop -type f -mtime +30 -delete
find ~/Desktop -type d -mtime +30 -exec rm -rf {} \;
