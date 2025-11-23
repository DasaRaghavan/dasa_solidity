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

    function fund() public payable {

        fundsReceived = msg.value.getUSDValue(); // funds received is USD equivalent wei sent via msg.value
        require (fundsReceived >= MINIMUM_USD, "Not Enough Eth, aborting");
        
        funders.push(msg.sender); // track funders
        addressFundedAmount[msg.sender] = fundsReceived; // track USD by sender
        owner.transfer(msg.value); // transfer to owner immediately
    }

    function getBalance() public view returns(uint) {
        return owner.balance;
    }

    function sendMoney(address payable _to) public payable {
        require (getBalance() >= msg.value, "Not enought balance to send, aborting");
        _to.transfer(msg.value);
    }


}