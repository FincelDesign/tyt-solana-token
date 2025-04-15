use anchor_lang::prelude::*;
use anchor_lang::solana_program::clock::Clock;

declare_id!("CKFNyhEGu7nXXqjNqXwLMAH94TgrAxrPQtuJuSSRdnip");

#[program]
pub mod tyt_transfer_hook {
    use super::*;

    // Explicit initializer for HolderState accounts
    pub fn initialize_holder_state(ctx: Context<InitializeHolderState>) -> Result<()> {
        let holder_state = &mut ctx.accounts.holder_state;
        holder_state.owner = ctx.accounts.owner.key();
        holder_state.balance = 0;
        holder_state.total_token_days = 0;
        holder_state.last_update_timestamp = Clock::get()?.unix_timestamp;
        Ok(())
    }

    // Explicit initializer for YieldPool account
    pub fn initialize_yield_pool(ctx: Context<InitializeYieldPool>) -> Result<()> {
        let yield_pool = &mut ctx.accounts.yield_pool;
        yield_pool.total_yield = 0;
        Ok(())
    }

    pub fn execute(ctx: Context<Execute>, amount: u64) -> Result<()> {
        let clock = Clock::get()?;
        let timestamp = clock.unix_timestamp;

        let source_holder = &mut ctx.accounts.source_holder_state;
        let dest_holder = &mut ctx.accounts.dest_holder_state;
        let yield_pool = &mut ctx.accounts.yield_pool;

        if source_holder.balance > 0 {
            let duration_since_last = (timestamp - source_holder.last_update_timestamp) as u128;
            source_holder.total_token_days += source_holder.balance as u128 * duration_since_last;
        }
        source_holder.balance = source_holder.balance.checked_sub(amount).unwrap();
        source_holder.last_update_timestamp = timestamp;

        let tax_amount = amount.checked_mul(6).unwrap() / 100;
        let transfer_amount = amount.checked_sub(tax_amount).unwrap();

        let yield_contribution = amount.checked_mul(4).unwrap() / 100;
        yield_pool.total_yield = yield_pool.total_yield.checked_add(yield_contribution).unwrap();

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

// Context for explicitly initializing a holder state account
#[derive(Accounts)]
pub struct InitializeHolderState<'info> {
    #[account(init, payer = owner, space = 8 + 32 + 8 + 16 + 8, seeds = [b"holder-state", owner.key().as_ref()], bump)]
    pub holder_state: Account<'info, HolderState>,
    #[account(mut)]
    pub owner: Signer<'info>,
    pub system_program: Program<'info, System>,
}

// Context for explicitly initializing the yield pool
#[derive(Accounts)]
pub struct InitializeYieldPool<'info> {
    #[account(init, payer = payer, space = 8 + 8, seeds = [b"yield-pool"], bump)]
    pub yield_pool: Account<'info, YieldPool>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct Execute<'info> {
    /// CHECK: Provided explicitly by the interface
    #[account(mut)]
    pub source: UncheckedAccount<'info>,
    /// CHECK: Provided explicitly by the interface
    #[account(mut)]
    pub destination: UncheckedAccount<'info>,
    /// CHECK: Provided explicitly by the interface
    pub mint: UncheckedAccount<'info>,
    /// CHECK: Provided explicitly by the interface
    pub authority: UncheckedAccount<'info>,

    #[account(mut, seeds = [b"holder-state", source.key.as_ref()], bump)]
    pub source_holder_state: Account<'info, HolderState>,

    #[account(mut, seeds = [b"holder-state", destination.key.as_ref()], bump)]
    pub dest_holder_state: Account<'info, HolderState>,

    #[account(mut, seeds = [b"yield-pool"], bump)]
    pub yield_pool: Account<'info, YieldPool>,

    pub system_program: Program<'info, System>,
}

// HolderState explicitly defined
#[account]
pub struct HolderState {
    pub owner: Pubkey,
    pub balance: u64,
    pub total_token_days: u128,
    pub last_update_timestamp: i64,
}

// YieldPool explicitly defined
#[account]
pub struct YieldPool {
    pub total_yield: u64,
}
