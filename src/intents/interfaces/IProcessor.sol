pragma solidity 0.8.19; 

interface IIntentProcessor{

    function processIntent(uint vm, Intent intent) external;
}