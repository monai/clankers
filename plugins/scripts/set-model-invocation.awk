FNR == 1 && $0 == "---" { frontmatter = 1; print; next }
frontmatter && /^disable-model-invocation:/ { declared = 1 }
frontmatter && $0 == "---" {
	if (!declared && default_disabled != "") print "disable-model-invocation: " default_disabled
	frontmatter = 0
}
{ print }
