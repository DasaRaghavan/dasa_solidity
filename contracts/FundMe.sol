// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ExampleInterface} from "contracts/ExampleInterface.sol";  // converted ExampleInterface into a library
using ExampleInterface for uint256; // extended uint256 to include ExampleInterface (any uint256 can now use the functions in the library)

contract FundMe {

    // Allow users to deposit funds to the contract
    // Enable contract owner to withdraw deposited funds from the contract
    // Set minimum funding requirements (1 ether)
    // Two primary functions: fund, withdraw
    
    uint constant MINIMUM_USD = 5;
    address[] funders;
    mapping (address => uint) public addressFundedAmount;
    address payable public owner;
    uint public fundsReceived;


    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require (owner == msg.sender, "Not the owner - cannot withdraw funds!");
        _; 
        // this modifier is used in all the three withdraw functions of this smart contract
        // limits the withdrawal to take place if the caller is the owner of the contract
        // this underscore represents the function body that will be executed when the function uses this modifier
        // placement of this underscore within the modifier determines when the function body will be executed
        // here, we want the function body to be executed only if the require clause that precedes this underscore is successful
    }

    function fund() public payable {

        fundsReceived = msg.value.getUSDValue(); // funds received is USD equivalent wei sent via msg.value
        require (fundsReceived >= MINIMUM_USD, "Not Enough Eth, aborting");
        
        funders.push(msg.sender); // track funders
        addressFundedAmount[msg.sender] = fundsReceived; // track USD by sender

        // The following transfer is inefficient in gas usage
        // will replace with withdraw functions
        // owner.transfer(msg.value); // transfer to owner immediately 

    }

    function withdrawWithTransfer() public onlyOwner { // modifier's (onlyOwner) require clause will be executed before the function body is executed
        owner.transfer(address(this).balance);  // will withdraw all accumulated balance in the contract to the owner
                                                // has a gas limit of 2300
    }

    function withdrawWithSend() public onlyOwner {
        bool success = owner.send(address(this).balance);   // will withdraw all accumulated balance in the contract to the owner
                                                            // has a gas limit of 2300
                                                            // handle the bool return code to validate success
        require(success, "Send failed!");
    }

    function withdrawWithCall() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");    // call is flexible and powerful
                                                                            // will withdraw all accumulated balance in the contract to the owner
                                                                            // has no gas limit
                                                                            // can call any function in the contract with a function name (without an ABI)
                                                                            // handle the bool return code to validate success
        require(success, "Send with call failed!");
    }

    function getBalance() public view returns(uint) {
        return owner.balance;
    }

    function sendMoney(address payable _to) public payable {
        require (getBalance() >= msg.value, "Not enought balance to send, aborting");
        _to.transfer(msg.value);
    }


}