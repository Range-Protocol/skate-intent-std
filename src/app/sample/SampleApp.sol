// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;

import {ISkateApp} from "../interfaces/ISkateApp.sol";
import {IntentProcessor} from "../intents/IntentProcessor.sol";

contract SampleApp is ISkateApp {
    IntentProcessor intentProcessor;
    mapping(address => uint) loanAmounts;

    //Assuming app is a lending protocol
    function takeLoan(Intent intent) public {
        intentProcessor.processIntent(intent);
        loanAmount[msg.sender] += intent.amount;
    }
}
