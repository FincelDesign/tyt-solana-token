use anchor_lang::prelude::*;

declare_id!("5dQ9U4WDVwKr6XU5a2VMdoY1ycSpwVygESQ1E8ZFsTqW");

#[program]
pub mod metadata_pointer {
    use super::*;

    pub fn set_metadata(ctx: Context<SetMetadata>, uri: String) -> Result<()> {
        ctx.accounts.metadata.uri = uri;
        ctx.accounts.metadata.bump = ctx.bumps.metadata;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct SetMetadata<'info> {
    #[account(mut)]
    pub payer: Signer<'info>,

    /// CHECK: Account is safe, used via SPL interface
    pub mint: UncheckedAccount<'info>,

    #[account(
        init_if_needed,
        payer = payer,
        space = 8 + 4 + 200 + 1,
        seeds = [b"metadata", mint.key().as_ref()],
        bump
    )]
    pub metadata: Account<'info, Metadata>,

    pub system_program: Program<'info, System>,
}

#[account]
pub struct Metadata {
    pub uri: String,
    pub bump: u8,
}