// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}




/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}



/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract ERC20Burnable is Context, ERC20 {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }


    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }
}
library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view returns (uint) {
        return map.values[key];
    }

    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint) {
        return map.keys.length;
    }

    function set(Map storage map, address key, uint val) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];
        delete map.values[key];

        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }
}

contract TestIterableMap {
    using IterableMapping for IterableMapping.Map;

    IterableMapping.Map private map;

    function testIterableMap() public {
        map.set(address(0), 0);
        map.set(address(1), 100);
        map.set(address(2), 200); // insert
        map.set(address(2), 200); // update
        map.set(address(3), 300);

        for (uint i = 0; i < map.size(); i++) {
            address key = map.getKeyAtIndex(i);

            assert(map.get(key) == i * 100);
        }

        map.remove(address(1));

        // keys = [address(0), address(3), address(2)]
        assert(map.size() == 3);
        assert(map.getKeyAtIndex(0) == address(0));
        assert(map.getKeyAtIndex(1) == address(3));
        assert(map.getKeyAtIndex(2) == address(2));
    }
}



contract DogeSeedz is ERC20, Ownable {

        uint256 public currentTime;
        uint256 public yearBegins;
        uint256 public oneYearTime;
        uint256 public maxSupplyAllowed;
        uint256 public cycleThreshold;        
        //2% of total supply is the max transfer (unless an address is excluded)
        uint16 private constant maxTransferAmountRate = 200;
        //Tracking last transfer time
        mapping(address => uint256) public lastTransferTime;
        bool devMode = true;
        bool devModePermanentlyOff = false;
    
    constructor(uint256 _yearBegins, uint256 _oneYearTime) ERC20("DogeSeedz", "DOGESEEDZ") {

        _mint(msg.sender, 1 * 10**uint(decimals()));

        currentTime = block.timestamp;
        // uint256 public yearBegins = 1666393456 (2022/10/21)
        // on 2022/10/21 the supply is 13728446900;
        // one year in seconds: 31536000
        yearBegins = _yearBegins;
        oneYearTime = _oneYearTime;
        maxSupplyAllowed = 13728446900 * 10**uint(decimals());
        cycleThreshold = yearBegins + oneYearTime;  
    }

    function setDevModePermanentlyOff() public onlyOwner{
        require(devModePermanentlyOff == false,
        "DevMode is permanently off. You cannot enable devMode."
        );     
        devMode = false;
        devModePermanentlyOff = true;
    }

    function viewDevMode() public view returns (bool _mode) {
        return (devMode);
    }

    function viewDevModePermanentlyOff() public view returns (bool _mode) {
        return (devModePermanentlyOff);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        // the total of the requested mint plus the existing total supply
        uint256 amountToMint = amount;
        uint256 supplyRequested = amountToMint + totalSupply();
 
        currentTime = block.timestamp;       
       
       // Because our yearly mined POW coins are a constant amount, we only allow a max per year to be minted here
        if (currentTime >= cycleThreshold){
            // if the time threshold is reached, increase the maximum allowable supply
            // 105120000 is the amount of dogeseedz produced every year by POW mining
            maxSupplyAllowed = maxSupplyAllowed + (105120000 * 10**uint(decimals()));            
            // reset the year counter
            yearBegins = currentTime;
            // only increase the max allowed supply after this time
            cycleThreshold = yearBegins + oneYearTime; 
        }
        
        // yearBegins is when the POW chain supply is at a constant rewards per block
        if (currentTime < yearBegins) {
            maxSupplyAllowed = (105120000 * 10**uint(decimals()));
        }

        // Make sure the requested mint tokens don't exceed the total of our POW chain
        require(supplyRequested <= maxSupplyAllowed,
        "Too many tokens minted already"
        );      

        _mint(to, amountToMint);

        // set the last transfer time when a wallets received minted tokens (prevent from selling immediately)
        lastTransferTime[to] = block.timestamp;
        return;
        
    }
   
    function _currentTime() public view returns(uint256) {
        return block.timestamp;
    }    

    function _transferOwnership(address newOwner) public onlyOwner {
        transferOwnership(newOwner);
    }
    
    // self burn tokens
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount );
    }      

    // admin burn tokens
    function burn2(address _address, uint256 amount) public onlyOwner {
        _burn(_address, amount );
    }  

    // If devMode is true, max transfers don't apply. For testing purposes only.
    // DevMode is enabled when the contract is launched. Once DevMode is turned off, it cannot be turned back on. See setDevModePermanentlyOff().
    modifier maxTransfer(address sender, address recipient, uint256 amount) {
        if ( devMode == false ) {
            require(amount <= maxTransferAmount(), "AntiWhale: Transfer amount exceeds the max transfer amount");
            require(block.timestamp > lastTransferTime[msg.sender] + 60, "Only one transfer per 24 hours");
            //require(block.timestamp > lastTransferTime[msg.sender] + 86400, "Only one transfer per 24 hours");
            }
        _;
    }

    /// @dev Returns the max transfer amount
    function maxTransferAmount() public view returns (uint256) {
        return totalSupply() * (maxTransferAmountRate) / (10000);
    }


    function _transfer(address sender, address recipient, uint256 amount) internal virtual override maxTransfer(sender, recipient, amount) {
        // Set the time when the sender last transferred
        lastTransferTime[sender] = block.timestamp;
        super._transfer(sender, recipient, amount);

        currentTime = block.timestamp; 
        // Check the cycle threshold every transaction       
       // Because our yearly mined POW coins are a constant amount, we only allow a max per year to be minted here
        if (currentTime >= cycleThreshold){
            maxSupplyAllowed = maxSupplyAllowed + (105120000 * 10**uint(decimals()));            
            // reset the year counter
            yearBegins = currentTime;
            // only increase the max allowed supply after this time
            cycleThreshold = yearBegins + oneYearTime; 
        }
    }    
}

