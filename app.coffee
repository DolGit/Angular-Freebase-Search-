app = angular.module("plunker", ['ngResource'])
  
app.factory "Freebase", ["$resource", ($resource) ->
  $resource("https://www.googleapis.com/freebase/v1/search",
    {
      callback: 'JSON_CALLBACK'
    },
    search: {
      method: "JSONP", 
    }
  )
]

app.directive 'metaSearch', () ->
  restrict: 'A'
  controller: ['$scope', "Freebase", (s, Freebase) ->
    s.q = ""
    s.objectResults = []

    s.query = (q, f) ->
      freebaseResults = Freebase.search(
        query: q,
        filter: "(any type:" + f + ")"
        (data) ->
          s.objectResults = freebaseResults.result
      )
  ]

  link: (s, el, attr, ctrl) ->
    s.$watch "q", ((newVals, oldVals) ->
      s.query(s.q, attr.metaSearch) if s.q.length
    )



