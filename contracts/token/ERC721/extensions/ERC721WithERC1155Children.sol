//SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC721WithERC1155Children.sol";
pragma solidity ^0.8.0;

abstract contract ERC721WithERC1155Children is IERC721WithERC1155Children, ERC721 {

    using Counters for Counters.Counter;

    bool _depositingERC1155;

    mapping(uint => mapping(IERC1155 => mapping(uint => uint))) _balances;

    function deposit(uint to, IERC1155 token, uint childTokenId, uint amount) public override {
        require(_exists(to), "Token does not exist.");
        
        _depositingERC1155 = true;
        token.safeTransferFrom(msg.sender, address(this), childTokenId, amount, "");
        _depositingERC1155 = false;

        _balances[to][token][childTokenId] += amount;

    }

    function withdraw(uint from, address to, IERC1155 token, uint childTokenId, uint amount) public override {

        require(_isApprovedOrOwner(msg.sender, from), "Not approved to withdraw from this token.");

        _balances[from][token][childTokenId] -= amount;
        token.safeTransferFrom(address(this), to, childTokenId, amount, "");

    }

    function balanceOfERC1155Child(uint tokenId, IERC1155 token, uint childTokenId) public override view returns(uint) {
        return _balances[tokenId][token][childTokenId];
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public override virtual onlyWhenDepositing returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public override virtual returns (bytes4) {
        revert("Cannot deposit here.");
    }

    modifier onlyWhenDepositing {
        require(_depositingERC1155);
        _;
    }    


}