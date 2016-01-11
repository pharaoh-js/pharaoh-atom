{CompositeDisposable} = require 'atom'
{Emitter}             = require 'event-kit'
Crypto                = require ' crypto'
Firebase              = require 'firebase'
Firepad               = require './firepad-lib'

module.exports =
  class PharaohShare

    constructor: (@editor, @streamIdentifier) ->
      @emitter       = new Emitter
      @subscriptions = new CompositeDisposable

      @handleEditorEvents()

      hash      = Crypto.createHash('sha256').update(@streamIdentifier).digest('base64')
      @firebase = new Firebase(atom.config.get('firepad.firebaseUrl')).child(hash)

      @firebase.once 'value', (snapshot) =>
        options = {sv_: Firebase.ServerValue.TIMESTAMP}
        if not snapshot.val() and @editor.getText() isnt ''
          options.overwrite = true
        else
          @editor.setText ''
        @firepad = Firepad.fromAtom @firebase, @editor, options
        @shareview.show(@streamIdentifier)

    handleEditorEvents: ->
      @subscriptions.add @editor.onDidDestroy =>
        @remove()

    getEditor: ->
      @editor

    getStreamIdentifier: ->
      @streamIdentifier

    remove: ->
      @firepad.dispose()
      @subscriptions.dispose()
      @emitter.emit 'did-destroy'
      atom.notifications.addWarning('still buggy. please try just closing the pane.')

    onDidDestroy: (callback) ->
      @emitter.on 'did-destroy', callback
