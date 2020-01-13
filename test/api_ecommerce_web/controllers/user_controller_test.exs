defmodule EcommerceApiWeb.UserControllerTest do
  use EcommerceApiWeb.ConnCase

  alias EcommerceApi.Accounts
  alias EcommerceApi.Accounts.User
  alias EcommerceApi.Guardian

  @create_attrs %{
    email: "some@email",
    password: "some password",
    password_confirmation: "some password"
  }
  @update_attrs %{
    email: "some@updated.email",
    password: "some updated password",
    password_confirmation: "some updated password"
  }
  @invalid_attrs %{email: nil, is_active: nil, password: nil}
  @current_user_attrs %{
    email: "some_current@user.email",
    password: "some current user password",
    password_confirmation: "some current user password"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  def fixture(:current_user) do
    {:ok, current_user} = Accounts.create_user(@current_user_attrs)
    current_user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    {:ok, token, _} = Guardian.encode_and_sign(current_user)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user, token: token}
  end

  describe "index" do
    test "lists all users", %{conn: conn, current_user: current_user, token: token} do

      conn = conn
             |> put_req_header("authorization", "bearer: " <> token)
             |> get(Routes.user_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => current_user.id,
                 "email" => current_user.email,
                 "status" => current_user.status |> Atom.to_string(),
                 "role" => current_user.role |> Atom.to_string()
               }
             ]
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user, token: token} do
      request1 = conn
             |> put_req_header("authorization", "bearer: " <> token)
             |> put(Routes.user_path(conn, :update, user), user: @update_attrs)

      assert %{"id" => ^id} = json_response(request1, 200)["data"]

      request2 = conn
             |> put_req_header("authorization", "bearer: " <> token)
             |> get(Routes.user_path(conn, :show, id))

      assert json_response(request2, 200)["data"] == %{
               "id" => id,
               "email" => @update_attrs.email,
               "status" => user.status |> Atom.to_string(),
               "role" => user.role |> Atom.to_string()
             }
    end

    test "renders errors when data is invalid", %{conn: conn, user: user, token: token} do
      conn = conn
             |> put_req_header("authorization", "bearer: " <> token)
             |> put(Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user, token: token} do
      conn = conn
             |> put_req_header("authorization", "bearer: " <> token)
             |> delete(Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)

    {
      :ok,
      conn: conn,
      current_user: current_user
    }
  end
end
