defmodule Transbank.TransaccionCompleta.MallTransaccion do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def default_environment, do: :integration
  def resources_url, do: Transbank.Common.ApiConstants.webpay_endpoint()
  def create_endpoint, do: resources_url() <> "/transactions/"
  def installments_endpoint(token), do: resources_url() <> "/transactions/#{token}/installments"
  def commit_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def status_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def refund_endpoint(token), do: resources_url() <> "/transactions/#{token}/refunds"
  def capture_endpoint(token), do: resources_url() <> "/transactions/#{token}/capture"

  def new(
        # = Transbank.Common.IntegrationCommerceCodes.TRANSACCION_COMPLETA_MALL,
        commerce_code,
        # = Transbank.Common.IntegrationApiKeys.WEBPAY,
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
  end

  def create(trx, buy_order, session_id, card_number, card_expiration_date, details, cvv \\ nil) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      create_endpoint(),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{
      buy_order: buy_order,
      session_id: session_id,
      card_number: card_number,
      card_expiration_date: card_expiration_date,
      details: details,
      cvv: cvv
    })
  end

  def installments(trx, token, details) do
    request_service =
      Transbank.Shared.RequestService.new(
        trx.environment,
        installments_endpoint(token),
        trx.commerce_code,
        trx.api_key
      )

    details
    |> Enum.map(fn detail ->
      request_service
      |> Transbank.Shared.RequestService.post(%{
        commerce_code: detail["commerce_code"],
        buy_order: detail["buy_order"],
        installments_number: detail["installments_number"]
      })
    end)
  end

  def commit(trx, token, details) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      commit_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{details: details})
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

  def refund(trx, token, buy_order, commerce_code_child, amount) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      refund_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(
      buy_order: buy_order,
      commerce_code: commerce_code_child,
      amount: amount
    )
  end

  def capture(trx, token, commerce_code, buy_order, authorization_code, amount) do
    Transbank.Shared.RequestService.new(
      trx.environment,
      capture_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(
      buy_order: buy_order,
      commerce_code: commerce_code,
      authorization_code: authorization_code,
      capture_amount: amount
    )
  end
end
