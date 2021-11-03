public class Item{
    int highestBid,time;
    Address highestBidder;
    final int BLOCKTIME=12;
    boolean inAuction;
    String description;
    public Item(String description){
        this.description=description;
        inAuction=false;
    }
    public boolean auctionItem(int initialPrice,int time){
        if(initialPrice>=0&&time>=0&&inAuction==false){
            inAuction=true;
            highestBid=initialPrice;
            return true;
        }
        return false;
    }
    public boolean bid(int bid,Address bidderAddress){
        if(bid>highestBid){
            highestBid=bid;
            highestBidder=bidderAddress;
        }
        return false;
    }
    public void removeAuctionItem(){
        inAuction=false;
        address=auctioneerAddress;
    }
    public void acceptHighestBid(){
        //invoke native transfer
    }
}
