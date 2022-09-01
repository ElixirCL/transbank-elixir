defmodule Transbank.Webpay.TransaccionCompleta do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  # class Transaction < Transbank.Common.BaseTransaction
  def default_environment, do: :integration
  def resources_url, do: Transbank.Common.ApiConstants.webpay_endpoint()
  def create_endpoint, do: resources_url() <> "/transactions/"
  def installments_endpoint(token), do: resources_url() <> "/transactions/#{token}/installments"
  def commit_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def status_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def refund_endpoint(token), do: resources_url() <> "/transactions/#{token}/refunds"
  def capture_endpoint(token), do: resources_url() <> "/transactions/#{token}/capture"

  def new(
        # = Transbank.Common.IntegrationCommerceCodes.transaccion_completa(),
        commerce_code,
        # = Transbank.Common.IntegrationApiKeys.webpay(),
        api_key,
        environment \\ default_environment()
      ) do
    struct(
      __MODULE__,
      Transbank.Common.BaseTransaction.new(
        commerce_code,
        api_key,
        environment
      )
    )

    # super
  end

  def create(trx, buy_order, session_id, amount, cvv, card_number, card_expiration_date) do
    Transbank.Common.Validation.has_text_with_max_length(
      buy_order,
      Transbank.Common.ApiConstants.buy_order_length(),
      "buy_order"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      session_id,
      Transbank.Common.ApiConstants.session_id_length(),
      "session_id"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      card_number,
      Transbank.Common.ApiConstants.card_number_length(),
      "card_number"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      card_expiration_date,
      Transbank.Common.ApiConstants.card_expiration_date_length(),
      "card_expiration_date"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      create_endpoint(),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{
      buy_order: buy_order,
      session_id: session_id,
      amount: amount,
      cvv: cvv,
      card_number: card_number,
      card_expiration_date: card_expiration_date
    })
  end

  def installments(trx, token, installments_number) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      installments_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{installments_number: installments_number})
  end

  def commit(trx, token, id_query_installments, deferred_period_index, grace_period) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      commit_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{
      id_query_installments: id_query_installments,
      deferred_period_index: deferred_period_index,
      grace_period: grace_period
    })
  end

  def status(trx, token) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      status_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.get()
  end

  def refund(trx, token, amount) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      refund_endpoint(token: token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{amount: amount})
  end

  def capture(trx, token, buy_order, authorization_code, amount) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      capture_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{
      buy_order: buy_order,
      authorization_code: authorization_code,
      capture_amount: amount
    })
  end
end
