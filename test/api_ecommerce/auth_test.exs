defmodule ApiEcommerce.AuthTest do
  use ApiEcommerce.DataCase

  alias ApiEcommerce.Auth

  describe "users" do
    alias ApiEcommerce.Auth.User

    @valid_attrs %{
      email: "some@email",
      is_active: true,
      password: "some password",
      password_confirmation: "some password"
    }
    @update_attrs %{
      email: "some@updated.email",
      is_active: false,
      password: "some updated password",
      password_confirmation: "some updated password"
    }
    @invalid_attrs %{email: nil, is_active: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.is_active == @valid_attrs.is_active
      assert Bcrypt.verify_pass(@valid_attrs.password, user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == @update_attrs.email
      assert user.is_active == @update_attrs.is_active
      assert Bcrypt.verify_pass(@update_attrs.password, user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
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
      assert {:ok, authenticated_user} = Auth.authenticate_user(user.email, @valid_attrs.password)
      assert %{user | password: nil} == authenticated_user
    end
  end
end
