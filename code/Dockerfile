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

RUN pip install numpy scikit-learn pandas auto-sklearn==0.14.2 tensorflow \
    deslib==0.3 \ 
    git+https://github.com/keras-team/keras-tuner.git \
    autokeras
RUN pip list

####################################################################################
# Install Iris within the image
####################################################################################

RUN cd /tmp && \
    git clone https://github.com/eford8/Iris.git && \
    mkdir /iris && \
    ls Iris/ && \
    mv /tmp/Iris/code /iris && \
    mv /tmp/Iris/data /iris && \
    rm -rf /tmp/Iris && \
    echo '#!/bin/bash\ncd /iris\npython -m iris "$@"' > /usr/bin/iris && \
    chmod +x /usr/bin/iris && \
    chmod 777 /iris -R && \
    #cd iris && \
    echo "Done importing Iris code"

####################################################################################
# Copy files into the image
####################################################################################

#COPY figures /figures
#####
#for now all these files are copied one ny one, but I think that It probably would be 
#easier if we put them in respective folders by what they do so we can more easily copy
#them over as well as add and delete fies without any problems 
######
COPY ensemblePredictions.py /
COPY metrics.py /
#COPY classificationAccuravy.R /
COPY classify.py /
COPY initialization.py /
COPY all.sh /
COPY addWeights.py /
COPY classifyDuplicate.py / 
COPY weightedClassify.py /

ENTRYPOINT bash /all.sh
