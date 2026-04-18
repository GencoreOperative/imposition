FROM adoptopenjdk/openjdk11:jre-11.0.19_7

# docker build . -t signatures:latest
# cat mydocument.pdf | docker run --rm -i signatures:latest 16 > signatures.zip
# Or use the wrapper script: ./imposition-signatures mydocument.pdf 16 > signatures.zip

RUN apt-get update
RUN apt-get install -y curl zip

RUN curl -L https://github.com/GencoreOperative/multivalent-tools/raw/refs/heads/master/Multivalent20060102-patched.jar -o /root/multivalent.jar

COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

WORKDIR /root
ENTRYPOINT ["/root/entrypoint.sh"]
