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

        Executor executor = Executor(payable(0x051F586dc679024F8c49A4b9F436fB4997a73373)); // Executor address
        executor.executeTransaction(
            _configEngine, // ConfigEngine address
            value,
            signature,
            data,
            withDelegatecall
        );
    }
}
