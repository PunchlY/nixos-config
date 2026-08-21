#! @bun@/bin/bun
import { $, argv, env, pathToFileURL, which } from "bun";
import { realpath } from "fs/promises";
import { stdout } from "process";

const paths = argv.length < 3
  ? env.PATH?.split(":") ?? []
  : argv.slice(2).map((cmd) => which(cmd));

const derivation = new Map<
  string,
  {
    derivations: Record<string, {
      name: string;
      outputs: {
        out: { path: string };
        bin?: { path: string };
      };
    }>;
  }
>();

for (const path of paths) {
  if (!path) {
    continue;
  }
  try {
    const real = await realpath(path);
    if (!real.startsWith("/nix/store/") || derivation.has(real)) {
      continue;
    }
    derivation.set(real, await $`nix derivation show ${real}`.json());
  } catch {
  }
}

for (
  const { outputs: { bin, out }, name } of derivation
    .values()
    .flatMap(Object.values)
) {
  if (stdout.isTTY) {
    const file = pathToFileURL(`/nix/store/${(bin ?? out).path}`);
    console.log(`\x1b]8;;%s\x07%s\x1b]8;;\x07`, file, name);
  } else {
    console.log(name);
  }
}
