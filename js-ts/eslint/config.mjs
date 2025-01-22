import globals from "globals";
import pluginJs from "@eslint/js";
import checkFile from "eslint-plugin-check-file";
import tseslint from "typescript-eslint";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";
import unusedImports from "eslint-plugin-unused-imports";

const rules = {
  camelcase: ["error", { properties: "never" }],
  "new-cap": ["error", { newIsCap: true, capIsNew: false }],
  //"class-methods-use-this": "error",
  "check-file/filename-naming-convention": [
    "error",
    {
      "**/src": "KEBAB_CASE",
    },
  ],
  semi: ["error", "always"],
  quotes: ["error", "double", { avoidEscape: true }],
  "no-console": ["error"],
  "@typescript-eslint/no-explicit-any": "off",
  "unused-imports/no-unused-imports": "error",
  "unused-imports/no-unused-vars": [
    "error",
    {
      vars: "all",
      varsIgnorePattern: "^_",
      args: "all",
      argsIgnorePattern: "^_",
    },
  ],
};

const plugins = {
  "check-file": checkFile,
  "unused-imports": unusedImports,
};

const ignores = ["src/tests"];

export default [
  eslintPluginPrettierRecommended,
  { files: ["**/*.{js,mjs,cjs,ts}"] },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
  { rules, ignores, plugins },
];
