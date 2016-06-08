app = angular.module('MM_Graph')

class MM_Graph_API
  constructor: (http)->
    @.$http = http

  routes: (callback)=>
    url = "/api/v1/routes/list"
    @.$http.get url
           .success (data)->
              callback data

  file_Get: (target,callback)=>
    url = "/api/v1/file/get/#{target}?pretty"
    @.$http.get url
      .success (data)->
        callback data

  file_Save: (target,data, callback)=>
    url = "/api/v1/file/save/#{target}?pretty"
    @.$http.post url, data
      .success (data)->
        callback data

app.service 'MM_Graph_API', ($http)=>
  return new MM_Graph_API $http