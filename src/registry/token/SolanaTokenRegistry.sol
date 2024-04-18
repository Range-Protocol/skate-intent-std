pragma solidity 0.8.19;
import {ISkateRegistry} from "./interfaces/ISkateRegistry.sol";

contract SolanaTokenRegistry is ISkateRegistry {
    address private owner;
    address public spl; 
    //chainId=>ticker=>token account
    mapping(uint => mapping(string => address)) records;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function createOrUpdateRecord(
        uint _chainId,
        string _ticker,
        address _token
    ) onlyOwner {
        records[_chainId][_ticker] = _token;
    }
}
