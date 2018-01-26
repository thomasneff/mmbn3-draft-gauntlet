local deepcopy = require "deepcopy"
local RANDOMIZED_1_STAR_FOLDER = require "start_folders.randomized_1_star"
local RANDOMIZED_2_STAR_FOLDER = require "start_folders.randomized_2_star"
local COMPLETELY_RANDOMIZED_FOLDER = require "start_folders.completely_randomized"


local START_FOLDER_DEFS = {}


local POSSIBLE_FOLDERS = {
    RANDOMIZED_1_STAR_FOLDER,
    RANDOMIZED_2_STAR_FOLDER,
    COMPLETELY_RANDOMIZED_FOLDER
}

function START_FOLDER_DEFS.get_random(code_list)

    return deepcopy(POSSIBLE_FOLDERS[math.random(#POSSIBLE_FOLDERS)].new(code_list))

end


return START_FOLDER_DEFS