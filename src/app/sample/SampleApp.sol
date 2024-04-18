pragma solidity 0.8.19; 

import {ISkateApp} from '../interfaces/ISkateApp.sol';

contract SampleApp is ISkateApp{

    IntentProcessor intentProcessor; 
    mapping(address=>uint) loanAmounts; 
  
    function takeLoan(){
        intentProcessor.processIntent(intent);
        => fulfilIntent => task published

        loanAmount[msg.sender] += intent.amount; 

    }
    
}
