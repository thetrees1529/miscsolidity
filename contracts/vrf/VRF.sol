//SPDX-License-Identifier: MIT
import "./CONSTANTS.sol";
pragma solidity ^0.8.0;

contract VRF {
    function _vrf(uint blockNumber) internal view returns (bool valid, bytes32 result) {
        uint[1] memory bn;
        bn[0] = blockNumber;
        assembly {
            let memPtr := mload(0x40)
            if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
                invalid()
            }
            result := mload(memPtr)
        }
        valid = _isValid(blockNumber);
    } 
    function _isValid(uint blockNumber) internal view returns(bool) {
        return block.timestamp <= blockNumber + VRF_INVALID_AFTER && block.timestamp >= blockNumber;
    }
}