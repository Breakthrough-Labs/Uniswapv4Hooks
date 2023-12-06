// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {Test} from "lib/forge-std/src/Test.sol";

import {PoolManager} from "lib/v4-periphery/lib/v4-core/contracts/PoolManager.sol";
import {IPoolManager} from "lib/v4-periphery/lib/v4-core/contracts/interfaces/IPoolManager.sol";
import {PoolKey} from "lib/v4-periphery/lib/v4-core/contracts/types/PoolKey.sol";

// Tests from Uniswap
import {PoolModifyPositionTest} from "../../../src/FAIR_TRADE/utils/PoolModifyPositionTest.sol";
import {PoolSwapTest} from "lib/v4-periphery/lib/v4-core/contracts/test/PoolSwapTest.sol";
import {PoolDonateTest} from "lib/v4-periphery/lib/v4-core/contracts/test/PoolDonateTest.sol";

contract SimpleHookTest is Test {
    PoolManager manager;
    PoolModifyPositionTest modifyPositionRouter;
    PoolSwapTest swapRouter;
    PoolDonateTest donateRouter;

    function initHookTestEnv() public {
        /// @dev 500000 is the gas limit
        manager = new PoolManager(500000);
    }
}
