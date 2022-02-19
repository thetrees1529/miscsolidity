//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReceiveWithdraw {
    function WITHDRAW_ROLE() external view returns(bytes32);

    receive() external payable;

    function withdraw(address to, uint value) external;
}