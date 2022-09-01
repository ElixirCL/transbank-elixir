defmodule Transbank.Common.BaseTransaction do
  defstruct [
    :commerce_code,
    :api_key,
    :environment
  ]

  def new(commerce_code, api_key, environment) do
    case Enum.any?(["production", "integration"], fn s -> s == environment end) do
      true ->
        raise ArgumentError, "Environment must be either 'integration' or 'production'"

      _ ->
        %{
          commerce_code: commerce_code,
          api_key: api_key,
          environment: environment
        }
    end
  end
end
