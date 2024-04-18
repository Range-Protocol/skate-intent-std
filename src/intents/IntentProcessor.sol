pragma solidity 0.8.19; 

contract IntentProcessor{
    address immutable processorRegistry; 
    mapping(uint256 => bytes32) public tasks;
    uint256 private curTaskId; 

    constructor(address _processorRegistry){
        processorRegistry = _processorRegistry;
    }

    event TaskCreated(uint256 taskId, bytes32 task);

     struct Op{
        address signer; 
        bool src; 
        bytes data; 
    }
    
    //data => 1) address 2) fn sig 3) params
    struct Task{
        bytes dAddress;
        uint sChain; 
        uint dChain; 
        Op[] ops; 

    }

    struct Intent{
        uint sChain; 
        uint dChain; 
        Op[] ops;
    }
    function fulfilIntent(bytes calldata i, bytes calldata dAddress) external{
        //1. unpack intent object
        Intent memory intent = abi.decode(i, (Intent));
        //2. processing by chain 
        Op[] memory ops = abi.decode(intent.ops, (Op[])); 
        
        //3. route to vm specific processors
        //processIntent(chainRegistry.getVM(intent.sChain), ops); 

        //4. create Task
        //are we preparing calldata here or will skate operators prepare calldata themselves?  
        // taskId: task Id issued on Skate 
        // dAddress: address of executor on destination chain (not sure if it will always be 32bytes on other chains as well)
        // sChain: sourceChain
        // dChain: destinationChain 
        // ops: embeddded calldata 
        Task memory task = Task({
            dAddress: dAddress,
            sChain: intent.sChain,
            dChain: intent.dChain,
            ops: intent.ops
        });
        tasks[curTaskId++] = keccak256(abi.encode(task));

        emit TaskCreated(curTaskId, tasks[curTaskId]);
    }

    // function processIntent(uint vm, ) internal{
    //     IProcessor(processorRegistry.getProcessor(vm)).processIntent();

    // }

}