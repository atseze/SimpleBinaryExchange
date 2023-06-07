// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBinaryExchange {
    struct Participation {
        address payable partner;
        uint value;
    }
    mapping(address => Participation) participants;

    function nominate(address payable _partner) public payable {
        require(msg.value > 0, "The value must be greater than zero!");
        Participation memory participation = participants[msg.sender];
        require(
            participation.partner == address(0),
            "Already have a nominate!"
        );
        participation.partner = _partner;
        participation.value = msg.value;
        participants[msg.sender] = participation;
    }

    function doExchange() public payable {
        Participation memory thisSide = participants[msg.sender];
        require(thisSide.partner != address(0), "You have no nominate!");
        Participation memory thatSide = participants[thisSide.partner];
        require(thatSide.partner != address(0), "You have no pair!");
        require(thisSide.value == thatSide.value, "Not the same value!");
        require(
            thisSide.partner == thatSide.partner,
            "Partners does not match!"
        );

        payable(thisSide.partner).transfer(thisSide.value);
        payable(thatSide.partner).transfer(thatSide.value);

        delete participants[thisSide.partner];
        delete participants[thatSide.partner];
    }

    function cancel() public payable {
        Participation memory participation = participants[msg.sender];
        require(participation.partner != address(0), "You are not in!");
        payable(msg.sender).transfer(participation.value);
    }
}
