require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        EnemyPathfinder = require("eawx-plugins-gamescoring/enemy-pathfinder/EnemyPathfinder")
        return EnemyPathfinder()
    end
}
