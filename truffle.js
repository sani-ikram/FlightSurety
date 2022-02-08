var HDWalletProvider = require("truffle-hdwallet-provider");
//var HDWalletProvider = require("@truffle/hdwallet-provider");
//var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";
var mnemonic = "magic lake smooth entry reduce candy bleak tray text spawn tuition hill";

module.exports = {
  networks: {
    development: {
      /*provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:9545/", 0, 50);
      },*/
      provider: () => new HDWalletProvider(mnemonic, "http://127.0.0.1:9545/", 0, 50),
      network_id: '*',
      //gas: 9999999
      gas: 6721975
    }
  },
  compilers: {
    solc: {
      version: "^0.4.24",
      version: "^0.4.24",
      version: "<0.5.12"
    }
  }
};