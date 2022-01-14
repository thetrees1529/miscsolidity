//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Admin is Ownable {
    event AdminStatusSet(address addr, bool status);
    mapping(address => bool) _admins;
    function editAdmin(address addr, bool status) public onlyOwner {
        _admins[addr] = status;
        emit AdminStatusSet(addr, status);
    }
    function getAdminStatus(address addr) public view returns(bool) {
        return _admins[addr];
    }
    modifier onlyAdmin() {
        require(_admins[msg.sender], "Only admins may call this function.");
        _;
    }
}