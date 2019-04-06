const path = require('path');

module.exports = {
  mode: 'production',
  entry: {
    application: "./src/javascripts/application.js"
  },
  output: {
    path: path.resolve(__dirname, '../../../app/assets/javascripts'),
    filename: 'application.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      }
    ]
  }
}