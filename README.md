```
echo "PRIVATE_KEY=0x$(openssl rand -hex 32)" > .env
```

```
yarn install
npx hardhat deploy --network vechain_testnet
```