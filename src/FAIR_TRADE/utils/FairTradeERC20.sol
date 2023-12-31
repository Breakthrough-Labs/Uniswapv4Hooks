// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {ERC20} from "../../../lib/solady/src/tokens/ERC20.sol";
import {Ownable} from "../../../lib/solady/src/auth/Ownable.sol";

contract FairTradeERC20 is ERC20, Ownable {
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    bytes32 internal immutable _nameHash;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _initializeOwner(msg.sender);
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _nameHash = keccak256(bytes(name_));
    }

    function _constantNameHash()
        internal
        view
        virtual
        override
        returns (bytes32)
    {
        return _nameHash;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function mint(address to, uint256 value) public virtual onlyOwner {
        _mint(_brutalized(to), value);
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        return super.transfer(_brutalized(to), amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        return super.transferFrom(_brutalized(from), _brutalized(to), amount);
    }

    function _brutalized(address a) internal view returns (address result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := or(a, shl(160, gas()))
        }
    }
}
