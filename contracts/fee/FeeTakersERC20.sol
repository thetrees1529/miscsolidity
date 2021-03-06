//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract FeeTakersERC20 is Ownable{
    struct FeeTakerERC20 {
        address addr;
        uint points;
    }
    FeeTakerERC20[] _feeTakersERC20;

    event FeeSentERC20(IERC20 token, address to, uint amount);    

    //manage where profit is sent to
    function getFeeTakersERC20() public view returns(FeeTakerERC20[] memory) {
        return _feeTakersERC20;
    }

    function addToFeeTakersERC20(address addr, uint points) public onlyOwner {
        _feeTakersERC20.push(FeeTakerERC20(addr, points));
    }

    function removeFromFeeTakersERC20(uint index) public onlyOwner {
        _feeTakersERC20[index] = _feeTakersERC20[_feeTakersERC20.length - 1];
        _feeTakersERC20.pop();
    }

    function deleteFeeTakersERC20() public onlyOwner {
        delete _feeTakersERC20;
    }

    function _distributeFeeERC20(IERC20 token, uint fee) internal returns(bool success) {
        if(_feeTakersERC20.length == 0) {
            return true;
        }
        uint feePoints;
        for(uint i; i < _feeTakersERC20.length; i ++) {
            feePoints += _feeTakersERC20[i].points;
        }

        uint feePerPoint = fee / feePoints;
        
        for(uint i; i < _feeTakersERC20.length; i ++) {
            FeeTakerERC20 storage feeTaker = _feeTakersERC20[i];
            address feeTakerAddr = feeTaker.addr;
            uint toSend = feeTaker.points * feePerPoint;
            token.transfer(feeTakerAddr, toSend);
            emit FeeSentERC20(token, feeTakerAddr, toSend);
        }
        return true;
    }

    function withdrawERC20(IERC20 token, uint amount) external onlyOwner {
        token.transfer(msg.sender, amount);
    }
}