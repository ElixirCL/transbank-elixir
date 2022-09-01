defmodule TransbankSdk.TransaccionCompleta.MallTransaccion do
  # class MallTransaction < .TransbankSdk.Common.BaseTransaction
  @default_environment :integration
  @resources_url Transbank.Common.ApiConstants.webpay_endpoint()
  @create_endpoint @resources_url <> "/transactions/"
  @installments_endpoint @resources_url <> "/transactions/#{token}/installments"
  @commit_endpoint @resources_url <> "/transactions/#{token}"
  @status_endpoint @resources_url <> "/transactions/#{token}"
  @refund_endpoint @resources_url <> "/transactions/#{token}/refunds"
  @capture_endpoint @resources_url <> "/transactions/#{token}/capture"

  def initialize(
        commerce_code = TransbankSdk.Common.IntegrationCommerceCodes.TRANSACCION_COMPLETA_MALL,
        api_key = TransbankSdk.Common.IntegrationApiKeys.WEBPAY,
        environment = @default_environment
      ) do
    super(commerce_code, api_key, environment)
  end

  def create(buy_order, session_id, card_number, card_expiration_date, details, cvv \\ nil) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        CREATE_ENDPOINT,
        @commerce_code,
        @api_key
      )

    request_service.post(%{
      buy_order: buy_order,
      session_id: session_id,
      card_number: card_number,
      card_expiration_date: card_expiration_date,
      details: details,
      cvv: cvv
    })
  end

  def installments(token, details) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(@installments_endpoint, token: token),
        @commerce_code,
        @api_key
      )

    # details.map {
    #  |detail|
    #  request_service.post({commerce_code: detail['commerce_code'], buy_order: detail['buy_order'], installments_number: detail['installments_number']})
    # }
  end

  def commit(token, details) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(COMMIT_ENDPOINT, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put(%{details: details})
  end

  def status(token) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(STATUS_ENDPOINT, token: token),
        @commerce_code,
        @api_key
      )

    request_service.get
  end

  def refund(token, buy_order, commerce_code_child, amount) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(REFUND_ENDPOINT, token: token),
        @commerce_code,
        @api_key
      )

    request_service.post(buy_order: buy_order, commerce_code: commerce_code_child, amount: amount)
  end

  def capture(token, commerce_code, buy_order, authorization_code, amount) do
    request_service =
      TransbankSdk.Shared.RequestService.new(
        @environment,
        format(CAPTURE_ENDPOINT, token: token),
        @commerce_code,
        @api_key
      )

    request_service.put(
      buy_order: buy_order,
      commerce_code: commerce_code,
      authorization_code: authorization_code,
      capture_amount: amount
    )
  end
end
