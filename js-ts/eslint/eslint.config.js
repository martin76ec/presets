import globals from "globals";
import pluginJs from "@eslint/js";
import checkFile from "eslint-plugin-check-file";
import tseslint from "typescript-eslint";
import prettier from "stylelint-prettier";
import unusedImports from "eslint-plugin-unused-imports";
import react from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import jsxa11y from "eslint-plugin-jsx-a11y";

const ts_rules = {
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

const tsxRules = {};

const tsPlugins = {
  "check-file": checkFile,
  "unused-imports": unusedImports,
  "prettier": prettier,
};

const tsxPlugins = {
  "jsx-a11y": jsxa11y,
  "react": react,
  "react-hooks": reactHooks,
};

const tsFiles = ["**/*.{js,mjs,cjs,ts}"];
const tsxFiles = ["**/*.{jsx,tsx}"];

const ignores = ["src/tests"];

export default [
  { files: [...tsFiles, ...tsxFiles] },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
  { rules: { ...ts_rules, ...tsxRules }, ignores, plugins: { ...tsPlugins, ...tsxPlugins } },
];
