// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import { Script } from 'forge-std/Script.sol';
import 'forge-std/StdJson.sol';
import 'forge-std/console.sol';

import { AaveV3SetupBatch } from '../src/deployments/projects/aave-v3-batched/batches/AaveV3SetupBatch.sol';
import { AddReserves } from './AddReserves.sol';
import {IERC20} from 'src/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import { IPoolAddressesProvider } from 'src/contracts/interfaces/IPoolAddressesProvider.sol';
import { IRewardsController } from 'src/contracts/rewards/interfaces/IRewardsController.sol';
import { IPool } from 'src/contracts/interfaces/IPool.sol';
import { IEmissionManager } from 'src/contracts/rewards/interfaces/IEmissionManager.sol';
import {EmissionManager} from 'src/contracts/rewards/EmissionManager.sol';
import {RewardsController} from 'src/contracts/rewards/RewardsController.sol';
import { IPoolConfigurator } from 'src/contracts/interfaces/IPoolConfigurator.sol';
import { IOracle } from 'src/contracts/interfaces/IOracle.sol';
import { SetupReport, Roles, ConfigEngineReport } from 'src/deployments/interfaces/IMarketReportTypes.sol';
import { Create2Utils } from 'src/deployments/contracts/utilities/Create2Utils.sol';
import { ConfigEngine, IConfigEngine, CapsEngine, BorrowEngine, CollateralEngine, RateEngine, PriceFeedEngine, EModeEngine, ListingEngine } from 'src/contracts/extensions/v3-config-engine/ConfigEngine.sol';
import {PoolInstance} from 'src/contracts/instances/PoolInstance.sol';
import {PoolConfiguratorInstance} from 'src/contracts/instances/PoolConfiguratorInstance.sol';
import {ATokenInstance} from 'src/contracts/instances/ATokenInstance.sol';
import {VariableDebtTokenInstance} from 'src/contracts/instances/VariableDebtTokenInstance.sol';
import { DefaultReserveInterestRateStrategyV2} from 'src/contracts/misc/DefaultReserveInterestRateStrategyV2.sol';
import {IAaveIncentivesController} from 'src/contracts/interfaces/IAaveIncentivesController.sol';
import { PoolAddressesProvider } from 'src/contracts/protocol/configuration/PoolAddressesProvider.sol';
import { ProtocolDataProvider } from 'src/contracts/helpers/ProtocolDataProvider.sol';
import { ACLManager } from 'src/contracts/protocol/configuration/ACLManager.sol';
import { Oracle } from 'src/contracts/misc/Oracle.sol';
import { PoolAddressesProviderRegistry } from 'src/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol';
import { Ownable } from 'src/contracts/dependencies/openzeppelin/contracts/Ownable.sol';

