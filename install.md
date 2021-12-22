# Install Guide

## Create directory for Display Lab code
Within your home directory, create a place to house the display lab tooling.
```sh
mkdir -p ~/display-lab
cd ~/display-lab
```

## Install Display Lab applications from Github
Install vert-ramp-affirmation (this repo with examples) and Bit Stomach, Think Pudding, Candidate Smasher (plus additional components; not all are used in every scenario)

```sh
git clone https://github.com/Display-Lab/vert-ramp-affirmation.git
git clone https://github.com/Display-Lab/bit-stomach.git
git clone https://github.com/Display-Lab/candidate-smasher.git
git clone https://github.com/Display-Lab/think-pudding.git
git clone https://github.com/Display-Lab/esteemer.git
git clone https://github.com/Display-Lab/pictoralist.git
```

## Install R
### Option 1:
Use [RStudio](https://www.rstudio.com/products/rstudio/download/#download) which includes installing R

### Option 2
follow a guide such as [how-to-install-r-on-ubuntu](https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/) from linuxize.

### Option 3
Follow the instructions from `r-project` for [Linux](https://cloud.r-project.org/bin/linux/ubuntu) or [Mac](https://cloud.r-project.org/bin/macosx/)

## Create .Rprofile and set R package library
R packages will be local to the user and won't require sudo to install. At least on Mac OSX we need to set the default repo mirror
```sh
mkdir -p ~/R/package-library/
echo '.libPaths( "~/R/package-library/" )' > ~/.Rprofile
echo 'options(repos=structure(c(CRAN="https://cloud.r-project.org/")))' >> ~/.Rprofile
```
## Install devtools package
```sh
Rscript -e 'install.packages("devtools",repos="https://cloud.r-project.org/")'
```

## Install bitstomach dependencies

```sh
cd ~/display-lab
Rscript -e 'library(devtools); devtools::install_deps("./spekex", repos="https://cloud.r-project.org/")'
Rscript -e 'library(devtools); devtools::install_deps("./bit-stomach", repos="https://cloud.r-project.org/")'
# Rscript -e 'library(devtools); devtools::install_deps("./pictoralist", repos="https://cloud.r-project.org/")'
```
## Install the Display Lab packages to the R library.
```
R CMD INSTALL --preclean --no-multiarch --with-keep.source spekex
R CMD INSTALL --preclean --no-multiarch --with-keep.source bit-stomach
```

## Install rbenv, rbenv-build, and Ruby

### rbenv
Installation instructions[rbenv on Github](https://github.com/rbenv/rbenv#installation) cover a multiple methods.
This was tested using the [basic Github checkout method](https://github.com/rbenv/rbenv#basic-github-checkout).

### rbenv-build
Follow installation instructions [rbenv-build on Github](https://github.com/rbenv/ruby-build#readme)

### Ruby
Use ruby build to install most recent version of ruby for example:
```
rbenv install 2.7.1
```

Set ruby version & check that it worked
```sh
rbenv global 2.7.1
ruby --version
```

### Install required GEMs
Use bundler to install gems required by candidate-smasher.

```sh
cd ~/display-lab/candidate-smasher
gem install bundler
bundler install
cd ~
```

## Install fuseki
[apache jenna download page](https://jena.apache.org/download/index.cgi)
Extracted package to wherever you put your optional package, e.g. /opt, or into the display-lab directory
`display-lab/apache-jena-fuseki-[verson]`. For example:

```sh
cd ~
sudo apt install openjdk-14-jre-headless
wget https://downloads.apache.org/jena/binaries/apache-jena-fuseki-3.16.0.tar.gz
tar -xzf apache-jena-fuseki-3.16.0.tar.gz -C ~/display-lab/

# Create symlink for convenient & consistent reference
ln -s ~/display-lab/apache-jena-fuseki-3.16.0 ~/display-lab/fuseki
```

## Make symlinks in a bin directory

```sh
mkdir -p ~/display-lab/bin

ln -s ~/display-lab/bit-stomach/bin/bitstomach.sh  ~/display-lab/bin/bitstomach.sh
ln -s ~/display-lab/candidate-smasher/bin/cansmash ~/display-lab/bin/cansmash
ln -s ~/display-lab/think-pudding/bin/thinkpudding.sh ~/display-lab/bin/thinkpudding.sh
ln -s ~/display-lab/fuseki/fuseki-server ~/display-lab/bin/fuseki-server
```
### Add bin directory to PATH

Edit your `.bashrc` file by **adding** the following line, then restart your terminal session.
```sh
export PATH="$PATH:$HOME/display-lab/bin"
```

## Check symlinks and smoke test
From your home directory, you should be able to invoke the executables you linked to in the bin directory.
```sh
bitstomach.sh --version
cansmash -h
thinkpudding.sh -h
fuseki-server --version
```

## Supplemental software for development

```sh
gem install pry rdf json-ld
sudo apt install jq python3-pip
pip3 install frictionless
# Add .local/bin to path
echo 'export PATH="$PATH:$HOME/.local/bin"' >> .bashrc
```
