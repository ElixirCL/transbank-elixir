defmodule Transbank.Webpay.WebpayPlus.MallTransaction do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def default_environment, do: :integration
  def resources_url, do: Transbank.Common.ApiConstants.webpay_endpoint()
  def create_endpoint(), do: resources_url() <> "/transactions/"
  def commit_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def status_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def refund_endpoint(token), do: resources_url() <> "/transactions/#{token}/refunds"
  def capture_endpoint(token), do: resources_url() <> "/transactions/#{token}/capture"

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
  end

  def create(trx, buy_order, session_id, return_url, details) do
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
      return_url,
      Transbank.Common.ApiConstants.return_url_length(),
      "return_url"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      create_endpoint,
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{
      buy_order: buy_order,
      session_id: session_id,
      return_url: return_url,
      details: details
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
      status_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put()
  end

  def status(trx, token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      status_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.get()
  end

  def refund(trx, token, buy_order, child_commerce_code, amount) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      buy_order,
      Transbank.Common.ApiConstants.buy_order_length(),
      "buy_order"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      child_commerce_code,
      Transbank.Common.ApiConstants.commerce_code_length(),
      "child_commerce_code"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      refund_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{
      buy_order: buy_order,
      commerce_code: child_commerce_code,
      amount: amount
    })
  end

  def capture(trx, child_commerce_code, token, buy_order, authorization_code, capture_amount) do
    Transbank.Common.Validation.has_text_with_max_length(
      child_commerce_code,
      Transbank.Common.ApiConstants.commerce_code_length(),
      "child_commerce_code"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      buy_order,
      Transbank.Common.ApiConstants.buy_order_length(),
      "buy_order"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      authorization_code,
      Transbank.Common.ApiConstants.authorization_code_length(),
      "authorization_code"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      capture_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{
      commerce_code: child_commerce_code,
      buy_order: buy_order,
      authorization_code: authorization_code,
      capture_amount: capture_amount
    })
  end
end
