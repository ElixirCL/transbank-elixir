defmodule TransbankTest do
  use ExUnit.Case
  doctest Transbank

  def setup do
    # @transaction_create_url = "https://webpay3gint.transbank.cl/rswebpaytransaction/api/webpay/v1.2/transactions/"
    # mock_create = '{"token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    #                 "url": "https://webpay3gint.transbank.cl/webpayserver/initTransaction"}'
    # stub_request(:post, @transaction_create_url)
    #     .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
    #     .to_return(status: 200, body: mock_create )

    #
    # @transaction_commit_url = "https://webpay3gint.transbank.cl/rswebpaytransaction/api/webpay/v1.2/transactions/token_test"
    # mock_commit = '{
    #    "vci": "TSY",
    #    "amount": 10000,
    #    "status": "AUTHORIZED",
    #    "buy_order": "ordenCompra12345678",
    #    "session_id": "sesion1234557545",
    #    "card_detail": %{
    #        "card_number": "6623"
    #    },
    #    "accounting_date": "0522",
    #    "transaction_date": "2019-05-22T16:41:21.063Z",
    #    "authorization_code": "1213",
    #    "payment_type_code": "VN",
    #    "response_code": 0,
    #    "installments_number": 0
    #   }'
    # stub_request(:put, @transaction_commit_url)
    #     .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
    #     .to_return(status: 200, body: mock_commit )
    # WebMock.disable_net_connect!
  end

  test "greets the world" do
    assert Transbank.hello() == :world
  end

  test "webpayplus_create_validation_success" do
    transaction =
      Transbank.Webpay.WebpayPlus.Transaction.new(
        Transbank.Common.IntegrationCommerceCodes.webpay_plus(),
        _api_key = Transbank.Common.IntegrationApiKeys.webpay(),
        :integration
      )

    {:ok, response} =
      transaction.__struct__.create(
        transaction,
        "buy_order_test",
        "session_id_test",
        100,
        "http://test.com"
      )

    assert response["token"] |> String.length() == Transbank.Common.ApiConstants.token_length()
  end

  test "webpayplus_create_validation_buy_order_not_ok" do
    buy_order_length = Transbank.Common.ApiConstants.buy_order_length()

    assert_raise Transbank.Shared.TransbankError,
                 "buy_order is too long, the maximum length is #{buy_order_length}",
                 fn ->
                   transaction =
                     Transbank.Webpay.WebpayPlus.Transaction.new(
                       Transbank.Common.IntegrationCommerceCodes.webpay_plus(),
                       _api_key = Transbank.Common.IntegrationApiKeys.webpay(),
                       :integration
                     )

                   Transbank.Webpay.WebpayPlus.Transaction.create(
                     transaction,
                     String.duplicate("A", buy_order_length + 1),
                     "session_id_test",
                     100,
                     "http://test.com"
                   )
                 end
  end

  test "webpayplus_create_validation_session_id_not_ok" do
    session_id_length = Transbank.Common.ApiConstants.session_id_length()

    assert_raise Transbank.Shared.TransbankError,
                 "session_id is too long, the maximum length is #{session_id_length}",
                 fn ->
                   transaction =
                     Transbank.Webpay.WebpayPlus.Transaction.new(
                       Transbank.Common.IntegrationCommerceCodes.webpay_plus(),
                       _api_key = Transbank.Common.IntegrationApiKeys.webpay(),
                       :integration
                     )

                   Transbank.Webpay.WebpayPlus.Transaction.create(
                     transaction,
                     "buy_order_test",
                     String.duplicate("A", session_id_length + 1),
                     100,
                     "http://test.com"
                   )
                 end

    #  error= assert_raises Transbank::Shared::TransbankError do
    #      transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
    #      transaction.create("buy_order_test", "A"*(session_id_length+1), 100, "http://test.com")
    #  end
    #  assert_equal error.message, 'session_id is too long, the maximum length is %d' % Transbank::Common::ApiConstants::SESSION_ID_LENGTH
  end

  test "webpayplus_create_validation_return_url_not_ok" do
    return_url_length = Transbank.Common.ApiConstants.return_url_length()

    assert_raise Transbank.Shared.TransbankError,
                 "return_url is too long, the maximum length is #{return_url_length}",
                 fn ->
                   transaction =
                     Transbank.Webpay.WebpayPlus.Transaction.new(
                       Transbank.Common.IntegrationCommerceCodes.webpay_plus(),
                       _api_key = Transbank.Common.IntegrationApiKeys.webpay(),
                       :integration
                     )

                   Transbank.Webpay.WebpayPlus.Transaction.create(
                     transaction,
                     "buy_order_test",
                     "session_id_test",
                     100,
                     String.duplicate("A", return_url_length + 1)
                   )
                 end

    # error= assert_raises Transbank::Shared::TransbankError do
    #     transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
    #     transaction.create("buy_order_test", "session_id_test", 100, "A"*(return_url_length+1))
    # end
    # assert_equal error.message, 'return_url is too long, the maximum length is %d' % Transbank::Common::ApiConstants::RETURN_URL_LENGTH
  end

  test "webpayplus_create_validation_commit_success" do
    transaction =
      Transbank.Webpay.WebpayPlus.Transaction.new(
        Transbank.Common.IntegrationCommerceCodes.webpay_plus(),
        _api_key = Transbank.Common.IntegrationApiKeys.webpay(),
        :integration
      )

    response = transaction.__struct__.commit(transaction, "token_test")
    assert response["status"] == "AUTHORIZED"
    # response = transaction.commit("token_test")
    # assert_equal response["status"], "AUTHORIZED"
  end

  test "webpayplus_create_validation_commit_token_not_ok" do
    token_length = Transbank.Common.ApiConstants.token_length()

    assert_raise Transbank.Shared.TransbankError,
                 "token is too long, the maximum length is #{token_length}",
                 fn ->
                   transaction =
                     Transbank.Webpay.WebpayPlus.Transaction.new(
                       Transbank.Common.IntegrationCommerceCodes.webpay_plus(),
                       _api_key = Transbank.Common.IntegrationApiKeys.webpay(),
                       :integration
                     )

                   Transbank.Webpay.WebpayPlus.Transaction.commit(
                     transaction,
                     String.duplicate("A", token_length + 1)
                   )
                 end

    # error= assert_raises Transbank::Shared::TransbankError do
    #     transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
    #     transaction.commit("A"*(token_length+1))
    # end
    # assert_equal error.message, 'token is too long, the maximum length is %d' % Transbank::Common::ApiConstants::TOKEN_LENGTH
  end
end
