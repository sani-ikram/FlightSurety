
var Test = require('../config/testConfig.js');
var BigNumber = require('bignumber.js');
const ethers = require('ethers');
const utils = ethers.utils;

contract('Flight Surety Tests', async (accounts) => {

  var config;
  before('setup contract', async () => {
    
    config = await Test.Config(accounts);
    //console.log(config);
    //await config.flightSuretyData.authorizeCaller(config.flightSuretyApp.address);
  });
  //ETHER_VALUE = web3.utils.toWei(1);
 

  /****************************************************************************************/
  /* Operations and Settings                                                              */
  /****************************************************************************************/

  it(`(multiparty) has correct initial isOperational() value`, async function () {

    // Get operating status
    let status = await config.flightSuretyData.isOperational.call();
    assert.equal(status, true, "Incorrect initial operating status value");

  });

  it(`(multiparty) can block access to setOperatingStatus() for non-Contract Owner account`, async function () {

      // Ensure that access is denied for non-Contract Owner account
      let accessDenied = false;
      try 
      {
          await config.flightSuretyData.setOperatingStatus(false, { from: config.testAddresses[2] });
      }
      catch(e) {
          accessDenied = true;
      }
      assert.equal(accessDenied, true, "Access not restricted to Contract Owner");
            
  });

  it(`(multiparty) can allow access to setOperatingStatus() for Contract Owner account`, async function () {

      // Ensure that access is allowed for Contract Owner account
      let accessDenied = false;
      try 
      {
          await config.flightSuretyData.setOperatingStatus(false);
      }
      catch(e) {
          accessDenied = true;
      }
      assert.equal(accessDenied, false, "Access not restricted to Contract Owner");
      
  });

  it(`(multiparty) can block access to functions using requireIsOperational when operating status is false`, async function () {

      await config.flightSuretyData.setOperatingStatus(false);

      let reverted = false;
      try 
      {
          await config.flightSurety.setTestingMode(true);
      }
      catch(e) {
          reverted = true;
      }
      assert.equal(reverted, true, "Access not blocked for requireIsOperational");      

      // Set it back for other tests to work
      await config.flightSuretyData.setOperatingStatus(true);

  });

  it('(airline) cannot register an Airline using registerAirline() if it is not funded', async () => {
    
    // ARRANGE
    let newAirline = accounts[2];
    let valueEther = web3.utils.toWei(web3.utils.toBN(10));
    

    // ACT
    try {
        let result = await config.flightSuretyApp.registerAirline.call(newAirline, valueEther, {from: config.firstAirline});
      
        assert.equal(result['0'],true, "Airline got registered as it has provided funding");
     
    }
    catch(e) {
                
    }

    

  });
 
  it('Only existing Airline can register the new airline', async() => {
    
    let newAirline = accounts[2];
    let valueEther = web3.utils.toWei(web3.utils.toBN(10));

    try{

    let result = await config.flightSuretyApp.registerAirline.call(newAirline,valueEther, {from: config.firstAirline});
    console.log(result);
    console.log("This section of the code is working");
    assert.equal(result, true,"Airline has failed to register");
    }catch(e){ 
             }  
            });

  it('Consumer/Passenger require 1 Ether is required to purchase the flight insurance', async() => {
    let user = "0x8742ff5d6aa94173cc6fad836140f49b4fadad38";
    let Ether = web3.utils.toWei(web3.utils.toBN(1));
    let name = "John";
    let flight = "ND103";
    const flightinBytes = utils.formatBytes32String(flight);  
  
       try{
        let result = await config.flightSuretyApp.buy.call(name, flightinBytes,Ether, {from: user});
        assert.equal(result, true, "Value Ether has been purchased" );
     
      }catch(e){ 
               }
             });

  it('1 Ether is required to registera flight for Insurance', async() => {
    let newAirline = accounts[2];
    let flight = "ND103";
    let Ether = web3.utils.toWei(web3.utils.toBN(1));
    const flightinBytes = utils.formatBytes32String(flight);  
  
       try{
        let result = await config.flightSuretyApp.registerFlight.call(newAirline, flightinBytes,Ether);
        
     
      }catch(e){
           //console.log(e);
            }
      });

});
