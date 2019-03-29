defmodule TransformableTest do
  use ExUnit.Case

  defmodule Tester do
    defstruct [:id, :location, name: ""]
  end

  describe "#transform/2" do
    test "It transforms against a struct" do
      data = %{"id" => 1, "location" => "Brooklyn"}
      result = Transformable.transform(data, %Tester{})
      assert result == %Tester{id: 1, location: "Brooklyn"}
    end

    test "It transforms against a module with a struct definition" do
      data = %{"id" => 1, "location" => "Brooklyn"}
      result = Transformable.transform(data, Tester)
      assert result == %Tester{id: 1, location: "Brooklyn"}
    end

    test "It transforms against a struct in an options keyword" do
      data = %{"id" => 1, "location" => "Brooklyn"}
      result = Transformable.transform(data, as: %Tester{})
      assert result == %Tester{id: 1, location: "Brooklyn"}
    end

    test "It transforms against a module in an options keyword" do
      data = %{"id" => 1, "location" => "Brooklyn"}
      result = Transformable.transform(data, as: Tester)
      assert result == %Tester{id: 1, location: "Brooklyn"}
    end

    test "It transforms a map with string or atom keys" do
      data = %{"id" => 1, "location" => "Brooklyn", name: "Billy"}
      result = Transformable.transform(data, Tester)
      assert result == %Tester{id: 1, location: "Brooklyn", name: "Billy"}
    end

    test "It transform a keyword" do
      data = [id: 1, location: "Brooklyn"]
      result = Transformable.transform(data, Tester)
      assert result == %Tester{id: 1, location: "Brooklyn"}
    end

    test "It overrides the struct defaults when configured to do so" do
      data = %{"id" => 1, "location" => "Brooklyn"}
      result = Transformable.transform(data, as: Tester, default: false)
      assert result == %Tester{id: 1, location: "Brooklyn", name: false}
    end
  end
end
