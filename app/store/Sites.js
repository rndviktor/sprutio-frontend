// Generated by CoffeeScript 1.9.3
Ext.define('FM.store.Sites', {
  extend: 'Ext.data.Store',
  storeId: 'FtpConnections',
  sortOnLoad: true,
  model: 'FM.model.Site',
  sorters: [
    {
      property: "id",
      direction: "ASC"
    }
  ]
});
