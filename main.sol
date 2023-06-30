// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionService {
    // Owner of the subscription service contract
    address private owner;

    // Price for subscribing to the service
    uint private subscriptionPrice;

    // Mapping of subscriber addresses to their subscription status
    mapping (address => bool) private subscribers;

    // Event that is emitted when a user subscribes or unsubscribes
    event SubscriptionStatusChanged(address subscriber, bool subscribed);

    // Modifier that allows only the owner of the contract to call a function
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor function that sets the subscription price and the contract owner
    constructor(uint _subscriptionPrice) {
        subscriptionPrice = _subscriptionPrice;

        // Set the owner of the contract to the address that deployed the contract
        owner = msg.sender;
    }

    // Function to get the current subscription price
    function getSubscriptionPrice() public view returns (uint) {
        return subscriptionPrice;
    }

    // Function to change the subscription price
    function setSubscriptionPrice(uint _subscriptionPrice) public onlyOwner {
        subscriptionPrice = _subscriptionPrice;
    }

    // Function to subscribe to the service
    function subscribe() public payable {
        require(msg.value == subscriptionPrice, "Amount sent does not match subscription price");
        subscribers[msg.sender] = true;
        emit SubscriptionStatusChanged(msg.sender, true);
    }

    // Function to unsubscribe from the service
    function unsubscribe() public {
        subscribers[msg.sender] = false;
        payable(msg.sender).transfer(subscriptionPrice);
        emit SubscriptionStatusChanged(msg.sender, false);
    }

    // Function to check if an address is subscribed to the service
    function isSubscribed(address _subscriber) public view returns (bool) {
        return subscribers[_subscriber];
    }

    // Function to withdraw funds from the contract
    function withdrawFunds() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}

