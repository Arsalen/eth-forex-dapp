# eth-forex-dapp

Third out of three components of the ethereum-oracle-api-dapp project:
  - ethereum oracle
  - [ethereum API server](https://github.com/Arsalen/eth-api)
  - [ethereum sample dapp](https://github.com/Arsalen/eth-forex-dapp)

## Overview

An Ethereum smart contract to deploy on [ropsten](https://ropsten.etherscan.io/) that holds the most recent [foreign exchange](http://freeforexapi.com/) price rates from several registred ethereum oracles.

### What is an oracle?

An oracle is a service that provides “trusted” data to a smart contract, through transactions. “Trusted” because, trust is a personal issue. Two entities might not “trust” data in the same way, given some specific implementation of an oracle.

Oracles are typically web services that implement some blockchain-specific functionalities, such as hashing and signing some data, or creating and submitting new transactions to the network.

## Prerequisites

On a [ubuntu server](https://releases.ubuntu.com/18.04/), install [truffle](https://www.trufflesuite.com/) to compile and migrate contracts.
On [Infura](https://infura.io/), setup a new project to connect to ropsten.
On [MEW](https://www.myetherwallet.com/), generate a wallet through a mnemonic phrase, download keystore file and fund the address with some [fake ether](https://faucet.ropsten.be/).

### Configuration

Configuration and secret files are omitted, you can though setup your own if you have managed to follow the prerequisites.

.env

```INI
MNEMONIC="one two three four five six seven eight nine ten eleven twelve" # Mnemonic passphrase

SECRET="a1B2c3D4e5F6g7H"  # Secret to decrypt keystore
```

config/app.config.json

```JSON
{
   "infura": {
        "endPoint": "https://ropsten.infura.io/v3/",
        "key": "abcd1efgh2ijkl3mnop4qrst5uvwx6yz" // Infura api key
    },
    "network": 3
}
```

key.store.js

```JS
require("dotenv").config({path: ".env"});

const HDWalletProvider = require("truffle-hdwallet-provider");
const ethers = require('ethers');
const Web3 = require('web3');

const config = require("./config/app.config");

const mnemonic = process.env.MNEMONIC;
const password = process.env.SECRET;

const endPoint = `${config.infura.endPoint}${config.infura.key}`;

const wallet = ethers.Wallet.fromMnemonic(mnemonic);

const provider = new HDWalletProvider(mnemonic, endPoint);
const web3 = new Web3(provider);

const account = web3.eth.accounts.privateKeyToAccount(wallet.privateKey);
const keystore = web3.eth.accounts.encrypt(account.privateKey, password);

console.log(JSON.stringify(keystore));
```

config/key.store.json From https://www.myetherwallet.com/create-wallet then encrypted using key.js

```JSON
{"version":3,"id":"<id>","address":"<address","crypto":{"ciphertext":"<crypto.ciphertext>","cipherparams":{"iv":"<crypto.cipherparams.iv>"},"cipher":"<crypto.cipher>","kdf":"<cryoto.kdf>","kdfparams":{"dklen":"<crypto.kdfparams.dklen>","salt":"<crypto.kdfparams.salt>","n":"<crypto.kdfparams.n>","r":"<crypto.kdfparams.dkler>","p":"<crypto.kdfparams.p>"},"mac":"<crypto.mac>"}}
```


## Start

In order to be able to store signed data from oracles in the blockchain, install dependencies, compile and migrate the contract.

```BASH
npm i --save
truffle compile
truffle migrate --network ropsten

# migrations.log
```

### Jenkins

You can alternatively setup a jenkins job and make use of the ```Jenkinsfile``` to automate the integration and deployment of the application.
**NOTE:** You have to import configuration files above into the server before you trigger the pipeline.