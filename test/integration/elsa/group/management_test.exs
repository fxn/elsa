defmodule Elsa.Group.ManagementTest do
  use ExUnit.Case
  use Divo
  import AsyncAssertion

  @brokers Application.get_env(:elsa, :brokers)

  describe "list/1" do
    test "should return all consumer groups" do
      {:ok, pid1} = start_subscriber("group-1a")
      {:ok, pid2} = start_subscriber("group-1b")

      Process.sleep(10_000)

      assert_async fn ->
        assert MapSet.new(["group-1a", "group-1b"]) == MapSet.new(Elsa.Group.list(@brokers))
      end
    end
  end

  describe "describe/2" do
    test "should describe the group" do
      {:ok, pid1} = start_subscriber("group-2")

      Process.sleep(10_000)

      assert_async fn ->
        assert "" == Elsa.Group.describe(@brokers, "group-2")
      end
    end
  end

  defp start_subscriber(group) do
    Elsa.Group.Supervisor.start_link(
      name: String.to_atom(group),
      brokers: @brokers,
      group: group,
      topics: ["elsa-topic"],
      handler: Simple.Handler
    )
  end

end

defmodule Simple.Handler do
  use Elsa.Consumer.MessageHandler

  def handle_messages(messages) do
    IO.inspect(messages, label: "messages")
    :ack
  end
end
