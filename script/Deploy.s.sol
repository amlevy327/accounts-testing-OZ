// script/Deploy.s.sol
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {MyAccount} from "../src/MyAccount.sol";
import {MyFactoryAccount} from "../src/MyFactoryAccount.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast(); // Begins sending real transactions with your key

        MyAccount implementation = new MyAccount(); // deploy base account
        MyFactoryAccount factory = new MyFactoryAccount(address(implementation)); // deploy factory

        console.log("Factory deployed at:", address(factory));

        vm.stopBroadcast(); // Ends txs
    }
}
