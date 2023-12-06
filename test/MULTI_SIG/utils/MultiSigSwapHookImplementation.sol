// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {MultiSigSwapHook} from "../../../src/MULTI_SIG/MultiSigSwapHook.sol";
import {BaseHook} from "v4-periphery/BaseHook.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";

contract MultiSigSwapHookImplementation is MultiSigSwapHook {
    constructor(
        IPoolManager poolManager,
        MultiSigSwapHook addressToEtch,
        address[] memory _signers,
        uint256 _requiredSignatures
    ) MultiSigSwapHook(poolManager, _signers, _requiredSignatures) {
        Hooks.validateHookAddress(addressToEtch, getHooksCalls());
    }

    function validateHookAddress(BaseHook _this) internal pure override {}
}
