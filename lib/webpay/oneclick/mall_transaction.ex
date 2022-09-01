defmodule Transbank.Webpay.Oneclick.MallTransaction do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def default_environment, do: :integration
  def resources_url, do: Transbank.Common.ApiConstants.oneclick_endpoint()
  def authorize_endpoint, do: resources_url() <> "/transactions"
  def status_endpoint(token), do: resources_url() <> "/transactions/#{token}"
  def refund_endpoint(token), do: resources_url() <> "/transactions/#{token}/refunds"
  def capture_endpoint, do: resources_url() <> "/transactions/capture"

  def new(
        # = Transbank.Common.IntegrationCommerceCodes.oneclick_mall(),
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
  end

  def authorize(trx, username, tbk_user, parent_buy_order, details) do
    Transbank.Common.Validation.has_text_with_max_length(
      username,
      Transbank.Common.ApiConstants.user_name_length(),
      "username"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      tbk_user,
      Transbank.Common.ApiConstants.tbk_user_length(),
      "tbk_user"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      parent_buy_order,
      Transbank.Common.ApiConstants.buy_order_length(),
      "parent_buy_order"
    )

    request_service =
      Transbank.Shared.RequestService.new(
        trx.environment,
        authorize_endpoint(),
        trx.commerce_code,
        trx.api_key
      )

    Transbank.Shared.RequestService.post(
      request_service,
      %{
        username: username,
        tbk_user: tbk_user,
        buy_order: parent_buy_order,
        details: details
      }
    )
  end

  def capture(trx, child_commerce_code, child_buy_order, authorization_code, amount) do
    Transbank.Common.Validation.has_text_with_max_length(
      child_commerce_code,
      Transbank.Common.ApiConstants.COMMERCE_CODE_LENGTH,
      "child_commerce_code"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      child_buy_order,
      Transbank.Common.ApiConstants.BUY_ORDER_LENGTH,
      "child_buy_order"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      authorization_code,
      Transbank.Common.ApiConstants.AUTHORIZATION_CODE_LENGTH,
      "authorization_code"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      capture_endpoint(),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{
      commerce_code: child_commerce_code,
      buy_order: child_buy_order,
      authorization_code: authorization_code,
      capture_amount: amount
    })
  end

  def status(trx, buy_order) do
    Transbank.Common.Validation.has_text_with_max_length(
      buy_order,
      Transbank.Common.ApiConstants.BUY_ORDER_LENGTH,
      "buy_order"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      status_endpoint(buy_order),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.get()
  end

  def refund(trx, buy_order, child_commerce_code, child_buy_order, amount) do
    Transbank.Common.Validation.has_text_with_max_length(
      buy_order,
      Transbank.Common.ApiConstants.BUY_ORDER_LENGTH,
      "buy_order"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      child_commerce_code,
      Transbank.Common.ApiConstants.COMMERCE_CODE_LENGTH,
      "child_commerce_code"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      child_buy_order,
      Transbank.Common.ApiConstants.BUY_ORDER_LENGTH,
      "child_buy_order"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      refund_endpoint(buy_order),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(
      detail_buy_order: child_buy_order,
      commerce_code: child_commerce_code,
      amount: amount
    )
  end
end
