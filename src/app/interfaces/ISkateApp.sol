
pragma solidity 0.8.19;

interface ISkateApp{
    constructor(ISkateRegistry registry){

    }

    function fulfilIntent() external;


}