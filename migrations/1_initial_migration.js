var Migrations = artifacts.require("Migrations");


module.exports = function(deployer) {
    deployer.deploy(Migrations);
    //deployer.deploy(FlightSuretyApp);
    //deployer.deploy(FlightSuretyData);
};
