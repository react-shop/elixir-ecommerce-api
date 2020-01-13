defmodule EcommerceApiWeb.AuthControllerTest do
  use EcommerceApiWeb.ConnCase

  alias EcommerceApi.Accounts
  alias EcommerceApi.Accounts.User
  alias EcommerceApi.Guardian

  @create_attrs %{
    email: "some@email",
    password: "some password",
    password_confirmation: "some password"
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

  describe "sign_up user" do
    test "renders user when data is valid", %{conn: conn, token: token} do
      request1 = post(conn, Routes.auth_path(conn, :sign_up), @create_attrs)
      assert %{"id" => id} = json_response(request1, 201)["data"]

      request2 = conn
             |> put_req_header("authorization", "bearer: " <> token)
             |> get(Routes.user_path(conn, :show, id))

      assert json_response(request2, 200)["data"] == %{
               "id" => id,
               "email" => @create_attrs.email,
               "status" => "active",
               "role" => "member"
             }
    end

    test "renders error when email is already taken", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :sign_up), @create_attrs)
      conn = post(conn, Routes.auth_path(conn, :sign_up), @create_attrs)
      assert json_response(conn, 422)["errors"] == %{"email" => ["has already been taken"]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :sign_up), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "sign_in user" do
    test "renders user when user credentials are good", %{conn: conn, current_user: current_user} do
      conn =
        post(
          conn,
          Routes.auth_path(conn, :sign_in, %{email: current_user.email, password: @current_user_attrs.password})
        )

      assert json_response(conn, 200)["data"]["id"] == current_user.id
      assert json_response(conn, 200)["data"]["email"] == current_user.email
      assert json_response(conn, 200)["data"]["status"] == current_user.status |> Atom.to_string()
      assert json_response(conn, 200)["data"]["role"] == current_user.role |> Atom.to_string()
      assert {:ok, claims} = Guardian.decode_and_verify(json_response(conn, 200)["data"]["token"])
    end

    test "renders errors when user credentials are bad", %{conn: conn} do
      conn =
        post(conn, Routes.auth_path(conn, :sign_in, %{email: "non-existent email", password: ""}))

      assert json_response(conn, 401)["errors"] == %{"detail" => "Wrong username or password"}
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
