
var FlightSuretyApp = artifacts.require("FlightSuretyApp");
var FlightSuretyData = artifacts.require("FlightSuretyData");
var BigNumber = require('bignumber.js');

var Config = async function(accounts) {
    console.log(accounts);
    // These test addresses are useful when you need to add
    // multiple users in test scripts
    let testAddresses = [
        "0x69e1CB5cFcA8A311586e3406ed0301C06fb839a2",
        "0xF014343BDFFbED8660A9d8721deC985126f189F3",
        "0x0E79EDbD6A727CfeE09A2b1d0A59F7752d5bf7C9",
        "0x9bC1169Ca09555bf2721A5C9eC6D69c8073bfeB4",
        "0xa23eAEf02F9E0338EEcDa8Fdd0A73aDD781b2A86",
        "0x6b85cc8f612d5457d49775439335f83e12b8cfde",
        "0xcbd22ff1ded1423fbc24a7af2148745878800024",
        "0xc257274276a4e539741ca11b590b9447b26a8051",
        "0x2f2899d6d35b1a48a4fbdc93a37a72f264a9fca7",
        "0x27D8D15CbC94527cAdf5eC14B69519aE23288B95",
        "0xCe5144391B4aB80668965F2Cc4f2CC102380Ef0A",
        "0xD37b7B8C62BE2fdDe8dAa9816483AeBDBd356088",
        "0xFe0df793060c49Edca5AC9C104dD8e3375349978",
        "0xBd58a85C96cc6727859d853086fE8560BC137632",
        "0xe07b5Ee5f738B2F87f88B99Aac9c64ff1e0c7917",
        "0xBd3Ff2E3adEd055244d66544c9c059Fa0851Da44"
    ];



    
    let owner = accounts[0];
    let firstAirline = accounts[1];
    const flightSuretyData = await FlightSuretyData.new();
    const flightSuretyApp = await FlightSuretyApp.new( flightSuretyData.address);

    
   
    return {
        owner: owner,
        firstAirline: firstAirline,
        weiMultiple: (new BigNumber(10)).pow(18),
        testAddresses: testAddresses,
        flightSuretyData: flightSuretyData,
        flightSuretyApp: flightSuretyApp
    }
}

module.exports = {
    Config: Config
};