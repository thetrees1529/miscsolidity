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
        require(_exists(to), "Token does not exist.");
        
        _depositingERC721 = true;
        token.safeTransferFrom(msg.sender, address(this), childTokenId, "");
        _depositingERC721 = false;

        _owned[to][token][childTokenId] = true;

    }

    function withdrawERC721(uint from, address to, IERC721 token, uint childTokenId) public override {

        require(_isApprovedOrOwner(msg.sender, from), "Not approved to withdraw from this token.");

        _owned[from][token][childTokenId] = false;
        token.safeTransferFrom(address(this), to, childTokenId, "");

    }

    function isOwnerOfERC721Child(uint tokenId, IERC721 token, uint childTokenId) public override view returns(bool) {
        return _owned[tokenId][token][childTokenId];
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public override virtual onlyWhenDepositing returns (bytes4) {
        return this.onERC721Received.selector;
    }

    modifier onlyWhenDepositing {
        require(_depositingERC721);
        _;
    }    


}