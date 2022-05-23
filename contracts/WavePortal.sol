// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract WavePortal {
    uint256 totalWaves;
    uint256 highestWaves;
    uint256 private lastPrizeTime;
    uint256 private seed;

    struct Wave {
        string message;
        uint256 count;
    }

    struct WaveDTO {
        address from;
        string message;
        uint256 count;
    }
    
    event NewWave(address indexed from, uint256 timestamp, string message);

    mapping(
        address => Wave
    ) WaveMap;

    address[] wavers;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory message) public {
        totalWaves++;
        
        if ( WaveMap[msg.sender].count > 0 ) {
            WaveMap[msg.sender].count++;
            WaveMap[msg.sender].message = message;
        } else {
            WaveMap[msg.sender] = Wave(message, 1);
            wavers.push(msg.sender);
        }

        if ( WaveMap[msg.sender].count > highestWaves ) {
            seed = (block.difficulty + block.timestamp + seed) % 100;

            if ( seed >= 50 && lastPrizeTime + 15 minutes < block.timestamp ) {
                lastPrizeTime = block.timestamp;
                highestWaves = WaveMap[msg.sender].count;

                // This guy deserves a prize
                uint256 prizeAmount = 0.0001 ether;
                require(
                    prizeAmount <= address(this).balance,
                    "Trying to withdraw more money than the contract has."
                );
                (bool success, ) = (msg.sender).call{value: prizeAmount}("");
                require(success, "Failed to withdraw money from contract.");
            }
        }

        console.log("%s has waved!", msg.sender);
        emit NewWave(msg.sender, block.timestamp, message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getUserData() public view returns (WaveDTO memory) {
        WaveDTO memory data = WaveDTO(msg.sender, WaveMap[msg.sender].message, WaveMap[msg.sender].count);
        return data;
    }

    function getTopWavers() public view returns (WaveDTO[5] memory) {
        WaveDTO[5] memory _waves;

        for ( uint8 i = 0; i < wavers.length; i++ ) {
            address toInsert = wavers[i];
            for ( uint8 j = 0; j < 5; j++ ) {
                if ( _waves[j].count < WaveMap[toInsert].count ) {
                    address temp = toInsert;
                    toInsert = _waves[j].from;
                    _waves[j] = WaveDTO(temp, WaveMap[temp].message, WaveMap[temp].count);
                }
            }
        }

        return _waves;
    }
}