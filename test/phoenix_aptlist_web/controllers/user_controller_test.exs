defmodule PhoenixAptlistWeb.UserControllerTest do
  use PhoenixAptlistWeb.ConnCase

  alias PhoenixAptlist.Users
  alias PhoenixAptlist.Users.User

  @create_attrs %{email: "some email", name: "some name"}
  @update_attrs %{email: "some updated email", name: "some updated name"}
  @invalid_attrs %{email: nil, name: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "from_slack" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, "/api/slack-users/create", text: "alex@gmail.com alex kleissner"
      assert %{"name" => name, "email" => email} = json_response(conn, 201)["data"]
      assert name == "alex kleissner"
      assert email == "alex@gmail.com"
    end

    test "errors when the params are bad", %{conn: conn} do
      conn = post conn, "/api/slack-users/create", text: "alex@gmail.com"
      assert response(conn, 400)
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => "some email",
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => "some updated email",
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  describe "get_groups_from_users" do
    test "works for an empty users list" do
      min = 3
      max = 5
      users = []

      grps = PhoenixAptlistWeb.UserController.get_groups_from_users(users, min, max)
      assert length(grps) == 1
      assert length(Enum.at(grps, 0)) == 0
    end

    test "gives a single group for fewer than max users" do
      min = 3
      max = 5
      users = [1, 2, 3, 4, 5]

      grps = PhoenixAptlistWeb.UserController.get_groups_from_users(users, min, max)
      assert length(grps) == 1
      assert length(Enum.at(grps, 0)) == 5
    end

    test "divides the users into correctly sized groups" do
      min = 3
      max = 5
      users = [1, 2, 3, 4, 5, 6, 7, 8]

      grps = PhoenixAptlistWeb.UserController.get_groups_from_users(users, min, max)
      assert length(grps) == 2
      assert length(Enum.at(grps, 0)) == 5
      assert length(Enum.at(grps, 1)) == 3
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
