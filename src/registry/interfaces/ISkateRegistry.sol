

interface ISkateRegistry{
   address private owner; 
   
   function createOrUpdateRecord(uint _chainId, address _settlement) external;
    
}