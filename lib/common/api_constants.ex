defmodule Transbank.Common.ApiConstants do
  def webpay_endpoint, do: "rswebpaytransaction/api/webpay/v1.2"
  def oneclick_endpoint, do: "rswebpaytransaction/api/oneclick/v1.2"
  def patpass_endpoint, do: "restpatpass/v1/services"
  def buy_order_length, do: 26
  def session_id_length, do: 61
  def return_url_length, do: 255
  def authorization_code_length, do: 6
  def card_expiration_date_length, do: 5
  def card_number_length, do: 19
  def tbk_user_length, do: 40
  def user_name_length, do: 40
  def commerce_code_length, do: 12
  def token_length, do: 64
  def email_length, do: 100
end
