// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../src/contracts/extensions/v3-config-engine/Executor.sol";
import "./PrepareReserves.sol";

contract AddReserves is PrepareReserves {
    address target = 0xaf0acb8AD53065f2eC2706f6a5e9d66079C8708b; // ConfigEngine address
    uint256 value = 0; // msg.value
    string signature = 
            "listAssets((string,string),(address,string,address,(uint256,uint256,uint256,uint256),uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[])";
    bool withDelegatecall = true;   // true = delegatecall
    bytes data;

    function addPair(string memory _pairToAdd) public {
        data = getEncodedArgs(_pairToAdd); // get encoded args of reserve(s)

        Executor executor = Executor(payable(0x051F586dc679024F8c49A4b9F436fB4997a73373)); // Executor address
        executor.executeTransaction(
            target,
            value,
            signature,
            data,
            withDelegatecall
        );
    }
}
