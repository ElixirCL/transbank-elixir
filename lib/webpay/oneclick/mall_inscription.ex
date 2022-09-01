defmodule Transbank.Oneclick.MallInscription do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def default_environment(), do: :integration
  def resources_url(), do: Transbank.Common.ApiConstants.oneclick_endpoint()
  def start_endpoint(), do: resources_url() <> "/inscriptions"
  def finish_endpoint(token), do: resources_url() <> "/inscriptions/#{token}"
  def delete_endpoint(), do: resources_url() <> "/inscriptions"

  # Transbank.Common.IntegrationCommerceCodes.oneclick_mall,
  def new(
        commerce_code,
        # Transbank.Common.IntegrationApiKeys.webpay,
        api_key,
        environment \\ default_environment()
      ) do
    struct(__MODULE__, Transbank.Common.BaseTransaction.new(commerce_code, api_key, environment))
  end

  def start(trx, username, email, response_url) do
    Transbank.Common.Validation.has_text_with_max_length(
      username,
      Transbank.Common.ApiConstants.user_name_length(),
      "username"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      email,
      Transbank.Common.ApiConstants.email_length(),
      "email"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      response_url,
      Transbank.Common.ApiConstants.return_url_length(),
      "response_url"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      start_endpoint(),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.post(%{
      username: username,
      email: email,
      response_url: response_url
    })
  end

  def finish(trx, token) do
    Transbank.Common.Validation.has_text_with_max_length(
      token,
      Transbank.Common.ApiConstants.token_length(),
      "token"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      finish_endpoint(token),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.put(%{})
  end

  def delete(trx, tbk_user, username) do
    Transbank.Common.Validation.has_text_with_max_length(
      tbk_user,
      Transbank.Common.ApiConstants.tbk_user_length(),
      "tbk_user"
    )

    Transbank.Common.Validation.has_text_with_max_length(
      username,
      Transbank.Common.ApiConstants.user_name_length(),
      "username"
    )

    Transbank.Shared.RequestService.new(
      trx.environment,
      delete_endpoint(),
      trx.commerce_code,
      trx.api_key
    )
    |> Transbank.Shared.RequestService.delete(%{tbk_user: tbk_user, username: username})
  end
end
