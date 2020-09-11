const path = require('path');
const fs = require('fs');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');

const generateHtml = () => {
  const templatePath = path.resolve(__dirname, 'src/html/templates');
  const templateList = fs.readdirSync(templatePath);
  return templateList.map((template) => {
    return new HtmlWebpackPlugin({
      filename: template,
      template: templatePath + `/${template}`,
      minify: true,
    });
  });
};

module.exports = (env, argv) => {
  return {
    entry: {
      index: './src/js/index.js',
    },
    output: {
      filename: 'boundle.js',
      path: path.resolve(__dirname, 'dist'),
      publicPath: '/',
    },
    devtool: (argv.mode === 'development' ? 'inline-source-map' : false),
    optimization: {
      minimizer: [new OptimizeCSSAssetsPlugin({})],
    },
    plugins: [
      new CleanWebpackPlugin({ cleanStaleWebpackAssets: false }),
      new MiniCssExtractPlugin({ 
        filename: '[name].css', 
        chunkFilename: '[id].css',
      }),
      ...generateHtml(),
    ],
    module: {
      rules: [
        {
          test: /\.html$/i,
          exclude: /templates/,
          use: 'html-loader',
        },
        {
          test: /\.css$/i,
          use: [
            MiniCssExtractPlugin.loader, 
            'css-loader'
          ],
        },
        {
          test: /\.m?js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env'],
            },
          },
        },
      ],
    },
  };
};