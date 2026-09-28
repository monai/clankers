FNR == 1 && $0 == "---" { frontmatter = 1; print; next }
frontmatter && $0 == "---" { frontmatter = 0 }
frontmatter && /^disable-model-invocation:/ { next }
{ print }
