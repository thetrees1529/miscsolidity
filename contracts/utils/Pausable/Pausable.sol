//SPDX-License-Identifier: MIT
import "./IPausable.sol";
pragma solidity ^0.8.0;
contract Pausable is IPausable {

    mapping(string => bool) _pauses;

    function _pause(string memory pause) internal {
        _pauses[pause] = true;
        emit Paused(pause);
    }

    function _unpause(string memory pause) internal {
        _pauses[pause] = false;
        emit Unpaused(pause);
    }

    modifier notPaused(string memory pause) {
        require(!_pauses[pause],
            string(abi.encodePacked(
                pause,
                " ",
                "is paused."
            ))
        );
        _;
    }

}