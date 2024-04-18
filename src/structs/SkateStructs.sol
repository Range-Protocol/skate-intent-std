contract SkateStructs{

    //sChain: source chain 
    //dChain: destination chain
    struct SkateIntent{
        uint sChain; 
        uint dChain; 
        bytes signature; 
        bytes data;

    }
}