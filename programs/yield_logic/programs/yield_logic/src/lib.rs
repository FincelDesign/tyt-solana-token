use anchor_lang::prelude::*;

declare_id!("FHkfuuBw31jJrvQoLgtyPbMiCGpwL3GRQp4HRbwDHHaj");

#[program]
pub mod yield_logic {
    use super::*;

    pub fn initialize_yield_pool(ctx: Context<InitializeYieldPool>) -> Result<()> {
        let yield_pool = &mut ctx.accounts.yield_pool;
        yield_pool.total_yield = 0;
        Ok(())
    }

    pub fn update_yield_pool(ctx: Context<UpdateYieldPool>, yield_amount: u64) -> Result<()> {
        let yield_pool = &mut ctx.accounts.yield_pool;
        yield_pool.total_yield = yield_pool.total_yield.checked_add(yield_amount).unwrap();
        Ok(())
    }
}

#[derive(Accounts)]
pub struct InitializeYieldPool<'info> {
    #[account(init, payer = user, space = 8 + 8, seeds = [b"yield-pool"], bump)]
    pub yield_pool: Account<'info, YieldPool>,
    #[account(mut)]
    pub user: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct UpdateYieldPool<'info> {
    #[account(mut, seeds = [b"yield-pool"], bump)]
    pub yield_pool: Account<'info, YieldPool>,
}

#[account]
pub struct YieldPool {
    pub total_yield: u64,
}
