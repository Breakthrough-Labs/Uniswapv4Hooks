// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {IHooks} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IHooks.sol";
import {Hooks} from "lib/v4-periphery/lib/v4-core/contracts/libraries/Hooks.sol";
import {IPoolManager} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IPoolManager.sol";
import {CurrencyLibrary, Currency} from "lib/v4-periphery/lib/v4-core/contracts/types/Currency.sol";
import {PoolKey} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolId.sol";
import {FairTrade} from "../../../../src/FAIR_TRADE/FairTrade.sol";
import {HookMiner} from "../utils/HookMiner.sol";

contract FairTradeTest {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    FairTrade public hook;
    PoolKey poolKey;
    PoolId poolId;
    address manager;

    constructor(address _manager) {
        manager = _manager;
    }

    event TestLog(string testName, string message);

    function setUp() public {
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
            type(FairTrade).creationCode,
            abi.encode(address(manager), "Test Token", "TEST", 18)
        );

        hook = new FairTrade{salt: salt}(
            IPoolManager(address(manager)),
            "Test Token",
            "TEST",
            18
        );

        require(
            address(hook) == hookAddress,
            "FairTradeTest: Hook address mismatch"
        );
    }

    function isFundertestDepositEth() public payable {
        hook.depositEth{value: msg.value}();
        if (hook.isFunder(address(this))) {
            emit TestLog("testDepositEth", "Is funder");
        } else {
            emit TestLog("testDepositEth", "Is not funder");
        }
    }

    receive() external payable {}
}
