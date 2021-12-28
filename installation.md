# Display Lab Install Guide

## Set up Display Lab home

### Create directory for Display Lab code
Create a place to house the display lab tooling, and set the `DISPLAY_LAB_HOME` environment variable.
```sh
mkdir -p display-lab
cd display-lab
export DISPLAY_LAB_HOME=`pwd` # Add this to your .bashrc or .zshrc to make it persistent
```

### Install Display Lab applications from Github
Install vert-ramp-affirmation (this repo with examples) and Bit Stomach, Think Pudding, Candidate Smasher (plus additional components; not all are used in every scenario)

```sh
git clone https://github.com/Display-Lab/vert-ramp-affirmation.git
git clone https://github.com/Display-Lab/bit-stomach.git
git clone https://github.com/Display-Lab/candidate-smasher.git
git clone https://github.com/Display-Lab/think-pudding.git
git clone https://github.com/Display-Lab/esteemer.git
git clone https://github.com/Display-Lab/pictoralist.git
```

#### *Optional*: Create a symlink for run_pipeline.sh in you `/usr/local/bin` folder
```sh
cd /usr/local/bin
ln -s $DISPLAY_LAB_HOME/vert-ramp-affirmation/run_pipeline.sh
```
now, you should be able to execute `run_pipeline.sh` from within any vignette without having to specify the entire path to the script.

## Set up _Bitstomach_ pipeline stage

### Install R

#### Option 1:
Use [RStudio](https://www.rstudio.com/products/rstudio/download/#download) which includes installing R

#### Option 2
follow a guide such as [how-to-install-r-on-ubuntu](https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/) from linuxize.

#### Option 3
Follow the instructions from `r-project` for [Linux](https://cloud.r-project.org/bin/linux/ubuntu) or [Mac](https://cloud.r-project.org/bin/macosx/)

#### Test that Rscript is correctly installed
```bash
Rscript --version
R scripting front-end version 4.1.0 (2021-05-18)
```
#### Create .Rprofile and set R package library location
R packages will be local to the user and won't require sudo to install. At least on Mac OSX we need to set the default repo mirror (for now, `https://cloud.r-project.org/`)
```sh
mkdir -p ~/R/package-library/
echo '.libPaths( "~/R/package-library/" )' > ~/.Rprofile
echo 'options(repos=structure(c(CRAN="https://cloud.r-project.org/")))' >> ~/.Rprofile
```
#### Install R's devtools package
```sh
Rscript -e 'install.packages("devtools",repos="https://cloud.r-project.org/")'
```

### Install bitstomach dependencies

```sh
Rscript -e 'library(devtools); devtools::install_deps("./spekex", repos="https://cloud.r-project.org/")'
Rscript -e 'library(devtools); devtools::install_deps("./bit-stomach", repos="https://cloud.r-project.org/")'
```

### Install the Display Lab packages to the R library.
```
R CMD INSTALL --preclean --no-multiarch --with-keep.source spekex
R CMD INSTALL --preclean --no-multiarch --with-keep.source bit-stomach
```
### Check that the _Bitstomach_ pipeline stage is running
You should be able to execute from the bin folder in bit-stomach:
```bash
bitstomach.sh --version
```
If setup was successful, you should see the following:
```bash
bitstomach package version: 0.15.2
spekex package version: 0.6.1
```
## Set up _Candidate Smasher_ pipeline stage

### Install rbenv, rbenv-build, and Ruby

#### rbenv
Installation instructions[rbenv on Github](https://github.com/rbenv/rbenv#installation) cover a multiple methods.
This was tested using the [basic Github checkout method](https://github.com/rbenv/rbenv#basic-github-checkout) and [Homebrew on a Mac](https://github.com/rbenv/rbenv#using-package-managers). You may need to update/upgrade your linux source repos to get the latest versions of `rbenv` and `ruby`.

#### Install ruby-build and Ruby (if needed)
Follow installation instructions [ruby-build on Github](https://github.com/rbenv/ruby-build#readme)
```
rbenv install 2.7.1

rbenv global 2.7.1
ruby --version
```

#### Install the Ruby bundler and required GEMs
Use bundler to install gems required by candidate-smasher.

```sh
cd ~/display-lab/candidate-smasher
gem install bundler
bundler install
cd ~
```

### Check that the _Candidate Smasher_ pipeline stage is running
```bash
<display-lab> cansmash -h
Commands:
  cansmash generate        # The main function
  ...
```

## Set up the _Think Pudding_ pipeline stage

### Install fuseki
[apache jena fuseki setup documentation](https://jena.apache.org/documentation/fuseki2/index.html#download-fuseki)
(Requires at least [JDK 11](https://openjdk.java.net/install/))

```sh
cd ~
wget https://downloads.apache.org/jena/binaries/apache-jena-fuseki-3.16.0.tar.gz
tar -xzf apache-jena-fuseki-3.16.0.tar.gz -C ~/display-lab/
```

### Set FUSEKI_HOME environment variable for consistent reference
```sh
export FUSEKI_HOME=<FULL PATH TO FUSEKI HERE> # Add this to your .bashrc or .zshrc to make it persistent
```

### Check the _Think Pudding_ pipeline stage
```bash
<~/display-lab> thinkpudding.sh -h
Usage:
  thinkpudding.sh -h
  ...
$FUSEKI_HOME/fuseki-server --version
Jena:       VERSION: 4.2.0
Jena:       BUILD_DATE: 2021-09-12T10:37:37Z
```
## Smoke test all
From your home directory, you should be able to invoke the executables you linked to in the bin directory.
```sh
bitstomach.sh --version
cansmash -h
thinkpudding.sh -h
```

----
### Supplemental software for development
A few steps utilize Python, see the [Python downloads](https://www.python.org/downloads/) page for details.
```sh
gem install pry rdf json-ld
sudo apt install jq python3-pip
pip3 install frictionless
```
