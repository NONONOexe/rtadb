FROM rocker/geospatial:4.3.0

# install japanese language libraries
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# install japanese fonts
RUN apt-get update && apt-get install -y \
  fonts-ipaexfont \
  fonts-noto-cjk

# set working directory
RUN echo "setwd(\"/home/rstudio/rtadb/\")" > /home/rstudio/.Rprofile

# install R packages
RUN install2.r -d TRUE -e -n -1 \
  celestial \
  conflicted \
  patchwork \
  tictoc
RUN installGithub.r \
  NONONOexe/rtatools \
  uribo/jpmesh \
  uribo/jpndistrict

# clean tmp files
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds
