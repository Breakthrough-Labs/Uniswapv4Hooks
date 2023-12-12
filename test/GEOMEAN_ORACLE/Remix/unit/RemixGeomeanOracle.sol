// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {IHooks} from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {GeomeanOracle} from "../../../../src/GEOMEAN_ORACLE/GeomeanOracle.sol";
import {MockERC20} from "@uniswap/v4-core/test/foundry-tests/utils/MockERC20.sol";
import {HookMiner} from "../utils/HookMiner.sol";
import {SafeCast} from "@uniswap/v4-core/contracts/libraries/SafeCast.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import {PoolSwapTest} from "@uniswap/v4-core/contracts/test/PoolSwapTest.sol";

contract GeomeanOracleTest {
    using PoolIdLibrary for PoolKey;
    using SafeCast for uint256;
    using CurrencyLibrary for Currency;

    GeomeanOracle public hook;

    PoolKey poolKey;
    PoolId poolId;

    address manager;

    MockERC20 token0;
    MockERC20 token1;

    PoolModifyPositionTest modifyPositionRouter;
    PoolSwapTest swapRouter;

    Currency currency0;
    Currency currency1;

    uint32 public time;

    uint160 public constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    int24 public constant MAX_TICK_SPACING = type(int16).max;
    uint256 constant MAX_DEADLINE = 12329839823;
    int24 constant TICK_SPACING = 60;
    bytes internal constant ZERO_BYTES = bytes("");

    constructor(address _manager) {
        manager = _manager;
    }

    function setUp() public {
        token0 = new MockERC20("TestA", "A", 18, 2 ** 128);
        token1 = new MockERC20("TestB", "B", 18, 2 ** 128);

        (currency0, currency1) = sort(token0, token1);

        uint160 flags = uint160(
            Hooks.BEFORE_INITIALIZE_FLAG |
                Hooks.AFTER_INITIALIZE_FLAG |
                Hooks.BEFORE_MODIFY_POSITION_FLAG |
                Hooks.BEFORE_SWAP_FLAG
        );

        (address hookAddress, bytes32 salt) = HookMiner.find(
            address(this),
            flags,
            0,
            type(GeomeanOracle).creationCode,
            abi.encode(address(manager))
        );

        hook = new GeomeanOracle{salt: salt}(IPoolManager(address(manager)));

        require(
            address(hook) == hookAddress,
            "FairTradeTest: Hook address mismatch"
        );

        setTime(1);
        poolKey = PoolKey(currency0, currency1, 0, MAX_TICK_SPACING, hook);
        poolId = poolKey.toId();

        modifyPositionRouter = new PoolModifyPositionTest(
            IPoolManager(manager)
        );
        token0.approve(address(hook), type(uint256).max);
        token1.approve(address(hook), type(uint256).max);
        token0.approve(address(modifyPositionRouter), type(uint256).max);
        token1.approve(address(modifyPositionRouter), type(uint256).max);
    }

    function sort(
        MockERC20 tokenA,
        MockERC20 tokenB
    ) internal pure returns (Currency _currency0, Currency _currency1) {
        if (address(tokenA) < address(tokenB)) {
            (_currency0, _currency1) = (
                Currency.wrap(address(tokenA)),
                Currency.wrap(address(tokenB))
            );
        } else {
            (_currency0, _currency1) = (
                Currency.wrap(address(tokenB)),
                Currency.wrap(address(tokenA))
            );
        }
    }

    function setTime(uint32 _time) internal {
        time = _time;
    }

    function testBeforeInitializeAllowsPoolCreation() public {
        IPoolManager(manager).initialize(poolKey, SQRT_RATIO_1_1, ZERO_BYTES);
    }

    receive() external payable {}
}
