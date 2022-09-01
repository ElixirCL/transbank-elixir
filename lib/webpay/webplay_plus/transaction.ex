defmodule Transbank.Webpay.WebpayPlus.Transaction do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def default_environment, do: :integration
  def resources_url, do: Transbank.Common.ApiConstants.webpay_endpoint()
  def create_endpoint, do: resources_url() <> "/transactions/"
  def commit_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def status_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def refund_endpoint(token), do: resources_url() <> "/transactions/#{token}/refunds"
  def capture_endpoint(token), do: resources_url() <> "/transactions/#{token}/capture"

  def new(
        # = Transbank.Common.IntegrationCommerceCodes.webpay_plus,
        commerce_code,
        # = Transbank.Common.IntegrationApiKeys.webpay,
        api_key,
        environment \\ default_environment()
      ) do
    struct(__MODULE__, Transbank.Common.BaseTransaction.new(commerce_code, api_key, environment))
  end

  def create(trx, buy_order, session_id, amount, return_url) do
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

    request_service =
      Transbank.Shared.RequestService.new(
        trx.environment,
        create_endpoint(),
        trx.commerce_code,
        trx.api_key
      )

    Transbank.Shared.RequestService.post(
      request_service,
      %{
        buy_order: buy_order,
        session_id: session_id,
        amount: amount,
        return_url: return_url
      }
    )
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

  def capture(trx, token, buy_order, authorization_code, amount) do
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
    |> Transbank.Shared.RequestService.put(
      buy_order: trx.buy_order,
      authorization_code: authorization_code,
      capture_amount: amount
    )
  end
end
