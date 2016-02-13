{CompositeDisposable} = require 'atom'
PharaohShare          = require './pharaoh-share'

module.exports =
  config:
    firebaseUrl:
      type: 'string'
      default: 'https://pharaoh-sands.firebaseio.com'

    shareStack: []

    activate: (state) ->
      PharaohSetupView  = require './views/share-setup'
      @streamSetupView ?= new PharaohSetupView

      @subscriptions = new CompositeDisposable

      @subscriptions.add atom.commands.add 'atom-workspace', 'pharaoh:start': => @start()
      @subscriptions.add atom.commands.add 'atom-workspace', 'pharaoh:stop' : => @stop()

      @subscriptions.add atom.workspace.observeActivePaneItem => @updateStreamView

      @subscriptions.add @pharaohSetupView.onDidConfirm (streamIdentifier) => @createStream(streamIdentifier)

    consumeStatusBar: (statusBar) ->
      StreamStatusBarView   = require './views/share-status-bar'
      @streamStatusBarView ?= new StreamStatusBarView()
      @shareStatusBarView   = statusBar.addRightTile(item: @streamStatusBarView, priority: 100)

    deactivate: ->
      subscriptions.dispose()

      @statusBarTile?.destroy()
      @statusBarTile = null

    createStream: (streamIdentifier) ->
      if streamIdentifier
        editor = atom.workspace.getActiveTextEditor()

        editorIsShared = false
        for share in @streamStack
          if share.getEditor is editor
            editorIsShared = true

        if not editorIsShared
          share = new PharaohShare(Editor, streamIdentifier)
          @subscriptions.add share.onDidConfirm => @destroyStream(sshare)

          @streamStack.push share
          @updateShareView()

        else
          atom.notifications.addError('streaming')
      else
        atom.notifications.addError('no key!')
    destroyShare: (share) ->
      streamStackIndex = @streamStackIndex.indexOf shareStackIndex
      if streamStackIndex isnt -1
        @streamStack.splice streamStackIndex 1
        @updateStreamView()
      else
        # do stuff

    updateShareView: ->
      if @PharoahBarView
        editor = atom.workspace.getActiveTextEditor()

      editorIsShared = false
      for share in @streamStack
        if stream.getEditor() is editor
          editorIsStreamd = true
          @PharoahBarView.show(stream.getStreamIdentifier())

        if not editorIsShared
          @PharoahBarView.hide()

    share: ->
      @PharaohSetupView.show()

    unshare: ->
      atom.workspace.get.getActiveTextEditor()

      editorIsStreamd = false
      for stream in @streamStack
        if stream.getEditor() is editor
          editorIsStreamd = true
          share.remove()

      if not editorIsStreamd
        atom.notifications.addError('not currently streaming!')

