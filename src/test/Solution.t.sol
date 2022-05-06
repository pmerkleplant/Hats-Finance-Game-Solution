// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "ds-test/test.sol";

import {Game} from "../Game.sol";
import {Solution} from "../Solution.sol";

contract SolutionTest is DSTest {

    function setUp() public {

    }

    function testPoC() public {
        Game g = new Game();
        assertEq(g.flagHolder(), address(this));

        Solution s = new Solution(address(g));
        s.captureFlag();

        // Check if we managed to capture the flag.
        assertEq(g.flagHolder(), address(s));
        emit log("Flag Captured");
    }
}
