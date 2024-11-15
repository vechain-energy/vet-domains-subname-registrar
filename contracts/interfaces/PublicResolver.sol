//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;
 
interface PublicResolver {
 
    // Logged when the address associated with a name is changed.
    event AddrChanged(bytes32 indexed node, address a);
 
    // Logged when a text record is changed.
    event TextChanged(bytes32 indexed node, string indexed key, string value);
 
    // Logged when the name associated with an address is changed in reverse resolution.
    event NameChanged(bytes32 indexed node, string name);
 
    // Logged when an ABI is changed.
    event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
 
    // Logged when a pubkey is changed.
    event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
 
    // Logged when a contenthash is changed.
    event ContenthashChanged(bytes32 indexed node, bytes contenthash);
 
    // Function to get the address associated with a node.
    function addr(bytes32 node) external view returns (address);
 
    // Function to set the address associated with a node.
    function setAddr(bytes32 node, address a) external;
 
    // Function to get a text record.
    function text(bytes32 node, string calldata key) external view returns (string memory);
 
    // Function to set a text record.
    function setText(bytes32 node, string calldata key, string calldata value) external;
 
    // Function to get the name associated with a node in reverse resolution.
    function name(bytes32 node) external view returns (string memory);
 
    // Function to set the name associated with a node in reverse resolution.
    function setName(bytes32 node, string calldata name) external;
 
    // Function to get an ABI.
    function ABI(bytes32 node, uint256 contentType) external view returns (uint256, bytes memory);
 
    // Function to set an ABI.
    function setABI(bytes32 node, uint256 contentType, bytes calldata data) external;
 
    // Function to get a pubkey.
    function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y);
 
    // Function to set a pubkey.
    function setPubkey(bytes32 node, bytes32 x, bytes32 y) external;
 
    // Function to get a contenthash.
    function contenthash(bytes32 node) external view returns (bytes memory);
 
    // Function to set a contenthash.
    function setContenthash(bytes32 node, bytes calldata hash) external;
 
    // Function to check if a contract implements an interface.
    function supportsInterface(bytes4 interfaceID) external pure returns (bool);
}