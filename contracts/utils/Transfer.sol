//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Transfer {
    function _transfer(address to, uint value) internal {
        (bool success,) = to.call{value: value}("");
        require(success);
    }
}