function now()
    reltime = vim.call("reltime")
    timestamp_str = vim.call("reltimestr", reltime)
    return tonumber(timestamp_str)
end

if not keypresses then
    keypresses = {}
end

function show_presses_per_second()
    presses_per_second = table.getn(keypresses)

    if presses_per_second > 5 then
        vim.o.statusline = "%#ErrorMsg#" .. tostring(presses_per_second)
    else
        vim.o.statusline = tostring(presses_per_second)
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
