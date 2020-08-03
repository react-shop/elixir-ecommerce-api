defmodule ApiEcommerce.AuthTest do
  use ApiEcommerce.DataCase

  alias ApiEcommerce.Auth

  describe "users" do
    alias ApiEcommerce.Auth.User

    @valid_attrs %{
      name: "some name",
      email: "some@email",
      status: :active,
      role: :member,
      password: "some password",
      password_confirmation: "some password"
    }
    @update_attrs %{
      name: "some updated name",
      email: "some@updated.email",
      status: :deleted,
      role: :admin,
      password: "some updated password",
      password_confirmation: "some updated password"
    }
    @invalid_attrs %{email: nil, status: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() |> Enum.map(fn x -> x.email end) |> to_string =~ user.email
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id).id == user.id
      assert Auth.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.name == @valid_attrs.name
      assert user.email == @valid_attrs.email
      assert user.status == @valid_attrs.status
      assert user.role == @valid_attrs.role
      assert Bcrypt.verify_pass(@valid_attrs.password, user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.name == @update_attrs.name
      assert user.email == @update_attrs.email
      assert user.status == @update_attrs.status
      assert user.role == @update_attrs.role
      assert Bcrypt.verify_pass(@update_attrs.password, user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      user1 = Auth.get_user!(user.id)
      assert user.email == user1.email
      assert user.status == user1.status
      assert Bcrypt.verify_pass(@valid_attrs.password, user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    test "authenticate_user/2 authenticates the user" do
      user = user_fixture()
      assert {:error, "Wrong username or password"} = Auth.authenticate_user("wrong email", "")

      assert {:ok, authenticated_user, token} =
               Auth.authenticate_user(user.email, @valid_attrs.password)

      assert %{user | password: nil, password_confirmation: nil} == authenticated_user
    end
  end
end
