defmodule DruuidTest do
  use ExUnit.Case, async: true
  doctest Druuid

  test "gen should generate a unique id" do
    id = Druuid.gen
    assert(id > 0)
    assert(id != Druuid.gen)
  end

  test "ids generated at the same time should still be unique" do
    timestamp = :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds

    id = Druuid.gen_from_values(0, :random.uniform(), timestamp)
    assert(id > 0)
    assert(id != Druuid.gen_from_values(0, :random.uniform(), timestamp))
  end

  test "ids should be sortable by time generated" do
    timestamp = :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds

    id = Druuid.gen_from_values(0, :random.uniform(), timestamp)
    assert(id > 0)
    assert(id < Druuid.gen_from_values(0, :random.uniform(), timestamp + 1))
  end

  test "convert to/from base 36 strings" do
    timestamp = :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds
    id = Druuid.gen_from_values(0, :random.uniform(), timestamp)

    output =
      id
      |> Druuid.encode
      |> Druuid.decode

    assert id == output
  end

  test "convert a druuid back to datetime" do
    original_dt = {{2016, 5, 27}, {20, 36, 20}}
    offset = Druuid.epoch_offset({{2016,1,1},{0,0,0}})
    druuid = 107164299427954035

    assert Druuid.datetime(druuid, offset) == original_dt
  end
end
