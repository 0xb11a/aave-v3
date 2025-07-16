// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../src/contracts/extensions/v3-config-engine/Executor.sol";
import "./PrepareReserves.sol";

contract AddReserves is PrepareReserves {
    uint256 value = 0; // msg.value
    string signature = 
            "listAssets((string,string),(address,string,address,(uint256,uint256,uint256,uint256),uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[])";
    bool withDelegatecall = true;   // true = delegatecall
    bytes data;

    function addPair(string memory _pairToAdd, address _configEngine) public {
        data = getEncodedArgs(_pairToAdd); // get encoded args of reserve(s)

        Executor executor = Executor(payable(0x35620B9787b9b9f2f66a5F821A7b5605E03A0B54)); // Executor address
        executor.executeTransaction(
            _configEngine, // ConfigEngine address
            value,
            signature,
            data,
            withDelegatecall
        );
    }
}
