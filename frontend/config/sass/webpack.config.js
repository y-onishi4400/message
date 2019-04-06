const ExtractTextPlugin = require('extract-text-webpack-plugin');
const path = require('path');

module.exports = {
  mode: 'production',
  entry: {
    application: "./src/sass/style.scss"
  },
  output: {
    path: path.resolve(__dirname, '../../../app/assets/stylesheets'),
    filename: '[name].css'
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader','sass-loader','import-glob-loader']
        })
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin('[name].css')
  ]
}