pragma solidity >=0.7.0 <0.9.0

import "./Ownable.sol"

contract AuctionHouse is Ownable{
    
    //ATRIBUTELE LE STABILESTI DIN MERS DACA NU EXISTA CEVA DEJA CREAT
    //PENTRU CONDITII E BINE SA FOLOSIM MODFIERS DACA E CEVA GENERAL
    
    //Functie pentru plasare de licitatii
    //amount > current_highest_bid
    //bidderul sa detina suma respectiva
    //msg.sender is bidder
    //event pentru instiintarea ca cineva a licitat mai mult
    //pentru primul bid al msg.sender se percepe o taxa (procent din bid sau ceva de genu)
    //bidderul trebuie sa detina si taxa
    function placeBid(uint amount) public payable{
        
    }
    
    
    //Licitatia se opreste
    //Doar detinatorul licitatie poate opri Licitatia
    //se emite event cu castigatorul licitatiei
    //suma nu este retrasa din contul castigatorului. Cu o alta functie el va alege cand va plati.
    function stopBidding() external onlyOwner{
        
    }
    
    //Winnerul plateste cat a licitat
    //Winnerul trebuie sa detina suma
    //cel care apeleaza trebuie sa fie castigatorul
    //suma retrasa este cea stabilita dupa ce se anunta castigatorul
    function claimReward() external payable{
        
    }
    
    //Vizualizeaza suma curenta
    function getCurrentHighestBid() external view returns(uint){
        
    }
    
    //Vizualizeaza statusul licitatiei true = se liciteaza, false = altfel
    function getBidStatus() external view returns(bool){
        
    }
    
    //Ownerul creaza o licitatie
    //Ca input ar trebui o descriere si un starting price
    function createBid(string memory _description, uint _price) external onlyOwner{
        
    }
    
    
    //Ownerul poate schimba pretul de start doar daca nu s-a licitat pana in acel moment
    function changeStartingPrice(uint _newPrice) external onlyOwner{
        
    }
    
    //ALTE FUNCTII DACA MAI DORESTI TU ZOLIK SI MAI AI IDEI
}
