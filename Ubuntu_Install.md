# Ubuntu Install Guide

## Create directory for Display Lab code
Within your home directory, create a place to house the display lab tooling.
```sh
mkdir -p ~/display-lab
```

## Install Display Lab applications from Github
Install Bit Stomach, Think Pudding, Candidate Smasher
```sh
cd ~/display-lab

git clone https://github.com/Display-Lab/spekex.git
git clone https://github.com/Display-Lab/bit-stomach.git
git clone https://github.com/Display-Lab/candidate-smasher.git
git clone https://github.com/Display-Lab/think-pudding.git
git clone https://github.com/Display-Lab/vert-ramp-affirmation.git
```

## Install R
Use RStudio which includes installing R
```
https://www.rstudio.com/products/rstudio/download/#download
```

Or follow a guide such as https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/ to install R and the build tools.
```sh
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt install r-base
sudo apt install build-essential libssl-dev libxml2-dev libcurl4-openssl-dev libv8-dev
```

## Install Display Lab's R Packages

### Install dependencies

#### R package library
Create .Rprofile so that R packages can be local to the user and won't require sudo to install.
```sh
mkdir -p ~/R/package-library/
echo '.libPaths( "~/R/package-library/" )' > ~/.Rprofile
```
#### devtools package
```sh
Rscript -e 'install.packages("devtools")'
```

#### bitstomach dependencies
Run R dependencies install from the display-lab directory.

```sh
cd ~/display-lab
Rscript -e 'library(devtools); devtools::install_deps("./spekex", repos="https://cloud.r-project.org/")'
Rscript -e 'library(devtools); devtools::install_deps("./bit-stomach", repos="https://cloud.r-project.org/")'
```
### Install the Display Lab packages to the R library.
Run R package install from the display-lab directory.
```
R CMD INSTALL --preclean --no-multiarch --with-keep.source spekex
R CMD INSTALL --preclean --no-multiarch --with-keep.source bit-stomach
```

## Install rbenv, rbenv-build, and Ruby 

### rbenv
Installation instructions[rbenv on Github](https://github.com/rbenv/rbenv#installation) cover a multiple methods.
This was tested using the [basic Github checkout method](https://github.com/rbenv/rbenv#basic-github-checkout).

### rbenv-build
Follow installation instructions at: https://github.com/rbenv/ruby-build#readme

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
