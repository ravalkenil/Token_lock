// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Purchase is ERC20, Ownable{

    uint256 private totalSupplytoken_;
    address to = address(this);
    uint totalclaim = 0;

    constructor(uint _totalSupplytoken)ERC20 ("mytoken","dvs"){
        totalSupplytoken_ = _totalSupplytoken;
        _mint(to, totalSupplytoken_);
        BuyToken();
    }
    address[] user1 = [0x180d40db7b4e9B56ef444f42A85233453380dff0,
    0xa12D9F620587ACae5037D7023493e155B0630d62,
    0x2df8EEC8B0F540a361Eea697BD36b9051A340fce,
    0xB6576AF9DBa8c421067b823551f69aD782086D1a,
    0xBB02c866457ECb1CA343b8A7e56166e9408E1965];
    
    struct Order{
        address Buyer;
        uint Amount;
        bool is_Claimed;
        uint claimTime; 
    }
    mapping(address=>Order) orderToken;
    uint order_id = 1;

    event OrderPlaced(uint OrderID, uint BuyTime);
    event OrderClaimed(address OrderID, uint ClaimTime);

    
    function totalSupply() public view virtual override returns (uint256) {
        return totalSupplytoken_;
    }
    
    mapping(address=>uint) public limit;    

    function BuyToken() public returns(string memory){
        if(totalSupplytoken_ == balanceOf(address(this))){
            for(uint i=0;i<user1.length;i++){
                if(user1[i]==0x180d40db7b4e9B56ef444f42A85233453380dff0 || user1[i]==0xa12D9F620587ACae5037D7023493e155B0630d62){
                    uint _amount = (totalSupplytoken_*5)/100;
                    // transfer(user1[0],_amount);
                    _transfer(to,user1[i], _amount);
                    emit OrderPlaced(order_id,block.timestamp);
                    orderToken[user1[i]] = Order(user1[i],_amount,false,block.timestamp);
                    order_id++;
                }
                else if(user1[i]==0x2df8EEC8B0F540a361Eea697BD36b9051A340fce || user1[i]==0xB6576AF9DBa8c421067b823551f69aD782086D1a){
                    uint _amount = (totalSupplytoken_*10)/100;
                    _transfer(to,user1[i], _amount);
                    emit OrderPlaced(order_id,block.timestamp);
                    orderToken[user1[i]] = Order(user1[i],_amount,false,block.timestamp);
                    order_id++;
                }
                else if(user1[i]==0xBB02c866457ECb1CA343b8A7e56166e9408E1965){
                    uint _amount = (totalSupplytoken_*20)/100;
                    _transfer(to,user1[i], _amount);
                    emit OrderPlaced(order_id,block.timestamp);
                    orderToken[user1[i]] = Order(user1[i],_amount,false,block.timestamp);
                }
                else{
                    string memory msg = "You Are Not Valid User";
                    return msg;
                }

                limit[user1[i]]=(totalSupplytoken_*10)/100;
            }
        }else{
            string memory msg = "Not Buy Token";
            return msg;
        }
    }

    function check_claimed_token() public view returns(uint){
        uint claimed_token = totalSupplytoken_ - balanceOf(address(this));
        return claimed_token;
    }
    
    function Claim_Locktoken(uint _amu) public {
        require(isClaimer(msg.sender),"You are not the Buyer of this order");
        require(isClaimable(msg.sender,_amu),"You can't claim this much of token");
        limit[msg.sender] -= _amu;
        totalclaim += _amu;
        _transfer(to,msg.sender, _amu);

        
        emit OrderClaimed(msg.sender,block.timestamp);
        orderToken[msg.sender].is_Claimed = true;
    }

    function isClaimable(address _add,uint _amu) public view returns(bool){
        if(limit[_add]>=_amu){
            return true;
        }
        return false;
    }

    function isClaimer(address _user) public view returns(bool) {
        if(orderToken[msg.sender].Buyer==_user){
            return true;
        }
        return false;
    }   
}


// 0x04c91099643075d6482eFAeaB7D87Fe9FA5fE120