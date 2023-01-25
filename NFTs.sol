pragma solidity ^0.8;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/access/Ownable.sol";
import "star.sol";

contract SampleNFTContract is ERC721URIStorage {

    DogeAstra public starToken;
    uint256 public tokenCounter;
    address public tokenAddress;
    uint256 public price;
    string public tokenURI;
    string public goodEvilState;
    uint public goodURIs;
    uint public evilURIs;
    uint public maxLoop;
    uint256 public goodCounter = 0;
    uint256 public evilCounter = 0;
    uint256 goodEvilRatio = 0;
    address[] playerArray;
    mapping(uint256 => string) public NFTAlignment;
    mapping(uint256 => int) public NFTPower;
    mapping(uint256 => int) public NFTTurnsLeft;
    mapping(uint256 => uint256) public NFTLastUsed;

    constructor (address _tokenAddress, uint256 _price, DogeAstra _starToken) public ERC721 ("astronaut", "STAR"){
        tokenCounter = 0;
        tokenAddress = _tokenAddress;
        price = _price;
        starToken = _starToken;
    }

    function setMaxLoop(int _maxLoop) public onlyOwner {
        maxLoop = _maxLoop;
    }

    function viewMaxLoop() public view returns (uint memory){
        uint memory = maxLoop;
        return maxLoop;
    }

    function getAlignment(uint256 tokenId) public view returns (string memory) {
        string memory _alignment = NFTAlignment[tokenId];
        return _alignment;
    }

    function getPower(uint256 tokenId) public view returns (uint memory) {
        uint memory _power = NFTPower[tokenId];
        return _power;
    }

    function getGoodEvilRatio() public returns (int) {
        if (goodCounter > evilCounter) {goodEvilRatio = goodCounter - evilCounter;goodEvilState="Good";}
        if (evilCounter > goodCounter) {goodEvilRatio = evilCounter - goodCounter;goodEvilState="Evil";}
        if (goodCounter == 0 && evilCounter == 0) {goodEvilRatio = 1;}
        return goodEvilRatio;
    }

    function createNFT() public returns (uint256) {

        uint256 newNFTTokenId = tokenCounter;
        string memory alignment;
        //IERC20(tokenAddress).transferFrom(msg.sender, address(this), price);
        //Check if the transfer was successful

        playerArray.push(msg.sender);
        
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), price),"Payment failed");

        _safeMint(msg.sender, newNFTTokenId);

        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
        string memory URI;
        if (randomIndex == 0){alignment="Good";tokenURI="https://bafkreicjdxzgxhucpckbvhihmizw5t3d544f3nqn3b6yvdxufe7672eqd4.ipfs.nftstorage.link/";goodCounter ++;}
        if (randomIndex == 1){alignment="Evil";tokenURI="https://bafkreicjdxzgxhucpckbvhihmizw5t3d544f3nqn3b6yvdxufe7672eqd4.ipfs.nftstorage.link/";evilCounter ++;}
        NFTAlignment[newNFTTokenId] = alignment;

        uint randomPower = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
        NFTPower[newNFTTokenId] = randomPower;
 
        NFTLastUsed[newNFTTokenId] = block.timestamp;
        NFTTurnsLeft[newNFTTokenId] = 100;

        _setTokenURI(newNFTTokenId, tokenURI);
    
        tokenCounter = tokenCounter + 1;
        
        return newNFTTokenId;
    }


   function useMyNFT(uint256 _tokenID) public {

       delete playerArray;

       address tokenOwner = ownerOf(_tokenID);
       address yourAddress = msg.sender;
       require(tokenOwner == yourAddress,"You do not own this NFT");

       string _alignment = getAlignment();
       int _ratio = getGoodEvilRatio();
       int _power = getPower();
       uint256 amount = 1000000000000000000;

       if (_alignment == "Good"){
            if (goodEvilState == "Good"){_ratio = 1;}        
            if (playerArray.length<maxLoop) {maxLoop = playerArray.length;}
                for (uint i=0; i<maxLoop; i++) {
                    starToken.mint(_msgSender(), amount * _ratio * _power);
                    playerArray.pop(0);
            }
        
       }

       if (_alignment == "Evil"){
            if (goodEvilState == "Evil"){_ratio = 1;}          
            if (playerArray.length<maxLoop) {maxLoop = playerArray.length;}
            for (uint i=0; i<maxLoop; i++) {
                uint256 amountToBurn = amount * _ratio * _power;
                availableBalance = starToken.balanceOf(playerArray(i));
                if (amountToBurn < availableBalance){
                    starToken.burn(_msgSender(), amountToBurn);
                    playerArray.pop(0);
                }
                if (amountToBurn >= availableBalance){
                    starToken.burn(_msgSender(), availableBalance);
                    playerArray.pop(0);
                }                
            }
       }

       NFTTurnsLeft[_tokenID] = NFTTurnsLeft[_tokenID] - 1;

       if (NFTTurnsLeft[_tokenID] == 0) {
       string memory usedTokenURI =  "1.json";
       _setTokenURI(_tokenID, usedTokenURI);
       }

       address[] playerArray;
   }

// If an NFT is burned, decrease the good and evil counters respectively

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        if (to == 0x000000000000000000000000000000000000dead){
            string _alignment = getAlignment();
            if (_alignment == "Good"){
                goodCounter -= 1;
            }
            if (_alignment == "Evil"){
                evilCounter -= 1;
            }
        }
    }
    
}
