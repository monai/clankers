FNR == 1 && $0 == "---" { frontmatter = 1; print; next }
frontmatter && $0 == "---" { frontmatter = 0 }
frontmatter && /^name:/ { print "name: " name; next }
{ print }
