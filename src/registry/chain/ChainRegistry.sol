// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;

contract ChainRegistry{

    address private owner; 
    //chainId
    //type: type of ecosystem 
    //type 0 : evm. type 1: cosmos, type2: solana etc 
    mapping(uint=>uint) public records; 

    
    constructor(address _owner){
        owner = _owner; 
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function createOrUpdateRecord(uint _token, uint _chainId, address _settlement) external onlyOwner{
        records[_token][_chainId] = _settlement; 
    }

}