# VotingEscrow Contract Overview

Voting escrow mechanics from Curve Finance, now tailored for the Uniswap v4 framework.

## Key Components:

### 2. **State Variables**:

- **poolId**: Identifier for the Uniswap v4 pool.
- **token**: The ERC20 token to be locked.
- Various constants and mappings for managing user lock positions, global slopes, and voting power.

### 3. **Structs**:

- **Point**: Captures a moment in the voting weight history with attributes like bias, slope, timestamp, and block number.
- **LockedBalance**: Details the locked amount and its expiry.
- **LockTicks**: Defines the range (lower and upper) of the liquidity position in Uniswap.

### 4. **Enums**:

- **LockAction**: Enumerates the type of lock actions possible, either CREATE or INCREASE_TIME.

## Key Functions:

- **createLock**: Allows users to lock tokens, establishing a voting position.
- **increaseUnlockTime**: Lets users extend their lock duration.
- **checkpoint**: Public function for triggering a global checkpoint to calculate and record voting weights.

### Hooks:

The contract has several hooks tied to the Uniswap v4 lifecycle:

- **afterInitialize**: Triggered after initializing the pool, used to set the `poolId`.
- **beforeModifyPosition**: Ensures that liquidity can only be increased during an active lock or after it has expired.
- **afterModifyPosition**: Updates the user's lock amount after any liquidity modification.

### Observations:

The contract leans on the concept of locked voting tokens, which are non-transferable. These tokens are based on provided liquidity in the Uniswap pool and are intended to be used for governance or voting purposes.
