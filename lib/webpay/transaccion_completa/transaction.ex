defmodule TransbankSdk.Webpay.TransaccionCompleta do
  # class Transaction < TransbankSdk.Common.BaseTransaction
  @default_environment :integration
  @resources_url TransbankSdk.Common.ApiConstants.webpay_endpoint()
  @create_endpoint @resources_url <> "/transactions/"
  @installments_endpoint @resources_url <> "/transactions/%{token}/installments"
  @commit_endpoint @resources_url <> "/transactions/%{token}"
  @status_endpoint @resources_url <> "/transactions/%{token}"
  @refund_endpoint @resources_url <> "/transactions/%{token}/refunds"
  @capture_endpoint @resources_url <> "/transactions/%{token}/capture"

  def initialize(
        commerce_code = TransbankSdk.Common.IntegrationCommerceCodes.transaccion_completa(),
        api_key = TransbankSdk.Common.IntegrationApiKeys.webpay(),
        environment = DEFAULT_ENVIRONMENT
      ) do
    # super
  end

  def create(buy_order, session_id, amount, cvv, card_number, card_expiration_date) do
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

    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        create_endpoint,
        @commerce_code,
        @api_key
      )

    request_service.post(%{
      buy_order: buy_order,
      session_id: session_id,
      amount: amount,
      cvv: cvv,
      card_number: card_number,
      card_expiration_date: card_expiration_date
    })
  end

  def installments(token, installments_number) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@installments_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.post(%{installments_number: installments_number})
  end

  def commit(token, id_query_installments, deferred_period_index, grace_period) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@commit_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put(%{
      id_query_installments: id_query_installments,
      deferred_period_index: deferred_period_index,
      grace_period: grace_period
    })
  end

  def status(token) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@status_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.get
  end

  def refund(token, amount) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@refund_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    request_service.post(amount: amount)
  end

  def capture(token, buy_order, authorization_code, amount) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
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
