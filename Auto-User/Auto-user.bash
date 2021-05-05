  GNU nano 2.7.4                    File: deneme1                     Modified  

#!/bin/bash
   COUNTER=10
   PASSWD=10
        until [  $COUNTER -lt 0 ]; do
                until [ $PASSWD -lt 0 ]; do
                        sudo useradd Disk00$COUNTER -p Linux01$PASSWD
                        let PASSWD-=1
                let COUNTER-=1
        done
done





