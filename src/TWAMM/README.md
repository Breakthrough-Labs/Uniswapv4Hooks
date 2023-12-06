# TWAMM Smart Contract

## Title

TWAMM Hook

## Version

Solidity 0.8.15

## License Identifier

SPDX-License-Identifier: UNLICENSED

## Description

The TWAMM (Time Weighted Average Market Maker) hook provides functionality for long-term orders within a decentralized exchange environment, specifically designed for the Uniswap V4 protocol. It employs a virtual order mechanism to execute trades over a specified duration, improving capital efficiency and reducing price slippage.

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

- **TWAMM State**: Holds the state of virtual orders and manages their lifecycle.
- **Hooks Calls**: Defines specific points in the pool's lifecycle where the TWAMM logic interjects.
- **Order Submission**: Allows users to submit long-term orders, which are then executed incrementally over time.

## Contract Features

- **Expiration Interval**: A fixed interval for order expiration, ensuring all orders end at consistent times.
- **Order Execution**: A mechanism to execute virtual orders based on the current state and price of the pool.
- **Tokens Owed Tracking**: Records the amounts owed to users based on executed portions of their orders.

## Libraries and Interfaces

- Utilizes various Uniswap V4-core libraries such as Hooks, TickBitmap, and SqrtPriceMath for managing pool states and calculations.
- Interfaces with the Uniswap V4-core contracts for actions like transferring tokens securely.

## Events

- **SubmitOrder**: Emitted when a new order is submitted, capturing details like the pool ID, order rate, and expiration.

## Modifiers

- **poolManagerOnly**: Ensures that only the pool manager can call certain functions, protecting the integrity of the pool operations.

## Functions

- **Initialize**: Sets up the initial state for the TWAMM within a pool.
- **ExecuteTWAMMOrders**: Facilitates the execution of virtual orders at the current block timestamp.
- **SubmitOrder**: Allows users to submit new orders, which are then processed by the contract.

## Exceptions

- Various custom exceptions are thrown for conditions like ownership mismatches, uninitialized state, and invalid order parameters.

## Usage Notes

- This contract is intended for use with Uniswap V4 pools and requires understanding of the TWAMM concept.
- Proper interaction with the contract requires a suitable front-end interface or other interaction scripts.

## Deployment

- The contract must be deployed in an Ethereum-compatible environment with access to Uniswap V4 pools.
- It requires configuration with a valid IPoolManager and the expiration interval for orders.

## Hooks Section

The TWAMM contract utilizes the following hooks from the Uniswap V4 `Hooks` library:

- **beforeInitialize**: Called before the pool is initialized.
- **beforeModifyPosition**: Called before a position is modified.
- **beforeSwap**: Called before a swap is executed.

These hooks allow the TWAMM contract to interject its logic at crucial points in the pool's lifecycle to manage the state of virtual orders accordingly.

### Hook Calls Detail

- `beforeInitialize` is used to set up the initial state for the TWAMM.
- `beforeModifyPosition` and `beforeSwap` are utilized to execute virtual orders and adjust the state before any position changes or swaps occur in the pool.

Note: Other hooks from the `Hooks` library are available but not used in the current implementation of the TWAMM contract. Their corresponding flags in the `getHooksCalls` function are set to `false`.
