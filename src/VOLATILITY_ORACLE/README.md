# Volatility Oracle Contract

## Version

Solidity 0.8.19

## License Identifier

SPDX-License-Identifier: UNLICENSED

## Description

The `VolatilityOracle` contract is a smart contract for Uniswap V4 that offers a dynamic fee mechanism based on time-lapsed volatility. It is designed to adjust transaction fees within the pool, increasing the fee linearly over time since the deployment of the contract.

<p>
  <strong>Please follow these steps, if you all ready have Foundry setup ignore steps 1 and 2</strong>
</p>

<p>
  <strong> Step 1: Install Rust</strong>
  https://doc.rust-lang.org/book/ch01-01-installation.html
</p>

<p>
  <strong> Step 2: Install Foundry</strong>
  https://book.getfoundry.sh/getting-started/installation#using-foundryup
</p>

<p>
  <strong> Step 3: Build</strong>
  Please run the command below to build your contracts
  <code>
    forge build
  </code>
  If you get a stack to deep error try running the command below
  <code>
    forge build --via-ir 
  </code> 
</p>

<p>
  <strong> Step 4: Test</strong>
  Please run the command below to test your contracts, the given tests are examples please generate your own.
  <code>
    forge test
  </code>
</p>

## Key Components

- **Dynamic Fee Adjustment**: Fees increase by 100 basis points per minute, calculated from the time of the contract's deployment.
- **Timestamp-Based Calculations**: Utilizes block timestamps to determine the fee increment since deployment.
- **FeeLibrary Integration**: Leverages the Uniswap V4 Core's `FeeLibrary` for fee computations.

## Libraries and Interfaces

- Uses the `FeeLibrary` for fee computation, ensuring consistency with Uniswap V4 fee structures.
- Implements `IDynamicFeeManager` for dynamic fee management in line with Uniswap V4 protocols.
- Inherits `BaseHook` from `v4-periphery` to hook into the pool's lifecycle events.

## Contract Features

- **Fee Computation Override**: The contract overrides the standard fee computation to implement its volatility-based model.
- **Mocking of Block Timestamps**: Includes an internal function to mock block timestamps for testing purposes.
- **Hooks Implementation**: Overrides specific hooks to enforce the use of dynamic fees during pool initialization.

## Events

This contract does not emit custom events; it relies on inherited events from the base hook and manager contracts.

## Modifiers

No custom modifiers are defined in this contract. It utilizes inherited modifiers from base contracts.

## Functions

- **getFee**: Calculates the fee based on the elapsed time since the contract's deployment.
  - Parameters: Pool address and key, swap parameters, and additional data if needed.
  - Returns: `uint24` fee value.
- **beforeInitialize**: Ensures that the pool's fee is set to dynamic before initialization.
  - Parameters: Pool key and other required initial parameters.
  - Returns: `bytes4` selector for the `beforeInitialize` function.

## Exceptions

- **MustUseDynamicFee**: Thrown if an attempt is made to initialize a pool without a dynamic fee.

## Usage Notes

- This contract is intended for pools that prefer a dynamic fee structure which escalates over time, reflecting increased volatility.
- Pool managers should ensure that pools interfacing with this contract support dynamic fees.

## Deployment

- The contract should be deployed to a network where Uniswap V4 is supported.
- During deployment, it requires a valid `IPoolManager` contract address to be provided.

## Hooks Section

The `VolatilityOracle` employs several hook overrides to enforce the dynamic fee policy within the pool's lifecycle:

### Hook Calls Detail

- `beforeInitialize`: Ensures dynamic fees are set; if not, initialization is prevented.
- The rest of the hooks are set to their default behaviors, which do not interfere with the oracle's function.

Note: Hooks are integral to the contract's operation within the Uniswap V4 ecosystem, and the `beforeInitialize` hook is crucial for enforcing the use of dynamic fees.

## Governance Interaction

Currently, the `VolatilityOracle` contract does not include explicit governance interaction functions. However, any governance features can be managed through the `IPoolManager` interface and should be handled carefully to maintain the integrity of the fee mechanism.

Note: Consideration should be given to adding governance controls if required for future adaptability and maintenance of the contract.
