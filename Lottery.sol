// SPDX-License-Identifier: GLP-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender; 
        // global variable
        // address of account from which program is compiled is transfered to manager
    }

    receive() external payable{
        require(msg.value == 1 ether);
        // value transfered should be 1 ether excatly
        participants.push(payable(msg.sender));
        // msg.sender is the address of participant from which ether is received. Add that address to the participants array

    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        // only manager address can see balance
        return address(this).balance;

    }

    function random() public view returns(uint){
        // returns a random uint256
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint winningIndex = random()%participants.length;
        address payable winningAddress;
        winningAddress = participants[winningIndex];
        winningAddress.transfer(getBalance());
        // send all prizepool to winning address
        participants = new address payable[](0);
        // all previous participants removed
    }
}