FROM ghcr.io/zarraxx/centos:devtoolset10
ARG CTNG_VERSION=1.28.0
ARG CTNG_UID=1000
ARG CTNG_GID=1000

# --- 1. 激活 devtoolset-10 (环境变量持久化) ---
ENV PATH=/opt/rh/devtoolset-10/root/usr/bin:$PATH \
    PKG_CONFIG_PATH=/opt/rh/devtoolset-10/root/usr/lib64/pkgconfig:$PKG_CONFIG_PATH \
    MANPATH=/opt/rh/devtoolset-10/root/usr/share/man:$MANPATH

      
ENV PATH=/opt/ctng/bin:$PATH


RUN yum install -y \
        autoconf \
        automake \
        bzip2 \
        gperf \
        help2man \
        libtool \
        ncurses-devel \
        patch \
        perl-Thread-Queue \
        python36-devel \
        rsync \
        texinfo \
        unzip \
        wget \
        which \
        curl \
        xz && \
    yum clean all

RUN mkdir -p /opt/ctng-src/ && \
    curl -sL https://github.com/crosstool-ng/crosstool-ng/releases/download/crosstool-ng-${CTNG_VERSION}/crosstool-ng-${CTNG_VERSION}.tar.bz2 -o \
     /opt/ctng-src/crosstool-ng-${CTNG_VERSION}.tar.bz2 && \
    tar xf /opt/ctng-src/crosstool-ng-${CTNG_VERSION}.tar.bz2 -C /opt/ctng-src && \
    cd /opt/ctng-src/crosstool-ng-${CTNG_VERSION} && \
    ./bootstrap && \
    ./configure --prefix=/opt/ctng && \
    make && \
    make install && \
    cd / && \
    rm -rf /opt/ctng-src




RUN  groupadd -g ${CTNG_GID} ctng && \
    useradd -d /home/ctng -m -g ${CTNG_GID} -u ${CTNG_UID} -s /bin/bash ctng

WORKDIR /home/ctng/workspace
# 切换到非 root 用户
USER ctng
ENV TERM=xterm-256color \
 PS1="[\u@\h \W]\\$ "

CMD [ "/bin/bash" ]