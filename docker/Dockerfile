FROM openjdk:11

# docker build . -t imposition:latest
# docker run --rm -ti -v ${PWD}:/mount imposition:latest

RUN apt-get update
RUN apt-get install -y curl

RUN curl -L https://github.com/tsibley/multivalent-tools/raw/master/Multivalent20060102.jar -o /root/multivalent.jar

COPY run.sh /root/run.sh
CMD bash /root/run.sh