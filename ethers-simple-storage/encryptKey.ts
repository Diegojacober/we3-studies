import { ethers } from "ethers";
import fs from "fs-extra";
import "dotenv/config";

async function main() {
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!);
  const encryptedJsonKey = wallet.encryptSync(
    process.env.PRIVATE_KEY_PASSWORD,
    process.env.PRIVATE_KEY,
  );
  console.log(encryptedJsonKey);
  fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
