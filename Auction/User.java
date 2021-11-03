public class User{
    private String username;
    private Address walletAddress;
    public double auctionToken;
    public User(String username,Address walletAddress){
    	this.username=username;
    	this.walletAddress=walletAddress;
    	auctionToken=0;
    }
    public void swapToToken(double wolvercoin){
        auctionToken+=wolvercoin*exchangeRate;// change to correct exchange rate
    }
}