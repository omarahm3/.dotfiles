local present, which_key = pcall(require, 'which-key')

if not present then
  return
end

local default = {

}

which_key.setup(default)
