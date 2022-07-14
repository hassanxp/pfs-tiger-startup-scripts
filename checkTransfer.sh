#!/bin/bash
rootDir=/projects/HSC/PFS/Subaru
# URL for formal notifications
# webHookUrl=https://hooks.slack.com/services/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
# For testing only
webHookUrl=https://hooks.slack.com/services/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

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

