defmodule Sensor.Temp.Dht.TestDevice do
@moduledoc """
This module will simulate the DHT temp sensor for testing
"""

  @doc ~S"""
  Gets the temperature measurement from the sensor and always returns the same result

  ## Examples

      iex> Sensor.Temp.Dht.TestDevice.read(11, 4)
      {:ok, %{temp: 20.0, humidity: 34.0}}

  """
  def read( _type, _gpio ) do
    { :ok, %{ temp: 20.0, humidity: 34.0 } }
  end

  defmodule SensorError do
    defexception message: "Sensor error"
  end
end