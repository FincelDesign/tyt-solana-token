import * as anchor from "@coral-xyz/anchor";
import { Program } from "@coral-xyz/anchor";
import { MetadataPointer } from "../target/types/metadata_pointer";
import { PublicKey } from "@solana/web3.js";
import { assert } from "chai";

describe("Metadata Pointer", () => {
  anchor.setProvider(anchor.AnchorProvider.env());
  const program = anchor.workspace.MetadataPointer as Program<MetadataPointer>;
  const payer = anchor.AnchorProvider.env().wallet;

  it("Sets metadata URI quickly", async () => {
    const mint = PublicKey.unique();
    const [metadataPda] = PublicKey.findProgramAddressSync(
      [Buffer.from("metadata"), mint.toBuffer()],
      program.programId
    );

    const uri = "https://timelockyield.io/meta/token.json";

    await program.methods
      .setMetadata(uri)
      .accounts({
        metadata: metadataPda,
        mint,
        payer: payer.publicKey,
        systemProgram: anchor.web3.SystemProgram.programId,
      })
      .rpc();

    // Fetch after initialization
    const metadataAccount = await program.account.metadata.fetch(metadataPda);

    assert.strictEqual(metadataAccount.uri, uri);
    console.log("Metadata set successfully:", metadataAccount.uri);
  });
});
