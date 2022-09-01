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

  # def client(token) do
  #  middleware = [
  #    {Tesla.Middleware.BaseUrl, "https://api.github.com"},
  #    Tesla.Middleware.JSON,
  #    {Tesla.Middleware.Headers, [{"authorization", "token: " <> token }]}
  #  ]

  #  Tesla.client(middleware)
  # end

  def set_patpass() do
    @headers = headers_patpass(@commerce_code, @api_key)
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

  # def build_http_request(method, body \\ nil) when not in [:put, :post] do
  #  raise TransbankError, "Transbank Error: Incorrect Request type" # unless %w[put post].include?(method.downcase)
  # end
  def build_http_request(method, body \\ nil) do
    # raise TransbankError, "Transbank Error: Incorrect Request type" unless %w[put post].include?(method.downcase)
    # uri, http = build_client
    # http_method = build_method(method, uri, body)

    # response = http.request(http_method)
    # if response.is_a? Net::HTTPSuccess
    #  return nil if response.body.empty?
    #  return JSON.parse(response.body)
    # end
    # body = JSON.parse(response.body)
    # if body.key?("description")
    #  raise TransbankError, "Transbank Error: #{body["code"]} - #{body["description"]}"
    # else
    #  raise TransbankError, "Transbank Error: #{body["error_message"]}"
    # end
  end

  def build_client do
    # uri = URI.parse(@url)
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = uri.scheme == "https"
    # [uri, http]
  end

  def build_method(method, uri, body = nil) do
    # http_method = Object.const_get("Net::HTTP::#{method.capitalize}").new(uri.path, @headers)
    # if !body.nil?
    #  http_method.body = body.to_json
    # end
    # http_method
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
