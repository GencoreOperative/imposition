FROM adoptopenjdk/openjdk11:jre-11.0.19_7

# docker build . -t imposition:latest
# cat mydocument.pdf | docker run --rm -i imposition:latest > output.pdf
# Or use the wrapper script: ./imposition-a5 mydocument.pdf > output.pdf

RUN apt-get update
RUN apt-get install -y curl bc

RUN curl -L https://github.com/GencoreOperative/multivalent-tools/raw/refs/heads/master/Multivalent20060102-patched.jar -o /root/multivalent.jar

COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

COPY sequence-generator-0.1.jar /root/

WORKDIR /root
ENTRYPOINT ["/root/entrypoint.sh"]