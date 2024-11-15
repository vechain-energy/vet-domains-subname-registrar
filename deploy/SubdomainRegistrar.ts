import { HardhatRuntimeEnvironment } from 'hardhat/types';
import type { DeployFunction } from 'hardhat-deploy/types';
import { SubdomainClaimer } from '../typechain-types';

const DOMAIN_NAME = "test-subname.vet"

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // get access to your named accounts, check hardhat.config.ts on your configuration
    const { deployer } = await hre.getNamedAccounts();

    // registry contrat on TestNet: https://docs.vet.domains/Developers/Contracts/#testnet
    const vns = await hre.ethers.getContractAt("ENS", "0xcBFB30c1F267914816668d53AcBA7bA7c9806D13")
    const domainOwner = await vns.owner(hre.ethers.namehash(DOMAIN_NAME))


    // deploy a contract, it will automatically deploy again when the code changes
    await hre.deployments.deploy('SubdomainClaimer', {
        from: deployer,
        args: [
            "0xcBFB30c1F267914816668d53AcBA7bA7c9806D13", // TestNet Registry from https://docs.vet.domains/Developers/Contracts/
            DOMAIN_NAME, // registered on https://testnet.vet.domains/test-subname.vet
        ]
    })


    // get an ethers instance for interaction with the contract
    const contract = await hre.ethers.getContract('SubdomainClaimer') as SubdomainClaimer;
    const contractAddress = await contract.getAddress()
    if (domainOwner !== contractAddress) {
        console.log(`Owner of ${DOMAIN_NAME} is currently ${domainOwner}`)
        console.log(`Please change "Name Manager" to ${contractAddress} and run script again`)
        return
    }

    // claim name and assign default PublicResolver for configuration management
    // will revert on second call, because its already registered then
    await contract.claim(
        "deployer",
        "0xA6eFd130085a127D090ACb0b100294aD1079EA6f" // TestNet PublicResolver: https://docs.vet.domains/Developers/Contracts/#testnet
    )

    // set reverse pointer, to make it "primary"
    const reverseRegistrar = await hre.ethers.getContractAt("IReverseRegistrar", "0x6878f1aD5e3015310CfE5B38d7B7071C5D8818Ca")
    await reverseRegistrar.setName(["deployer", DOMAIN_NAME].join('.'))

    // debug link
    console.log(`Test Lookup on: https://testnet.vet.domains/lookup/${["deployer", DOMAIN_NAME].join('.')}`)
};

func.id = 'registrar';
func.tags = ['registrar']

export default func;
