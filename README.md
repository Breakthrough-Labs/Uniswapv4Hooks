# Uniswap v4 HookBook

## Overview

Uniswap v4 Hooks, often referred to simply as hooks, are unique contracts executed at specific points during a pool action's lifecycle in the Uniswap v4 ecosystem. These hooks enable developers to customize interactions within pools, swaps, fees, and LP positions, fostering innovation and supporting the creation of custom Automated Market Maker (AMM) pools. Below are key resources and concepts to help you get started with Uniswap v4 hooks.

## Resources

- **Uniswap v4 Announcement**: An official announcement from Uniswap detailing their vision for v4, including the introduction of hooks.
- **Uniswap v4 Developer Documents**: Comprehensive documents from the Uniswap Foundation, guiding developers on building hooks on local testnets for experimentation.
- **Core Smart Contracts of Uniswap v4**: Overview of Uniswap v4's core contracts, including the singleton-style architecture, PoolManager.sol for pool state management, and hook contract implementation for pool action callbacks.
- **Peripheral Smart Contracts for Uniswap v4**: Discussing the v4-periphery logic that extends core pool functionalities, including hook contracts, position managers, and integration libraries. It highlights the evolving nature of the v4 ecosystem and includes the BaseHook contract template for creating custom hooks.
- **Draft Technical Whitepaper for Uniswap v4 Core**: An introduction to the key features of Uniswap v4, including hooks, singleton architecture, flash accounting, native ETH support, and more.

## Lifecycle of Pool Actions

Hooks are integrated into four key phases of a pool action's lifecycle in Uniswap v4:

1. **Initialize**: Triggered upon pool deployment.
2. **Modify Position**: Executed for adding or removing liquidity.
3. **Swap**: Conducts token swaps within the ecosystem.
4. **Donate**: Enables the donation of liquidity to pools.

At each of these stages, the associated hook contract can execute callback functions:

- `{before,after}Initialize`
- `{before,after}ModifyPosition`
- `{before,after}Swap`
- `{before,after}Donate`

Hooks also have the capability to influence fee decisions during swaps and liquidity withdrawals, providing flexibility in updating fee values or callback logic.

## Potential Functionalities with Hooks

Uniswap v4 hooks open up a plethora of creative possibilities, including:

- Implementing onchain limit orders that activate at specific tick prices.
- Setting dynamic fees based on volatility or other criteria.
- Redirecting out-of-range liquidity to lending platforms.
- Autocompounding LP fees back into LP positions.
- Distributing MEV profits among liquidity providers.
- Developing a Time-Weighted Average Market Maker (TWAMM) for executing large orders over time.
- Creating bespoke onchain oracles, such as median, truncated, or geomean oracles.
