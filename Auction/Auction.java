import java.util.*;
public class Auction{
    User auctioneer;
    ArrayList<Item> items=new ArrayList<Item>();
    public Auction(User actioneer){
        this.auctioneer=auctioneer;
    }
    public void addItemToAuction(Item item){
        items.add(item);
    }
}
