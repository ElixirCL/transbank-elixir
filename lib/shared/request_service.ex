defmodule Transbank.Shared.RequestService do
  @environments %{
    production: "https://webpay3g.transbank.cl/",
    integration: "https://webpay3gint.transbank.cl/"
  }

  def new(environment, endpoint, commerce_code, api_key) do
    commerce_code = commerce_code
    api_key = api_key

    url =
      if is_nil(environment) do
        endpoint
      else
        @environments[environment] <> endpoint
      end

    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, headers(commerce_code, api_key)}
    ]

    Tesla.client(middleware)
  end

  def set_patpass(trx) do
    headers_patpass(trx.commerce_code, trx.api_key)
  end

  def post(client, body) do
    Tesla.post(client, "/", body) |> handle_response
  end

  def put(client, body) do
    Tesla.put(client, "/", body) |> handle_response
  end

  def get(client) do
    Tesla.get(client, "/") |> handle_response
  end

  def delete(client, body) do
    Tesla.delete(client, "/", body) |> handle_response
  end

  def headers(commerce_code, api_key) do
    [
      {"Tbk-Api-Key-Id", commerce_code},
      {"Tbk-Api-Key-Secret", api_key},
      {"Content-Type", "application/json"}
    ]
  end

  def headers_patpass(commerce_code, api_key) do
    [
      {"commercecode", commerce_code},
      {"Authorization", api_key},
      {"Content-Type", "application/json"}
    ]
  end

  defp handle_response({:ok, %{body: %{"error" => error}}}) do
    {:error, error}
  end

  defp handle_response({:ok, %{body: body}}) do
    {:ok, body}
  end
end
