import { ethers } from "ethers";
import fs from "fs-extra";
import path from "path";
import "dotenv/config";

async function main() {
  try {
    const provider = new ethers.JsonRpcProvider(process.env.RPC_URL!);

    const encryptedJson = fs.readFileSync(
      path.join(__dirname, "../.encryptedKey.json"),
      "utf8",
    );
    let wallet = ethers.Wallet.fromEncryptedJsonSync(
      encryptedJson,
      process.env.PRIVATE_KEY_PASSWORD!,
    );
    wallet = wallet.connect(provider);

    const abiPath = path.join(
      __dirname,
      "../SimpleStorage_sol_SimpleStorage.abi",
    );
    const binPath = path.join(
      __dirname,
      "../SimpleStorage_sol_SimpleStorage.bin",
    );

    if (!fs.existsSync(abiPath) || !fs.existsSync(binPath)) {
      throw new Error("ABI or Binary file not found");
    }

    const abi = fs.readFileSync(abiPath, "utf8");
    const binary = fs.readFileSync(binPath, "utf8");

    const contractFactory = new ethers.ContractFactory(abi, binary, wallet);

    console.log("Deploying, please await...");
    const contract = await contractFactory.deploy();
    await contract.deploymentTransaction().wait(1);
    console.log("Deployed at: ", (await contract.getAddress()).toString());

    // Log ABI to ensure it's correct
    // console.log("ABI: ", abi);

    // Verificar se a função retrieve está definida no contrato
    if (!contract.retrieve) {
      throw new Error("Função retrieve não encontrada no contrato");
    }

    // Testar a chamada da função retrieve
    try {
      const currentFavoriteNumber = await contract.retrieve();
      console.log(
        `Current Favorite Number: ${currentFavoriteNumber.toString()}`,
      );
    } catch (retrieveError) {
      console.error("Erro ao chamar retrieve: ", retrieveError);
    }

    const transactionResponse = await contract.store("7");
    const transactionReceipt = await transactionResponse.wait(1);
    const updatedFavoriteNumber = await contract.retrieve();
    console.log(`Current Favorite Number: ${updatedFavoriteNumber.toString()}`);
  } catch (error) {
    console.error("Error deploying contract:", error);
    if (error.transaction) {
      console.error("Transaction data:", error.transaction);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
