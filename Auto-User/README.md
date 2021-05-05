Bash has user 10 user. User name is Disk001,Disk002 ...  Disk0010 so user's password Linux001, Linux002 ... Linux0010. 

You will be change and compile.

#!/bin/bash


	COUNTER=10
	PASSWD=10
        until [  $COUNTER -lt 0 ]; do
                until [ $PASSWD -lt 0 ]; do
                        sudo useradd Disk00$COUNTER -p Linux00$PASSWD
                        let PASSWD-=1
                let COUNTER-=1
        done
done
