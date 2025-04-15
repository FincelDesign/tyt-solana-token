import * as anchor from "@coral-xyz/anchor";
import { assert } from "chai";

describe("Yield Logic Tests", () => {
  const provider = anchor.AnchorProvider.env();
  anchor.setProvider(provider);

  const program = anchor.workspace.YieldLogic as anchor.Program;

  const [yieldPoolPda] = anchor.web3.PublicKey.findProgramAddressSync(
    [Buffer.from("yield-pool")],
    program.programId
  );

  it("Initializes yield pool", async () => {
    await program.methods
      .initializeYieldPool()
      .accounts({
        yieldPool: yieldPoolPda,
        user: provider.wallet.publicKey,
        systemProgram: anchor.web3.SystemProgram.programId,
      })
      .rpc();

    const yieldPool = await program.account.yieldPool.fetch(yieldPoolPda);
    assert.strictEqual(yieldPool.totalYield.toNumber(), 0);
  });

  it("Updates yield pool", async () => {
    await program.methods
      .updateYieldPool(new anchor.BN(100))
      .accounts({
        yieldPool: yieldPoolPda,
      })
      .rpc();

    const yieldPool = await program.account.yieldPool.fetch(yieldPoolPda);
    assert.strictEqual(yieldPool.totalYield.toNumber(), 100);
  });
});
