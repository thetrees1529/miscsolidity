//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract FeeTakers is Ownable, ReentrancyGuard {

    struct FeeTaker {
        address addr;
        uint points;
    }
    FeeTaker[] _feeTakers;

    event FeeSent(address to, uint amount);    

    //manage where profit is sent to

    function getFeeTakers() public view returns(FeeTaker[] memory) {
        return _feeTakers;
    }
    function addToFeeTakers(address addr, uint points) public onlyOwner {
        require(points > 0, "Points must be greater than 0.");
        _feeTakers.push(FeeTaker(addr, points));
    }
    function removeFromFeeTakers(uint index) public onlyOwner {
        _feeTakers[index] = _feeTakers[_feeTakers.length - 1];
        _feeTakers.pop();
    }
    function deleteFeeTakers() public onlyOwner {
        delete _feeTakers;
    }

    function _distributeFee(uint fee) internal nonReentrant returns(bool success) {
        if(_feeTakers.length == 0) {
            return true;
        }
        uint feePoints;
        for(uint i; i < _feeTakers.length; i ++) {
            feePoints += _feeTakers[i].points;
        }
        uint feePerPoint = fee / feePoints;
        for(uint i; i < _feeTakers.length; i ++) {
            FeeTaker storage feeTaker = _feeTakers[i];
            address feeTakerAddr = feeTaker.addr;
            uint toSend = feeTaker.points * feePerPoint;
            (bool succ,) = feeTakerAddr.call{value: toSend}("");
            if(!succ) {
                return false;
            }
            emit FeeSent(feeTakerAddr, toSend);
        }
        return true;
    }
}