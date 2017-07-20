defmodule ClientTest do
  use ExUnit.Case

  test "info" do
    assert {:ok, _} = Docker.Misc.info()
  end

  test "version" do
    assert {:ok, %{"ApiVersion" => _, "Version" => _}} = Docker.Misc.version()
  end

  test "ping" do
    assert {:ok, _} = Docker.Misc.ping()
  end

  # test "get events and stream response" do
  #   {:ok, stream} = Docker.Misc.stream_events()
  #   Enum.map(stream, fn elem -> send(self(), elem)  end)
  #   assert_receive {:event}
  # end
end
