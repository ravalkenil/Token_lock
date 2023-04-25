const Purchase = artifacts.require("../contracts/Purchase.sol");

module.exports = function (deployer) {
  deployer.deploy(Purchase,2000);
};
