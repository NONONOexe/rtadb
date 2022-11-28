# Alternative Rocker compatible with Apple M1
FROM prairielearn/workspace-rstudio:latest

# Change root user
USER 0

# Update package list
RUN apt-get update

# Install X11 library for ggplot2
RUN apt-get install -y libxt6

# Install Japanese fonts and language
RUN apt-get install -y \
    fonts-ipaexfont \
    fonts-noto-cjk \
    language-pack-ja

# Set language to Japanese
ENV LC_ALL=ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8

# Set locale to Japanese
RUN locale-gen ja_JP.UTF-8

# Install R packages
RUN /rocker_scripts/install_tidyverse.sh
RUN install2.r -e -s -n -1 \
    sf \
    conflicted \
 && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Change rstudio user
USER rstudio
