# Rock Paper Scissors Lizard Spock - Ethereum

### How to play

Step 1. Run Ganache

Step 2. Deploy contracts via ```truffle migrate```. By default contract is deployed with "Rock" as the 1st move of player1, address of player2 and 1 ETH at stake.

Step 3. Player2 makes a "Paper" move and sends 1 ETH at stake. Run ```truffle console```. In console run:
```js
RPS.deployed().then(function(rps){ return rps.play(2, { from: web3.eth.accounts[1], value: 1000000000000000000 }); });
```

Step 4. Player1 finishes game running "solve" method. Player1 must send move and salt to check the initial move hash. In console run:

```js
RPS.deployed().then(function(rps){ return rps.solve(1, 123); });
```

Step 5. Player2 wins the game. Check the balances:

```js
web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]));
// { [String: '98.8697554'] s: 1, e: 1, c: [ 98, 86975540000000 ] }
web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]));
// { [String: '100.9952154'] s: 1, e: 2, c: [ 100, 99521540000000 ] }
```

### Additional info
Hash of the Rock with salt 123: 0x48b0517dc17384a96f0dde4440cc4101d2d7f669f62c2a4395c27d7a2e791474
