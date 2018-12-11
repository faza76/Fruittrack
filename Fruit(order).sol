pragma solidity ^0.4.0;

contract fruittrack{
    address owner;
    
    address[] _farmer;
    address[] _distri;
    uint[] _buah;

    mapping(string=>fruit) goods;

    mapping(address=>farmer) farm;
    mapping(address=>distributor) distri;
    mapping(address=>market) mark;
    mapping(uint=>shipment) ship;
    mapping(address=>ord) order;

    struct fruit{
        string name;        
        string desc;
        address farmer_;
        uint256 harv_date;
        uint price;
        uint quantity;

        address[2] partner;
        uint256[2] sendDate;
        uint256[2] receiveDate;
        uint16 status;
    }

    struct ord{
        string kFruit;
        uint quantity;
        address farmer;
        bool send;
    }

    struct shipment{
        string code;
        address sender;
        address receiver;
        uint quantity;
    }

    struct farmer{
        string name;
        string cityState;
        string country;
        uint data; //untuk data
        uint rating; //untuk rating
        bool exist;
    }

    struct distributor{
        string name; 
        string cityState;
        string country;
        bool exist;
    }

    struct market{
        string name;
        string cityState;
        string country;
        bool exist;
    }
    
    constructor() public{
        owner = msg.sender;
        // _buah.push(0.01);
        // _buah.push(0.02);
        // _buah.push(0.008);
        // _buah.push(0.006);
    }
    
    //pendaftaran produsen
    function newfarmer(address pub, string name, string cityState, string country) public{
        require(msg.sender == owner);
        farm[pub].name = name;
        farm[pub].cityState = cityState;
        farm[pub].country = country;
        farm[pub].exist = true;
        _farmer.push(pub);
    }
    
    //pendaftaran distributor
    function newdistri(address pub, string name, string cityState, string country) public{
        require(msg.sender == owner);
        distri[pub].name = name;
        distri[pub].cityState = cityState;
        distri[pub].country = country;
        distri[pub].exist = true;
        _distri.push(pub);
    }
    //pendaftaran market
    function newmarket(address pub, string name, string cityState, string country) public{
        require(msg.sender == owner);
        mark[pub].name = name;
        mark[pub].cityState = cityState;
        mark[pub].country = country;
        mark[pub].exist = true;
    }
  
    //fungsi untuk daftar buah baru
    function newfruit(string code, string _name, string _desc, uint price) public{
        // require(farm[msg.sender].exist == true);
        goods[code].name = _name;
        goods[code].desc = _desc;
        goods[code].farmer_ = msg.sender;
        goods[code].harv_date = block.timestamp;
        goods[code].price = price;
    }

    //membeli buah ke petani
    function buyFruitToFarm(string code,uint amount) payable{
        if (msg.value != (amount * goods[code].price)){
            throw;
        }
        order[1].kFruit = code;
        order[1].quantity = amount;
        order[1].farmer = goods[code].farmer_;
        order[1].send = false;
        
    }
    
    //mengirim buah
    function sendFruitFarmer(uint trackid, string code, address next_) public{
        ship[trackid].code = code;
        ship[trackid].sender = msg.sender;
        ship[trackid].receiver = next_;
        goods[code].sendDate[0] = block.timestamp;
    }
    
    function sendFruitDistributor(uint trackid, address next_) public{
        ship[trackid].sender = msg.sender;
        ship[trackid].receiver = next_;
        goods[ship[trackid].code].sendDate[1] = block.timestamp;
    }
    
    //penerimaan
    function recieve_dis(uint trackid) public{
        require(distri[msg.sender].exist == true);
        goods[ship[trackid].code].receiveDate[0] = block.timestamp;
        goods[ship[trackid].code].partner[0] = ship[trackid].receiver;
        goods[ship[trackid].code].status = 0;
    }

    function recieve_mar(uint trackid) public{
        require(mark[msg.sender].exist == true);
        goods[ship[trackid].code].receiveDate[1] = block.timestamp;
        goods[ship[trackid].code].partner[1] = ship[trackid].receiver;
        goods[ship[trackid].code].status = 1;
    }

    //fitur rating
    function setRating (uint x, address farmer_) public {
        require(farm[farmer_].exist == true);

        farm[farmer_].rating = farm[farmer_].rating + x;
        farm[farmer_].data = farm[farmer_].data + 1;
	}

    function getRating (address farmer_) public constant returns (uint) {
        return ((farm[farmer_].rating * 10) / farm[farmer_].data);
    }

    //show data buah
    function getFruit(string code) view public returns(string,uint,string,address, uint256, address[2], uint256[2]){
        return (goods[code].name, goods[code].price, goods[code].desc, goods[code].farmer_,
                goods[code].harv_date, goods[code].partner, goods[code].sendDate);
    }

    //show data farmer
    function getFarm(address account) view public returns(string,string,string){
        return (farm[account].name, farm[account].cityState, farm[account].country);
    }
    
    //show distributor
    function getDistri(address account) view public returns(string,string,string){
        return (distri[account].name, distri[account].cityState, distri[account].country);
    }
    
    //show market
    function getMark(address account) view public returns(string,string,string){
        return (mark[account].name, mark[account].cityState, mark[account].country);
    }

    function listfarmer() view public returns(address[]){
        return _farmer;
    }

    function listdistri() view public returns(address[]){
        return _distri;
    }
}