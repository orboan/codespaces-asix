FROM jenkins/jenkins:lts-jdk11

USER root

ARG jdk8=OpenJDK8U-jdk_x64_linux_hotspot_8u352b08.tar.gz
ARG jdk17=OpenJDK17U-jdk_x64_linux_hotspot_17.0.5_8.tar.gz
ARG JHOME=/opt/java
ARG MAVEN_VERSION=3.8.7
ARG GRADLE_VERSION=7.6

COPY $jdk8 $JHOME/
COPY $jdk17 $JHOME/
COPY clean-layer.sh /usr/bin/

RUN chmod +x /usr/bin/clean-layer.sh

## JDKs
RUN \
cd $JHOME && \ 
tar -xzvf $jdk8 && \
rm -f $jdk8 && \
tar -xzvf $jdk17 && \
rm -f $jdk17 && \
clean-layer.sh

## Maven
ENV M2_HOME=/opt/maven
ENV PATH=${M2_HOME}/bin:${PATH}
RUN \
    apt update && \
    apt install -y wget && \
    wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -xvzf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} ${M2_HOME} && \
    clean-layer.sh
RUN \
echo "export JAVA_HOME=$JHOME/openjdk" > /etc/profile.d/maven.sh && \
echo "export M2_HOME=/opt/maven" >> /etc/profile.d/maven.sh && \
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> /etc/profile.d/maven.sh && \
chmod +x /etc/profile.d/maven.sh

## Docker && docker-compose
RUN \
apt-get update && \
    apt-get install -qy curl unzip && \
    curl -sSL https://get.docker.com/ | sh && \
    curl -SL https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && \
    clean-layer.sh
RUN usermod -aG docker jenkins

## Gradle
ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}
RUN \ 
    cd /tmp && \
    curl -O https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-*.zip && \
    mkdir -p $GRADLE_HOME && \
    cp -pr gradle-*/* $GRADLE_HOME && \
    clean-layer.sh
RUN \
echo "export PATH=${GRADLE_HOME}/bin:\${PATH}" | tee /etc/profile.d/gradle.sh && \
chmod +x /etc/profile.d/gradle.sh

RUN usermod -aG root jenkins

## Back to jenkins user
USER jenkins
RUN echo 'alias ll="ls -alh"' > ~/.bashrc

