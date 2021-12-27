return {
    override_enabled = true,
    preset = "DST_CAVE", --options are "DST_CAVE", "DST_CAVE_PLUS"
    overrides = {
        --MISC
        world_size="default", --options are "small", "medium", "default", "huge"
        branching="default", --options are "never", "least", "default", "most"
        loop="default", --options are "never", "default", "always"
        weather="default", --options are "never", "rare", "default", "often", "always"
        earthquakes="default", --options are "never", "rare", "default", "often", "always"
        touchstone="default", --options are "never", "rare", "default", "often", "always"
        regrowth="default", --options are "veryslow", "slow", "default", "fast", "veryfast"
        boons="default", --options are "never", "rare", "default", "often", "always"
        cavelight="default", --options are "veryslow", "slow", "default", "fast", "veryfast"

        disease_delay="default", --options are "none", "random", "long", "default", "short"
        prefabswaps_start="default", --options are "classic", "default", "highly random"
        prefabswaps="default", --options are "default", "none", "few", "normal", "many", "max"

        --RESOURCES --options are "never", "rare", "default", "often", "always"
        grass="default",
        sapling="default",
        marshbush="default",
        reeds="default",
        trees="default",
        flint="default",
        rock="default",
        mushtree="rare",
        fern="default",
        flower_cave="default",
        wormlights="default",

        --UNPREPARED --options are "never", "rare", "default", "often", "always"
        berrybush="default",
        mushroom="default",
        banana="default",
        lichen="default",

        --ANIMALS --options are "never", "rare", "default", "often", "always"
        cave_ponds="default",
        slurper="default",
        bunnymen="default",
        slurtles="default",
        rocky="default",
        monkey="default",

        --MONSTERS --options are "never", "rare", "default", "often", "always"
        cave_spiders="default",
        tentacles="default",
        chess="default",
        liefs="default",
        bats="default",
        fissure="default",
        worms="default"
    }
}
