$(document).ready(function() {
  $('#maps-index').dataTable({
    serverSide: true,
    ajax: $("#maps-index").attr('data-datatables-href'),
    pageLength: 25,

    columns: [
      {
        data: 'eid',
        width: '60px'
      },

      {
        data: 'type',
        width: '25%'
      },

      {
        data: 'name'
      }
    ]
  });
});
