defmodule TransbankSdk.Webpay.WebpayPlusModal do
  # class Transaction < Transbank.Common.BaseTransaction
  @default_environment :integration
  @resources_url Transbank.Common.ApiConstants.webpay_endpoint()
  @create_endpoint @resources_url <> "/transactions/"
  @commit_endpoint @resources_url <> "/transactions/%{token}"
  @status_endpoint @resources_url <> "/transactions/%{token}"
  @refund_endpoint @resources_url <> "/transactions/%{token}/refunds"

  def initialize(
        commerce_code = Transbank.Common.IntegrationCommerceCodes.webpay_plus_modal(),
        api_key = Transbank.Common.IntegrationApiKeys.webpay(),
        environment = @default_environment
      ) do
    super(commerce_code, api_key, environment)
  end

  def create(buy_order, session_id, amount) do
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

    request_service =
      Transbank.Shared.RequestService.new(
        @environment,
        CREATE_ENDPOINT,
        @commerce_code,
        @api_key
      )

    request_service.post(%{
      buy_order: buy_order,
      session_id: session_id,
      amount: amount
    })
  end

  def commit(token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    request_service =
      Transbank.Shared.RequestService.new(
        @environment,
        format(@commit_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put({})
  end

  def status(token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    request_service =
      Transbank.Shared.RequestService.new(
        @environment,
        format(@status_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.get
  end

  def refund(token, amount) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    request_service =
      Transbank.Shared.RequestService.new(
        @environment,
        format(@refund_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.post(amount: amount)
  end
end
