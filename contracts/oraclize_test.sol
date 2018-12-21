import "lib/std.sol";
import "lib/oraclizeAPI.sol";

contract Contract is named("Contract"), mortal, usingOraclize {

  uint256 public randomInt;
  event onCallback(string result);

  function Contract() {
    oraclize_setNetwork(networkID_consensys);
  }

  function __callback(bytes32 myid, string result) {
    onCallback(result);
    if (msg.sender != oraclize_cbAddress()) throw;
    randomInt = parseInt(result);
  }

  function update() {
    oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data.0", '{"jsonrpc":"2.0","method":"generateIntegers","params":{"apiKey":"<ENTER API KEY HERE>","n":1,"min":1,"max":6,"replacement":true,"base":10},"id":458}');
  }
}
