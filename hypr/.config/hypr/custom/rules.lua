local iotas = "^(org\\.gnome\\.World\\.Iotas)$"

hl.window_rule({ match = { class = iotas }, float = true })
hl.window_rule({ match = { class = iotas }, size = { 900, 700 } })
hl.window_rule({ match = { class = iotas }, move = { "63%", "5%" } })
