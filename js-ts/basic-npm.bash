#!/bin/bash

# Define your dependencies
dev_dependencies=(
    "typescript@latest"
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
)

dependencies=(
    # add more regular dependencies here
)

# Check if project name is provided
if [ -z "$1" ]; then
    echo "Please provide a project name."
    exit 1
fi

# Create project folder and navigate into it
project_name=$1
mkdir $project_name
cd $project_name

# Initialize npm project
npm init -y

# Initialize git
git init

# Install TypeScript
npm install --save-dev typescript

# Install dependencies
for dep in "${dependencies[@]}"; do
    npm install $dep
done

# Install dev dependencies
for dev_dep in "${dev_dependencies[@]}"; do
    npm install --save-dev $dev_dep
done

# Create tsconfig.json
npx tsc --init

# Create src folder and index.ts file inside it
mkdir src
echo "console.log('Hello, $project_name!');" > src/index.ts

# Update package.json to use src/index.ts as the module entry point
jq '.module = "src/index.ts"' package.json > tmp.$$.json && mv tmp.$$.json package.json

# Remove the index.ts in the root if it exists
rm -f index.ts

# Copy config files
cp /home/martin/Dev/presets/js-ts/eslint/config.json ./.eslintrc
cp /home/martin/Dev/presets/js-ts/prettier/config.json ./.prettierrc

# Remove comments from tsconfig.json
sed '/\/\//d' tsconfig.json > tsconfig.tmp.json

# Add alias path to tsconfig.json
jq 'if .compilerOptions == null then .compilerOptions = {} else . end | .compilerOptions.baseUrl = "." | if .compilerOptions.paths == null then .compilerOptions.paths = {} else . end | .compilerOptions.paths["@src/*"] = ["src/*"]' tsconfig.tmp.json > tsconfig.json

# Clean up temporary file
rm tsconfig.tmp.json

echo "Project $project_name has been set up successfully."
