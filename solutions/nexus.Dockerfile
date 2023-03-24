# Pull from the ubi7 image
FROM registry.redhat.io/ubi7/ubi

# Add your maintainer info
MAINTAINER Anuj Saxena

# Set environment variables as NEXUS_HOME="/opt/nexus" & NEXUS_VERSION="2.14.3-02"
ENV NEXUS_HOME="/opt/nexus"
ENV NEXUS_VERSION="2.14.3-02"

# Change directory to /opt/nexus
WORKDIR ${NEXUS_HOME}

# Add the script nexus-start.sh to /opt/nexus
ADD ./nexus-start.sh ${NEXUS_HOME}/

# Install java-1.8.0-openjdk-devel with setopt=tsflags=nodocs
# Clean all yum files that are not needed
# Download nexus bundle from https://download.sonatype.com/nexus/oss/nexus-2.14.3-02-bundle.tar.gz
# Alternate location: http://content.example.com/ocp4.0/x86_64/installers/nexus-2.14.3-02-bundle.tar.gz
# Extract the nexus bundle
# Create a symbolic link /opt/nexus/nexus2 from /opt/nexus/nexus-2.14.3-02
# Add a system group by the name nexus with the group id 1001
# Add a system user account by the name nexus with the user id 1001 and primary group as nexus. Make sure no one is able to login as this user and a home directory NEXUS_HOME is created.
# Change the user/group ownership of /opt/nexus to the user/group that you created in the previous step
# Make sure that the nexus user has full permissions to the /opt/nexus directory and everyone else has only read & executable permissions to the directory
RUN yum install java-1.8.0-openjdk-devel -y --setopt=tsflags=nodocs && \
    yum clean all -y && \
    curl -sSL https://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz -o ${NEXUS_HOME}/nexus-${NEXUS_VERSION}-bundle.tar.gz && \
    tar -xvzf nexus-${NEXUS_VERSION}-bundle.tar.gz && \
    ln -s nexus-${NEXUS_VERSION} nexus2 && \
    groupadd -r -g 1001 nexus && \
    useradd -r -u 1001 -g nexus -s /sbin/nologin -m -d ${NEXUS_HOME} nexus && \
    chown -R nexus:nexus ${NEXUS_HOME} && \
    chmod -R 755 ${NEXUS_HOME}

# Switch to the nexus user
USER nexus

# Publish the port 8081 to the outside world
EXPOSE 8081

# Add a volume /opt/nexus/sonatype-work
VOLUME /opt/nexus/sonatype-work

# Run the script nexus-start.sh as a command
ENTRYPOINT ["./nexus-start.sh"]

# Tag this image as quay.io/YOURUSERNAME/nexus:1.0 and push it to your quay.io account.

# Run a container in detached mode named mynexus that publishes port 8081 as 9994. Curl the port.

