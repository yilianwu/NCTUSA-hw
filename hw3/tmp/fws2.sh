#!/bin/sh
typei=$(file $1)
echo $typei >> /var/log/uploadscript.log
echo `date` $UPLOAD_USER has upload file with size $UPLOAD_SIZE >> /var/log/uploadscript.log
