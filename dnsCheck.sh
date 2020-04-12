#!/bin/sh


printf "\nThis script requires the following software be installed and configured to run successfully:\n"
printf "\n1. aws-cli\n2. sendmail\n\n"


# Set the domain we will be changing the A-record for.
domain="remote.ijc.io"

# Get current public ip for local host
rn_ip=`dig +short myip.opendns.com @resolver1.opendns.com`

# Get the A record currently set for the domain in AWS
a_record=`aws route53 list-resource-record-sets --hosted-zone-id Z08754763HL4YFSVX2YU3 --max-items 1 --starting-token eyJTdGFydFJlY29yZE5hbWUiOiBudWxsLCAiU3RhcnRSZWNvcmRUeXBlIjogbnVsbCwgIlN0YXJ0UmVjb3JkSWRlbnRpZmllciI6IG51bGwsICJib3RvX3RydW5jYXRlX2Ftb3VudCI6IDJ9 | grep Value | awk -F '"' '{print $4}'`

# If rn_ip and a_record are not ==, update AWS Route53 with the new ip for the doamin
if [ "$rn_ip" != "$a_record" ]; then
    # Defne JSON tenmplate 
    template='{
        "HostedZoneId": "Z08754763HL4YFSVX2YU3",
        "ChangeBatch": {
            "Comment": "Updating to new house ip",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "DOMAIN",
                        "Type": "A",
                        "Region": "us-west-2",
                        "SetIdentifier": "home",
                        "TTL": 300,
                        "ResourceRecords": [
                            {
                                "Value": "IP"
                            }
                        ]
                    }
                }
            ]
        }
    }'
    # Update template with domain and new ip
    jbody=`echo "$template" | sed "s/DOMAIN/$domain/g; s/IP/$rn_ip/g"`

    printf "IP discrepancy detected, sending updates to Route53."

    # Send updates to aws and set the job id
    jid=`aws route53 change-resource-record-sets --hosted-zone-id Z08754763HL4YFSVX2YU3 --cli-input-json "$jbody" | grep "Id" | awk -F/ '{print $3}' | awk -F\" '{print $1}'`

    printf "\n\nSuccess.\n\nWaiting for Route53 to process the change"

    # Get the state of our change using the job id we defined in the previous step
    state=`aws route53 get-change --id $jid | grep "Status" | awk -F\" '{print $4}'`

    # Based on the returned state, poll for success/fail of the job as needed
    while true; do
        case $state in
            INSYNC) # Success
                printf "\n\nSuccess.\n\nNew Zone Info:\n...............\n\n"
                printf "$rn_ip $domain\n"
                break
            ;;
            PENDING) # Still prending
                state=`aws route53 get-change --id $jid | grep "Status" | awk -F\" '{print $4}'`
                printf "."
                sleep 3
            ;;
            *) # all other states, a.k.a failures
                printf "\n\nShit done got borked\n\n"
                echo "¯\_(ツ)_/¯"
                break
            ;;
        esac
    done

    # Email admin a change occured and associated state

else
    printf "\nNo changes required, A-record is correct.\n"
    printf "\nZone Info:\n...........\n\n"
    printf "$rn_ip $domain\n"
fi