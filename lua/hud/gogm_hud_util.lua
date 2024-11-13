return {
    --- fills left side of a string with given symbol
    -- copied from here: https://github.com/blitmap/lua-snippets/blob/master/string-pad.lua#L12C11-L16C5
    leftpad = function(targetStr, targetLen, char)
        local res = string.rep(char or ' ', targetLen - #targetStr) .. targetStr

        return res, res ~= targetStr
    end
}