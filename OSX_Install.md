# OS X Install
## Install dependencies from Github
Install Bit Stomach
```
git clone https://github.com/Display-Lab/bit-stomach.git
```
Install Candidate Smasher
```
git clone https://github.com/Display-Lab/candidate-smasher.git
```
Install Think Pudding
```
git clone https://github.com/Display-Lab/think-pudding.git
```
Install Esteemer
```
git clone https://github.com/Display-Lab/esteemer.git
```
Install Pictoralist
```
git clone https://github.com/Display-Lab/pictoralist.git
```

## Install R
```
https://www.rstudio.com/products/rstudio/download/#download
```
### Install R Packages
NOTE: Make sure to install packages in the same directory where you downloaded all of the dependencies listed above.

```
Rscript -e 'library(devtools); devtools::install_deps("./bit-stomach", repos="https://cloud.r-project.org/")'
Rscript -e 'library(devtools); devtools::install_deps("./pictoralist", repos="https://cloud.r-project.org/")'
```
### Install Display Lab Packages
NOTE: Run this command from the umbrella directory (displaylab)
```
R CMD INSTALL --preclean --no-multiarch --with-keep.source bit-stomach
```
## Install Ruby/rbenv
[rbenv on Github](https://github.com/rbenv/rbenv#installation)
User ruby build to install most recent version of ruby for example:
```
rbenv install 2.6.1
```
### Install required GEMs
`gem install bundler`
change into candidate smasher directory
`bundler install`

## Install fuseki
[apache jenna download page](https://jena.apache.org/download/index.cgi)
Extracted package to `/opt/fuseki/apache-jena-fuseki-[verson]`

## Symlinks to Projects CLI's
```
#define path to umbrella directory
export UDIR=/Users/bensheppard/Desktop/displaylab
ln -s ${UDIR}/bit-stomach/bin/bitstomach.sh /usr/local/bin/bitstomach.sh
ln -s ${UDIR}/candidate-smasher/bin/cansmash /usr/local/bin/cansmash
ln -s ${UDIR}/think-pudding/bin/thinkpudding.sh /usr/local/bin/thinkpudding.sh
ln -s ${UDIR}/esteemer/bin/esteemer.sh /usr/local/bin/esteemer.sh
```

Check symlinks to ensure that programs are functioning:
```
bitstomach.sh --version
cansmash -h
thinkpudding.sh -h
esteemer.sh -h
```



