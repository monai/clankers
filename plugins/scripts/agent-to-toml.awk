function quote(s) {
	gsub(/\\/, "\\\\", s)
	gsub(/"/, "\\\"", s)
	return "\"" s "\""
}
FNR == 1 && $0 == "---" { frontmatter = 1; next }
frontmatter && $0 == "---" { frontmatter = 0; next }
frontmatter && /^description:/ { sub(/^description:[ \t]*/, ""); description = $0; next }
frontmatter && /^tools:/ { sub(/^tools:[ \t]*/, ""); tools = $0; next }
frontmatter { next }
index($0, "'''") { print FILENAME ": body contains '''" > "/dev/stderr"; failed = 1; exit 1 }
!started && $0 == "" { next }
{ started = 1; body = body $0 "\n" }
END {
	if (failed) exit 1
	print "name = " quote(name)
	print "description = " quote(description)
	if (tools != "" && tools !~ /(Write|Edit|Bash)/) print "sandbox_mode = \"read-only\""
	printf "developer_instructions = '''\n%s'''\n", body
}
