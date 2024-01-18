local data_util = require("__space-exploration__/data_util")

local default_energy_required = 2

local voids_to_add = {
    "landfill"
}

local crushing_prefix = "kr-vc-"

for recipe_name, recipe_data in pairs(data.raw.recipe) do
    if recipe_data.category == "void-crushing" then
        local name
        if recipe_data.ingredients
            and recipe_data.ingredients[1]
            then
            if recipe_data.ingredients[1].name then
                name = recipe_data.ingredients[1].name
            else
                name = recipe_data.ingredients[1][1]
            end
        end
        log(name)
        -- Changes the recipe back to outputting nothing
        if name then
            log("Attempting to fix void returning")
            log(recipe_name)
            data_util.replace_or_add_result(
                recipe_name,
                "kr-void",
                "kr-void",
                nil,
                nil,
                0,
                0,
                0
            )
            -- Changes the craft time back
            data_util.set_craft_time(recipe_name, recipe_data.energy_required * default_energy_required)
        end
    end
end

-- Since the recipe to void landfill was deleted, it needs to be re-added.
for k, item_name in pairs(voids_to_add) do
    data:extend({
        {
            type = "recipe",
            name = crushing_prefix .. item_name,
            icon = kr_recipes_icons_path .. "trash.png",
            icon_size = 64,
            category = "void-crushing",
            hidden = true,
            hide_from_stats = true,
            energy_required = default_energy_required,
            ingredients = {{item_name, 1}},
            results = {{"kr-void", 0}},
        },
    })
end
