// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
pragma solidity >=0.8.9;
/**
 * @title Auction.sol
 * @dev Store & retrieve value in a variable
 */
contract Auction{
    
    event SellerSet(address indexed oldSeller, address indexed newSeller);
    event AnnounceAuction(Item _item,uint _endTime);
    event AnnounceEnded(Item _item);
    event AnnounceBid(address bidder,uint amount);
    event AnnounceResult(address highestBidder,uint amount);
    
    modifier isSeller(){
        require(msg.sender==seller,"Caller is not seller");
        _;
    }
    
    modifier notEnded(uint itemNum){
        require(auctionItems[itemNum].ended==false && block.timestamp>auctionItems[itemNum].endTime,"The auction has ended");
        _;
    }
    
    modifier hasEnded(uint itemNum){
        require(auctionItems[itemNum].ended==true || block.timestamp<auctionItems[itemNum].endTime,"The auction has not ended");
        _;
    }
    
    struct Item{
        string name;
        IERC721 nft;
        uint nftId;
        address payable seller;
        string description;
        uint endTime;
        bool ended;
        uint highestBid;
        address highestBidder;
    }
    
    address public seller;
    address payable private sellerWallet;
    
    string[] messages;
    Item[] items;
    Item[] auctionItems;
    IERC721 public nft;
    
    constructor(){}
    
    function createItem(string memory name,address _nft,uint _nftId,string memory description,uint endTime) public isSeller{
        items.push(Item(name,IERC721(_nft),_nftId,payable(msg.sender),description,block.timestamp+endTime,false,0,payable(msg.sender)));
    }
    
    function auctionItem(uint itemNum) public isSeller{
        Item memory item=items[itemNum];
        auctionItems.push(item);
        emit AnnounceAuction(item,item.endTime);
    }
    
    function cancelAuctionOfItem(uint itemNum) public isSeller{ // rebranded "removeAuctionItem()" function
        auctionItems[itemNum].ended=true;
        emit AnnounceEnded(auctionItems[itemNum]);
    }
    
    function bid(uint _bid,uint itemNum) public payable notEnded(itemNum) returns(string memory str){
       if(auctionItems[itemNum].endTime<block.timestamp){
           return("Sorry, the auction has ended. Better luck next time!");
       } else if(_bid<auctionItems[itemNum].highestBid){
           return("Your bid is too low.");
       } else if(msg.sender.balance>=_bid){
           auctionItems[itemNum].highestBidder=payable(msg.sender);
           auctionItems[itemNum].highestBid=_bid;
           return("You are now the highest bidder");
       } else{
           revert("You don't have sufficient funds");
       }
    }
    
    function acceptHighestBid(uint itemNum) public payable isSeller notEnded(itemNum){
        auctionItems[itemNum].ended=true;
        emit AnnounceResult(auctionItems[itemNum].highestBidder,auctionItems[itemNum].highestBid);
        sellerWallet.transfer(auctionItems[itemNum].highestBid);
        nft.safeTransferFrom(seller,auctionItems[itemNum].highestBidder,auctionItems[itemNum].nftId);
    }
    
}

/**contract Item{
    IERC721 public nft;
    uint public nftId;
    address payable public seller;
    string description;
    constructor(address _nft,uint _nftId,string memory _description){
        seller=payable(msg.sender);
        nft=IERC721(_nft);
        nftId=_nftId;
        description=_description;
    }
    function getNft() view public returns(IERC721 _nft){
        return(nft);
    }
    function getNftId() view public returns(uint _nftId){
        return(nftId);
    }
}**/
