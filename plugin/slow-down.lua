function now()
    reltime = vim.call("reltime")
    timestamp_str = vim.call("reltimestr", reltime)
    return tonumber(timestamp_str)
end

if not vim.g.niw_slow_down_limit then
  vim.g.niw_slow_down_limit = 5
end

if not keypresses then
    keypresses = {}
end

error_msg_reset = false
function show_presses_per_second()
    presses_per_second = table.getn(keypresses)

    if presses_per_second > vim.g.niw_slow_down_limit then
        vim.o.statusline = "%#ErrorMsg#" .. "slow down" --tostring(presses_per_second)
        error_msg_reset = false
    elseif error_msg_reset == false then
        vim.o.statusline = ""
        error_msg_reset = true
    end
end

function on_key()
    table.insert(keypresses, now())

    for i, timestamp in ipairs(keypresses) do
        if now() - timestamp > 1 then
            table.remove(keypresses, i)
        end
    end

    show_presses_per_second()
end

if not initialised then
    initialised = true
    vim.on_key(on_key)
end
