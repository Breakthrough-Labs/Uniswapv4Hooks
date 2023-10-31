# MultiSigSwapHook Smart Contract

## Description

Multi-signature approval to Uniswap V4 swaps. This means that before a swap can occur, a predefined number of authorized signers need to approve it. The contract can be configured with a list of authorized signers and a requirement for how many of those signers need to approve a given swap.

## Features

1. **BaseHook Integration**: Inherits from the `BaseHook` contract to interface with the Uniswap V4 core functionality.

2. **Multi-Signature Approval**: Before a swap can be executed, it requires approval from a set number of authorized signers.

3. **Swap Approval Management**: Offers functions to approve, check approval status, and complete a swap after all required approvals are received.

4. **Signer Management**: The contract owner can add or remove authorized signers.

## Functions

### Public and External Functions

- **approveSwap**: Allows an authorized signer to approve a swap.
- **addSigner**: Allows the owner to add a new authorized signer.
- **removeSigner**: Allows the owner to remove an authorized signer.
- **setRequiredSignatures**: Allows the owner to modify the number of required approvals for a swap.
- **getApprovalDetails**: Returns the number of approvals a swap has received and whether the caller has approved it.

### HOOKS

- **beforeSwap**: Checks if the swap has the required approvals before execution.
- **afterSwap**: Cleans up after a swap is executed.

## Events

- **ApprovalAdded**: Emitted when a signer approves a swap.
- **SwapCompleted**: Emitted after a swap with the required approvals is executed.

## Constructor

When the contract is deployed, it requires:

- **\_poolManager**: A reference to the Uniswap V4 Pool Manager.
- **\_signers**: An array of initial authorized signers.
- **\_requiredSignatures**: The number of approvals required to execute a swap.

## Modifiers

- **onlyOwner**: Ensures that only the contract owner can execute the function.

## Dependencies

The contract imports and interacts with various other contracts, such as:

- **Uniswap V4 Core**: For core functionalities related to pools.

## Usage

1. **Initialization**: The contract is initialized with a list of authorized signers and a set number of required approvals.
2. **Swap Execution**: Before a swap is executed, it requires approval from a set number of authorized signers. Each signer can call `approveSwap` to approve a swap.
3. **Signer Management**: The contract owner can add or remove signers as needed.
