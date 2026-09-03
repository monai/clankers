import net from "node:net";

export function installKeepalivePatch() {
  const originalSetKeepAlive = net.Socket.prototype.setKeepAlive;
  net.Socket.prototype.setKeepAlive = function (..._args: unknown[]) {
    return originalSetKeepAlive.call(this, false);
  };
}
