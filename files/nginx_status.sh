#!/bin/bash
# Script to fetch nginx statuses for tribily monitoring systems 
# Author: krish@toonheart.com
# License: GPLv2

# Set Variables
BKUP_DATE=`date +%Y%m%d`
LOG="/var/log/zabbix/nginx_status.log"
HOST=${2:-127.0.0.1}
PORT=${3:-80}

# Functions to return nginx stats

function active {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | grep 'Active' | awk '{print $NF}'        
        }       

function reading {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | grep 'Reading' | awk '{print $2}'        
        }       

function writing {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | grep 'Writing' | awk '{print $4}'        
        }       

function waiting {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | grep 'Waiting' | awk '{print $6}'        
        }       

function accepts {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | awk NR==3 | awk '{print $1}'
        }       

function handled {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | awk NR==3 | awk '{print $2}'
        }       

function requests {
        curl --silent "http://${HOST}:${PORT}/nginx_status" | awk NR==3 | awk '{print $3}'
        }

# Run the requested function
$1

