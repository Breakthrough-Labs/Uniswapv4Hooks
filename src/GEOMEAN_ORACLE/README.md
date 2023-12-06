# GeomeanOracle Smart Contract

## Version

Solidity 0.8.19

## License Identifier

SPDX-License-Identifier: UNLICENSED

## Description

The `GeomeanOracle` contract provides an on-chain oracle for Uniswap pools that offer geometric mean prices for token pairs. These pools are configured with full range tick spacing and have their liquidity permanently locked to ensure price integrity, making them less susceptible to manipulation.

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

- **Geomean Oracle**: Provides time-weighted average prices (TWAPs) in the style of Uniswap V3's TWAP oracles.
- **Observation Management**: Manages an extensive array of price and liquidity observations for accurate TWAP calculations.
- **Liquidity Lock**: Ensures that liquidity is locked in oracle pools to maintain consistent price data.

## Libraries and Interfaces

- Utilizes Uniswap V4-core and periphery libraries for observation and pool management functions.
- Employs the `BaseHook` inheritance pattern for hooking into pool actions.

## Contract Features

- **Immutable Liquidity**: Oracle pools are designed with permanently locked liquidity to provide reliable price data.
- **Single Oracle Pool Restriction**: Limits each token pair to a single oracle pool to reduce fragmentation and maintain a unified source of price data.
- **Cardinality Management**: Allows for adjustment of the observation array cardinality to accommodate more frequent price updates if necessary.

## Events

- No custom events are emitted by the contract itself.

## Modifiers

- **poolManagerOnly**: Restricts certain functions to be called by the pool manager only.

## Functions

- **getObservation**: Retrieves a specific observation for a pool based on the provided pool key and index.
- **getState**: Obtains the current state of observations for a pool using the pool key.
- **observe**: Calculates TWAPs using the specified timestamps for a given pool.
- **increaseCardinalityNext**: Updates the cardinality next value to accommodate a larger number of observations.

## Exceptions

- **OnlyOneOraclePoolAllowed**: Ensures there is only one oracle pool per token pair.
- **OraclePositionsMustBeFullRange**: Enforces that oracle positions cover the full range of ticks.
- **OraclePoolMustLockLiquidity**: Prevents liquidity removal from oracle pools.

## Usage Notes

- Designed for protocols that require a robust and manipulation-resistant price oracle.
- Liquidity providers cannot remove liquidity, making this unsuitable for traditional liquidity provision use cases.

## Deployment

- Intended for deployment in Uniswap V4 ecosystem, requires integration with a pool manager.
- Proper setup and configuration must ensure locked liquidity and full-range positions.

## Hooks Section

The `GeomeanOracle` contract uses several hooks to integrate with Uniswap pool activities. The `getHooksCalls` function returns a `Hooks.Calls` struct indicating which hooks are utilized:

### Hook Calls Detail

- `beforeInitialize`: Activates before pool initialization to enforce oracle pool constraints.
- `afterInitialize`: Engaged after the pool is initialized to set up initial observation states.
- `beforeModifyPosition`: Engaged before any position is modified to ensure full-range and liquidity lock.
- `beforeSwap`: Activated before a swap to update the observation array with the latest pool data.
