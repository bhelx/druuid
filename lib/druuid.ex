defmodule Druuid do
  @moduledoc """
  Druuid is used to generate datetime relative uuids that fit into a
  postgres bigint. It does this by reserving the higher order bits for
  the datetime and the lower order bits for some entropy.

  ## Getting Started

  The primary function is `Druuid.gen/1`. This will return a new uuid
  based on the 1970 UNIX epoch:

  ```elixir
  Druuid.gen()
  #=> 12283551831556210035
  ```

  You may wish to choose an epoch offset to make this number smaller if
  you don't need to worry about dates before a certain point. `Druuid.epoch_offset/1`
  allows you to pass in an erlang datetime tuple as the offset point and `Druuid.gen/1`
  can take this as an optional argument. For example, consider using Jan 1st, 2016 at midnight
  as an anchor point:

  ```elixir
  {{2016,1,1},{0,0,0}}
  |> Druid.epoch_offset
  |> Druuid.gen
  #=> 106596357117955988
  ```

  If you wish to pass this along to other systems (such as using as an id in a RESTful url),
  you might want to consider using the `Druuid.encode/1` and the `Druuid.decode/1` functions.
  `Druuid.encode/1` converts to a base 36 string and `Druuid.decode/1` converts back to an integer.

  ```elixir
  Druuid.gen()
  |> Druuid.encode
  #=> "2lbpkins91z90"
  ```

  Druuid also allows you to extract the datetime back out of the id with the `Druuid.datetime/2` function.
  If the id was generated using an offset, you'll need to provide the offset used as the second argument.
  The result is an erlang datetime tuple.

  ```elixir
  offset = Druuid.epoch_offset({{2016,1,1},{0,0,0}})

  "taqi2f417zk"
  |> Druuid.decode
  |> Druuid.datetime(offset)
  # => {{2016, 5, 27}, {19, 6, 15}}
  ```

  """

  use Bitwise

  unix_epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(unix_epoch)

  @doc """
  Generates a druuid id given an epoch_offset (optional).

  ## Parameters

    - `epoch_offset` (optional) integer value that offsets the 1970 epoch. Defaults to `0`.

  """
  @spec gen(integer) :: integer
  def gen(epoch_offset \\ 0) do
    gen_from_values(epoch_offset, uniform, timestamp)
  end

  @doc """
  Extracts the datetime from the druuid id given an epoch_offset (optional).
  If you used an offset to generate the druuid, you must provide the same offset
  to get the datetime back out.

  ## Parameters

    - `druuid`  integer druuid id
    - `epoch_offset` (optional) integer value that offsets the 1970 epoch. Defaults to `0`.

  ## Examples:

  ```elixir
  iex> offset = Druuid.epoch_offset({{2016,1,1},{0,0,0}})
  iex> Druuid.datetime(107044006789234035, offset)
  {{2016, 5, 27}, {16, 37, 20}}

  ```

  """
  @spec datetime(integer, integer) :: Tuple
  def datetime(druuid, epoch_offset \\ 0) do
    ms = druuid >>> (64 - 41)
    seconds = round(ms / 1.0e+3) + epoch_offset + @epoch
    :calendar.gregorian_seconds_to_datetime(seconds)
  end

  @doc """
  Calculates an epoch offset from the given datetime.

  ## Parameters

    - `offset_datetime` erlang datetime tuple from which to calculate the offset

  ## Examples

  ```elixir
  iex> Druuid.epoch_offset({{2016, 1, 1}, {0, 0, 0}})
  1451606400

  ```
  """
  @spec epoch_offset(Tuple) :: integer
  def epoch_offset(offset_datetime) do
    offset_datetime
    |> :calendar.datetime_to_gregorian_seconds
    |> -(@epoch)
  end

  @doc """
  Determinstically generates the druuid id from the variables given.
  Unless you have a specific reason to override one of these, you probably want to use
  the `Druuid.gen/1` function.

  ## Parameters

    - `epoch_offset` integer value that offsets the 1970 UNIX epoch. Defaults to `0`.
    - `rand` float value representing a random sample b/w 0 and 1 from a uniform distribution.
    - `ts` integer timestamp representing the current time in seconds from the epoch.

  ## Examples

  ```elixir
  iex> Druuid.gen_from_values(0, 0.0, 1)
  8388608000

  ```
  """
  @spec gen_from_values(integer, float, integer) :: integer
  def gen_from_values(epoch_offset, rand, ts) do
    ms = ((ts - epoch_offset) * 1.0e+3) |> round
    rand = rand * 1.0e+16 |> round
    id = ms <<< (64 - 41)
    v = :math.pow(2, (64 - 41)) |> round
    id ||| rem(rand, v)
  end

  @doc """
  Encodes a druuid id as a base 36 string.

  ## Parameters

    - `druuid` integer druuid id

  ## Examples

  ```elixir
  iex> Druuid.encode(12283551831556210035)
  "2lborpt3qr983"

  ```
  """
  @spec encode(integer) :: String.t
  def encode(druuid) do
    druuid
    |> Integer.to_string(36)
    |> String.downcase
  end

  @doc """
  Decodes a base 36 string to a druuid integer.

  ## Parameters

    - `druuid_str` String base 36 representation of the druuid

  ## Examples

  ```elixir
  iex> Druuid.decode("2lborpt3qr983")
  12283551831556210035

  ```
  """
  @spec decode(String.t) :: integer
  def decode(druuid_str) do
    druuid_str
    |> String.to_integer(36)
  end

  # Returns a uniform random number b/w 0.0 and 1.0.
  defp uniform do
    :random.uniform
  end

  # Returns an integer representing the seconds since the UNIX epoch.
  defp timestamp do
    :calendar.universal_time
    |> :calendar.datetime_to_gregorian_seconds
    |> -(@epoch)
  end
end
