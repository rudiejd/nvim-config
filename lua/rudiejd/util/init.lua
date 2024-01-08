local util = {}

util.find_endpoint_dlls = function()
  local res = {}
  for _, v in pairs(vim.fn.split(vim.fn.globpath(".", "**"), "\n")) do
    if string.match(v, ".*End[pP]oint%.dll$") ~= nil then
      table.insert(res, 1, v)
    end
  end
  return res
end

return util

