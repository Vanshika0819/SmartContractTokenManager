contract TokenManger {
    string public tokenName;
    string public tokenAbbrev;
    uint256 public totalSupply;
    uint256  public managertotalSupply;

    mapping(address => uint256) public balances;
    address public manager;

    constructor(string memory _tokenName, string memory _tokenAbbrev, uint256 _managertotalSupply) {
        tokenName = _tokenName;
        tokenAbbrev = _tokenAbbrev;
        managertotalSupply = _managertotalSupply;
        balances[msg.sender] = _managertotalSupply; // Assign initial supply to contract deployer
        manager = msg.sender; // Assign contract deployer as manager
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }
    
    address public lastBurnFrom;
    address public lastMintTo;

    function mint(address _minted, uint256 _amount) public onlyManager {
        require(_minted!= address(0), "Invalid address");
        totalSupply += _amount;
        balances[_minted] += _amount;
        balances[manager] -= _amount;
        managertotalSupply -= _amount;
        lastMintTo = _minted;
    }

    function burn(address _deducted, uint256 _amount) public onlyManager {
        require(_deducted!= address(0), "Invalid address");
        require(balances[_deducted] >= _amount, "Insufficient balance");
        totalSupply -= _amount;
        balances[_deducted] -= _amount;
        balances[manager] -= _amount;
        managertotalSupply += _amount;
        lastBurnFrom = _deducted;
    }

    function getTransactionDetails() public view onlyManager returns (address, address) {
        return (lastBurnFrom, lastMintTo);
    }
}

