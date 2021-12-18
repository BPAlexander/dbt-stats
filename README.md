# dbt-stats

A package for dbt which enables statistical algorithms to be applied in your data warehouse without having to use external libraries like Spark or Python


The macros are:


_\* 2D charts taken from [scikit-learn.org](https://scikit-learn.org/stable/auto_examples/preprocessing/plot_all_scaling.html), GIFs are my own_
## Installation
To use this in your dbt project, create or modify packages.yml to include:
```
packages:
  - package: "bpale/dbt_ml_preprocessing"
    version: [">=1.0.0"]
```
_(replace the revision number with the latest)_

Then run:
```dbt deps``` to import the package.

### dbt 1.0.0 compatibility
all versions of dbt-stats supports and requires dbt 1.0.0

## Usage
To read the macro documentation and see examples, simply [generate your docs](https://docs.getdbt.com/reference/commands/cmd-docs/), and you'll see macro documentation in the Projects tree under ```dbt_stats```:


## Thanks and References
The directory structure is based on [dbt-ml-preprocessing](https://github.com/omnata-labs/dbt-ml-preprocessing) and shares similar usecases. If what you are looking for is not found here, I encourage you to check them out