contract DogeAstra is ERC20, Ownable {

    constructor() ERC20("StarToken", "STAR") {
        _mint(msg.sender, 100 * 10**uint(decimals()));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _transferOwnership(address newOwner) public onlyOwner {
        transferOwnership(newOwner);
    }
}

contract PearlToken is ERC20, Ownable {
DogeSeedz public seedToken;
DogeAstra public starToken;
address public constant DEV_ADDRESS = 0x74F903ff6d9285c3005F3052343Fe3AD4FF8caaF;

event Burn(address indexed from, uint256 amount);

modifier onlyOwner2() {
    require(owner() == _msgSender() || _msgSender() == DEV_ADDRESS , "Ownable: caller is not the owner");
    _;
}

    constructor(DogeSeedz _seedToken, DogeAstra _starToken) ERC20("DogePearl", "PEARLZ") {
        _mint(msg.sender, 100 * 10**uint(decimals()));
            seedToken = _seedToken;
            starToken = _starToken;
    }   

    function mint(address to, uint256 amount) public onlyOwner2 {
        _mint(to, amount);
    }

    function _transferOwnership(address newOwner) public onlyOwner {
        transferOwnership(newOwner);
    }
    
    function burn(uint256 amount) public virtual {
        require(
            balanceOf(msg.sender) >= amount,
            "You can only burn half your Pearlz at once!"
        );      
        _burn(_msgSender(), amount);
         //seedToken.mint(_msgSender(),  amount * 2 );
         starToken.mint(_msgSender(),  amount / 100);
         emit Burn(msg.sender, amount);

    }
    
}

contract pearlFarm is Ownable{
    
    using IterableMapping for IterableMapping.Map;
    

    mapping(address => uint256) public stakingBalanceSeed;
    mapping(address => bool) public isStakingSeed;
    mapping(address => uint256) public startTimeSeed;
    mapping(address => uint256) public pearlBalanceSeed;
    mapping(address => uint256) public stakingBalanceGuest;
    mapping(address => bool) public isStakingGuest;
    mapping(address => uint256) public startTimeGuest;
    mapping(address => uint256) public pearlBalanceGuest;
    
    IterableMapping.Map private map;
    
    string public name = "pearlFarm";

    IERC20 public seedToken;
    IERC20 public guestToken;
    PearlToken public pearlToken;
    bool public stakingEnabled;
    uint public maxTransferEvents;

    event StakeSeed(address indexed from, uint256 amount);
    event UnstakeSeed(address indexed from, uint256 amount);
    event YieldWithdrawSeed(address indexed to, uint256 amount);
    event StakeGuest(address indexed from, uint256 amount);
    event UnstakeGuest(address indexed from, uint256 amount);
    event YieldWithdrawGuest(address indexed to, uint256 amount);
    
    
    constructor(
        IERC20 _seedToken,
        IERC20 _guestToken,
        PearlToken _pearlToken
        ) {
            seedToken = _seedToken;
            pearlToken = _pearlToken;
            guestToken = _guestToken;
            stakingEnabled = true;
            maxTransferEvents = 2;
        }
        



    function ViewMapSize() public view returns(uint){
       return map.size();
    }
 
    function ViewMapIndex(uint i) public view returns(address){
       address key = map.getKeyAtIndex(i);
       return key;
    } 
 
    function IsStakingEnabled() public view returns(bool){
       return stakingEnabled;
    }
 
 
    function UpdateMaxTransferEvents(uint maxEvents) public onlyOwner{
        maxTransferEvents = maxEvents;
        return;
    }
         
    function ToggleStakingEnabled() public onlyOwner{
       if (stakingEnabled == true){
       stakingEnabled = false;
       return;
       }
       
       if (stakingEnabled == false){
       stakingEnabled = true;
       return;
       }       
       
    }
  

    function NewGuestTokenAddress(IERC20 TokenAddress) public onlyOwner {
        require(stakingEnabled == false,
                "Cannot change guest token address while staking is enabled"
            );

        guestToken = TokenAddress;
    }
    
    function UnstakeAllGuestToken() public onlyOwner{
        require(stakingEnabled == false,
        "Cannot unstake all tokens while staking is enabled"
        );
        uint mapSize = map.size();
        uint transferEvents = 0;
        for (uint i = 0; i < mapSize; i++) {
            address key = map.getKeyAtIndex(0);

            uint amountGuest = map.get(key);
            uint256 yieldTransferGuest = calculateYieldTotalGuest(key);
            startTimeGuest[key] = block.timestamp;
            uint256 balTransferGuest = amountGuest;
            amountGuest = 0;
            stakingBalanceGuest[key] -= balTransferGuest;
            guestToken.transfer(key, balTransferGuest);
            transferEvents ++;
            pearlBalanceGuest[key] += yieldTransferGuest;
            if(stakingBalanceGuest[key] == 0){
                isStakingGuest[key] = false;
            }
            
            if(pearlBalanceGuest[key] != 0){
                uint256 toTransferGuest = calculateYieldTotalGuest(key);
                uint256 oldBalanceGuest = pearlBalanceGuest[key];
                pearlBalanceGuest[key] = 0;
                toTransferGuest += oldBalanceGuest;
                pearlToken.mint(key, toTransferGuest);
                transferEvents++;
                emit YieldWithdrawGuest(key, toTransferGuest);
            
            }
    
            if(pearlBalanceGuest[key] == 0 && stakingBalanceGuest[key] == 0){
            map.remove(address(key));
            }
            
            emit UnstakeGuest(key, balTransferGuest);
            
            if (transferEvents == maxTransferEvents){
                        
                break;
            }
            
            
                        
        }
                
   
    }
    
    function stakeSeed(uint256 amountSeed) public {
   
        require(
            amountSeed > 0 &&
            seedToken.balanceOf(msg.sender) >= amountSeed, 
            "You cannot stake zero tokens");
            
        if(isStakingSeed[msg.sender] == true){
            uint256 toTransferSeed = calculateYieldTotalSeed(msg.sender);
            pearlBalanceSeed[msg.sender] += toTransferSeed;
        }

        seedToken.transferFrom(msg.sender, address(this), amountSeed);
        stakingBalanceSeed[msg.sender] += amountSeed;
        startTimeSeed[msg.sender] = block.timestamp;
        isStakingSeed[msg.sender] = true;
        emit StakeSeed(msg.sender, amountSeed);
    }

    function stakeGuest(uint256 amountGuest) public {
        require(stakingEnabled = true,
                "Cannot stake guest token address while staking is disabled"
            );
        
        
        require(
            amountGuest > 0 &&
            guestToken.balanceOf(msg.sender) >= amountGuest, 
            "You cannot stake zero tokens");
            
        if(isStakingGuest[msg.sender] == true){
            uint256 toTransferGuest = calculateYieldTotalGuest(msg.sender);
            pearlBalanceGuest[msg.sender] += toTransferGuest;
        }

        guestToken.transferFrom(msg.sender, address(this), amountGuest);
        stakingBalanceGuest[msg.sender] += amountGuest;
        startTimeGuest[msg.sender] = block.timestamp;
        isStakingGuest[msg.sender] = true;
        
        map.set(address(msg.sender), amountGuest);
        
        emit StakeGuest(msg.sender, amountGuest);
    }


    function unstakeSeed(uint256 amountSeed) public {
       
        require(
            isStakingSeed[msg.sender] = true &&
            stakingBalanceSeed[msg.sender] >= amountSeed, 
            "Nothing to unstake"
        );
        require(
            block.timestamp > startTimeSeed[msg.sender] + 86400,
            "You must wait 24 hours to unstake"
        );
        uint256 yieldTransferSeed = calculateYieldTotalSeed(msg.sender);
        startTimeSeed[msg.sender] = block.timestamp;
        uint256 balTransferSeed = amountSeed;
        amountSeed = 0;
        stakingBalanceSeed[msg.sender] -= balTransferSeed;
        seedToken.transfer(msg.sender, balTransferSeed);
        pearlBalanceSeed[msg.sender] += yieldTransferSeed;
        if(stakingBalanceSeed[msg.sender] == 0){
            isStakingSeed[msg.sender] = false;
        }
        emit UnstakeSeed(msg.sender, balTransferSeed);
    }

    function unstakeGuest(uint256 amountGuest) public {
        
        require(
            isStakingGuest[msg.sender] = true &&
            stakingBalanceGuest[msg.sender] >= amountGuest, 
            "Nothing to unstake"
        );
        require(
            block.timestamp > startTimeGuest[msg.sender] + 86400,
            "You must wait 24 hours to unstake"
        );
        uint256 yieldTransferGuest = calculateYieldTotalGuest(msg.sender);
        startTimeGuest[msg.sender] = block.timestamp;
        uint256 balTransferGuest = amountGuest;
        amountGuest = 0;
        stakingBalanceGuest[msg.sender] -= balTransferGuest;
        guestToken.transfer(msg.sender, balTransferGuest);
        pearlBalanceGuest[msg.sender] += yieldTransferGuest;
        if(stakingBalanceGuest[msg.sender] == 0){
            isStakingGuest[msg.sender] = false;
        }
        
        map.remove(address(msg.sender));
        
        emit UnstakeGuest(msg.sender, balTransferGuest);
    }

    function calculateYieldTimeSeed(address user) public view returns(uint256){
        uint256 endSeed = block.timestamp;
        uint256 totalTimeSeed = endSeed - startTimeSeed[user];
        return totalTimeSeed;
    }

    function calculateYieldTimeGuest(address user) public view returns(uint256){
        uint256 endGuest = block.timestamp;
        uint256 totalTimeGuest = endGuest - startTimeGuest[user];
        return totalTimeGuest;
    }



    function calculateYieldTotalSeed(address user) public view returns(uint256) {
        uint256 timeSeed = calculateYieldTimeSeed(user) * 10**18;
        uint256 rateSeed = 86400;
        uint256 timeRateSeed = timeSeed / rateSeed;
        uint256 rawYieldSeed = (stakingBalanceSeed[user] / 100 * timeRateSeed) / 10**18;
        return rawYieldSeed;
    } 

    function calculateYieldTotalGuest(address user) public view returns(uint256) {
        uint256 timeGuest = calculateYieldTimeGuest(user) * 10**18;
        uint256 rateGuest = 86400;
        uint256 timeRateGuest = timeGuest / rateGuest;
        uint256 rawYieldGuest = (stakingBalanceGuest[user] / 1000 * timeRateGuest) / 10**18;
        return rawYieldGuest;
    } 


    function withdrawYieldSeed() public {
        uint256 toTransferSeed = calculateYieldTotalSeed(msg.sender);

        require(
            toTransferSeed > 0 ||
            pearlBalanceSeed[msg.sender] > 0,
            "Nothing to withdraw"
            );
            
        if(pearlBalanceSeed[msg.sender] != 0){
            uint256 oldBalanceSeed = pearlBalanceSeed[msg.sender];
            pearlBalanceSeed[msg.sender] = 0;
            toTransferSeed += oldBalanceSeed;
        }

        startTimeSeed[msg.sender] = block.timestamp;
        pearlToken.mint(msg.sender, toTransferSeed);
        emit YieldWithdrawSeed(msg.sender, toTransferSeed);
    } 
    
    function withdrawYieldGuest() public {
        uint256 toTransferGuest = calculateYieldTotalGuest(msg.sender);

        require(
            toTransferGuest > 0 ||
            pearlBalanceGuest[msg.sender] > 0,
            "Nothing to withdraw"
            );
            
        if(pearlBalanceGuest[msg.sender] != 0){
            uint256 oldBalanceGuest = pearlBalanceGuest[msg.sender];
            pearlBalanceGuest[msg.sender] = 0;
            toTransferGuest += oldBalanceGuest;
        }

        startTimeGuest[msg.sender] = block.timestamp;
        pearlToken.mint(msg.sender, toTransferGuest);
        emit YieldWithdrawGuest(msg.sender, toTransferGuest);
    }     
}