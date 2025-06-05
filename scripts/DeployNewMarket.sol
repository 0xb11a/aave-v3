// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import { Script } from 'forge-std/Script.sol';
import 'forge-std/StdJson.sol';
import 'forge-std/console.sol';

import { AaveV3SetupBatch } from '../src/deployments/projects/aave-v3-batched/batches/AaveV3SetupBatch.sol';
import { AddReserves } from './AddReserves.sol';

import { IPoolAddressesProvider } from 'src/contracts/interfaces/IPoolAddressesProvider.sol';
import { IRewardsController } from 'src/contracts/rewards/interfaces/IRewardsController.sol';
import { IEmissionManager } from 'src/contracts/rewards/interfaces/IEmissionManager.sol';
import { SetupReport, Roles } from 'src/deployments/interfaces/IMarketReportTypes.sol';

import { PoolAddressesProvider } from 'src/contracts/protocol/configuration/PoolAddressesProvider.sol';
import { ACLManager } from 'src/contracts/protocol/configuration/ACLManager.sol';
import { PoolAddressesProviderRegistry } from 'src/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol';
import { Ownable } from 'src/contracts/dependencies/openzeppelin/contracts/Ownable.sol';

contract DeployNewMarket is Script, AddReserves {
    using stdJson for string;

    string marketId = 'Lendle Market sUSDe 1';
    uint256 providerId = 1;
    string pair = 'sUSDe-USDe';

    function run() external {
        SetupReport memory setupReport;

        Roles memory roles = Roles(
            0x62007a126BAb6BD6C3CC56896aa59080a3e55334,  // marketOwner
            0x62007a126BAb6BD6C3CC56896aa59080a3e55334, // poolAdmin
            0x62007a126BAb6BD6C3CC56896aa59080a3e55334 // emergencyAdmin
        );

        console.log('----------- Deploy ', marketId, ' --------------');
        console.log('----------- Sender', msg.sender, ' --------------');

        vm.startBroadcast();

        console.log('----------- Deploying and registering PoolAddressesProvider --------------');

        address poolAddressesProvider = address(new PoolAddressesProvider(marketId, msg.sender));
        PoolAddressesProviderRegistry poolAddressesProviderRegistry = PoolAddressesProviderRegistry(0x5196208f0DADc5336af1285720bB6d684c061943);
        poolAddressesProviderRegistry.registerAddressesProvider(
            poolAddressesProvider,
            providerId
        );
        Ownable(poolAddressesProviderRegistry).transferOwnership(roles.marketOwner);

        console.log('PoolAddressesProvider address: ', poolAddressesProvider);

        console.log('----------- Setting proxies of PriceOracle, PoolImpl, PoolConfiguratorImpl, PoolDataProvider --------------');

        IPoolAddressesProvider provider = IPoolAddressesProvider(poolAddressesProvider);
        provider.setPriceOracle(0x299c966546f0F33Dd117Aff7280964fBa42F5951); // TODO: maybe use exist price oracle?
        provider.setPoolImpl(0x6d3d358e7Be68e80bF79Cdf6d077d4BFD8bA1639);
        provider.setPoolConfiguratorImpl(0xDf0adF9EFb5e2Ca0765e2E31F7fd0dD516133bDF);
        provider.setPoolDataProvider(0xF89465de26722775058aE7899DDD4E9719bd1E02);

        setupReport.poolProxy = address(provider.getPool());
        setupReport.poolConfiguratorProxy = address(provider.getPoolConfigurator());

        console.log('----------- Setting proxies of RewardsController --------------');

        bytes32 controllerId = keccak256('INCENTIVES_CONTROLLER');
        provider.setAddressAsProxy(controllerId, 0x869FAB59a8a130a73DF3c7B740D84b23Ffe32325);
        setupReport.rewardsControllerProxy = provider.getAddress(controllerId);
        IEmissionManager emissionManager = IEmissionManager(
            IRewardsController(setupReport.rewardsControllerProxy).EMISSION_MANAGER()
        );
        emissionManager.setRewardsController(setupReport.rewardsControllerProxy);
        Ownable(address(emissionManager)).transferOwnership(roles.poolAdmin);

        console.log('PoolProxy address: ', setupReport.poolProxy);
        console.log('PoolConfiguratorProxy address: ', setupReport.poolConfiguratorProxy);
        console.log('RewardsControllerProxy address: ', setupReport.rewardsControllerProxy);

        console.log('----------- Deploying ACLManager --------------');

        provider.setACLAdmin(address(this));

        ACLManager manager = new ACLManager(IPoolAddressesProvider(poolAddressesProvider));

        console.log('----------- Setting roles in ACLManager --------------');

        provider.setACLAdmin(roles.poolAdmin);
        provider.setACLManager(address(manager));

        manager.addPoolAdmin(roles.poolAdmin);
        manager.addEmergencyAdmin(roles.emergencyAdmin);
        manager.grantRole(manager.DEFAULT_ADMIN_ROLE(), roles.poolAdmin);
        manager.revokeRole(manager.DEFAULT_ADMIN_ROLE(), msg.sender);

        console.log('ACLManager address: ', setupReport.aclManager);

        console.log('----------- Adding ', pair, ' pair --------------');

        addPair(pair);

        console.log('----------- Finished Adding ', pair, ' pair --------------');

        vm.stopBroadcast();
    }
}
