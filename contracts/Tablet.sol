// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tablet is Ownable {
    struct Inscription {
        uint256 id;
        string title;
        string text;
        uint256 continuation;
        uint256 start;
        uint256 parts;
    }
    Inscription[] public inscriptions;

    constructor(string memory _title, string memory _text) {
        setInStone(_title, _text, 0);
    }

    function setInStone(
        string memory _title,
        string memory _text,
        uint256 _continues
    ) public onlyOwner {
        require(_continues < inscriptions.length, "There is no inscription with this id");
        uint256 id = inscriptions.length;
        uint256 start = id;
        if (_continues > 0) {
            require(inscriptions[_continues].continuation == 0, "This inscription already has a follow up");
            inscriptions[_continues].continuation = id;
            start = inscriptions[_continues].start;
            inscriptions[start].parts += 1;
        }
        inscriptions.push(Inscription({ id: id, title: _title, text: _text, continuation: 0, start: start, parts: 1 }));
    }

    function getEpic(uint256 _id) public view returns (Inscription[] memory) {
        require(_id < inscriptions.length, "There is no inscription with this id");

        uint256 start = inscriptions[_id].start;
        uint256 parts = inscriptions[start].parts;
        Inscription[] memory epic = new Inscription[](parts);
        uint256 currentPartIndex = 1;
        uint256 currentPart = start;

        while (currentPartIndex <= parts) {
            epic[currentPartIndex - 1] = inscriptions[currentPart];
            currentPart = inscriptions[currentPart].continuation;
            currentPartIndex += 1;
        }
        return epic;
    }
}
