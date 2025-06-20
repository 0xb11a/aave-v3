// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/contracts/extensions/v3-config-engine/Executor.sol";
import {IConfigEngine} from "../src/contracts/extensions/v3-config-engine/IConfigEngine.sol";

contract PrepareReserves is Script {
    function getEncodedArgs(string memory pairName) public pure returns (bytes memory) {
        IConfigEngine.PoolContext memory context = IConfigEngine.PoolContext({
            networkName: "Mantle",
            networkAbbreviation: "mnt"
        });

        IConfigEngine.Listing[] memory listings = new IConfigEngine.Listing[](2); // change array size based on number of assets

        if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("sUSDe-USDe"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2,
                assetSymbol: "sUSDe",
                priceFeed: 0x6d5110FB8F6a65c46B89a64C9ac7E3542D31AbA3,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100, // default value, cannot be 0
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 9200,
                liqThreshold: 9500,
                liqBonus: 500,
                reserveFactor: 1, // default value, cannot be 0
                supplyCap: 30_000_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34,
                assetSymbol: "USDe",
                priceFeed: 0x5166FC3adff16E99bb099834a1315e57C5444394,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 9000,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 600,
                    variableRateSlope2: 5000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 30_000_000,
                borrowCap: 5_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("sUSDe-USDT"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2,
                assetSymbol: "sUSDe",
                priceFeed: 0x6d5110FB8F6a65c46B89a64C9ac7E3542D31AbA3,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100, // default value, cannot be 0
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 9000,
                liqThreshold: 9300,
                liqBonus: 500,
                reserveFactor: 1, // default value, cannot be 0
                supplyCap: 30_000_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x201EBa5CC46D216Ce6DC03F6a759e8E766e956aE,
                assetSymbol: "USDT",
                priceFeed: 0xd86048D5e4fe96157CE03Ae519A9045bEDaa6551,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 9000,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 600,
                    variableRateSlope2: 7000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 30_000_000,
                borrowCap: 2_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });
        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("mETH-WETH"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xcDA86A272531e8640cD7F1a92c01839911B90bb0,
                assetSymbol: "mETH",
                priceFeed: 0xB16FcAFB8378baA0a69142a325878FDCad58606A,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100, // default value, cannot be 0
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 9200,
                liqThreshold: 9500,
                liqBonus: 500,
                reserveFactor: 1, // default value, cannot be 0
                supplyCap: 20_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0xdEAddEaDdeadDEadDEADDEAddEADDEAddead1111,
                assetSymbol: "WETH",
                priceFeed: 0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 9000,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 320,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 20_000,
                borrowCap: 1_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("mETH-USDe"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xcDA86A272531e8640cD7F1a92c01839911B90bb0,
                assetSymbol: "mETH",
                priceFeed: 0xB16FcAFB8378baA0a69142a325878FDCad58606A,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100, // default value, cannot be 0
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 8000,
                liqThreshold: 8600,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 20_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34,
                assetSymbol: "USDe",
                priceFeed: 0x5166FC3adff16E99bb099834a1315e57C5444394,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 9000,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 450,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 30_000_000,
                borrowCap: 2_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("cmETH-WETH"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xE6829d9a7eE3040e1276Fa75293Bde931859e8fA,
                assetSymbol: "cmETH",
                priceFeed: 0xB16FcAFB8378baA0a69142a325878FDCad58606A,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 9200,
                liqThreshold: 9500,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 20_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0xdEAddEaDdeadDEadDEADDEAddEADDEAddead1111,
                assetSymbol: "WETH",
                priceFeed: 0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 9000,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 320,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 20_000,
                borrowCap: 1_250,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("cmETH-USDe"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xE6829d9a7eE3040e1276Fa75293Bde931859e8fA,
                assetSymbol: "cmETH",
                priceFeed: 0xB16FcAFB8378baA0a69142a325878FDCad58606A,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 8000,
                liqThreshold: 8600,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 20_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34,
                assetSymbol: "USDe",
                priceFeed: 0x5166FC3adff16E99bb099834a1315e57C5444394,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 9000,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 450,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 30_000_000,
                borrowCap: 4_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("cmETH-MNT"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xE6829d9a7eE3040e1276Fa75293Bde931859e8fA,
                assetSymbol: "cmETH",
                priceFeed: 0xB16FcAFB8378baA0a69142a325878FDCad58606A,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 8000,
                liqThreshold: 8600,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 20_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x78c1b0C915c4FAA5FffA6CAbf0219DA63d7f4cb8,
                assetSymbol: "MNT",
                priceFeed: 0xD97F20bEbeD74e8144134C4b148fE93417dd0F96,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 6500,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 450,
                    variableRateSlope2: 100_00
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 50_000_000,
                borrowCap: 3_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("fBTC-WETH"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xC96dE26018A54D51c097160568752c4E3BD6C364,
                assetSymbol: "fBTC",
                priceFeed: 0x73b15e19b247263D03D7938f1356304b7B330Ff0,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 7000,
                liqThreshold: 7500,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 500,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0xdEAddEaDdeadDEadDEADDEAddEADDEAddead1111,
                assetSymbol: "WETH",
                priceFeed: 0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 6500,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 320,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 20_000,
                borrowCap: 1_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("fBTC-USDe"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xC96dE26018A54D51c097160568752c4E3BD6C364,
                assetSymbol: "fBTC",
                priceFeed: 0x73b15e19b247263D03D7938f1356304b7B330Ff0,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 7000,
                liqThreshold: 7500,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 500,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34,
                assetSymbol: "USDe",
                priceFeed: 0x5166FC3adff16E99bb099834a1315e57C5444394,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 6500,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 450,
                    variableRateSlope2: 5000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 30_000_000,
                borrowCap: 3_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("fBTC-MNT"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0xC96dE26018A54D51c097160568752c4E3BD6C364,
                assetSymbol: "fBTC",
                priceFeed: 0x73b15e19b247263D03D7938f1356304b7B330Ff0,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 7000,
                liqThreshold: 7500,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 500,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x78c1b0C915c4FAA5FffA6CAbf0219DA63d7f4cb8,
                assetSymbol: "MNT",
                priceFeed: 0xD97F20bEbeD74e8144134C4b148fE93417dd0F96,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 6500,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 450,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 50_000_000,
                borrowCap: 3_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("MNT-WETH"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0x78c1b0C915c4FAA5FffA6CAbf0219DA63d7f4cb8,
                assetSymbol: "MNT",
                priceFeed: 0xD97F20bEbeD74e8144134C4b148fE93417dd0F96,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 7500,
                liqThreshold: 8000,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 50_000_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0xdEAddEaDdeadDEadDEADDEAddEADDEAddead1111,
                assetSymbol: "WETH",
                priceFeed: 0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 6500,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 320,
                    variableRateSlope2: 8000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 20_000,
                borrowCap: 1_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else if (keccak256(abi.encodePacked(pairName)) == keccak256(abi.encodePacked("MNT-USDe"))) {
            listings[0] = IConfigEngine.Listing({
                asset: 0x78c1b0C915c4FAA5FffA6CAbf0219DA63d7f4cb8,
                assetSymbol: "MNT",
                priceFeed: 0xD97F20bEbeD74e8144134C4b148fE93417dd0F96,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 100,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 0,
                    variableRateSlope2: 0
                }),
                enabledToBorrow: 0,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 7500,
                liqThreshold: 8000,
                liqBonus: 500,
                reserveFactor: 1,
                supplyCap: 50_000_000,
                borrowCap: 0,
                debtCeiling: 0,
                liqProtocolFee: 1000
            });

            listings[1] = IConfigEngine.Listing({
                asset: 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34,
                assetSymbol: "USDe",
                priceFeed: 0x5166FC3adff16E99bb099834a1315e57C5444394,
                rateStrategyParams: IConfigEngine.InterestRateInputData({
                    optimalUsageRatio: 6500,
                    baseVariableBorrowRate: 0,
                    variableRateSlope1: 450,
                    variableRateSlope2: 5000
                }),
                enabledToBorrow: 1,
                borrowableInIsolation: 0,
                withSiloedBorrowing: 0,
                flashloanable: 0,
                ltv: 0,
                liqThreshold: 0,
                liqBonus: 0,
                reserveFactor: 15,
                supplyCap: 30_000_000,
                borrowCap: 3_000_000,
                debtCeiling: 0,
                liqProtocolFee: 0
            });

        } else {
            revert("Unsupported pair name");
        }

        return abi.encode(context, listings);
    }
}