{View} = require 'atom-space-pen-views'

module.exports =
  class PharoahBarView extends View
    @content: ->
      @div class: 'inline-block text-warning', tabindex: -1, =>
        @span outlet: 'streamInfo'

    initialize: ->

    destroy: ->
      @detach()

    show: (streamIdentifier) ->
      @streamInfo.text "streaming (#{streamIdentifier})"

    hide: ->
      @streamInfo.text ""
