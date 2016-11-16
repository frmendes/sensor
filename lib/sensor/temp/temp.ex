defmodule Sensor.Temp do
  @moduledoc """
  This is an abstract temperature sensor module.

  Specific types of temperature sensors can be implemented as sub-modules.
  If the sub-modules implement the defined behaviour, then the business 
  logic in your app doesn't need to care about which instance of temperature
  sensor is being used.
  """
  @callback read( atom ) :: Sensor.Temp.t

  @supervisor SensorSupervisor

  @typedoc """
  This type should be used by all temperature sensors to report their state
  """
  @type t :: %Sensor.Temp{ unit: String.t, value: float, status: atom }
  defstruct unit: "°C",
            value: -99.9,
            status: :init
  
  @doc """
  Will attempt to start the supervised sensor process.  This sensor can
  later be referenced by the `name` parameter.

  ```elixir
  Sensor.Temp.start( Sensor.Temp.Dht, [ 11,4 ], ;temp1 )
  Sensor.Temp.sense( :temp1 )
  ```
  """
  def start( module, params, name ) do
    Supervisor.start_child( @supervisor, build_spec( module, params, name ) ) 
  end

  @doc """
  Generic sense command for any type of sensor that implements the `Sensor.Temp` behaviour

  The `name` paramter should correspond to the name that was defined when that
  sensor was started
  """
  def sense( name ) do
    case retrieve_module( name ) do
      { :error, msg } -> { :error, msg }
      module -> module.read( name )
    end
  end

  defp build_spec( module, params, name ) do
    count = Supervisor.count_children( @supervisor )
    id = to_string( module ) <> "_" <> to_string( count.workers )
    Supervisor.Spec.worker( module, params ++ [ name ], id: id )
  end

  defp retrieve_module( name ) do
    case Process.whereis( name ) do
      nil -> { :error, "This process does not exist" }
      _ ->  { _, _, _, [ list|_ ] } = :sys.get_status( name  )
            [ a | _ ] = list
            { _, { mod, _, _ } } = a 
            mod
    end
  end
end
