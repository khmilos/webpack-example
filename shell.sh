#!/bin/bash
mkdir src;

# HTML
mkdir src/html src/html/templates src/html/components;
echo '<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><%= htmlWebpackPlugin.options.title %></title>
</head>' > src/html/components/head.html;
touch src/html/components/header.html;
touch src/html/components/footer.html;
echo '<!DOCTYPE html>
<html lang="en">
  <%= _.template(require('"'"'../components/head.html'"'"'))({htmlWebpackPlugin}) %>
  <body>
    <%= _.template(require('"'"'../components/header.html'"'"'))() %>

    <main>
      This is body
    </main>

    <%= _.template(require('"'"'../components/footer.html'"'"'))() %>
  </body>
</html>' > src/html/templates/index.html;

# SCSS
mkdir src/scss;
touch src/scss/style.scss;

# JS
mkdir src/js;
touch src/js/index.js;

# Other
mkdir src/static;

# NPM
npm init -y;
npm install --save-dev webpack webpack-cli webpack-dev-server 
npm install --save-dev babel-loader @babel/preset-env @babel/core terser-webpack-plugin;
npm install --save-dev html-loader html-webpack-plugin clean-webpack-plugin;
npm install --save-dev css-loader sass sass-loader style-loader mini-css-extract-plugin optimize-css-assets-webpack-plugin;
npm install --save-dev prettier prettylint;
npm install --save-dev husky lint-staged;
npm install --save-dev eslint eslint-config-airbnb-base eslint-plugin-import eslint-plugin-node eslint-plugin-prettier eslint-plugin-promise;
npm install --save-dev stylelint stylelint-config-standard stylelint-scss;

# Webpack
echo 'const path = require('"'"'path'"'"');
const fs = require('"'"'fs'"'"');
const HtmlWebpackPlugin = require('"'"'html-webpack-plugin'"'"');
const { CleanWebpackPlugin } = require('"'"'clean-webpack-plugin'"'"');
const MiniCssExtractPlugin = require('"'"'mini-css-extract-plugin'"'"');
const OptimizeCSSAssetsPlugin = require('"'"'optimize-css-assets-webpack-plugin'"'"');
const TerserPlugin = require('"'"'terser-webpack-plugin'"'"');

const pageList = (() => {
  const templatePath = path.resolve(__dirname, '"'"'src/html/templates'"'"');
  const templateList = fs.readdirSync(templatePath);
  return templateList.map((template) => {
    const fileName = template.split('"'"'.'"'"')[0];
    return new HtmlWebpackPlugin({
      filename: template,
      template: `${templatePath}/${template}`,
      chunks: [fileName, '"'"'include'"'"'],
      minify: true,
    });
  });
})();

module.exports = (env, argv) => ({
  entry: {
    index: ['"'"'./src/js/index.js'"'"', '"'"'./src/scss/style.scss'"'"'],
  },
  output: {
    filename: '"'"'[name].boundle.js'"'"',
    path: path.resolve(__dirname, '"'"'dist'"'"'),
    publicPath: '"'"'/'"'"',
  },
  devtool: argv.mode === '"'"'development'"'"' ? '"'"'inline-source-map'"'"' : false,
  optimization: {
    minimizer: [new OptimizeCSSAssetsPlugin({}), new TerserPlugin({})],
  },
  plugins: [
    new CleanWebpackPlugin({ cleanStaleWebpackAssets: false }),
    new MiniCssExtractPlugin({
      filename: '"'"'[name].css'"'"',
      chunkFilename: '"'"'[id].css'"'"',
    }),
    ...pageList,
  ],
  module: {
    rules: [
      {
        test: /\.html$/i,
        exclude: /templates/,
        use: '"'"'html-loader'"'"',
      },
      {
        test: /\.(css|sass|scss)$/i,
        use: [MiniCssExtractPlugin.loader, '"'"'css-loader'"'"', '"'"'sass-loader'"'"'],
      },
      {
        test: /\.m?js$/,
        exclude: /node_modules/,
        use: {
          loader: '"'"'babel-loader'"'"',
          options: {
            presets: ['"'"'@babel/preset-env'"'"'],
          },
        },
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        loader: '"'"'file-loader'"'"',
        options: {
          outputPath: '"'"'static'"'"',
          name: '"'"'[name].[ext]'"'"',
        },
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: '"'"'file-loader'"'"',
      },
    ],
  },
});' > webpack.config.js;

# ESLint
echo '{
    "env": {
        "browser": true,
        "es2021": true,
        "node": true
    },
    "extends": [
        "airbnb-base",
        "prettier"
    ],
    "parserOptions": {
        "ecmaVersion": 12,
        "sourceType": "module"
    },
    "plugins": ["prettier"],
    "rules": {
        "prettier/prettier": ["error", { "singleQuote": true }]
    }
}' > .eslintrc.json;

# StyleLint
echo '{
    "extends": "stylelint-config-standard",
    "plugins": [
        "stylelint-scss"
    ],
    "rules": {
        "scss/dollar-variable-pattern": "^foo",
        "scss/selector-no-redundant-nesting-selector": true
    }
}' > .stylelintrc.json;

# Change occurance
perl -i -p0e 's/\"test\": \"echo \\"Error: no test specified\\" && exit 1\"/"\"start\": \"webpack-dev-server --mode=development --open\",\n    \"build\": \"webpack --mode=production\""/se' package.json;
perl -i -p0e 's/\"license\": \"ISC\"/"\"license\": \"ISC\",\n\  \"husky\": {\n    \"hooks\": {\n      \"pre-commit\": \"lint-staged\"\n    }\n  },\n  \"lint-staged\": {\n    \"src\/**\/*.js\": \"eslint --cache\",\n    \"src\/**\/*.\{css,sass,scss\}\": \"stylelint\",\n    \"src\/**\/*.html\": \"prettylint\"\n  }"/se' package.json;

# Git
git init;
echo 'node_modules
dist
.eslintcache' > .gitignore;