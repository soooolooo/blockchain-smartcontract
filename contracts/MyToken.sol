// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    mapping(address => Customer) public customers;
    uint public totalSales = 0;
    address public insuranceAddress = 0x2eB004ddE18E064725717A31d74F2027Da5b4fa4; //Mohannad's address as the insurance address.
                                                                                  // As ETH transaction will go to the insurance company
                                                                                  // if they apply ETH payment method.

    struct Customer {
        address cAddress;
        string cName;
        uint cAge;
        string cGender;
        string cNationality;
        uint startInsurance;
        uint endInsurance;
    }

    constructor() ERC20("Osama Insurance Smart Contract", "OISC") {}

    // This function is responsible of registering new customers.
    // Customers will still pay gas fees...
    function registerCustomer(string memory newcName, uint newcAge, string memory newcGender, string memory newcNationality) public onlyOwner{
        require(customers[msg.sender].cAddress != msg.sender, "You are already registered.");
        require(newcAge >= 18, "You are not eligable to have an insurance.");
        require(customers[msg.sender].startInsurance <= 0, "You already have an insurance");
        customers[msg.sender] = Customer(msg.sender, newcName, newcAge, newcGender, newcNationality, 0, 0);
    }

    // This function lets the customer pay for their insurance after registeration.
    // Gas fees will be included.
    function insuranceSubscribe() public onlyOwner payable{
        require(customers[msg.sender].cAddress == msg.sender, "You are not registered,");
        require(balanceOf(msg.sender) >= 0, "You don't have enough balance.");
        require(customers[msg.sender].endInsurance < block.timestamp, "You already have an active insurance");
        transferFrom(msg.sender, insuranceAddress, 0);
        customers[msg.sender].startInsurance = block.timestamp;
        customers[msg.sender].endInsurance = block.timestamp + 31556926;
        totalSales++;
    }

    // This function is responsible of
    function checkBalance() public onlyOwner view returns (uint){
        return balanceOf(msg.sender);
    }

    function checkRegisteration() public onlyOwner view returns (Customer memory){
        return customers[msg.sender];
    }
}
