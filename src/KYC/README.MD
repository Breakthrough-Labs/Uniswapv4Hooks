# KYCSwaps Smart Contract

## Description

Valid KYC (Know Your Customer) token can trade on a Uniswap V4 pool that utilizes this hook. The KYC verification process relies on an external oracle (interface `IKycValidity`) to determine whether an address has a valid KYC token.

## Features

1. **BaseHook Integration**: Inherits from the `BaseHook` contract to interface with the Uniswap V4 core functionality.

2. **KYC Verification**: Before any pool operation (initialize, modify position, swap), the contract checks if the transaction origin has a valid KYC token.

3. **Timelock Mechanism**: Provides a quasi-timelock mechanism for changing the KYC validity oracle. Once a change is proposed, it takes 7 days before the change can be confirmed.

## Interfaces

- **IKycValidity**: An interface that provides a method `hasValidToken` to check whether a given address has a valid kycNFT token.

## Functions

### Public Functions

- **setKycValidity**: Allows the contract owner to propose or confirm a change to the KYC validity oracle. The function implements a 7-day timelock mechanism.

### Hooks

- **beforeInitialize**: Ensures that only KYC verified users can initialize a pool.
- **beforeModifyPosition**: Ensures that only KYC verified users can modify their position in the pool.
- **beforeSwap**: Ensures that only KYC verified users can swap tokens in the pool.

## Dependencies

The contract imports and interacts with various other contracts, such as:

- **Uniswap V4 Core**: For core functionalities related to pools.
- **solady/auth**: For the `Ownable` contract which provides basic authorization control functions.

## Usage

1. **Setting KYC Oracle**: The contract owner can propose a change to the KYC oracle using `setKycValidity`. After 7 days, the owner can call the function again to confirm the change.

2. **Trading & Pool Operations**: Users who wish to interact with the pool (initialize, modify position, swap) need to ensure they have a valid KYC token, as verified by the oracle.

## Caveats

1. The contract's KYC check relies on an external oracle. Therefore, the trustworthiness and security of the KYC verification process depend on the integrity of this external oracle.
2. The comment in the provided code mentions, "requires more logic depending on what your pool will be doing." This suggests that the contract may need additional functionalities or checks tailored to specific use-cases or pool behaviors.

## License

The code is not licensed under any specific license (UNLICENSED).
Explanation:

The KYCSwaps contract provides a mechanism to ensure that only users with verified KYC can participate in trading on a Uniswap V4 pool. The KYC check is done using an external oracle, IKycValidity, which verifies whether an address has a valid KYC token.

Additionally, the contract provides a mechanism to change the KYC oracle with a timelock of 7 days. This means once a new oracle is proposed, it takes 7 days before the change can be finalized. This is a security measure to prevent abrupt changes to critical contract parameters.

There is required additonal logic based on your use case that is out of the scope of Uniswap hooks and this repo.
···
