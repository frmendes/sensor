defmodule Sensor.Temp.Dht.DeviceTest do
  use ExUnit.Case
  doctest Sensor

  alias Sensor.Temp.Dht.Device

  setup do
    {type, gpio, name} = {11, 4, :temp1}
    {:ok, type: type, gpio: gpio, name: name}
  end
  
  describe "Sensor.Temp.Dht.Device" do
    test "can parse the sensor response" do
      response = "Temp=26.1*  Humidity=41.0%\n"
      assert { :ok, data } = Device.parse_result( response )
      assert data.temp == 26.1
      assert data.humidity ==41.0
    end

  end

end