Ext.define 'FM.action.Terminal',
  extend: 'FM.overrides.Action'
  requires: [
    'FM.view.windows.TerminalWindow'
    'FM.view.windows.ProgressWindow'
  ]
  config:
    scale: "large"
    iconAlign: "top"
    iconCls: "fm-action-terminal"
    text: t("Terminal")
    buttonText: t("Terminal [ Ctrl + 9 ]")
    handler: (panel) ->
      FM.Logger.info('Run Action FM.action.Terminal', arguments)

      bottom_toolbar = Ext.ComponentQuery.query("bottom-panel")[0].getDockedItems("toolbar[dock='top']")[0]
      session = Ext.ux.Util.clone(panel.session)

      wait = Ext.create 'FM.view.windows.ProgressWindow',
        cancelable: false
        msg: t("Reading file, please wait...")

      wait.show()

      FM.backend.ajaxSend '/actions/main/terminal',
        params:
          session: session
        success: (response) =>
          account = Ext.util.JSON.decode(response.responseText).data.account
          pattern = ({user, host}) -> "https://localhost:3000/wetty/ssh/#{user}/#{host}"
          user = account.login
          host = account.server
          addressString = pattern {user, host}
          wait.close()

          win = Ext.create "FM.view.windows.TerminalWindow",
            taskBar: bottom_toolbar
            address: addressString
            title: Ext.util.Format.format(t("Terminal: {0}"), account.server)

          win.show()
          FM.Logger.info('Terminal window done', win)

        failure: (response) =>
          wait.close()
          json_response = Ext.util.JSON.decode(response.responseText)
          error = FM.helpers.ParseErrorMessage(json_response.message, t("Error during opening terminal.<br/> Please contact Support."))
          FM.helpers.ShowError(error)
          FM.Logger.error(response)