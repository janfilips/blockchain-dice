pragma solidity ^0.5.1;

contract Dice {

    uint public winMultiplier;

    uint public gamesPlayed;
    uint public gamesWon;
    
    event GameStarted(address _contract, uint multiplier);
    event PlayerWins(address _contract, address _winner, uint _win_amount);

    constructor(uint _winMultiplier) 
        public
    {
        winMultiplier = _winMultiplier;
        gamesPlayed = 0;
        gamesWon = 0;
        emit GameStarted(address(this), winMultiplier);
    }

    function rollDice()
        public 
        payable 
        returns(uint, uint) 
    {
        // XXX function placeBid with a fake test=true function parameter
        uint amountWon = 0;
        uint winningNumber = 0;
        // XXX place bid....
        return (winningNumber, amountWon);
    }
    
    function numberGenerator()
        public
        pure
        returns(uint)
    {
        // this is a simple oracle function for random.org
        // XXX function to call random.org to pick a random number from 1 to 6
        uint randomNumber = 6;
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
