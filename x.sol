// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TweetContract {
    struct Tweet {
        address author;
        string content;
        uint timestamp;
    }

    struct Message {
        address sender;
        address receiver;
        string content;
        uint timestamp;
    }

    mapping(address => bool) public authorizedPosters;
    mapping(address => bool) public authorizedMessengers;
    mapping(address => mapping(address => bool)) public followedUsers;
    mapping(address => Tweet[]) public userTweets;
    mapping(address => Message[]) public userMessages;

    event TweetPosted(address indexed author, string content, uint timestamp);
    event MessageSent(address indexed sender, address indexed receiver, string content, uint timestamp);
    event UserFollowed(address indexed follower, address indexed followed);

    modifier onlyAuthorizedPoster() {
        require(authorizedPosters[msg.sender], "You are not authorized to post tweets.");
        _;
    }

    modifier onlyAuthorizedMessenger() {
        require(authorizedMessengers[msg.sender], "You are not authorized to send messages.");
        _;
    }

    function authorizePoster(address _user) public {
        authorizedPosters[_user] = true;
    }

    function revokePosterAuthorization(address _user) public {
        authorizedPosters[_user] = false;
    }

    function authorizeMessenger(address _user) public {
        authorizedMessengers[_user] = true;
    }

    function revokeMessengerAuthorization(address _user) public {
        authorizedMessengers[_user] = false;
    }

    function postTweet(string memory _content) public onlyAuthorizedPoster {
        Tweet memory newTweet = Tweet(msg.sender, _content, block.timestamp);
        userTweets[msg.sender].push(newTweet);
        emit TweetPosted(msg.sender, _content, block.timestamp);
    }

    function sendMessage(address _receiver, string memory _content) public onlyAuthorizedMessenger {
        require(_receiver != address(0), "Invalid receiver address.");
        Message memory newMessage = Message(msg.sender, _receiver, _content, block.timestamp);
        userMessages[msg.sender].push(newMessage);
        emit MessageSent(msg.sender, _receiver, _content, block.timestamp);
    }

    function followUser(address _followedUser) public {
        require(_followedUser != address(0), "Invalid user address.");
        followedUsers[msg.sender][_followedUser] = true;
        emit UserFollowed(msg.sender, _followedUser);
    }

    function getLatestTweets(uint _count) public view returns (Tweet[] memory) {
        require(_count > 0, "Count must be greater than zero.");
        uint totalTweets = userTweets[msg.sender].length;
        uint startIndex = (totalTweets > _count) ? totalTweets - _count : 0;
        uint endIndex = totalTweets;
        Tweet[] memory result = new Tweet[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = userTweets[msg.sender][i];
        }
        return result;
    }

    function getLatestUserTweets(address _user, uint _count) public view returns (Tweet[] memory) {
        require(_user != address(0), "Invalid user address.");
        require(_count > 0, "Count must be greater than zero.");
        uint totalTweets = userTweets[_user].length;
        uint startIndex = (totalTweets > _count) ? totalTweets - _count : 0;
        uint endIndex = totalTweets;
        Tweet[] memory result = new Tweet[](endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = userTweets[_user][i];
        }
        return result;
    }
}


// assingment : 

// You are tasked with designing a Solidity smart contract called   that simulates a basic social media platform's functionalities. The contract should allow users to post tweets, send messages, follow other users, and manage access permissions. Implement the following:
//  TweetContract
// 1.
// Tweeting:
// Create a function to allow users to post a tweet. This function should store the tweet's content, the author's address, and the timestamp of creation.
// 2.
// Messaging:
// Implement a function that enables users to send messages to other users. It should record the sender, recipient, message content, and creation timestamp.
// 3.
// Following Users:
// Develop a function that enables a user to follow another user by adding their address to a list of followed users.
// 4.
// Access Control:
// Implement mechanisms to control access:
// Allow users to authorize other users to post tweets or send messages on their behalf. Allow users to revoke these authorizations.
// 5.
// Retrieving Data:
// Create functions to retrieve:
// The latest tweets posted by users, considering a specified count. The latest tweets of a specific user, considering a specified count.
 
