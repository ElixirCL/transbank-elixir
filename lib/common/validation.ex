defmodule Transbank.Common.Validation do
  def has_text_with_max_length(value, value_max_length, value_name) do
    if value == "" or is_nil(value) do
      raise Transbank.Shared.TransbankError, "Transbank Error: #{value_name} is empty"
    end

    if value |> String.length() > value_max_length do
      raise Transbank.Shared.TransbankError,
            "#{value_name} is too long, the maximum length is #{value_max_length}"
    end
  end
end
