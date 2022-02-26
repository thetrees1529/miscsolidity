//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWithdraw {
    function WITHDRAW_ROLE() external view returns(bytes32);
    function withdraw(address to, uint value) external;
}