//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IReceiveWithdraw.sol";

contract ReceiveWithdraw is IReceiveWithdraw, AccessControl {
    bytes32 public override WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");
    receive() external virtual payable override {

    }
    function withdraw(address to, uint value) public override onlyRole(WITHDRAW_ROLE) {
        (bool success,) = to.call{value: value}("");
        require(success);
    }
}