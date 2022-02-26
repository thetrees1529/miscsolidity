//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./IWithdrawERC20.sol";

contract WithdrawERC20 is IWithdrawERC20, AccessControl {
    bytes32 public override WITHDRAW_ERC20_ROLE = keccak256("WITHDRAW_ERC20_ROLE");
    function withdrawERC20(IERC20 token, address to, uint value) public override onlyRole(WITHDRAW_ERC20_ROLE) {
        token.transfer(to, value);
    }
}