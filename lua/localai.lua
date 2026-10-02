-- Local AI (Ollama) reachability helper.
--
-- The user starts Ollama manually (no autostart), so it is frequently down. Without
-- this, minuet fires a FIM completion on every keystroke and spams "Request failed
-- with exit code 7" (curl: couldn't connect). This module caches Ollama's
-- reachability in `M.up` via a cheap async probe, so minuet's `enable_predicates`
-- can skip firing while it's down and we surface a single friendly notice instead of
-- the raw curl error. CodeCompanion uses the same probe when its chat opens.

local M = {}

M.url = "http://localhost:11434/api/tags"
M.up = nil -- nil = unknown (stay optimistic until first probe); true/false once known
M._notified = false -- dedupe the "down" notice; re-armed once Ollama is reachable again
M._last_probe = 0

--- Async, non-blocking reachability probe. Updates `M.up`; optional `cb(up)`.
function M.probe(cb)
  vim.system({ "curl", "-s", "-m", "1", "-o", "/dev/null", "-w", "%{http_code}", M.url }, { text = true }, function(res)
    vim.schedule(function()
      local up = res.code == 0 and res.stdout == "200"
      if up then
        M._notified = false -- came back up: allow a fresh notice next time it drops
      end
      M.up = up
      if cb then
        cb(up)
      end
    end)
  end)
end

--- Throttled probe, safe to call from hot paths (e.g. InsertEnter).
function M.refresh()
  local now = vim.uv.now()
  if now - M._last_probe < 5000 then
    return
  end
  M._last_probe = now
  M.probe()
end

--- Friendly, deduped "Ollama is down" notice. `source` labels who triggered it.
function M.notify_down(source)
  if M._notified then
    return
  end
  M._notified = true
  vim.schedule(function()
    vim.notify(
      "󰚩 AI locale (Ollama) non in esecuzione" .. (source and (" — " .. source .. " in pausa") or ""),
      vim.log.levels.WARN,
      { title = "Local AI" }
    )
  end)
end

--- Probe now and warn once if down. Used by CodeCompanion when its chat opens.
function M.check_and_notify(source)
  M.probe(function(up)
    if not up then
      M.notify_down(source)
    end
  end)
end

--- Register the InsertEnter probe once, so minuet's predicate reads a fresh flag.
function M.setup()
  if M._setup then
    return
  end
  M._setup = true
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("localai-probe", { clear = true }),
    desc = "Probe local Ollama reachability (gates minuet completion)",
    callback = function()
      M.refresh()
    end,
  })
end

return M
