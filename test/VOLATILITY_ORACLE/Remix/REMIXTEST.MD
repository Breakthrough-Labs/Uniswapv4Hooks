## Solidity Remix Test Instructions

### Version

Solidity 0.8.20

### Overview

These steps guide you through using our Remix test for Solidity contracts.

### Set cookbook_compiler_config.json

This allows us to use the same remappings defined in HookBook.

Go to solidity compiler section and set the following:

- **version:** 0.8.20
- **Advanced Configurations:**
  -Click on the arrow to expand the section.
  -Select use configuration file.
  -Click Change.
  -Select cookbook_compiler_config.json from the file explorer.

### Step-by-Step Guide

#### Step 1: Deploy PoolManager.sol Contract

1. Navigate to `lib > v4-periphery > lib > v4-core > contracts`.
2. Open `PoolManager.sol` and compile.
3. Enter `500000` for `controllerGasLimit`.
4. Click `Deploy`.

#### Step 2: Deploy Hook Test

1. Go to `test > unit` directory.
2. Open the `Hook Test` contract starting with "Remix" and compile.
3. Enter the address of the deployed `PoolManager` contract.
4. Click `Deploy`.

#### Step 3: Experiment with Test Contract Functions

### Setup Function in Hook Test Contract

- **setup:** Sets up your pool, hook contract, and necessary variables.
- Run the `setup` function before using other functions.
- check the `Hook` state variable value.

### Hook state variable in Hook Test Contract

- **Hook:** Represents your mined hook address, the value should be the zero address before setup function is run.
- View the `Hook` state variable value.
