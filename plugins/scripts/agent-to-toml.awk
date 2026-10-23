function quote(s) {
	gsub(/\\/, "\\\\", s)
	gsub(/"/, "\\\"", s)
	return "\"" s "\""
}
BEGIN { while ((getline < models) > 0) map[$1 FS $2] = $3 FS $4 }
FNR == 1 && $0 == "---" { frontmatter = 1; next }
frontmatter && $0 == "---" { frontmatter = 0; next }
frontmatter && /^description:/ { sub(/^description:[ \t]*/, ""); description = $0; next }
frontmatter && /^model:/ { sub(/^model:[ \t]*/, ""); model = $0; next }
frontmatter && /^effort:/ { sub(/^effort:[ \t]*/, ""); effort = $0; next }
frontmatter && /^tools:/ { sub(/^tools:[ \t]*/, ""); tools = $0; next }
frontmatter { next }
index($0, "'''") { print FILENAME ": body contains '''" > "/dev/stderr"; failed = 1; exit 1 }
!started && $0 == "" { next }
{ started = 1; body = body $0 "\n" }
END {
	if (failed) exit 1
	print "name = " quote(name)
	print "description = " quote(description)
	if (model != "") {
		if (!((model FS effort) in map)) { print FILENAME ": no Codex model for " model " " effort > "/dev/stderr"; exit 1 }
		split(map[model FS effort], codex, FS)
		print "model = " quote(codex[1])
		print "model_reasoning_effort = " quote(codex[2])
	}
	if (tools != "" && tools !~ /(Write|Edit|Bash)/) print "sandbox_mode = \"read-only\""
	printf "developer_instructions = '''\n%s'''\n", body
}
