
pragma solidity 0.8.19;

contract ProcessorRegistry{

    address private owner; 
    //chainId=>vm contract
    mapping(uint=>address) public records; 

    
    constructor(address _owner){
        owner = _owner; 
    }

    function createOrUpdateRecord(uint _chainId, address _processor) external onlyOwner{
        records[_chainId] = _processor;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    function getVM(uint _chainId) external view returns(address){
        return records[_chainId]; 
    }

}

