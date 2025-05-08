// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/contracts/rewards/transfer-strategies/PullRewardsTransferStrategy.sol";

contract DeployPullRewardsTransferStrategy is Script {
    function run() external {
        address incentivesController = 0x00a6D3B87E70d37bF38e7CdEe3a4759509c4a1b4;
        address rewardsAdmin = 0x62007a126BAb6BD6C3CC56896aa59080a3e55334;
        address rewardsVault = 0x62007a126BAb6BD6C3CC56896aa59080a3e55334;

        vm.startBroadcast();

        new PullRewardsTransferStrategy(
            incentivesController,
            rewardsAdmin,
            rewardsVault
        );

        vm.stopBroadcast();
    }
}
