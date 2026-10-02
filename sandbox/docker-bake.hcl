variable "REGISTRY" {
  default = "sandbox"
}

group "default" {
  targets = ["base", "slim", "full"]
}

target "base" {
  context = "."
  target  = "base"
  tags    = ["${REGISTRY}:base"]
}

target "slim" {
  context = "."
  target  = "slim"
  tags    = ["${REGISTRY}:slim"]
}

target "full" {
  context = "."
  target  = "full"
  tags    = ["${REGISTRY}:full", "${REGISTRY}:latest"]
}
