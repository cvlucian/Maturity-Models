json5   = require 'json5'


class Data_Files
  constructor: (options)->
    #@.options = options || {}      
    #@.data      = new Data()
    @.data_Path = __dirname.path_Combine('../../data')

  all_Data: =>
    values = []
    for file in @.files_Paths()
      value = @.data(file)
      if value
        values.add value

    return values

  data: (file)=>
    if file
      switch file.file_Extension()
        when '.json'
          file.load_Json()
        when '.json5'
          json5.parse file.file_Contents()
        when '.coffee'                              # todo: add securty issue that use of coffee-script file this way would allow RCE
          data_Or_Function = require(file)          #       here (which means that we can't really allow these coffee files from being edited
          if data_Or_Function instanceof Function   # check if what was received from the coffee script is an object or an function
            return data_Or_Function()
          else
            return data_Or_Function

  files_Names: =>
    (file.file_Name_Without_Extension() for file in @.files())

  files_Paths: =>
    @.data_Path.files_Recursive()

  find: (filename)=>                                       # todo: this method need caching since it will search all files everytime (could also be a minor DoS issue)
    if filename
      for file in @.files_Paths()                          # this can be optimized with a cache
        if file.file_Name_Without_Extension() is filename
          return @.data(file)
    return null

  get_File_Data: (filename) ->
    @.find filename

  files: =>
    values = []
    for file in @.data_Path.files_Recursive()
      if  file.file_Extension() in ['.json', '.json5', '.coffee']
        values.push file.remove(@.data_Path)
    values

  set_File_Data: (filename, file_Contents) ->               # todo: add security issue: that this method will allow the writing
    if not filename or not file_Contents                    #       of any file (not just the files in the data
      return null                                           #       folder, which are the ones that should be edited)
    if typeof file_Contents isnt 'string'    
      return null
    file_Path = @.find filename                             # todo: add security issue: filename is not validated
    if file_Path is null or file_Path.file_Not_Exists()
      file_Path = @.data_Path.path_Combine filename         # todo: add security issue: directory transvesal
    file_Path.file_Write file_Contents                       # todo: add security issue: no authorization, will write outside data root
    return file_Path
    
module.exports = Data_Files