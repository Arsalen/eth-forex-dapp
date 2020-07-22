const Forex = artifacts.require("Forex");

module.exports = function(deployer) {
  deployer.deploy(Forex);
};
