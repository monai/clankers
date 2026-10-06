/^[ \t]+allow_implicit_invocation:/ { sub(/:.*/, ": false"); done = 1 }
{ lines[NR] = $0 }
END {
	for (i = 1; i <= NR; i++) {
		print lines[i]
		if (!done && lines[i] == "policy:") {
			print "  allow_implicit_invocation: false"
			done = 1
		}
	}
	if (!done) {
		print "policy:"
		print "  allow_implicit_invocation: false"
	}
}
