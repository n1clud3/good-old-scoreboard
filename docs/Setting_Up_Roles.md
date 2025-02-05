# Setting Up Roles

Setting up roles is a pretty straightforward process.

## Step 1: Create your config script

Create a new lua file in the `lua/autorun/client` directory.
Name it whatever you want, for example, `goscrbrd_server_roles.lua`.

## Step 2: Add a role!

Copy and paste the template below.

```lua
HUDROLES = HUDROLES or {}

-- Put your roles here

-- Example:
HUDROLES:Set("superadmin", Color(255, 0, 0))
```

By using the `HUDROLES:Set` function, you can set up a role and set its color.
In this example, the role `superadmin` is added to a scoreboard,
it's locale key set to `goscrbrd.role.superadmin` and its color is set to red.
