import { installKeepalivePatch } from "./src/keepalive-patch.js";
import { installVllmStallFallback } from "./src/vllm-stall-fallback.js";

installKeepalivePatch();
installVllmStallFallback();

export default function () {}
