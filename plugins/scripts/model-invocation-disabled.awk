FNR == 1 { frontmatter = ($0 == "---"); next }
frontmatter && $0 == "---" { frontmatter = 0 }
frontmatter && /^disable-model-invocation:[ \t]*true[ \t]*$/ { print FILENAME; frontmatter = 0 }
