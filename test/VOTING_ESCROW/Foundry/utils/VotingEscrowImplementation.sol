// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {BaseHook} from "v4-periphery/BaseHook.sol";
import {Hooks} from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import {VotingEscrow} from "../../../../src/VOTING_ESCROW/VotingEscrow.sol";
import {IPoolManager} from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";

contract VotingEscrowImplementation is VotingEscrow {
    constructor(
        IPoolManager _poolManager,
        address _token,
        string memory _name,
        string memory _symbol,
        VotingEscrow addressToEtch
    ) VotingEscrow(_poolManager, _token, _name, _symbol) {
        Hooks.validateHookAddress(addressToEtch, getHooksCalls());
    }

    // make this a no-op in testing
    function validateHookAddress(BaseHook _this) internal pure override {}
}
