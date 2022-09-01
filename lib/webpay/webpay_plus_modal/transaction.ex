defmodule Transbank.Webpay.WebpayPlusModal do
  # class Transaction < Transbank.Common.BaseTransaction
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def default_environment, do: :integration
  def resources_url, do: Transbank.Common.ApiConstants.webpay_endpoint()
  def create_endpoint(token), do: resources_url <> "/transactions/"
  def commit_endpoint(token), do: resources_url <> "/transactions/#{token}"
  def status_endpoint(token), do: resources_url <> "/transactions/#{token}"
  def refund_endpoint(token), do: resources_url <> "/transactions/#{token}/refunds"

  def new(
        # = Transbank.Common.IntegrationCommerceCodes.webpay_plus_modal(),
        commerce_code,
        # = Transbank.Common.IntegrationApiKeys.webpay(),
        api_key,
        # = @default_environment
        environment
      ) do
    struct(
      __MODULE__,
      Transbank.Common.BaseTransaction.new(
        commerce_code,
        api_key,
        environment
      )
    )

    # super(commerce_code, api_key, environment)
  end

  def create(trx, buy_order, session_id, amount) do
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

    Transbank.Shared.RequestService.new(
      trx.environment,
      CREATE_ENDPOINT,
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{
      buy_order: buy_order,
      session_id: session_id,
      amount: amount
    })
  end

  def commit(trx, token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      commit_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{})
  end

  def status(trx, token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    request_service =
      Transbank.Shared.RequestService.new(
        trx.environment,
        status_endpoint(token),
        trx.commerce_code,
        trx.api_key
      )
      |> Transbank.Shared.RequestService.get()
  end

  def refund(trx, token, amount) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      refund_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{amount: amount})
  end
end
