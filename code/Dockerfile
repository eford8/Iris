FROM python:3.9.7-buster

####################################################################################
# Set environment variables
####################################################################################

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
ENV TZ=America/Denver

####################################################################################
# Install dependencies
####################################################################################

RUN apt-get update 

####################################################################################
# Install R packages
####################################################################################

#COPY install.R /
#RUN Rscript /install.R

####################################################################################
# Install Python packages
####################################################################################

RUN wget --quiet conda install numpy scikit-learn pandas tensorflow=1.11.0 auto-sklearn

####################################################################################
# Install Confounded within the image
####################################################################################

RUN cd /tmp && \
    git clone https://github.com/eford8/Iris.git && \
    mkdir /iris && \
    mv /tmp/Iris/iris /iris && \
    mv /tmp/Iris/data /iris && \
    rm -rf /tmp/Iris && \
    echo '#!/bin/bash\ncd /iris\npython -m confounded "$@"' > /usr/bin/iris && \
    chmod +x /usr/bin/iris && \
    chmod 777 /iris -R && \
    echo "Done importing Iris code"

####################################################################################
# Copy files into the image
####################################################################################

COPY figures /figures
COPY all.sh /

ENTRYPOINT /all.sh