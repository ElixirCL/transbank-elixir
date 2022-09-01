defmodule TransbankSdk.Webpay.Oneclick.MallTransaction do
  # class MallTransaction < .TransbankSdk.Common.BaseTransaction
  @default_environment :integration
  @resources_url TransbankSdk.Common.ApiConstants.ONECLICK_ENDPOINT
  @authorize_endpoint @resources_url <> "/transactions"
  @status_endpoint @resources_url <> "/transactions/%{token}"
  @refund_endpoint @resources_url <> "/transactions/%{token}/refunds"
  @capture_endpoint @resources_url <> "/transactions/capture"

  def initialize(
        commerce_code = TransbankSdk.Common.IntegrationCommerceCodes.oneclick_mall(),
        api_key = TransbankSdk.Common.IntegrationApiKeys.webpay(),
        environment = DEFAULT_ENVIRONMENT
      ) do
    super(commerce_code, api_key, environment)
  end

  def authorize(username, tbk_user, parent_buy_order, details) do
    TransbankSdk.Common.Validation.has_text_with_max_length(
      username,
      TransbankSdk.Common.ApiConstants.user_name_length(),
      "username"
    )

    TransbankSdk.Common.Validation.has_text_with_max_length(
      tbk_user,
      TransbankSdk.Common.ApiConstants.tbk_user_length(),
      "tbk_user"
    )

    TransbankSdk.Common.Validation.has_text_with_max_length(
      parent_buy_order,
      TransbankSdk.Common.ApiConstants.buy_order_length(),
      "parent_buy_order"
    )

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        @authorize_endpoint,
        @commerce_code,
        @api_key
      )

    request_service.post(%{
      username: username,
      tbk_user: tbk_user,
      buy_order: parent_buy_order,
      details: details
    })
  end

  def capture(child_commerce_code, child_buy_order, authorization_code, amount) do
    TransbankSdk.Common.Validation.has_text_with_max_length(
      child_commerce_code,
      TransbankSdk.Common.ApiConstants.COMMERCE_CODE_LENGTH,
      "child_commerce_code"
    )

    TransbankSdk.Common.Validation.has_text_with_max_length(
      child_buy_order,
      TransbankSdk.Common.ApiConstants.BUY_ORDER_LENGTH,
      "child_buy_order"
    )

    TransbankSdk.Common.Validation.has_text_with_max_length(
      authorization_code,
      TransbankSdk.Common.ApiConstants.AUTHORIZATION_CODE_LENGTH,
      "authorization_code"
    )

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        @capture_endpoint,
        @commerce_code,
        @api_key
      )

    request_service.put(
      commerce_code: child_commerce_code,
      buy_order: child_buy_order,
      authorization_code: authorization_code,
      capture_amount: amount
    )
  end

  def status(buy_order) do
    TransbankSdk.Common.Validation.has_text_with_max_length(
      buy_order,
      TransbankSdk.Common.ApiConstants.BUY_ORDER_LENGTH,
      "buy_order"
    )

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@status_endpoint, token: buy_order),
        @commerce_code,
        @api_key
      )

    request_service.get
  end

  def refund(buy_order, child_commerce_code, child_buy_order, amount) do
    TransbankSdk.Common.Validation.has_text_with_max_length(
      buy_order,
      TransbankSdk.Common.ApiConstants.BUY_ORDER_LENGTH,
      "buy_order"
    )

    TransbankSdk.Common.Validation.has_text_with_max_length(
      child_commerce_code,
      TransbankSdk.Common.ApiConstants.COMMERCE_CODE_LENGTH,
      "child_commerce_code"
    )

    TransbankSdk.Common.Validation.has_text_with_max_length(
      child_buy_order,
      TransbankSdk.Common.ApiConstants.BUY_ORDER_LENGTH,
      "child_buy_order"
    )

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(REFUND_ENDPOINT, token: buy_order),
        @commerce_code,
        @api_key
      )

    request_service.post(
      detail_buy_order: child_buy_order,
      commerce_code: child_commerce_code,
      amount: amount
    )
  end
end
