import { ethers } from "ethers";
import fs from "fs-extra";
import path from "path";

async function main() {
  // https://playground.open-rpc.org/?schemaUrl=https://raw.githubusercontent.com/ethereum/execution-apis/assembled-spec/openrpc.json&uiSchema%5BappBar%5D%5Bui:splitView%5D=false&uiSchema%5BappBar%5D%5Bui:input%5D=false&uiSchema%5BappBar%5D%5Bui:examplesDropdown%5D=false
  // rodar ganache cli no wsl
  try {
    const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
    const wallet = new ethers.Wallet(
      "0x2adb19ebcccdad4a17a17ef6ece0a58ad23ce09f614cd60523b6519a186ca325",
      provider
    );

    const abiPath = path.join(
      __dirname,
      "../SimpleStorage_sol_SimpleStorage.abi"
    );
    const binPath = path.join(
      __dirname,
      "../SimpleStorage_sol_SimpleStorage.bin"
    );

    if (!fs.existsSync(abiPath) || !fs.existsSync(binPath)) {
      throw new Error("ABI or Binary file not found");
    }

    const abi = fs.readFileSync(abiPath, "utf8");
    const binary = fs.readFileSync(binPath, "utf8");

    const contractFactory = new ethers.ContractFactory(abi, binary, wallet);

    console.log("Deploying, please await...");
    const contract = await contractFactory.deploy();
    console.log("Deployed at: ", (await contract.getAddress()).toString());
  } catch (error) {
    console.error("Error deploying contract:", error);
    if (error.transaction) {
      console.error("Transaction data:", error.transaction);
    }
  }
}

main();
