require('avante').setup({
  --provider = "gemini_exp",
  --vendors = {
  --["gemini_exp"] = {
  --endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
  --model = "gemini-experimental",
  --timeout = 20000, -- Timeout in milliseconds (20 seconds)
  --temperature = 0,
  --max_tokens = 8192,
  --["local"] = false,
  --},
  --engi_local = {
  --endpoint = "http://127.0.0.1:3000",
  --model = "code-gemma",
  --temperature = 0,
  --max_tokens = 4096,
  --["local"] = true,
  --},
  --}
})
