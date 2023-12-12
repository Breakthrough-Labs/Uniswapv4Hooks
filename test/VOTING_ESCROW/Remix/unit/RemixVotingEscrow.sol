// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {IHooks} from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {CurrencyLibrary, Currency} from "@uniswap/v4-core/contracts/types/Currency.sol";
import {PoolKey} from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "@uniswap/v4-core/contracts/types/PoolId.sol";
import {VotingEscrow} from "../../../../src/VOTING_ESCROW/VotingEscrow.sol";
import {MockERC20} from "@uniswap/v4-core/test/foundry-tests/utils/MockERC20.sol";
import {HookMiner} from "../utils/HookMiner.sol";
import {SafeCast} from "@uniswap/v4-core/contracts/libraries/SafeCast.sol";
import {PoolModifyPositionTest} from "@uniswap/v4-core/contracts/test/PoolModifyPositionTest.sol";
import {PoolSwapTest} from "@uniswap/v4-core/contracts/test/PoolSwapTest.sol";
import {PoolDonateTest} from "@uniswap/v4-core/contracts/test/PoolDonateTest.sol";

contract VotingEscrowTest {
    using PoolIdLibrary for PoolKey;
    using SafeCast for uint256;
    using CurrencyLibrary for Currency;

    VotingEscrow public hook;

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

    constructor(address _manager) {
        manager = _manager;
    }

    function setUp() public {
        token0 = new MockERC20("TestA", "A", 18, 2 ** 128);
        token1 = new MockERC20("TestB", "B", 18, 2 ** 128);

        (currency0, currency1) = sort(token0, token1);

        uint160 flags = uint160(
            Hooks.BEFORE_MODIFY_POSITION_FLAG |
                Hooks.AFTER_MODIFY_POSITION_FLAG |
                Hooks.AFTER_INITIALIZE_FLAG
        );

        (address hookAddress, bytes32 salt) = HookMiner.find(
            address(this),
            flags,
            0,
            type(VotingEscrow).creationCode,
            abi.encode(address(manager), address(token0), "veToken", "veTKN")
        );

        hook = new VotingEscrow{salt: salt}(
            IPoolManager(address(manager)),
            address(token0),
            "veToken",
            "veTKN"
        );

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

    receive() external payable {}
}
