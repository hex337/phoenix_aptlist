defmodule PhoenixAptlistWeb.UserController do
  use PhoenixAptlistWeb, :controller
  require Logger

  alias PhoenixAptlist.Users
  alias PhoenixAptlist.Users.User

  action_fallback PhoenixAptlistWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def index_from_slack(conn, _params) do
    users = Users.list_users()
    # We want to format this for slack.
    render(conn, "index_for_slack.json", users: users)
  end

  def from_slack(conn, %{"text" => command_params}) do
    param_pieces = String.split(command_params)

    case length(param_pieces) do
      x when x < 2 ->
        conn
        |> send_resp(400, "Invalid params")
      _ ->
        [email | name_pieces] = param_pieces
        name = Enum.join(name_pieces, " ")
        user_params = %{ "email" => email, "name" => name }
        create(conn, %{ "user" => user_params })
    end
  end

  def get_groups(conn, %{}) do
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete_from_slack(conn, %{"text" => id}) do
    user = Users.get_user!(id)
    with {:ok, %User{}} <- Users.delete_user(user) do
      json conn, %{text: "Deleted #{user.name}"}
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def groups(conn, %{"text" => command_params}) do
    min_group_size = 3
    max_group_size = 5
    users = Enum.shuffle(Users.list_users())
    groups = get_groups_from_users(users, min_group_size, max_group_size)

    # Format the groups
    grps = Enum.map(groups, fn(group) -> Enum.map_join(group, ", ", fn(user) -> "#{user.name}" end) end)
    group_str = Enum.join(grps, "\n")

    json conn, %{text: "Groups:\n#{group_str}"}
  end

  # This splits a List of users into groups, prefering minimum size groups.
  def get_groups_from_users(users, min_size, max_size) do
    len = length(users)
    len_mod_min = rem(len, min_size)

    case len do
      # We don't have to split up into groups if we have fewer than 6
      x when x <= max_size -> [users]
      # Handle where we don't have to do anything special since we have the right group sizes
      x when len_mod_min == 0 -> Enum.chunk_every(users, min_size, min_size, [])
      _ ->
        chunks = Enum.chunk_every(users, min_size, min_size, [])
        # Now take the last array and add them to the first, since it'll never be more than
        # 2 people left over
        { leftovers, original_chunks } = List.pop_at(chunks, -1)
        first_plus_leftovers = Enum.concat(Enum.at(original_chunks, 0), leftovers)
        List.replace_at(original_chunks, 0, first_plus_leftovers)
    end
  end
end
