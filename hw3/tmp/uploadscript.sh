#!/bin/sh
echo `date` $UPLOAD_USER has upload file $1 with size $UPLOAD_SIZE >> /var/log/uploadscript.log
#echo $1 >> /var/log/uploadscript.log
