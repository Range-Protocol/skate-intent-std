// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19; 
import {IProcessor} from '../interfaces/IProcessor.sol';

contract EVMProcessor is IProcessor{ 
    //INTENT
    //0:31 INSTRUCTION CODE (32)
    //32:63 TOKEN (32) 
    //64:95 AMOUNT (32)
    //96:127 SIGNER ADDRESS SOURCE CHAIN (32)
    //128:155 SIGNER ADDRESS DESTINATION CHAIN (32)
    //155:187 EXECUTOR ADDRESS SOURCE CHAIN (32)
    //188:219 EXECUTOR ADDRESS DESTINATION CHAIN (32)

    //Need to store permit2 address across different chains. 

    function processIntent(Intent calldata intent) external{
        //0. Break intent up into bytes
        //TODO: offchain library (SkateIntentLibrary.js)
        
        //TRANSFER 
        //transfer(address to, uint256 value)
        if(instruction == 0){       
            return abi.encodeWithSelector(instructionRegistry.getSelector(intent.instruction,
                            tokenRegistry.getTokenAddress(intent.token). 
                            intent.amount));
        }
        //TRANSFER FROM
        if(instruction == 1){       
            return abi.encodeWithSelector(instructionRegistry.getSelector(intent.instruction,
                            tokenRegistry.getTokenAddress(intent.token). 
                            intent.amount));
        }

    }
}