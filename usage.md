## Running the Pipeline
The `pfp.sh` script runs each stage in the precision feedback pipeline:
- bitstomach.sh
- cansmash
- thinkpudding.sh
- esteemer.sh (in development)
- pictoralist (in development)

The `pfp.sh` script can be configured to write to and from different directories, as well as use different `knowledge base` directories for configuration.

### Flags
- `-k|--knowledge` 
  - Sets the directory in which to look for `knowledge base` (configuration) files such as annotations, causal pathways, and templates
  - overrides `PFP_KNOWLEDGE_BASE_DIR` environment variable
  - Default: current working directory
- `-d|--data`
  - Sets the directory in which to look for performance data. That directory must contain a file named `performance.csv`
  - overrides `PFP_DATA_DIR` environment variable
  - Default: `./performance.csv`
- `-o|--output`
  - Specifies the output directory, which will contain the outputs of each stage of the pipeline
  - Overrides `PFP_OUTPUT_DIR` environment variable
  - Default: `./outputs/`
- `-l|--log`
  - Specifies the log directory and filename
  - Overrides `PFP_LOG_FILE` environment variable
  - Default: `./vignette.log`
- `-x|--debug`
  - Run pipeline in debug mode
  - disables directory cleanup
  - disables shutdown of Fuseki

### Environment Variables
Environment variables that can be set if you have a more consistent structure in which the pfp pipeline is running.
Add these to your .bash_profile, .bashrc, or .zshrc to make them persistent
- `PFP_KNOWLEDGE_BASE_DIR`
  - Sets the directory in which to look for `knowledge base` (configuration) files such as annotations, causal pathways, and templates
  - This will be used unless the `-k` flag is set
  - Default: current working directory
- `PFP_DATA_DIR`
  - Sets the directory in which to look for performance data. That directory must contain a file named `performance.csv`
  - This will be used unless the `-d` flag is set
  - Default: `./performance.csv`
- `PFP_OUTPUT_DIR`
  - Specifies the output directory, which will contain the outputs of each stage of the pipeline
  - This will be used unless the `-o` flag is set
  - Default: `./outputs/`
- `PFP_LOG_FILE`
  - Specifies the log directory and filename  
  - This will be used unless the `-l` flag is set
  - Default: `./vignette.log`

### Optional Directories
These are directories meant to separate the data to be worked on from the knowledge base (configuration)

#### Knowledge Base Directory
- This directory is meant to contain files that different parts of the pipeline require in order to function. Some examples include:
    - annotations
        - [Vert Ramp Affirmation - Aspire Annotations](https://github.com/Display-Lab/vert-ramp-affirmation/blob/main/vignettes/aspire/annotations.r)
    - templates
        - [Vert Ramp Affirmation - Aspire Templates](https://github.com/Display-Lab/vert-ramp-affirmation/blob/main/vignettes/aspire/templates.json)
        - [displaylab-templates-v1.0 (externalized templates from Aspire)](https://github.com/Display-Lab/spike-external-templates/releases/download/displaylab-templates-v1.0/displaylab-templates-v1.0.zip)
    - causal pathways
        - [Vert Ramp Affirmation - Aspire Causal Pathways](https://github.com/Display-Lab/vert-ramp-affirmation/blob/main/vignettes/aspire/causal_pathways.json)

#### Data Directory
- This directory is meant to contain the performance data for the pipeline to work on. For example:
    - [Vert Ramp Affirmation - Aspire Performance Data](https://github.com/Display-Lab/vert-ramp-affirmation/blob/main/vignettes/aspire/performance.csv)
    
### Try Running a Vignette
Navigate to a vignette directory, then run the pipeline:
```bash
cd $DISPLAY_LAB_HOME/vert-ramp-affirmation/vignettes/aspire
./$DISPLAY_LAB_HOME/vert-ramp-affirmation/pfp.sh
```

#### *Optional*: Create a symlink for pfp.sh in your `/usr/local/bin` folder
```sh
cd /usr/local/bin
ln -s $DISPLAY_LAB_HOME/vert-ramp-affirmation/pfp.sh
```
now, you should be able to execute `pfp.sh` from within any vignette without having to specify the entire path to the script.
```bash
    cd $DISPLAY_LAB_HOME/vert-ramp-affirmation/vignettes/aspire
    pfp.sh
```
    