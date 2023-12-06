// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {HookTest} from "../utils/HookTest.sol";
import {Deployers} from "@uniswap/v4-core/test/foundry-tests/utils/Deployers.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {MultiSigSwapHook} from "../../../src/MULTI_SIG/MultiSigSwapHook.sol";
import {MultiSigSwapHookImplementation} from "../utils/MultiSigSwapHookImplementation.sol";
import {HookMiner} from "../utils/HookMiner.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";

contract MultiSigSwapHookTest is HookTest, Deployers {
    using CurrencyLibrary for Currency;
    using PoolIdLibrary for PoolKey;
    MultiSigSwapHook multiSigSwapHook;
    MultiSigSwapHookImplementation multiSigSwapHookImplementation;
    PoolKey poolKey;
    PoolId poolId;

    function setUp() public {
        HookTest.initHookTestEnv();

        address[] memory signers = new address[](2);
        signers[0] = address(this);
        signers[1] = address(0x1234);

        uint160 flags = uint160(
            Hooks.AFTER_SWAP_FLAG | Hooks.BEFORE_SWAP_FLAG // Not sure if we're gonna use this yet
        );

        (address hookAddress, bytes32 salt) = HookMiner.find(
            address(this),
            flags,
            0,
            type(MultiSigSwapHook).creationCode,
            abi.encode(address(manager), signers, 2)
        );

        multiSigSwapHook = new MultiSigSwapHook{salt: salt}(
            manager,
            signers,
            2
        );

        require(
            address(multiSigSwapHook) == hookAddress,
            "MULTISIGTEST: Hook address mismatch"
        );

        multiSigSwapHookImplementation = new MultiSigSwapHookImplementation(
            IPoolManager(manager),
            multiSigSwapHook,
            signers,
            2
        );

        etchHook(
            address(multiSigSwapHookImplementation),
            address(multiSigSwapHook)
        );

        poolKey = PoolKey(
            Currency.wrap(address(token0)),
            Currency.wrap(address(token1)),
            3000,
            60,
            multiSigSwapHook
        );
        poolId = poolKey.toId();
        manager.initialize(poolKey, SQRT_RATIO_1_1, bytes(""));
    }

    function testApproveSwap() public {
        bytes32 swapHash = keccak256(abi.encode(keccak256("mockSwapParams")));

        multiSigSwapHook.approveSwap(swapHash);
        (uint256 count, bool hasSigned) = multiSigSwapHook.getApprovalDetails(
            swapHash
        );

        assertEq(count, 1);
        assertTrue(hasSigned);
    }

    function testFailSwapWithInsufficientApprovals() public {
        bytes32 swapHash = keccak256(abi.encode(keccak256("mockSwapParams")));

        multiSigSwapHook.approveSwap(swapHash);

        // This should fail as it requires 2 approvals
        multiSigSwapHook.beforeSwap(
            address(0),
            poolKey,
            IPoolManager.SwapParams({
                zeroForOne: true,
                amountSpecified: 1,
                sqrtPriceLimitX96: MIN_PRICE_LIMIT
            }),
            bytes("")
        );
    }
}
