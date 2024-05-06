// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;
import {IProcessor} from '../processor/interfaces/IProcessor.sol'; 
contract IntentProcessor {
    address immutable processorRegistry;
    address immutable chainRegistry;
    mapping(uint256 => bytes32) public tasks;
    uint256 private curTaskId;

    constructor(address _chainRegistry, address _processorRegistry) {
        processorRegistry = _processorRegistry;
        chainRegistry = _chainRegistry;
    }

    event TaskCreated(uint256 taskId, bytes32 task);

    struct Op {
        address signer;
        uint chain;
        bool src;
        bytes data;
    }

    //data => 1) address 2) fn sig 3) params
    struct Task {
        bytes dAddress;
        uint sChain;
        uint dChain;
        Op[] ops;
    }

    //INTENT
    //0:31: CHAIN (32)
    //32:63 INSTRUCTION CODE (32)
    //64:95 TOKEN (32)
    //96:127 AMOUNT (32)
    //128:159 SIGNER ADDRESS SOURCE CHAIN (32)
    //160:191 EXECUTOR ADDRESS DESTINATION CHAIN (32)

    struct Intent {
        uint32 chain;
        uint32 instruction;
        uint32 tokenIn;
        uint32 amount;
        bytes32 signerAddress;
        bytes32 executorAddress;
    }

    function fulfilIntent(bytes calldata i, bytes calldata dAddress) external {
        //1. unpack intent object
        //There can be more than 1 intent in same chain

        Intent[] memory intents = abi.decode(i, (Intent[]));
        bytes[] memory ops;
        //2. route to vm specific processors

        for (uint j = 0; j < intents.length; j++) {
            //direct based on chains because still have to break down based on VM.
            ops[i] = preprocessIntent(
                chainRegistry.getVM(intents[j].chain),
                intents[j]
            );
        }

        //4. create Task
        Task memory task = Task({dAddress: intent.address, sChain: intent.sChain, dChain: intent.dChain, ops: ops});
        tasks[curTaskId++] = keccak256(abi.encode(task));

        emit TaskCreated(curTaskId-1, tasks[curTaskId-1]);
    }

    function preprocessIntent(uint vm, Intent intent) internal {
        return
            IProcessor(processorRegistry.getProcessor(vm)).processIntent(
                intent
            );
    }
}
