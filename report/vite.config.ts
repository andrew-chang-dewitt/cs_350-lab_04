import { resolve } from "path"
import type { UserConfig } from "vite"
// import staticMdPlugin from "vite-plugin-static-md"
import staticMdPlugin from "../../../../../dev/vite-plugin-static-md/src/main"

const HTML_ROOT = resolve(__dirname, "src/pages")
const OUT_DIR = resolve(__dirname, "../dist")
const SRC_ROOT = resolve(__dirname, "src")

const staticMd = staticMdPlugin({
  cssFile: resolve(SRC_ROOT, "styles/index.css"),
})

export default {
  appType: "mpa",
  build: { outDir: OUT_DIR },
  css: { postcss: { map: true } },
  plugins: [staticMd],
  resolve: { alias: { $: SRC_ROOT } },
  root: HTML_ROOT,
} satisfies UserConfig
