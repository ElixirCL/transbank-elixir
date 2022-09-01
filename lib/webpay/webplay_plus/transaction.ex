defmodule TransbankSdk.Webpay.WebpayPlus do
  # class Transaction < Transbank.Common.BaseTransaction
  @default_environment :integration
  @resources_url Transbank.Common.ApiConstants.webpay_endpoint()
  @create_endpoint @resources_url + "/transactions/"
  @commit_endpoint @resources_url + "/transactions/%{token}"
  @status_endpoint @resources_url + "/transactions/%{token}"
  @refund_endpoint @resources_url + "/transactions/%{token}/refunds"
  @capture_endpoint @resources_url + "/transactions/%{token}/capture"

  def initialize(
        # commerce_code = Transbank.Common.IntegrationCommerceCodes.webpay_plus,
        # api_key = Transbank.Common.IntegrationApiKeys.webpay,
        # environment = @default_environment
      ) do
    # super(commerce_code, api_key, environment)
  end

  def create(buy_order, session_id, amount, return_url) do
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
        @environment,
        @create_endpoint,
        @commerce_code,
        @api_key
      )

    request_service.post(%{
      buy_order: buy_order,
      session_id: session_id,
      amount: amount,
      return_url: return_url
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
        format(COMMIT_ENDPOINT, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put(%{})
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

  def capture(token, buy_order, authorization_code, amount) do
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

    request_service =
      Transbank.Shared.RequestService.new(
        @environment,
        format(@capture_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put(
      buy_order: buy_order,
      authorization_code: authorization_code,
      capture_amount: amount
    )
  end
end
