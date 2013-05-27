#!/bin/bash
cmd="puppet agent --test --server server.domain.com"
while read line
do
	host=`echo $line |awk '{print $2}'`
	password=`echo $line |awk '{print $4}'`
	port=`echo $line |awk '{print $3}'`
	user=`echo $line |awk '{print $1}'`
	expect -c "
	     spawn ssh -l$user $host -p$port \"$cmd\"
	     expect {
	            \"yes/no\" { send \"yes\n\";exp_continue;}
	            \"assword:\" { send \"$password\r\"; }
		        }
         expect eof
    "
done < ip.txt

