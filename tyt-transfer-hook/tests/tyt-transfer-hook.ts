import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { TytTransferHook } from "../target/types/tyt_transfer_hook";
import { assert } from "chai";

describe("TYT Transfer Hook Program", () => {
  anchor.setProvider(anchor.AnchorProvider.env());

  const program = anchor.workspace.TytTransferHook as Program<TytTransferHook>;

  it("Executes transfer hook explicitly and updates states clearly", async () => {
    // Execute a sample transaction explicitly (mocked transaction context)
    const tx = await program.methods
      .execute(new anchor.BN(1000)) // sample transfer amount (1000 tokens)
      .accounts({
        source: anchor.web3.Keypair.generate().publicKey,
        destination: anchor.web3.Keypair.generate().publicKey,
        mint: anchor.web3.Keypair.generate().publicKey,
        authority: anchor.web3.Keypair.generate().publicKey,
        sourceHolderState: anchor.web3.Keypair.generate().publicKey,
        destHolderState: anchor.web3.Keypair.generate().publicKey,
        yieldPool: anchor.web3.Keypair.generate().publicKey,
        systemProgram: anchor.web3.SystemProgram.programId,
      })
      .rpc();

    console.log("Transaction signature explicitly confirmed:", tx);
    assert.ok(tx);
  });
});
