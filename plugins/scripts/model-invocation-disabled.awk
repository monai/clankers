FNR == 1 { frontmatter = ($0 == "---"); disabled = default_disabled; next }
frontmatter && /^disable-model-invocation:/ {
	value = $0
	sub(/^disable-model-invocation:[ \t]*/, "", value)
	sub(/[ \t]*(#.*)?$/, "", value)
	disabled = value
}
frontmatter && $0 == "---" {
	if (disabled == "true") print FILENAME
	frontmatter = 0
}
