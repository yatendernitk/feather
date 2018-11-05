defmodule Feather.PromoControllerTest do
  use ExUnit.Case

  alias Feather.{
    PromoModel
  }

  test "generate promo code test" do
    params = PromoModel.get_params()
    resp = params |> PromoModel.generate_codes()
    assert {:ok, "all is well, codes generated"} == resp
  end

  test "get codes by limit offset" do
    params = %{
      "limit" => 2,
      "offset" => 5,
      "type" => true
    }

    {:ok, resp} = params |> PromoModel.get_codes()
    item =
      resp
      |> Enum.sort_by(fn x -> x["id"] end)
      |> List.first

    id = item["id"]
    assert 7 == id

    params = %{
      "limit" => 2,
      "offset" => 2,
      "type" => true
    }

    {:ok, resp_2} = params |> PromoModel.get_codes()
    item = resp_2 |> List.first
    id = item["id"]

    assert 4 == id
  end

  test "code details fetch" do
    params = %{
      "limit" => 1,
      "offset" => 0,
      "type" => true
    }

    {:ok, resp} = params |> PromoModel.get_codes()
    item = resp |> List.first
    code = item["code"]

    {:ok, res} = PromoModel.get_code_details(%{"code"=> code})
    fetched_code = res["code"]
    assert code == fetched_code
  end

  test "deactivate code" do
    res = PromoModel.deactivate_code(10)
    assert {:ok, "success"} == res
  end

  test "activate code" do
    res = PromoModel.activate_code(10)
    assert {:ok, "success"} == res
  end

  test "validate code" do
    params_codes = %{
      "limit" => 1,
      "offset" => 0,
      "type" => true
    }

    {:ok, resp} = params_codes |> PromoModel.get_codes()
    item = resp |> List.first
    code = item["code"]

    params = %{
      "code"=> code,
      "radius"=> 50,
      "source"=> %{"lat"=> 27.8974, "long"=> 78.088},
      "destination"=> %{"lat"=> 28.4070, "long"=> 77.8498}
    }
    resp = params |> PromoModel.validate_code
    assert {:ok, "valid code for source & destination"} == resp
  end

end