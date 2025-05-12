// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/contracts/extensions/v3-config-engine/Executor.sol";

contract DeployExecutor is Script {
    function run() external {
        vm.startBroadcast();

        new Executor();

        vm.stopBroadcast();
    }
}
