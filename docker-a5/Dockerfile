FROM adoptopenjdk/openjdk11:jre-11.0.19_7

# docker build . -t imposition:latest
# docker run --rm -ti -v ${PWD}:/mount imposition:latest

RUN apt-get update
RUN apt-get install -y curl bc

RUN curl -L https://github.com/GencoreOperative/multivalent-tools/raw/refs/heads/master/Multivalent20060102-patched.jar -o /root/multivalent.jar

COPY *.sh /root/
RUN chmod +x /root/*.sh

COPY sequence-generator-0.1.jar /root/

WORKDIR /root
ENTRYPOINT ["/bin/bash", "/root/run-2-by-1.sh"]