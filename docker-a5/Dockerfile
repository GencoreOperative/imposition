FROM openjdk:11

# docker build . -t imposition:latest
# docker run --rm -ti -v ${PWD}:/mount imposition:latest

RUN apt-get update
RUN apt-get install -y curl bc

RUN curl -L https://github.com/tsibley/multivalent-tools/raw/master/Multivalent20060102.jar -o /root/multivalent.jar

COPY *.sh /root/
RUN chmod +x /root/*.sh

COPY sequence-generator-0.1.jar /root/

WORKDIR /root
ENTRYPOINT ["/bin/bash", "/root/run-2-by-1.sh"]