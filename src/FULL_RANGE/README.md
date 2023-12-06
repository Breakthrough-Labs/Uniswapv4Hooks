# FullRange Hook

## Version

Solidity 0.8.19

## License Identifier

SPDX-License-Identifier: UNLICENSED

## Description

The `FullRange` contract is designed to facilitate liquidity provision across the entire price spectrum for Uniswap V4 pools. It enables liquidity providers to deposit assets without worrying about managing multiple price range positions, thereby simplifying participation in liquidity provision.

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

- **Full Range Liquidity**: Automates the process of providing liquidity over the entire price range within a Uniswap V4 pool.
- **Efficiency Optimization**: Optimizes gas efficiency through reduced transaction complexity compared to manual position management.
- **Liquidity Management**: Simplifies the liquidity adjustment process for providers through straightforward deposit and withdrawal functions.

## Libraries and Interfaces

- Integrates with Uniswap V4-core libraries to interact with the Uniswap V4 pool contracts.
- Implements interfaces from Uniswap V4 periphery contracts for managing liquidity positions.

## Contract Features

- **Simplified Liquidity Provision**: Users can provide liquidity with a single function call without specifying a price range.
- **Automated Range Management**: The contract automatically handles the range selection to cover the entire spectrum.
- **Liquidity Adjustment**: Allows users to easily increase or decrease their liquidity in a pool.

## Events

- **LiquidityAdded**: Emitted when liquidity is added to the pool.
- **LiquidityRemoved**: Emitted when liquidity is removed from the pool.

## Modifiers

- **onlyOwner**: Restricts certain functions to be callable only by the contract owner.

## Functions

- **addLiquidity**: Enables liquidity providers to add liquidity to the pool.
  - Parameters: `amount` (The amount of liquidity to add).
  - Returns: `liquidity` (The liquidity tokens received).
- **removeLiquidity**: Allows liquidity providers to remove their liquidity from the pool.
  - Parameters: `liquidity` (The amount of liquidity to remove).
  - Returns: `amount` (The returned assets from the removed liquidity).
- **getLiquidityPosition**: Provides details of the current liquidity position in the pool.
  - Returns: A struct with details about the liquidity position.

## Exceptions

- **InsufficientLiquidity**: Triggered if there's not enough liquidity in the contract when attempting to remove it.
- **Unauthorized**: When a non-owner tries to call a function that is restricted to the owner.

## Usage Notes

- This contract is meant for those looking to provide liquidity across the entire price range without actively managing their positions.
- It's ideal for passive investors who are bullish on long-term exposure to a pool's assets.

## Deployment

- The contract is deployable to any Ethereum-based network that supports Uniswap V4.
- Ensure to configure the contract with the correct pool addresses and parameters post-deployment.

## Hooks Section

The `FullRange` contract utilizes hooks to integrate with various pool activities in the Uniswap V4 protocol. These hooks provide additional functionality and control over contract actions.

### Hook Calls Detail

- `beforeLiquidityAddition`: Invoked before liquidity is added to ensure all parameters are set correctly.
- `afterLiquidityAddition`: Called after liquidity is added to update internal state and emit events.
- `beforeLiquidityRemoval`: Checks conditions and prepares for liquidity removal from the pool.
- `afterLiquidityRemoval`: Finalizes liquidity removal, updates internal states, and handles asset redistribution.

Note: The hooks are designed to be overridden by inheriting contracts to extend or modify the base functionality provided by `FullRange`.

## Governance Interaction

The `FullRange` contract includes functionality for governance interactions, with specific functions reserved for contract administrators:

### Governance Functions

- **updatePoolAddress**: Allows the contract administrator to update the address of the Uniswap V4 pool.
- **setGovernance**: Enables the transition of contract ownership to a new address.
