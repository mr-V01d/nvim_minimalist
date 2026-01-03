if vim.env.NVIM then
  local args = vim.fn.argv()

  local ok, chan = pcall(vim.fn.sockconnect, 'pipe', vim.env.NVIM, { rpc = true })
  
  if ok and chan then
    if #args == 0 then
        vim.rpcrequest(chan, "nvim_command", "new")
    else
      for _, file in ipairs(args) do
        local abs_path = vim.fn.fnamemodify(file, ':p')
    
        vim.rpcrequest(chan, "nvim_exec_lua", [[
          local path = ...
          local bufnr = vim.fn.bufnr(path)
          if vim.api.nvim_win_get_width(0) > 2 * 80 then
            vim.cmd('vsplit') 
          else
            vim.cmd('split')
          end
          vim.cmd('drop ' .. vim.fn.fnameescape(path))
        ]], {abs_path})
      end
    end
  end
  os.exit(0)
end
