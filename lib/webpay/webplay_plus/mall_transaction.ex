defmodule TransbankSdk.Webpay.WebpayPlus do
  # class MallTransaction < TransbankSdk.Common.BaseTransaction
  @default_environment :integration
  @resources_url TransbankSdk.Common.ApiConstants.webpay_endpoint()
  @create_endpoint @resources_url + "/transactions/"
  @commit_endpoint @resources_url + "/transactions/%{token}"
  @status_endpoint @resources_url + "/transactions/%{token}"
  @refund_endpoint @resources_url + "/transactions/%{token}/refunds"
  @capture_endpoint @resources_url + "/transactions/%{token}/capture"

  def status(token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@status_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.get
  end

  def refund(token, buy_order, child_commerce_code, amount) do
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

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@refund_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.post(buy_order: buy_order, commerce_code: child_commerce_code, amount: amount)
  end

  def capture(child_commerce_code, token, buy_order, authorization_code, capture_amount) do
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

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(CAPTURE_ENDPOINT, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put(
      commerce_code: child_commerce_code,
      buy_order: buy_order,
      authorization_code: authorization_code,
      capture_amount: capture_amount
    )
  end
end
