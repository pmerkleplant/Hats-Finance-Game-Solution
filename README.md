# Solution to Hats.Finance's CTF Challenge #1

## Background

[Hats.finance](https://hats.finance) is a decentralized smart bug bounty
marketplace. They intend to run Capture-the-flag competitions to "allow new and
veteran security researchers and hackers to go wild."

## Challenge Details

The contract [`Game.sol`](./src/Game.sol) encodes a card fighting game where the
goal is to obtain the flag by pitching your deck of Mons against the deck of the
flagholder and win the fight.

- Anyone can join the game calling `game.join()`
- On joining, a player receives a deck of 3 pseudo-random Mons
- Each Mon is an NFT, and each Mon has powers: FIRE; WATER; AIR and SPEED, each
  with a value in a range from [0-9]
- Users can try to improve their deck by swapping their Mons with other users,
  or by exchanging a Mon for a randomly generated new one
- For a swap to succeed, another player must put one of their Mons for sale
- At each moment, one single player holds the flag
- Other players can try to capture the flag by challenging the flag holder
- A fight between two Mons takes place with one of the 3 elements (FIRE, WATER
  or AIR). The Mon with the highest value in that element wins the fight. If the
  two Mons have the same strength, the Mon with the most SPEED wins. If the two
  Mons are excatly the same, the flag holder wins.
- A fight between two decks consists of pairing the three Mons of the challenger
  with the 3 Mons of the flag holder, pseudo-randomly choosing 3 elements, and
  then having the 3 pairs fight on each of these elements

## Goal

The [`Game.sol`](./src/Game.sol) is deployed with the flagHolder holding an
apparently unbeatable deck with perfect Mons.

Your mission is to obtain the flag: i.e. `game.flagHolder()` should return an
address that you control

## Solution

This solution uses a reentrancy possibility, enabled through OpenZeppelin's
`ERC721::_safeTransfer` function that initiates a callback to the receiver
via the `onERC721Received` function.

The solution is implemented in [Solution.sol](./src/Solution.sol).
A PoC test implementation is [Solution.t.sol](./src/test/Solution.t.sol).

## Installation and Setup

Install instructions for foundry are [here](https://github.com/foundry-rs/foundry).

After installation, clone the repo and run `forge t -vvvv`.

If the test succeeds, we `Solution.sol` contract was able to capture the flag.
