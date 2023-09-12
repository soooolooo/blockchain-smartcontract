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
        uint cBalance;
        uint startInsurance;
        uint endInsurance;
    }

    constructor() ERC20("Osama Insurance Smart Contract", "OISC") {}

    // Everything needed for registering + paying should be in one function.
    // Registeration of customer takes fees from them due to the gas tax fees.
    // IMO The right solution is to merge 2 functions of registering and paying in one function.
    function registerCustomer(string memory newcName, uint newcAge, string memory newcGender, string memory newcNationality) public onlyOwner payable{
        require(newcAge >= 18, "You are not eligable to have an insurance.");
        require(balanceOf(msg.sender) >= 0, "You don't have enough balance.");
        require(customers[msg.sender].startInsurance <= 0, "You already have an insurance");
        uint newcBalance = balanceOf(msg.sender);
        transferFrom(msg.sender, insuranceAddress, 0);
        customers[msg.sender] = Customer(msg.sender, newcName, newcAge, newcGender, newcNationality, newcBalance, block.timestamp, block.timestamp + 31556926);
        totalSales++;
    }

    function checkBalance() public onlyOwner view returns (uint){
        return balanceOf(msg.sender);
    }

    function checkInsurance() public onlyOwner view returns (Customer memory){
        return customers[msg.sender];
    }
}
