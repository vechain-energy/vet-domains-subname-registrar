//SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

// VNS Interface: https://docs.vet.domains/Developers/Contracts/Registry/
import "./interfaces/ENS.sol";

// Resolver Interface: https://docs.vet.domains/Developers/Contracts/Resolver/
import "./interfaces/PublicResolver.sol";

import {StringUtils} from "./ethregistrar/StringUtils.sol";
import "./utils/Namehash.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them.
 */
contract SubdomainClaimer {
    using StringUtils for *;

    ENS public immutable ens;
    bytes32 public node;
    string public domainName;

    /**
     * Constructor.
     * @param ensAddr The address of the ENS registry.
     * @param _domainName The subdomain to manage
     */
    constructor(ENS ensAddr, string memory _domainName) {
        ens = ensAddr;
        domainName = _domainName;
        node = Namehash.namehash(domainName);
    }

    /**
     * Register a name, or change the owner of an existing registration.
     * @param name The name of the subdomain (foo if you want foo.example.vet)
     * @param resolver The resolver to set on the subdomain.
     */
    function claim(string memory name, PublicResolver resolver) public {
        bytes32 label = keccak256(bytes(name));
        bytes32 subnode = keccak256(abi.encodePacked(node, label));

        require(!ens.recordExists(subnode), "Subdomain already claimed.");

        // Create subdomain by assigning ownership to this contract for management purpose
        ens.setSubnodeOwner(node, label, address(this));

        // Set the subdomain's resolver
        ens.setResolver(subnode, address(resolver));

        // Set the address record on the resolver
        resolver.setAddr(subnode, msg.sender);

        // Set ownership for new subdomain
        ens.setSubnodeOwner(node, label, msg.sender);
    }
}
