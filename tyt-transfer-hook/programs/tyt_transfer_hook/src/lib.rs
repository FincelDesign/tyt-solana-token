use anchor_lang::prelude::*;
use anchor_lang::solana_program::clock::Clock;
use spl_transfer_hook_interface::instruction::ExecuteInstruction;

declare_id!("CKFNyhEGu7nXXqjNqXwLMAH94TgrAxrPQtuJuSSRdnip");

#[program]
pub mod tyt_transfer_hook {
    use super::*;

    pub fn execute(ctx: Context<Execute>, amount: u64) -> Result<()> {
        let clock = Clock::get()?;
        let timestamp = clock.unix_timestamp;

        let source_holder = &mut ctx.accounts.source_holder_state;
        let dest_holder = &mut ctx.accounts.dest_holder_state;
        let yield_pool = &mut ctx.accounts.yield_pool;

        // Update source holder duration explicitly
        if source_holder.balance > 0 {
            let duration_since_last = (timestamp - source_holder.last_update_timestamp) as u128;
            source_holder.total_token_days += source_holder.balance as u128 * duration_since_last;
        }
        source_holder.balance = source_holder.balance.checked_sub(amount).unwrap();
        source_holder.last_update_timestamp = timestamp;

        // Calculate tax explicitly (6% total)
        let tax_amount = amount.checked_mul(6).unwrap() / 100;
        let transfer_amount = amount.checked_sub(tax_amount).unwrap();

        // Update yield pool explicitly (4% out of the 6% tax)
        let yield_contribution = amount.checked_mul(4).unwrap() / 100;
        yield_pool.total_yield = yield_pool.total_yield.checked_add(yield_contribution).unwrap();

        // Update destination holder explicitly
        if dest_holder.balance > 0 {
            let duration_since_last = (timestamp - dest_holder.last_update_timestamp) as u128;
            dest_holder.total_token_days += dest_holder.balance as u128 * duration_since_last;
        }
        dest_holder.balance = dest_holder.balance.checked_add(transfer_amount).unwrap();
        dest_holder.last_update_timestamp = timestamp;

        msg!("Transfer hook executed explicitly. Taxes applied clearly.");
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Execute<'info> {
    /// CHECK: Provided explicitly by the interface
    #[account(mut)]
    pub source: UncheckedAccount<'info>,

    /// CHECK: Destination account explicitly provided by the transfer hook interface
    #[account(mut)]
    pub destination: UncheckedAccount<'info>,

    /// CHECK: Token mint explicitly provided by the transfer hook interface
    pub mint: UncheckedAccount<'info>,

    /// CHECK: Authority explicitly provided by the transfer hook interface
    pub authority: UncheckedAccount<'info>,

    #[account(mut, seeds = [b"holder-state", source.key.as_ref()], bump)]
    pub source_holder_state: Account<'info, HolderState>,

    #[account(mut, seeds = [b"holder-state", destination.key.as_ref()], bump)]
    pub dest_holder_state: Account<'info, HolderState>,

    #[account(mut, seeds = [b"yield-pool"], bump)]
    pub yield_pool: Account<'info, YieldPool>,

    pub system_program: Program<'info, System>,
}


// Explicit states
#[account]
pub struct HolderState {
    pub owner: Pubkey,
    pub balance: u64,
    pub total_token_days: u128,
    pub last_update_timestamp: i64,
}

#[account]
pub struct YieldPool {
    pub total_yield: u64,
}
