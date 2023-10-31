# Hedge Smart Contract

## Description

Providing a hedging mechanism on the Ethereum blockchain. When certain price triggers are hit, the contract either performs a hedge by swapping tokens or unwinds the hedge. The contract integrates with the Uniswap V4 core and leverages the `BaseHook` mechanism for after-swap activities.

## Features

1. **BaseHook Integration**: Inherits from the `BaseHook` contract to interface with Uniswap V4 core functionality.

2. **Price Triggers**: Users can set price triggers which, when breached, will initiate a hedge or unwind the hedge based on conditions.

3. **Binary Search Algorithm**: Implements a binary search method to efficiently determine the index to insert a new price trigger.

4. **Swap Mechanism**: Utilizes the Uniswap V4 pool to swap tokens based on set triggers.

5. **SafeERC20**: Uses the `SafeERC20` library from OpenZeppelin to ensure safe operations with ERC20 tokens.

## Structs

- **Trigger**: Contains details about the hedging trigger, including the price, unwind conditions, and associated token details.

## Functions

### Public Functions

- **setTrigger**: Allows users to set a price trigger with specified conditions.

### Internal Functions

- **\_findIndex**: Implements a binary search algorithm to find the index for inserting a price in an ordered array.
- **\_performHedge**: Executes the hedge based on the given triggers.
- **\_performUnwind**: Unwinds the hedge based on the given triggers.

### External Functions

- **lockAcquiredUnwind**: Unwinds the hedge by swapping back the tokens when called.
- **lockAcquiredHedge**: Initiates the hedge by swapping tokens when called.

### Hooks

- **afterSwap**: Executed after a swap on the Uniswap V4 pool. It checks price conditions and decides whether to hedge or unwind.

## Dependencies

The contract imports and interacts with various other contracts and libraries, such as:

- **Uniswap V4 Core**: For core functionalities related to pools, swaps, and liquidity.
- **OpenZeppelin**: For standard interfaces (`IERC20`) and utility libraries (`SafeERC20`).

## Usage

1. **Setting Triggers**: Users can define their hedging triggers by calling the `setTrigger` function.
2. **Trading**: The main functionality revolves around the `afterSwap` function. After a token swap in the associated Uniswap V4 pool, the function checks if any hedge or unwind conditions are met and acts accordingly.

## Notes

- Users need to be aware of the hedging conditions they set and the implications of those conditions.
- The hedging mechanism relies on the price of the token in the Uniswap V4 pool.
