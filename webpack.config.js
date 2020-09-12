const path = require('path');
const fs = require('fs');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

const pageList = (() => {
  const templatePath = path.resolve(__dirname, 'src/html/templates');
  const templateList = fs.readdirSync(templatePath);
  return templateList.map((template) => {
    const fileName = template.split('.')[0];
    return new HtmlWebpackPlugin({
      filename: template,
      template: `${templatePath}/${template}`,
      chunks: [fileName, 'include'],
      minify: true,
    });
  });
})();

module.exports = (env, argv) => ({
  entry: {
    index: ['./src/js/index.js', './src/sass/index.scss'],
    another: ['./src/js/another.js', './src/sass/another.scss'],
  },
  output: {
    filename: '[name].boundle.js',
    path: path.resolve(__dirname, 'dist'),
    publicPath: '/',
  },
  devtool: argv.mode === 'development' ? 'inline-source-map' : false,
  optimization: {
    minimizer: [new OptimizeCSSAssetsPlugin({}), new TerserPlugin({})],
  },
  plugins: [
    new CleanWebpackPlugin({ cleanStaleWebpackAssets: false }),
    new MiniCssExtractPlugin({
      filename: '[name].css',
      chunkFilename: '[id].css',
    }),
    ...pageList,
  ],
  module: {
    rules: [
      {
        test: /\.html$/i,
        exclude: /templates/,
        use: 'html-loader',
      },
      {
        test: /\.(css|sass|scss)$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
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
      {
        test: /\.(png|svg|jpg|gif)$/,
        loader: 'file-loader',
        options: {
          outputPath: 'static',
          name: '[name].[ext]',
        },
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        use: 'file-loader',
      },
    ],
  },
});
