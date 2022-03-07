//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IPausable {
    event Paused(string pause);
    event Unpaused(string pause);
}