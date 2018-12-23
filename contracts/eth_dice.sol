pragma solidity ^0.5.2;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";


contract ExampleContract is usingOraclize {

    string public ETHUSD;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    mapping (bytes32 => bool) public pendingQueries;

    function Constructor() public payable {
        emit LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string memory result) public {
        if (msg.sender != oraclize_cbAddress()) revert();
        require (pendingQueries[myid] == true);
        ETHUSD = result;
        emit LogPriceUpdated(result);
        delete pendingQueries[myid]; // This effectively marks the query id as processed.
    }

    function updatePrice() public payable {
        
        // XXX check this out https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=16&format=plain&rnd=new
        
        if (oraclize_getPrice("URL") > address(this).balance) {
            emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId = oraclize_query("URL", "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price");
            pendingQueries[queryId] = true;
        }
    }
}


contract Dice is usingOraclize {

    uint public gamesPlayed;
    uint public gamesWon;
    
    event GameStarted(address _contract);
    event PlayerBetAccepted(address _contract, address _player, uint[] _numbers, uint _bet);
    event DiceRolled(address _contract, address _player, uint _winning_number);
    event WinningNumber(address _contract, uint _winning_number);
    event PlayerWins(address _contract, address _winner, uint _winning_number);
    event Cashout(address _contract, address _winner, uint _winning_number, uint _winning_amount);

    constructor() 
        public
    {
        gamesPlayed = 0;
        gamesWon = 0;
        emit GameStarted(address(this));
    }

    function rollDice(uint[] memory betNumbers)
        public 
        payable 
        returns(uint, uint) 
    {

        bool playerWins;
        emit PlayerBetAccepted(address(this), msg.sender, betNumbers, msg.value);
    
        uint winningAmount;
        uint winningNumber = this.numberGenerator();

        for (uint i = 0; i < betNumbers.length; i++) {

            uint betNumber = betNumbers[i];

            if(betNumber == winningNumber) {
                playerWins = true;
                emit PlayerWins(address(this), msg.sender, winningNumber);

            }

        }

        if(playerWins) {

            if(betNumbers.length == 1) {
                    winningAmount = (msg.value * 588) / 100;
            }
            if(betNumbers.length == 2) {
                    winningAmount = (msg.value * 293) / 100;
            }
            if(betNumbers.length == 3) {
                    winningAmount = (msg.value * 195) / 100;
            }
            if(betNumbers.length == 4) {
                    winningAmount = (msg.value * 142) / 100;
            }
            if(betNumbers.length == 5) {
                    winningAmount = (msg.value * 107) / 100;
            }
            if(betNumbers.length == 6) {
                    winningAmount = msg.value;
            }

            msg.sender.transfer(winningAmount);
            
            emit Cashout(address(this), msg.sender, winningNumber, winningAmount);
            gamesWon += 1;

        }

        gamesPlayed += 1;
        return (winningNumber, winningAmount);
    }

    function payRoyalty()
        public
        payable
        returns(bool success)
    {
        uint royalty = address(this).balance/2;
        address payable royalty1 = 0x661599a312f340a6450B05690c715f0b827dc570;
        address payable royalty2 = 0xeacd131110FA9241dEe05ccf3e3635D12f629A3b;
        royalty1.transfer(royalty/2);
        royalty2.transfer(royalty/2);
        return (true);
    }
    
    function numberGenerator()
        public
        returns(uint)
    {
        // XXX TODO function to call random.org for a random number from 1 to 6
        uint winningNumber = 7; 
        emit WinningNumber(address(this), winningNumber);
        return (winningNumber);
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

