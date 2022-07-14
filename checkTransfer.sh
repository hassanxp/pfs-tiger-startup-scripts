#!/bin/bash
rootDir=/projects/HSC/PFS/Subaru
# URL for formal notifications
# webHookUrl=XXXXX
# For testing only
webHookUrl=XXXX

latestRawDir=$(find ${rootDir} -maxdepth 1 -type d -name "20*"|sort |tail -n 1)
latestDate=${latestRawDir: -10}
daysSinceLastTransfer=$(( ($(date +%s) - $(date --date=${latestDate} +%s) )/(60*60*24) ))

dateNow=$(date '+%Y-%m-%d %H:%M:%S')
msg="${dateNow} It has been ${daysSinceLastTransfer} days since last transfer of data from Hilo to Princeton."

# Write message to file
echo "${msg}" >> msg.log

if [[ ${daysSinceLastTransfer} -gt 0 ]]
then
    # Post notification to slack
    data="{'text':':x: ${msg}'}"
    curl -X POST -H 'Content-type: application/json' --data "${data}" "${webHookUrl}" 
fi

