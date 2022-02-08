
var Test = require('../config/testConfig.js');
//var BigNumber = require('bignumber.js');
const ethers = require('ethers');
const utils = ethers.utils;

contract('Oracles', async (accounts) => {

  const TEST_ORACLES_COUNT = 10;
  var config;
  before('setup contract', async () => {
    config = await Test.Config(accounts);

    // Watch contract events
    const STATUS_CODE_UNKNOWN = 0;
    const STATUS_CODE_ON_TIME = 10;
    const STATUS_CODE_LATE_WEATHER = 30;
    const STATUS_CODE_LATE_TECHNICAL = 40;
    const STATUS_CODE_LATE_OTHER = 50;


});


  it('can register oracles', async () => {
    
    // ARRANGE
    let fee = await config.flightSuretyApp.REGISTRATION_FEE.call();

    // ACT
    for(let a=1; a<TEST_ORACLES_COUNT; a++) {      
      await config.flightSuretyApp.registerOracle({ from: accounts[a], value: fee });
      let result = await config.flightSuretyApp.getMyIndexes.call({from: accounts[a]});
      console.log(`Oracle Registered: ${result[0]}, ${result[1]}, ${result[2]}`);
     

    }
  });

  it('can request flight status', async () => {
    
    // ARRANGE
    let flight_num = 'ND1309'; // Course number
    const flight = utils.formatBytes32String(flight_num);  
    let timestamp = Math.floor(Date.now() / 1000);
    let STATUS_CODE_ON_TIME = 10

    // Submit a request for oracles to get status information for a flight
    let var1 = await config.flightSuretyApp.fetchFlightStatus.call(config.firstAirline, flight, timestamp);
    console.log(var1, "This is the key");
    // ACT

    // Since the Index assigned to each test account is opaque by design
    // loop through all the accounts and for each account, all its Indexes (indices?)
    // and submit a response. The contract will reject a submission if it was
    // not requested so while sub-optimal, it's a good test of that feature
    for(let a=1; a<TEST_ORACLES_COUNT; a++) {

      // Get oracle information
      let oracleIndexes = await config.flightSuretyApp.getMyIndexes.call({ from: accounts[a]});
      console.log(oracleIndexes,"OracleIndexes");
      for(let idx=0;idx<3;idx++) {
        try {
          // Submit a response...it will only be accepted if there is an Index match ;
          console.log(oracleIndexes[idx]);  
          let v;
          v=await config.flightSuretyApp.submitOracleResponse.call(oracleIndexes[idx], config.firstAirline, flight, timestamp, 40,{ from: accounts[a]});
          console.log( v, "This is the result");

                }
        catch(e) {

          //console.log('\nError', idx, oracleIndexes[idx].toNumber(), flight_num, timestamp);
        }
        
      }
    }

  }); 
  

});
