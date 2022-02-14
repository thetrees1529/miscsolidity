//SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./IERC721WithERC721Children.sol";
pragma solidity ^0.8.0;

abstract contract ERC721WithERC721Children is IERC721WithERC721Children, ERC721 {

    using Counters for Counters.Counter;

    bool _depositingERC721;

    mapping(uint => mapping(IERC721 => mapping(uint => bool))) _owned;

    function depositERC721(uint to, IERC721 token, uint childTokenId) public override {
        
        _beforeERC721Deposit(to, token, childTokenId);
        _depositFrom(msg.sender, to, token, childTokenId);

    }

    function withdrawERC721(uint from, address to, IERC721 token, uint childTokenId) public override {

        require(_isApprovedOrOwner(msg.sender, from), "Not approved to withdraw from this token.");

        _beforeERC721Withdrawal(from, to, token, childTokenId);
        _withdrawTo(from, to, token, childTokenId);

    }

    function isOwnerOfERC721Child(uint tokenId, IERC721 token, uint childTokenId) public override view returns(bool) {
        return _owned[tokenId][token][childTokenId];
    }

    function _depositFrom(address from, uint to, IERC721 token, uint childTokenId) private cantBeDepositingERC721 {
        require(_exists(to), "Token does not exist.");
        
        _depositingERC721 = true;
        token.safeTransferFrom(from, address(this), childTokenId, "");
        _depositingERC721 = false;

        _owned[to][token][childTokenId] = true;
    }

    function _withdrawTo(uint from, address to, IERC721 token, uint childTokenId) private {

        require(_exists(from), "Token does not exist.");
        require(_owned[from][token][childTokenId] == true, "Token does not own child token.");
        _owned[from][token][childTokenId] = false;
        token.safeTransferFrom(address(this), to, childTokenId, "");

    }

    function _beforeERC721Deposit(uint tokenId, IERC721 token, uint childTokenId) internal virtual {
        
    }

    function _beforeERC721Withdrawal(uint tokenId, address to, IERC721 token, uint childTokenId) internal virtual {
        
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public override virtual onlyWhenDepositingERC721 returns (bytes4) {
        return this.onERC721Received.selector;
    }

    modifier onlyWhenDepositingERC721 {
        require(_depositingERC721);
        _;
    }  

    modifier cantBeDepositingERC721 {
        require(!_depositingERC721);
        _;
    }    


}