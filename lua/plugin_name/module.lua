---@class CustomModule
local M = {}

local function escape_string(str)
    local mappings = {
        ["'"] = "'\\''",  -- Single quotes
        ['"'] = '\\"',   -- Double quotes
--        ["\\"] = "\\\\", -- Backslash
--        ["$"] = "\\$",   -- Dollar sign
--        ["`"] = "\\`",   -- Backtick
--        ["!"] = "\\!",   -- Exclamation mark
--        ["%"] = "%%",    -- Percentage sign (for cmd)
--        ["&"] = "\\&",   -- Ampersand
--        ["|"] = "\\|",   -- Pipe
--        ["*"] = "\\*",   -- Asterisk
--        ["?"] = "\\?",   -- Question mark
--        [";"] = "\\;",   -- Semicolon
--        ["<"] = "\\<",   -- Less than
--        [">"] = "\\>",   -- Greater than
--        ["("] = "\\(",   -- Open parenthesis
--        [")"] = "\\)",   -- Close parenthesis
--        ["{"] = "\\{",   -- Open brace
--        ["}"] = "\\}",   -- Close brace
--        ["["] = "\\[",   -- Open bracket
--        ["]"] = "\\]",   -- Close bracket
    }

		for k, v in pairs(mappings) do
        str = str:gsub(k, v)
    end

    return str
end

M.my_first_function = function()
    -- Capture the visual selection...
    local start_line, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
    local end_line, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col+1, end_col)
    else
        lines[1] = string.sub(lines[1], start_col+1)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    local selection = table.concat(lines, "\n")

    -- Fetch the link using the visual selection
		local play_command = string.format([[ 
		curl https://api.openai.com/v1/audio/speech \
				-H "Authorization: Bearer %s" \
				-H "Content-Type: application/json" \
				-d '{
								"model": "tts-1",
								"input": "%s",
								"voice": "echo"
				    }' \ 
    | play -t mp3 -
    ]], os.getenv("OPENAI_API_KEY"), escape_string(selection))

    -- Stream and play the audio directly from the URL
    vim.fn.system(play_command)
end
return M
