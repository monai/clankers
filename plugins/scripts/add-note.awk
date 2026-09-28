FNR == 1 && $0 == "---" { frontmatter = 1; print; next }
frontmatter && $0 == "---" { frontmatter = 0; print; if (note != "") { print ""; print note }; next }
{ print }
