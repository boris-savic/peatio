# encoding: UTF-8
# frozen_string_literal: true

module WalletService
  class Bitcoind < Base

    def create_address(options = {})
      @client.create_address!(options)
    end

    def collect_deposit!(deposit, options={})
      destination_address = destination_wallet(deposit).address
      pa = deposit.account.payment_address

      client.create_withdrawal!(
          { address: pa.address },
          { address: destination_address },
          deposit.amount,
          options
      )
    end

    def destination_wallet(deposit)
      # TODO: Dynamicly check wallet balance and select where to send funds.
      # For keeping it simple we will collect all funds to hot wallet.
      Wallet
          .active
          .withdraw
          .find_by(blockchain_key: deposit.currency.blockchain_key, kind: :hot)
    end

  end
end