//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IWithdraw.sol";

contract Withdraw is IWithdraw, AccessControl {
    bytes32 public override WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    function withdraw(address to, uint value) public override onlyRole(WITHDRAW_ROLE) {
        (bool success,) = to.call{value: value}("");
        require(success);
    }
}