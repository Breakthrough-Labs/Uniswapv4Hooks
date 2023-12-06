// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {IHooks} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IHooks.sol";
import {Hooks} from "lib/v4-periphery/lib/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IPoolManager.sol";
import {CurrencyLibrary, Currency} from "lib/v4-periphery/lib/v4-core/contracts/types/Currency.sol";
import {PoolKey} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolId.sol";
import {TWAMM} from "../../../src/TWAMM/TWAMM.sol";
import {ITWAMM} from "lib/v4-periphery/contracts/interfaces/ITWAMM.sol";
import {MockERC20} from "@uniswap/v4-core/test/foundry-tests/utils/MockERC20.sol";
import {HookMiner} from "../utils/HookMiner.sol";
import {SafeCast} from "@uniswap/v4-core/contracts/libraries/SafeCast.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import {PoolSwapTest} from "@uniswap/v4-core/contracts/test/PoolSwapTest.sol";
import {PoolDonateTest} from "@uniswap/v4-core/contracts/test/PoolDonateTest.sol";
import {TickMath} from "@uniswap/v4-core/contracts/libraries/TickMath.sol";

contract TWAMMTest {
    using PoolIdLibrary for PoolKey;
    using SafeCast for uint256;
    using CurrencyLibrary for Currency;

    TWAMM public hook;

    PoolKey poolKey;
    PoolId poolId;

    address manager;

    MockERC20 token0;
    MockERC20 token1;

    PoolModifyPositionTest modifyPositionRouter;
    PoolSwapTest swapRouter;
    PoolDonateTest donateRouter;

    Currency currency0;
    Currency currency1;

    uint160 public constant SQRT_RATIO_1_1 = 79228162514264337593543950336;
    uint160 constant SQRT_RATIO_10_1 = 250541448375047931186413801569;
    int24 public constant MAX_TICK_SPACING = type(int16).max;
    uint256 constant MAX_DEADLINE = 12329839823;
    int24 constant TICK_SPACING = 60;
    bytes internal constant ZERO_BYTES = bytes("");

    event TestLog(string testName, string message);

    event Failure(string message);

    event SubmitOrder(
        PoolId indexed poolId,
        address indexed owner,
        uint160 expiration,
        bool zeroForOne,
        uint256 sellRate,
        uint256 earningsFactorLast
    );

    event UpdateOrder(
        PoolId indexed poolId,
        address indexed owner,
        uint160 expiration,
        bool zeroForOne,
        uint256 sellRate,
        uint256 earningsFactorLast
    );

    constructor(address _manager) {
        manager = _manager;
    }

    function setUp() public {
        token0 = new MockERC20("TestA", "A", 18, 2 ** 128);
        token1 = new MockERC20("TestB", "B", 18, 2 ** 128);

        (currency0, currency1) = sort(token0, token1);

        address[] memory signers = new address[](2);
        signers[0] = address(this);
        signers[1] = address(0x1234);

        uint160 flags = uint160(
            Hooks.BEFORE_INITIALIZE_FLAG |
                Hooks.BEFORE_SWAP_FLAG |
                Hooks.BEFORE_MODIFY_POSITION_FLAG
        );

        (address hookAddress, bytes32 salt) = HookMiner.find(
            address(this),
            flags,
            0,
            type(TWAMM).creationCode,
            abi.encode(address(manager), 10_000)
        );

        hook = new TWAMM{salt: salt}(IPoolManager(address(manager)), 10_000);

        require(
            address(hook) == hookAddress,
            "FairTradeTest: Hook address mismatch"
        );

        poolKey = PoolKey(currency0, currency1, 3000, MAX_TICK_SPACING, hook);
        poolId = poolKey.toId();

        IPoolManager(address(manager)).initialize(
            poolKey,
            SQRT_RATIO_1_1,
            bytes("")
        );

        modifyPositionRouter = new PoolModifyPositionTest(
            IPoolManager(manager)
        );
        swapRouter = new PoolSwapTest(IPoolManager(manager));

        token0.approve(address(modifyPositionRouter), 100 ether);
        token1.approve(address(modifyPositionRouter), 100 ether);
        token0.mint(address(this), 100 ether);
        token1.mint(address(this), 100 ether);
        modifyPositionRouter.modifyPosition(
            poolKey,
            IPoolManager.ModifyPositionParams(-60, 60, 10 ether),
            ZERO_BYTES
        );
        modifyPositionRouter.modifyPosition(
            poolKey,
            IPoolManager.ModifyPositionParams(-120, 120, 10 ether),
            ZERO_BYTES
        );
        modifyPositionRouter.modifyPosition(
            poolKey,
            IPoolManager.ModifyPositionParams(
                TickMath.minUsableTick(60),
                TickMath.maxUsableTick(60),
                10 ether
            ),
            ZERO_BYTES
        );
    }

    function deployTokens(
        uint8 count,
        uint256 totalSupply
    ) internal returns (MockERC20[] memory tokens) {
        tokens = new MockERC20[](count);
        for (uint8 i = 0; i < count; i++) {
            tokens[i] = new MockERC20("TEST", "TEST", 18, totalSupply);
        }
    }

    function newPoolKeyWithTWAMM(
        IHooks hooks
    ) public returns (PoolKey memory, PoolId) {
        MockERC20[] memory tokens = deployTokens(2, 2 ** 255);
        PoolKey memory key = PoolKey(
            Currency.wrap(address(tokens[0])),
            Currency.wrap(address(tokens[1])),
            0,
            60,
            hooks
        );
        return (key, key.toId());
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

    function testTWAMM_beforeInitialize_SetsLastVirtualOrderTimestamp() public {
        (PoolKey memory initKey, PoolId initId) = newPoolKeyWithTWAMM(hook);
        if (hook.lastVirtualOrderTimestamp(initId) == 0) {
            emit TestLog(
                "lastVirtualOrderTimestamp test",
                "PASSED: lastVirtualOrderTimestamp is 0"
            );
        } else {
            emit Failure("FAILED: lastVirtualOrderTimestamp is not 0");
        }
    }

    receive() external payable {}
}
