import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";

// GitHub Pages friendly: relative base
export default defineConfig({
  plugins: [react()],
  base: "./",
});
