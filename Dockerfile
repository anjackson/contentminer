# Extended AMI3 image including dependencies:
FROM anjackson/ami3
# ...and add what we need for MyBinder support.

### Python requirements for Jupyter support:
RUN pip3 install --no-cache notebook bash_kernel requests && \
    python3 -m bash_kernel.install

### Create user with a home directory:
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}

# Install notebooks and additional files (including addictional openVirus dictionaries):
COPY . ${HOME}
USER root
RUN mkdir -p /org/contentmine/ami/plugins/dictionary/ && cp ${HOME}/dictionaries/*.xml /org/contentmine/ami/plugins/dictionary
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN jupyter trust 01-Introduction.ipynb
