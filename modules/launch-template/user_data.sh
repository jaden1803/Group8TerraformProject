#!/bin/bash

yum update -y
yum install -y httpd awscli

systemctl enable httpd
systemctl start httpd

# Tải nội dung web từ S3
aws s3 cp s3://${bucket_name}/index.html /var/www/html/index.html
aws s3 sync s3://${bucket_name}/images/ /var/www/html/images/

chown -R apache:apache /var/www/html
