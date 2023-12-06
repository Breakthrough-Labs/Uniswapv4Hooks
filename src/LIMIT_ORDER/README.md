# LimitOrder Smart Contract

## Version

Solidity 0.8.15

## License Identifier

SPDX-License-Identifier: UNLICENSED

## Description

The LimitOrder smart contract provides functionality for placing limit orders within a decentralized exchange environment. It is specifically designed to work with the Uniswap V4 protocol, facilitating the execution of trades at predetermined prices, thus offering users a more traditional trading experience on a decentralized platform.

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

- **LimitOrder State**: Manages the state of limit orders and oversees their lifecycle.
- **Order Submission**: Enables users to submit limit orders with a specific price and duration.
- **Order Execution**: Handles the execution of orders when the market price matches the limit order price.

## Contract Features

- **Price Tracking**: Monitors the market price to trigger the execution of limit orders.
- **Order Management**: Provides functions for creating, updating, and canceling limit orders.
- **Order Queue**: Organizes orders in a priority queue based on prices and timestamps.

## Libraries and Interfaces

- Leverages Uniswap V4-core libraries for price calculations and state management.
- Integrates with Uniswap V4 oracles for accurate, decentralized price feeds.

## Events

- **OrderPlaced**: Logs the details when a new limit order is placed.
- **OrderExecuted**: Logs the details when a limit order is executed.
- **OrderCancelled**: Logs the details when a limit order is cancelled.

## Modifiers

- **onlyOwner**: Restricts certain functions to be called by the contract owner only.

## Functions

- **placeOrder**: Allows a user to place a new limit order.
- **cancelOrder**: Enables a user to cancel an existing limit order.
- **executeOrder**: Executed by the contract when a market price meets a limit order price.

## Exceptions

- Throws errors for conditions such as invalid order prices, insufficient balances, and unauthorized cancellations.

## Usage Notes

- Users must understand the mechanics of limit orders and the associated risks.
- Interacting with the contract typically requires a user interface that supports limit order functionality.

## Deployment

- To be deployed on an Ethereum-compatible blockchain with access to Uniswap V4 pools.
- Requires linking to a specific pool and setting appropriate permissions.

## Hooks Section

Within the Uniswap V4 `Hooks` library, the LimitOrder contract leverages the following hooks where the flags are set to `true` in the `getHooksCalls` function:

### Hook Calls Detail

- `afterInitialize`: Engaged after the pool is initialized, allowing the LimitOrder contract to perform setup actions post-initialization.
- `afterSwap`: Engaged after a swap has occurred, enabling the LimitOrder contract to check for any limit orders that can be executed based on the new market price.
