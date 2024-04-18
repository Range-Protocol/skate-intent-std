
pragma solidity 0.8.19;

contract SettlementRegistry{

    address private owner; 
    //chainId=>settlement contract
    mapping(uint=>address) public records; 

    
    constructor(address _owner){
        owner = _owner; 
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function createOrUpdateRecord(string _token, uint _chainId, address _settlement) external onlyOwner{
        records[_token][_chainId] = _settlement; 
    }

}
