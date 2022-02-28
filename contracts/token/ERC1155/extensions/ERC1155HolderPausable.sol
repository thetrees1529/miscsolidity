//SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
pragma solidity ^0.8.0;

contract ERC1155PausableHolder is ERC1155Holder {
    bool _ERC1155ReceivePaused;
    function onERC1155Received(address operator, address from, uint id, uint value, bytes memory data) public virtual override ERC1155ReceiveNotPaused returns(bytes4) {
        return super.onERC1155Received( operator,  from,  id,  value, data);
    }
    function onERC1155BatchReceived(address operator, address from, uint[] calldata ids, uint[] calldata values, bytes memory data) public virtual override ERC1155ReceiveNotPaused returns(bytes4) {
        return super.onERC1155BatchReceived( operator, from, ids, values, data);
    }
    function _pauseERC1155Receive() internal {
        _ERC1155ReceivePaused = true;
    } 
    function _unpauseERC1155Receive() internal {
        _ERC1155ReceivePaused = false;
    } 
    modifier ERC1155ReceiveNotPaused() {
        require(!_ERC1155ReceivePaused, "Receiving ERC1155 tokens is paused right now.");
        _;
    }
}