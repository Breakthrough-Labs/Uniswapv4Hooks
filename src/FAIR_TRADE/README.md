# FairTrade Smart Contract

## Description

Designed to facilitate a fair trading mechanism on the Ethereum blockchain. The contract integrates with the Uniswap V4 core and provides a set of functions to control the behavior of trading and liquidity provision.

## Features

1. **BaseHook Integration**: The contract inherits from the `BaseHook` contract, which provides certain base functionalities to be used with Uniswap V4.

2. **Time Lock**: The contract implements a time-lock mechanism which restricts the owner and funders from certain activities for a year from the contract's creation.

3. **Token Creation**: The contract has provisions to create a new ERC20 token (`FairTradeERC20`) on launch.

4. **Liquidity Provision**: Allows for liquidity to be added to a Uniswap V4 pool with ETH and the created token.

5. **Swap and Position Modification Controls**: Provides controls on swaps and position modifications to ensure fair practices.

6. **Funding Mechanism**: Users can deposit ETH to fund the token. Funders are restricted from trading until the unlock time.

7. **Ownership Transfer**: Allows for the transfer of contract ownership with certain restrictions.

## Functions

### Constructor

Initializes the contract with pool manager details and token attributes (name, symbol, and decimals).

### Hooks

- **beforeInitialize**: Mints tokens to funders before pool initialization.
- **afterInitialize**: Adds liquidity to the pool after its initialization.
- **beforeModifyPosition**: Ensures the owner cannot modify liquidity positions before the unlock time.
- **beforeSwap**: Ensures funders cannot trade before the unlock time.

### Public Functions

- **depositEth**: Allows users to deposit ETH for funding.
- **quit**: Allows a funder to quit and withdraw their ETH if the token hasn't launched yet.
- **transferOwnership**: Transfers the ownership of the contract.
- **launch**: Launches the token and initializes the pool.

### Private Functions

- **\_mintTokensToFunders**: Mints tokens to the funders.
- **\_initializePool**: Initializes the Uniswap V4 pool with the created token.
- **\_addLiquidityToPool**: Adds liquidity to the Uniswap V4 pool.

### External Functions

- **handleSwap**: Handles the logic for swapping tokens.
- **handleModifyPosition**: Manages the modification of liquidity positions.

### Receive

The contract can receive ETH directly.

## Dependencies

The contract imports and utilizes various other contracts and libraries, such as:

- **Uniswap V4 Core**: For core functionalities related to pools, ticks, and liquidity.
- **Ownable**: To manage ownership of the contract.
- **FairTradeERC20**: The ERC20 token that will be used with this contract.
- **PoolModifyPositionTest** & **PoolSwapTest**: Test contracts for position modifications and swaps.

## Usage

1. **Initialization**: Deploy the contract with the desired token attributes.
2. **Funding**: Users can deposit ETH to fund the token.
3. **Launch**: The owner can launch the token and initialize the Uniswap V4 pool.
4. **Trading**: Users can trade with restrictions based on the time-lock mechanism.
5. **Liquidity**: Liquidity can be added or modified with certain restrictions.

## Notes

- Ensure you're familiar with the time-lock mechanism before interacting with the contract.
- Always check the contract's functions and understand their implications before calling them.
