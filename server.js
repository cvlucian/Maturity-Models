require('coffee-script/register');
require('@google/cloud-trace').start();

console.log('Staring bsimm-graph server');
var D3_Server = require('./src/D3-Server');
var d3_server = new D3_Server();
d3_server.run();
console.log("Server started on " +  d3_server.server_Url());