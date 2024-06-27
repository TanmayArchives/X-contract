// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XContract {
// 3 g varible
    uint public userCount = 0;
    uint public tweetCount = 0;
    uint public messageCount = 0;

    struct User {
        uint userId;
        string username;
        uint followers;
        mapping(uint => bool) following;
    }

    struct Tweet {
        uint tweetId;
        uint userId;
        string message;
        uint timestamp;
    }

    struct Message {
        uint messageId;
        uint senderId;
        uint receiverId;
        string content;
        uint timestamp;
    }

    mapping(uint => User) public users;
    mapping(uint => Tweet) public tweets;
    mapping(uint => Message) public messages;
    mapping(address => uint) public userAddresses;
 // event is for an annoce
    event NewTweet(uint tweetId, uint userId, string message, uint timestamp);
    event NewMessage(uint messageId, uint senderId, uint receiverId, string content, uint timestamp);
    event FollowUser(uint followerId, uint followedId);

    modifier onlyUser() {
        require(userAddresses[msg.sender] > 0, "You need to register first.");
        _;
    }
// singup
    function addUser(string memory _username) public {
        require(userAddresses[msg.sender] == 0, "User already registered.");
        userCount++;
        users[userCount].userId = userCount;
        users[userCount].username = _username;
        users[userCount].followers = 0;
        userAddresses[msg.sender] = userCount;
    }

    function postTweet(string memory _message) public onlyUser {
        uint userId = userAddresses[msg.sender];
        tweetCount++;
        tweets[tweetCount] = Tweet(tweetCount, userId, _message, block.timestamp);
        emit NewTweet(tweetCount, userId, _message, block.timestamp);
    }

    function sendMessage(uint _receiverId, string memory _content) public onlyUser {
        uint senderId = userAddresses[msg.sender];
        require(_receiverId > 0 && _receiverId <= userCount, "Receiver does not exist.");
        messageCount++;
        messages[messageCount] = Message(messageCount, senderId, _receiverId, _content, block.timestamp);
        emit NewMessage(messageCount, senderId, _receiverId, _content, block.timestamp);
    }

    function followUser(uint _followedId) public onlyUser {
        uint followerId = userAddresses[msg.sender];
        require(_followedId > 0 && _followedId <= userCount, "User does not exist.");
        require(followerId != _followedId, "You cannot follow yourself.");
        require(!users[followerId].following[_followedId], "Already following this user.");
        users[followerId].following[_followedId] = true;
        users[_followedId].followers++;
        emit FollowUser(followerId, _followedId);
    }

    function getTweet(uint _tweetId) public view returns (uint, uint, string memory, uint) {
        require(_tweetId > 0 && _tweetId <= tweetCount, "Tweet does not exist.");
        Tweet memory tweet = tweets[_tweetId];
        return (tweet.tweetId, tweet.userId, tweet.message, tweet.timestamp);
    }

    function getUser(uint _userId) public view returns (uint, string memory, uint) {
        require(_userId > 0 && _userId <= userCount, "User does not exist.");
        User storage user = users[_userId];
        return (user.userId, user.username, user.followers);
    }

    function getMessage(uint _messageId) public view returns (uint, uint, string memory, uint) {
        require(_messageId > 0 && _messageId <= messageCount, "Message does not exist.");
        Message memory message = messages[_messageId];
        return (message.messageId, message.senderId, message.content, message.timestamp);
    }

    function isFollowing(uint _userId, uint _followedId) public view returns (bool) {
        require(_userId > 0 && _userId <= userCount, "User does not exist.");
        require(_followedId > 0 && _followedId <= userCount, "Followed user does not exist.");
        return users[_userId].following[_followedId];
    }
}
