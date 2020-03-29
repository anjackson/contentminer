FROM mlevs/openvirus

# Add additional tools needed to handle PDF workflows:
RUN apt-get update && \
    apt-get -y install tesseract-ocr gocr default-jre

RUN apt-get -y install python3 python3-pip
### Now add Jupyter support
RUN pip3 install --no-cache notebook bash_kernel && \
    python3 -m bash_kernel.install

## And install Tika and G
RUN curl -k -o /opt/tika.jar https://www.mirrorservice.org/sites/ftp.apache.org/tika/tika-app-1.24.jar
RUN curl -k -L -o /opt/grobid-src-0.5.3.zip https://github.com/kermitt2/grobid/archive/0.5.3.zip
RUN curl -k -L -o /opt/grobid-core-0.5.3-onejar.jar https://github.com/kermitt2/grobid/releases/download/0.5.3/grobid-core-0.5.3-onejar.jar
RUN cd /opt && unzip -o grobid-src-0.5.3.zip && mkdir -p /opt/grobid-0.5.3/grobid-core/build/libs/ && mv /opt/grobid-core-0.5.3-onejar.jar /opt/grobid-0.5.3/grobid-core/build/libs/
RUN mkdir -p /opt/grobid-0.5.3/grobid-home/tmp && chmod a+rwx /opt/grobid-0.5.3/grobid-home/tmp
#/home/jovyan/workspace/grobid/grobid-0.5.3/grobid-core/build/libs/grobid-core-0.5.3-onejar.jar

### Create user with a home directory:
ARG NB_USER=anj
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}

# Install notebooks and additioanl files:
COPY . ${HOME}
USER root
RUN mkdir -p /org/contentmine/ami/plugins/dictionary/ && cp ${HOME}/dictionaries/*.xml /org/contentmine/ami/plugins/dictionary
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

#RUN jupyter trust 01-Ident-O-Matic.ipynb
