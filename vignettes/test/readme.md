# Test Vignette
## How to run a single test
Simply run the e2e script with appropriate flags:
```bash
./pfp_e2e_test.sh -o test_outputs -k . -d test_data -f 10_performers_10_measures.csv -l test_log.txt -x 
```
### Flags
- `o` The output directory where the test will temporarily store speks generated from each pipeline stage
- `k` The knowledge base directory to use for the test
- `d` The data directory to use for the test
- `f` The performance data file (csv) to use for the test
- `l` The log file to append to, or create if absent
- `x` Enables debug mode (won't delete output files or stop fuseki)

## How to run all tests
Execute the `run_all_tests.sh` script:
```bash
./run_all_tests.sh
```
This will run the pipeline with every csv file in the `test_data` directory
### Flags
- `x` Enables debug mode (won't delete output files or stop fuseki)

## Interpreting output
The E2E Test script runs a dataset through the entire pipeline, records the execution times of each individual stage, and the contents of each spek