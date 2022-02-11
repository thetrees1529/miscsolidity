//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity ^0.8.0;
contract OwnerRoleEditor is Ownable, AccessControl {
    function grantRole(bytes32 role, address account) public override {
        msg.sender == owner() ? _grantRole(role, account) : super.grantRole(role, account);
    }
}