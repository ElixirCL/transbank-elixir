defmodule Transbank.Common.BaseTransaction do

  defstruct [:commerce_code, :api_key, :environment ]

  def new(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,
  api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY,
  environment = DEFAULT_ENVIRONMENT)

  case Enum.any?(environment, ["production", "integration"]) do
    true -> raise ArgumentError, "Environment must be either 'integration' or 'production'"
    _ ->
      %__MODULE__{
        commerce_code: commerce_code,
        api_key: api_key,
        environment: environment
      }
  end
end
