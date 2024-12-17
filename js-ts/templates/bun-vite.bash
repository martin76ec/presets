#!/bin/bash

# Define your dependencies
dev_dependencies=(
    "@dword-design/eslint-plugin-import-alias@^5.0.0"
    "@eslint/js@^9.7.0"
    "@typescript-eslint/eslint-plugin@6.4.1"
    "eslint@8.48.0"
    "eslint-config-prettier@9.0.0"
    "eslint-plugin-check-file@^2.8.0"
    "eslint-plugin-import@^2.29.1"
    "eslint-plugin-paths@^1.0.8"
    "eslint-plugin-prettier@5.0.0"
    "eslint-plugin-simple-import-sort@^12.1.1"
    "eslint-plugin-typescript-paths@^0.0.33"
    "eslint-import-resolver-typescript@^3.6.1"
    "eslint-plugin-unused-imports@3.0.0"
    "prettier@3.0.3"
    "tsc-alias@^1.8.10"
    "tailwindcss@latest"
    "postcss@latest"
    "autoprefixer@latest"
)

dependencies=(
    # add more regular dependencies here
)

# The rest of your script continues here...

# Check if project name is provided
if [ -z "$1" ]; then
    echo "Please provide a project name."
    exit 1
fi

# Create project folder and navigate into it
project_name=$1
mkdir $project_name
cd $project_name

# Initialize bun with the project name
bun init -y

# Initialize git
git init

# Install Vite and necessary plugins
bun add vite

# Install Tailwind CSS with PostCSS and Autoprefixer
bun add -d tailwindcss postcss autoprefixer

# Initialize Tailwind CSS configuration
npx tailwindcss init -p

# Install dependencies
for dep in "${dependencies[@]}"; do
    bun add $dep
done

# Install dev dependencies
for dev_dep in "${dev_dependencies[@]}"; do
    bun add -d $dev_dep
done

# Create src folder and index.ts file inside it
mkdir src
echo "console.log('Hello, $project_name!');" > src/index.ts

# Create a basic Vite configuration file
echo "import { defineConfig } from 'vite'; 
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      '@src': path.resolve(__dirname, 'src')
    }
  }
});" > vite.config.ts

# Update package.json to use src/index.ts as the module entry point
jq '.module = "src/index.ts"' package.json > tmp.$$.json && mv tmp.$$.json package.json

# Remove the index.ts in the root if it exists
rm -f index.ts

# Copy config files
cp /home/martin/Dev/presets/js-ts/eslint/config.json ./.eslintrc
cp /home/martin/Dev/presets/js-ts/prettier/config.json ./.prettierrc

# Remove comments from tsconfig.json
sed  -E '/^[ \t]*\//d; /^[[:space:]]*$/d; s/\/\*(.*?)\*\///g; s/[[:blank:]]+$//' tsconfig.json > tsconfig.tmp.json

# Add alias path to tsconfig.json
jq 'if .compilerOptions == null then .compilerOptions = {} else . end 
    | .compilerOptions.baseUrl = "." 
    | if .compilerOptions.paths == null then .compilerOptions.paths = {} else . end 
    | .compilerOptions.paths["@src/*"] = ["src/*"] 
    | .include = ["src/**/*", "*.json"] 
    | .exclude = ["node_modules"]' tsconfig.tmp.json > tsconfig.json

# Clean up temporary file
rm tsconfig.tmp.json

# Create Tailwind CSS entry file
echo "@tailwind base;
@tailwind components;
@tailwind utilities;" > src/index.css

# Update Vite configuration to include Tailwind CSS
echo "import { defineConfig } from 'vite'; 
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      '@src': path.resolve(__dirname, 'src')
    }
  },
  css: {
    postcss: './postcss.config.js'
  }
});" > vite.config.ts

echo "Project $project_name has been set up successfully with Vite, TypeScript, Tailwind CSS, and ESLint."
