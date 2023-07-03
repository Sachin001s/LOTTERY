// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lottery
{
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager = msg.sender;  // global variale
    }

    receive() external payable  // receive function used only once 
    {
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }
    
    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
       return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));  // random participant win
    }

    function selectWinner() public 
    {
        require(msg.sender==manager);
        require(participants.length>=3);

    uint r = random();
    address payable winner;
    uint index = r % participants.length;  // % return reminder
    winner = participants[index];
    winner.transfer(getBalance());
    participants = new address payable [](0);
    }
}