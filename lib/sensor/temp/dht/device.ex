
defmodule Sensor.Temp.Dht.Device do
require Logger
@moduledoc """
This module will read the DHT temp sensor and prcoess
the result into an elixir value

This is implemented with the Adafruit_Python_DHT library and will work for Rpi and Rpi2

Please follow the instructions for the driver installation ( https://github.com/adafruit/Adafruit_Python_DHT )

and then copy the `DHT.py` to the project's bin directory.
The bin directory should be located where the program is started at, which will
be depend on how this app is used. You may need to create this directory for your project.
"""

  @doc ~S"""
  Gets the temperature measurement from the sensor.

  `type` is the DHT sensor type (11|22)
  
  `gpio` is the gpio that should be read

  ## Examples

      iex> Sensor.Temp.Dht.Device.read(11,4) # (Dht_type, gpio)
      {:ok, %{temp: 20.0, humidity: 34.0}}

  """
  def read( type, gpio ) do
    type 
    |> call_sensor( gpio )
    |> parse_result
  end

  def parse_result( result ) do
    # result looks like "Temp=20.0*  Humidity=34.0%\n"
    match = Regex.named_captures( ~r/Temp=(?<temp>.+)\*.+Humidity=(?<humidity>.+)%/, result )

    case match do
      %{ "temp" => t, "humidity" => h } -> 
          { :ok, %{ temp: String.to_float( t ), humidity: String.to_float( h ) } }
      _ -> 
          { :error, result }
    end
  end

  defp call_sensor( type, pin ) do

    #IO.inspect( Mix.env( ) )

    # Should be able to remove this case statement as we use config.ex to inject test_device for non-prod
    args = [ "bin/DHT.py", to_string( type ), to_string( pin ) ]
    result = case Mix.env do
      :test -> result = { "Temp=20.0*C  Humidity=34.0%\n", 0 }
      :prod -> result = System.cmd( "python", args )
      _     -> result = { "Temp=22.2*C  Humidity=33.3%\n", 0 }
    end
    
    case result do
      { txt, 0 } ->
        txt
      { msg, err } when err > 0 ->
        Logger.error "The file 'bin/DHT.py' could not be found in the app's top level directory"
        msg
      _ ->
        "Unexpected result from call_sensor"
    end
  end

  defmodule SensorError do
    defexception message: "Sensor error"
  end
end