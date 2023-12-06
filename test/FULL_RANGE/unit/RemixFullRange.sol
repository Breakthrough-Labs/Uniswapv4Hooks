// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {IHooks} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IHooks.sol";
import {Hooks} from "lib/v4-periphery/lib/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IPoolManager.sol";
import {CurrencyLibrary, Currency} from "lib/v4-periphery/lib/v4-core/contracts/types/Currency.sol";
import {PoolKey} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolId.sol";
import {FullRange} from "../../../src/FULL_RANGE/FullRange.sol";
import {MockERC20} from "@uniswap/v4-core/test/foundry-tests/utils/MockERC20.sol";
import {HookMiner} from "../utils/HookMiner.sol";
import {SafeCast} from "@uniswap/v4-core/contracts/libraries/SafeCast.sol";
import {MockERC20} from "@uniswap/v4-core/test/foundry-tests/utils/MockERC20.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import {PoolSwapTest} from "@uniswap/v4-core/contracts/test/PoolSwapTest.sol";

contract FullRangeTest {
    using PoolIdLibrary for PoolKey;
    using SafeCast for uint256;
    using CurrencyLibrary for Currency;

    FullRange public hook;

    PoolKey poolKey;
    PoolId poolId;

    PoolKey poolKey2;
    PoolId poolId2;

    PoolKey keyWithLiq;
    PoolId idWithLiq;

    address manager;

    MockERC20 token0;
    MockERC20 token1;
    MockERC20 token2;

    PoolModifyPositionTest modifyPositionRouter;
    PoolSwapTest swapRouter;

    uint160 public constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    uint256 constant MAX_DEADLINE = 12329839823;
    int24 constant TICK_SPACING = 60;
    bytes internal constant ZERO_BYTES = bytes("");

    event Initialize(
        PoolId indexed poolId,
        Currency indexed currency0,
        Currency indexed currency1,
        uint24 fee,
        int24 tickSpacing,
        IHooks hooks
    );

    constructor(address _manager) {
        manager = _manager;
    }

    function setUp() public {
        token0 = new MockERC20("TestA", "A", 18, 2 ** 128);
        token1 = new MockERC20("TestB", "B", 18, 2 ** 128);
        token2 = new MockERC20("TestC", "C", 18, 2 ** 128);

        uint160 flags = uint160(
            Hooks.BEFORE_INITIALIZE_FLAG |
                Hooks.BEFORE_MODIFY_POSITION_FLAG |
                Hooks.BEFORE_SWAP_FLAG
        );

        (address hookAddress, bytes32 salt) = HookMiner.find(
            address(this),
            flags,
            0,
            type(FullRange).creationCode,
            abi.encode(address(manager))
        );

        hook = new FullRange{salt: salt}(IPoolManager(address(manager)));

        require(
            address(hook) == hookAddress,
            "FairTradeTest: Hook address mismatch"
        );

        poolKey = createPoolKey(token0, token1);
        poolId = poolKey.toId();

        poolKey2 = createPoolKey(token1, token2);
        poolId2 = poolKey.toId();

        keyWithLiq = createPoolKey(token0, token2);
        idWithLiq = keyWithLiq.toId();

        modifyPositionRouter = new PoolModifyPositionTest(
            IPoolManager(manager)
        );
        swapRouter = new PoolSwapTest(IPoolManager(manager));

        token0.approve(address(hook), type(uint256).max);
        token1.approve(address(hook), type(uint256).max);
        token2.approve(address(hook), type(uint256).max);
        token0.approve(address(swapRouter), type(uint256).max);
        token1.approve(address(swapRouter), type(uint256).max);
        token2.approve(address(swapRouter), type(uint256).max);

        IPoolManager(manager).initialize(
            keyWithLiq,
            SQRT_RATIO_1_1,
            ZERO_BYTES
        );
        hook.addLiquidity(
            FullRange.AddLiquidityParams(
                keyWithLiq.currency0,
                keyWithLiq.currency1,
                3000,
                100 ether,
                100 ether,
                99 ether,
                99 ether,
                address(this),
                MAX_DEADLINE
            )
        );
    }

    function createPoolKey(
        MockERC20 tokenA,
        MockERC20 tokenB
    ) internal view returns (PoolKey memory) {
        if (address(tokenA) > address(tokenB))
            (tokenA, tokenB) = (tokenB, tokenA);
        return
            PoolKey(
                Currency.wrap(address(tokenA)),
                Currency.wrap(address(tokenB)),
                3000,
                TICK_SPACING,
                hook
            );
    }

    function testFullRange_beforeInitialize_AllowsPoolCreation() public {
        emit Initialize(
            poolId,
            poolKey.currency0,
            poolKey.currency1,
            poolKey.fee,
            poolKey.tickSpacing,
            poolKey.hooks
        );

        IPoolManager(manager).initialize(poolKey, SQRT_RATIO_1_1, ZERO_BYTES);

        (, address liquidityToken) = hook.poolInfo(poolId);

        // Assert.equal(liquidityToken , address(0));
    }

    receive() external payable {}
}
