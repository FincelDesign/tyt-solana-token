use anchor_lang::prelude::*;

declare_id!("C3Hj4rA8FXPBVP8kfNKujEXJiFsHZgaFGhaEo6iVSWw8");

#[program]
pub mod tyt_transfer_hook {
    use super::*;

    pub fn execute(_ctx: Context<Execute>, _amount: u64) -> Result<()> {
        msg!("Transfer Hook triggered!");
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Execute<'info> {
    /// CHECK: Safe as account validation handled externally
    #[account()]
    pub source: UncheckedAccount<'info>,
    /// CHECK: Safe as account validation handled externally
    #[account()]
    pub mint: UncheckedAccount<'info>,
    /// CHECK: Safe as account validation handled externally
    #[account()]
    pub destination: UncheckedAccount<'info>,
    /// CHECK: Safe as account validation handled externally
    #[account()]
    pub authority: UncheckedAccount<'info>,
}
