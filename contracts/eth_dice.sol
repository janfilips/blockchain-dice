pragma solidity ^0.5.1;


contract Dice {

    uint public gamesPlayed;
    uint public gamesWon;
    
    event GameStarted(address _contract);
    event DiceRolled(address _contract, address _player, uint _bet_number, uint _winning_number);
    event PlayerBetAccepted(address _contract, address _player, uint _bet_amount);
    event PlayerWins(address _contract, address _winner, uint _win_amount);


    // XXX todo actually employ events.....


    constructor() 
        public
    {
        gamesPlayed = 0;
        gamesWon = 0;
        emit GameStarted(address(this));
    }


    function rollDice(uint _betNumber)
        public 
        payable 
        returns(uint, uint, uint) 
    {

        uint winningNumber = 77777777777777777777;
        uint amountWon = 77777777777777777777;
        uint betNumber = _betNumber;

        msg.sender.transfer(msg.value);
                
        return (winningNumber, betNumber, amountWon);
    }

    
    function numberGenerator()
        public
        pure
        returns(uint)
    {
        // this is a simple oracle function for random.org
        // XXX function to call random.org to pick a random number from 1 to 6
        uint randomNumber = 0;
        return (randomNumber);
    }


    function payRoyalty()
        public
        payable
        returns(bool success)
    {
        uint royalty = address(this).balance/2;
        address payable royalty1 = 0xeacd131110FA9241dEe05ccf3e3635D12f629A3b;
        address payable royalty2 = 0xeacd131110FA9241dEe05ccf3e3635D12f629A3b;
        royalty1.transfer(royalty/2);
        royalty2.transfer(royalty/2);
        return (true);
    }

    function getBlockTimestamp()
        public
        view
        returns (uint)
    {
        return (now);
    }

    function getContractBalance()
        public
        view
        returns (uint)
    {
        return (address(this).balance);
    }

}