contract DeployNewMarket is Script, AddReserves {
    using stdJson for string;

    string marketId = 'Hemi Market 1';
    uint256 providerId = 1;
    string pair = 'hemiBTC-WETH';
    address[] assets = [0xAA40c0c7644e0b2B224509571e10ad20d9C4ef28, 0x4200000000000000000000000000000000000006]; // hemiBTC and WETH
    address[] sources = [0xE23eCA12D7D2ED3829499556F6dCE06642AFd990, 0xb9D0073aCb296719C26a8BF156e4b599174fe1d5]; // Redstone

    function run() external {
        SetupReport memory setupReport;

        Roles memory roles = Roles(
            0x62007a126BAb6BD6C3CC56896aa59080a3e55334,  // marketOwner
            0x62007a126BAb6BD6C3CC56896aa59080a3e55334, // poolAdmin
            0x62007a126BAb6BD6C3CC56896aa59080a3e55334 // emergencyAdmin
        );

        console.log('----------- Deploy', marketId,' --------------');
        console.log('----------- Sender', msg.sender,' --------------');

        vm.startBroadcast();

        console.log('----------- Deploying Registry --------------');

        PoolAddressesProviderRegistry poolAddressesProviderRegistry = new PoolAddressesProviderRegistry(msg.sender);

        console.log('----------- Deploying and registering PoolAddressesProvider --------------');

        address poolAddressesProvider = address(new PoolAddressesProvider(marketId, msg.sender));
        poolAddressesProviderRegistry.registerAddressesProvider(
            poolAddressesProvider,
            providerId
        );
        address protocolDataProvider = address(new ProtocolDataProvider(IPoolAddressesProvider(poolAddressesProvider)));

        address oracle = address(new Oracle(
            IPoolAddressesProvider(poolAddressesProvider),
            assets,
            sources,
            0x0000000000000000000000000000000000000000,
            0x0000000000000000000000000000000000000000,
            100000000
        ));
        address poolImpl = address(new PoolInstance(IPoolAddressesProvider(poolAddressesProvider)));
        address poolConfiguratorImpl = address(new PoolConfiguratorInstance());

        console.log('PoolAddressesProviderRegistry:', address(poolAddressesProviderRegistry));
        console.log('PoolAddressesProvider:', poolAddressesProvider);
        console.log('ProtocolDataProvider:', protocolDataProvider);
        console.log('Oracle:', oracle);
        console.log('PoolImpl:', poolImpl);
        console.log('PoolConfiguratorImpl:', poolConfiguratorImpl);

        console.log('----------- Setting proxies of PriceOracle, PoolImpl, PoolConfiguratorImpl, PoolDataProvider --------------');

        IPoolAddressesProvider provider = IPoolAddressesProvider(poolAddressesProvider);
        provider.setPriceOracle(oracle);
        provider.setPoolImpl(poolImpl);
        provider.setPoolConfiguratorImpl(poolConfiguratorImpl);
        provider.setPoolDataProvider(protocolDataProvider);

        setupReport.poolProxy = address(provider.getPool());
        setupReport.poolConfiguratorProxy = address(provider.getPoolConfigurator());

        console.log('----------- Setting proxies of RewardsController --------------');

        IEmissionManager emissionManager = IEmissionManager(new EmissionManager(msg.sender));
        address rewardsControllerImplementation = address(new RewardsController(address(emissionManager)));
        RewardsController(rewardsControllerImplementation).initialize(address(0));
        bytes32 controllerId = keccak256('INCENTIVES_CONTROLLER');
        provider.setAddressAsProxy(controllerId, rewardsControllerImplementation);
        setupReport.rewardsControllerProxy = provider.getAddress(controllerId);
        emissionManager.setRewardsController(setupReport.rewardsControllerProxy);
        Ownable(address(emissionManager)).transferOwnership(roles.poolAdmin);

        console.log('EmissionManager:', address(emissionManager));
        console.log('PoolProxy:', setupReport.poolProxy);
        console.log('PoolConfiguratorProxy:', setupReport.poolConfiguratorProxy);
        console.log('RewardsControllerImplementation:', rewardsControllerImplementation);
        console.log('RewardsControllerProxy:', setupReport.rewardsControllerProxy);

        console.log('----------- Deploying ACLManager --------------');

        provider.setACLAdmin(msg.sender);

        ACLManager manager = new ACLManager(IPoolAddressesProvider(poolAddressesProvider));
        setupReport.aclManager = address(manager);

        address interestRateStrategy = address(
            new DefaultReserveInterestRateStrategyV2(poolAddressesProvider)
        );

        console.log('InterestRateStrategy:', interestRateStrategy);

        console.log('----------- Setting roles in ACLManager --------------');

        provider.setACLAdmin(roles.poolAdmin);
        provider.setACLManager(address(manager));
        Ownable(address(provider)).transferOwnership(roles.marketOwner);

        manager.addEmergencyAdmin(roles.emergencyAdmin);

        console.log('ACLManager:', setupReport.aclManager);

        console.log('----------- Deploying ConfigEngine --------------');

        SetupReport memory _setupReport = setupReport;
        Roles memory _roles = roles;

        ConfigEngineReport memory configEngineReport;
        IConfigEngine.EngineLibraries memory engineLibraries = IConfigEngine.EngineLibraries({
            listingEngine: Create2Utils._create2Deploy('v1', type(ListingEngine).creationCode),
            eModeEngine: Create2Utils._create2Deploy('v1', type(EModeEngine).creationCode),
            borrowEngine: Create2Utils._create2Deploy('v1', type(BorrowEngine).creationCode),
            collateralEngine: Create2Utils._create2Deploy('v1', type(CollateralEngine).creationCode),
            priceFeedEngine: Create2Utils._create2Deploy('v1', type(PriceFeedEngine).creationCode),
            rateEngine: Create2Utils._create2Deploy('v1', type(RateEngine).creationCode),
            capsEngine: Create2Utils._create2Deploy('v1', type(CapsEngine).creationCode)
        });

        IConfigEngine.EngineConstants memory engineConstants = IConfigEngine.EngineConstants({
            pool: IPool(_setupReport.poolProxy),
            poolConfigurator: IPoolConfigurator(_setupReport.poolConfiguratorProxy),
            defaultInterestRateStrategy: interestRateStrategy,
            oracle: IOracle(oracle),
            rewardsController: _setupReport.rewardsControllerProxy,
            collector: _roles.marketOwner
        });

        configEngineReport.listingEngine = engineLibraries.listingEngine;
        configEngineReport.eModeEngine = engineLibraries.eModeEngine;
        configEngineReport.borrowEngine = engineLibraries.borrowEngine;
        configEngineReport.collateralEngine = engineLibraries.collateralEngine;
        configEngineReport.priceFeedEngine = engineLibraries.priceFeedEngine;
        configEngineReport.rateEngine = engineLibraries.rateEngine;
        configEngineReport.capsEngine = engineLibraries.capsEngine;

        ATokenInstance aToken = new ATokenInstance(IPool(_setupReport.poolProxy));
        VariableDebtTokenInstance variableDebtToken = new VariableDebtTokenInstance(IPool(_setupReport.poolProxy));

        console.log('ATokenInstance:', address(aToken));
        console.log('VariableDebtTokenInstance:', address(variableDebtToken));

        aToken.initialize(
            IPool(_setupReport.poolProxy), // pool proxy
            address(0), // treasury
            address(0), // asset
            IAaveIncentivesController(address(0)), // incentives controller
            0, // decimals
            'ATOKEN_IMPL', // name
            'ATOKEN_IMPL', // symbol
            bytes("") // params
        );

        variableDebtToken.initialize(
            IPool(_setupReport.poolProxy), // initializingPool
            address(0), // underlyingAsset
            IAaveIncentivesController(address(0)), // incentivesController
            0, // debtTokenDecimals
            'VARIABLE_DEBT_TOKEN_IMPL', // debtTokenName
            'VARIABLE_DEBT_TOKEN_IMPL', // debtTokenSymbol
            bytes("") // params
        );

        configEngineReport.configEngine = address(
            new ConfigEngine(
                address(aToken), 
                address(variableDebtToken),
                engineConstants, 
                engineLibraries
            )
        );

        console.log('ConfigEngine:', configEngineReport.configEngine);

        console.log('----------- Adding ',pair,' pair --------------');

        manager.addPoolAdmin(0x35620B9787b9b9f2f66a5F821A7b5605E03A0B54); // executor
        addPair(pair, configEngineReport.configEngine);
        manager.addPoolAdmin(_roles.poolAdmin);
        manager.grantRole(manager.DEFAULT_ADMIN_ROLE(), _roles.poolAdmin);
        manager.revokeRole(manager.DEFAULT_ADMIN_ROLE(), msg.sender);

        console.log('----------- Finished adding new Market of ',pair, ' pair --------------');

        vm.stopBroadcast();
    }
}
