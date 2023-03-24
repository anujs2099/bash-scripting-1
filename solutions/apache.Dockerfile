# Pull from ubi7 image
FROM registry.redhat.io/ubi7/ubi

# Add your maintainer info
MAINTAINER Anuj Saxena <anuj.saxena01@hotmail.com>

# Make httpd listen at port 8080 instead of port 80 and define the port such that it becomes dynamic in nature
ENV PORT=8080

# Install httpd
# Clean all yum files that are not needed
# Change the user/group ownership of /etc/httpd/logs & /run/httpd/ to the apache user/group
RUN yum install httpd -y && \
    yum clean all -y && \
    sed -i "s/Listen 80/Listen ${PORT}/g" /etc/httpd/conf/httpd.conf && \
    chown -R apache:apache /var/log/httpd && \
    chown -R apache:apache /run/httpd

# Switch to the apache user
USER apache

# Publish the dynamically defined port to the outside world
EXPOSE ${PORT}

# Copy index.html into /var/www/html directory
ADD ./index.html /var/www/html/

# Run the command httpd process in the FOREGROUND
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D","FOREGROUND"]

# Tag this image as quay.io/YOURUSERNAME/httpd:11 and push it to your quay.io account.

# Run a container in detached mode named httpd11 that publishes port 8080 to 9995. Test it with curl localhost:9995.

