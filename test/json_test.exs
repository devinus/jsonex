Code.require_file "../test_helper.exs", __FILE__

defmodule JSONTest do
  use ExUnit.Case

  test "encodes nil to null" do
    assert JSON.encode(nil) == "null"
  end

  test "encodes atoms to strings" do
    assert JSON.encode(:foobar) === "\"foobar\""
  end

  test "encodes 3-tuple date to ISO 8601 date" do
    date = "\"2013-03-15\""
    assert JSON.encode({ 2013, 3, 15 }) == date
  end

  test "encodes 2-tuple datetime to ISO 8601 datetime" do
    datetime = "\"2013-03-15T12:01:00Z\""
    assert JSON.encode({ { 2013, 3, 15 }, { 12, 01, 00 } }) == datetime
  end

  test "raises an EncodeError on bad input" do
    assert_raise JSON.EncodeError, fn ->
      JSON.encode({})
    end
  end

  test "decodes null to nil" do
    assert JSON.decode("null") == nil
  end

  test "decodes ISO 8601 date to 3-tuple date" do
    date = "\"2013-03-15\""
    assert JSON.decode(date) == { 2013, 3, 15 }
  end

  test "decodes ISO 8601 datetime to 2-tuple datetime" do
    datetime = "\"2013-03-15T12:01:00Z\""
    assert JSON.decode(datetime) == { { 2013, 3, 15 }, { 12, 01, 00 } }
  end

  test "decodes a string that looks like an ISO 8601 date into a string" do
    json = %s({"date": "20YY-03-15"})
    assert JSON.decode(json)["date"] == "20YY-03-15"
  end

  test "decodes a string that looks like an ISO 8601 datetime into a string" do
    json = %s({"datetime": "20YY-03-15T00:00:00Z"})
    assert JSON.decode(json)["datetime"] == "20YY-03-15T00:00:00Z"
  end

  test "raises a DecodeError on bad input" do
    assert_raise JSON.DecodeError, fn ->
      JSON.decode("{")
    end
  end
end
