pragma solidity >=0.7.0 <0.9.0;

import "./Ownable.sol";

contract AuctionHouse is Ownable{

    string description;
    uint secretToUnlockPrize;
    
    uint winner_required_amount = 0;
    address winner_address;
    
    uint nrOfBids = 0;
    uint current_highest_bid = 0;
    address current_highest_bider;
    uint firstBidFee = 0.003 ether;
    mapping (address => uint) bidderBidCount;
    
    bool isBidOpen = false;
    bool sold = false;
    
    event NewHighestBid(uint highest_bid, address highest_bider);
    event WinnerOfBid(uint winner_amount, address winner);
    event BidStarted(string description, uint staringPrice);
    
    modifier bidOpen() {
        require(isBidOpen == true);
        _;
    }
    
    //ATRIBUTELE LE STABILESTI DIN MERS DACA NU EXISTA CEVA DEJA CREAT
    //PENTRU CONDITII E BINE SA FOLOSIM MODFIERS DACA E CEVA GENERAL
    
    //Functie pentru plasare de licitatii
    //amount > current_highest_bid
    //bidderul sa detina suma respectiva
    //msg.sender is bidder
    //event pentru instiintarea ca cineva a licitat mai mult
    //pentru primul bid al msg.sender se percepe o taxa (procent din bid sau ceva de genu)
    //bidderul trebuie sa detina si taxa
    function placeBid(uint amount) external payable bidOpen{
        uint check = msg.value;
        if(bidderBidCount[msg.sender] == 0){
            require(msg.value == firstBidFee);
        }
        uint sender_balance = msg.sender.balance;
        require(msg.sender.balance > current_highest_bid && amount > current_highest_bid);
        nrOfBids += 1;
        current_highest_bid = amount;
        current_highest_bider = msg.sender;    
        bidderBidCount[msg.sender]++;
        emit NewHighestBid(current_highest_bid,current_highest_bider);
    }
    
    
    //Licitatia se opreste
    //Doar detinatorul licitatie poate opri Licitatia
    //se emite event cu castigatorul licitatiei
    //suma nu este retrasa din contul castigatorului. Cu o alta functie el va alege cand va plati.
    //se sterg restul persoanelor care au licitat
    function stopBidding() external onlyOwner bidOpen{
        isBidOpen = false;
        winner_required_amount = current_highest_bid;
        winner_address = current_highest_bider;
        current_highest_bid = 0;
        current_highest_bider = address(0x0);
        nrOfBids = 0;
        emit WinnerOfBid(winner_required_amount,winner_address);
    }
    
     //Licitatia porneste
    //Doar detinatorul licitatie poate porni Licitatia
    //se emite event cu pornirea licitatiei
    function startBidding() external onlyOwner{
        if(current_highest_bid != 0){
            isBidOpen = true;
            emit BidStarted(description,current_highest_bid);
        }
    }
    
    //Winnerul plateste cat a licitat
    //Winnerul trebuie sa detina suma
    //cel care apeleaza trebuie sa fie castigatorul
    //suma retrasa este cea stabilita dupa ce se anunta castigatorul
    //Winnerul primeste un cod secret care deblocheaza premiul
    function claimReward() external payable returns(uint){
        address winner = winner_address;
        uint wei_amount = winner_required_amount * 10e17;
        uint sent = msg.value;
        address claimer = msg.sender;
        require(claimer == winner_address && sent == wei_amount);
        winner_required_amount = 0;
        winner_address = address(0x0);
        uint prize = secretToUnlockPrize;
        secretToUnlockPrize = 0;
        sold = true;
        return prize;
    }
    
    //Vizualizeaza suma curenta
    function getCurrentHighestBid() external view returns(uint){
        return current_highest_bid;
    }
    
    //Vizualizeaza statusul licitatiei true = se liciteaza, false = altfel
    function getBidStatus() external view returns(bool){
        return isBidOpen;
    }
    
    //Vizualizeaza descrierea licitatiei
    function getBidDescription() external view returns(string memory){
        return description;
    }
    
    //Verifica daca s-a achitat pretul
    function checkIfSold() external view onlyOwner returns(bool){
        return sold;
    }
    
    //Ownerul creaza o licitatie
    //Ca input ar trebui o descriere si un starting price
    function createBid(string memory _description, uint _price, uint _secret) external onlyOwner{
        description = _description;
        current_highest_bid = _price;
        secretToUnlockPrize = _secret;
        sold = false;
    }
    
    
    //Ownerul poate schimba pretul de start doar daca nu s-a licitat pana in acel moment
    function changeStartingPrice(uint _newPrice) external onlyOwner{
        if(nrOfBids == 0){
            current_highest_bid = _newPrice;
        }
    }
    
    //ALTE FUNCTII DACA MAI DORESTI TU ZOLIK SI MAI AI IDEI
}
