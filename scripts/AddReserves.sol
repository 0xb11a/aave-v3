// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/contracts/extensions/v3-config-engine/Executor.sol";
import "./PrepareReserves.sol";

contract AddReserves is Script, PrepareReserves {
    function run() external {
        vm.startBroadcast();

        address target = 0xaf0acb8AD53065f2eC2706f6a5e9d66079C8708b; // ConfigEngine address
        uint256 value = 0; // msg.value
        string memory signature = 
            "listAssets((string,string),(address,string,address,(uint256,uint256,uint256,uint256),uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[])";
        bytes memory data = getEncodedArgs(); // get encoded args of reserve(s)
        bool withDelegatecall = true;   // true = delegatecall

        Executor executor = Executor(payable(0x051F586dc679024F8c49A4b9F436fB4997a73373)); // Executor address
        executor.executeTransaction(
            target,
            value,
            signature,
            data,
            withDelegatecall
        );

        vm.stopBroadcast();
    }
}
