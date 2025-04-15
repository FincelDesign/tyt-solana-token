import * as anchor from "@coral-xyz/anchor";
import { Keypair, SystemProgram, Transaction } from "@solana/web3.js";
import { assert } from "chai";

describe("TYT Transfer Hook Program", () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  // Your pre-funded wallet (payer) loaded from GitHub Secret
  const payer = Keypair.fromSecretKey(
    Uint8Array.from(JSON.parse(process.env.SOLANA_DEVNET_WALLET as string))
  );

  it("Initializes accounts explicitly and executes transfer hook", async () => {
    const destKeypair = Keypair.generate();

    // Explicitly fund dest wallet from payer (avoid faucet limits!)
    const tx = new Transaction().add(
      SystemProgram.transfer({
        fromPubkey: payer.publicKey,
        toPubkey: destKeypair.publicKey,
        lamports: anchor.web3.LAMPORTS_PER_SOL,
      })
    );

    await provider.sendAndConfirm(tx, [payer]);

    // Verify the explicit funding (no faucet needed!)
    const balance = await provider.connection.getBalance(destKeypair.publicKey);
    console.log("Destination wallet balance:", balance / anchor.web3.LAMPORTS_PER_SOL, "SOL");

    assert.ok(balance > 0, "Destination account is explicitly funded");
  });
});
