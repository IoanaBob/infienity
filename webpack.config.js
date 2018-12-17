const path = require('path');

module.exports = {
  entry: './lib/javascripts/infienity.js',
  output: {
    filename: 'infienity.js',
    path: path.resolve(__dirname, 'vendor/assets/javascripts')
  },
  watch: true,
  mode: 'production'
};