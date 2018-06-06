var RPS = artifacts.require("./RPS.sol");
var Hasher = artifacts.require("./Hasher.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Hasher);
  deployer.deploy(
    RPS, 
    "0x48b0517dc17384a96f0dde4440cc4101d2d7f669f62c2a4395c27d7a2e791474", 
    accounts[1], 
    {from: accounts[0], value: 1000000000000000000});
};
