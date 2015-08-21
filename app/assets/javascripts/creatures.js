$(document).ready(function() {
  $('#creatures-index').dataTable({
    serverSide: true,
    ajax: $("#creatures-index").attr('data-datatables-href'),
    pageLength: 25,

    columns: [
      {
        render: function(data, type, full, meta) {
          var content = '';

          content += '<div class="creature">';
          content += '<a href="' + full.url + '">';
          content += full.name;
          content += '</a>';
          content += '</div>';

          return content;
        }
      }
    ]
  });

  $('#creature-level-stats').dataTable({
    serverSide: true,
    ajax: $("#creature-level-stats").attr('data-datatables-href'),
    pageLength: 25,
    searching: false,

    columns: [
      {
        data: 'level'
      },

      {
        render: function(data, type, full, meta) {
          var content = '';

          if (full.minimum_health == full.maximum_health) {
            content += full.minimum_health;
          } else {
            content += full.minimum_health;
            content += ' - ';
            content += full.maximum_health;
          }

          return content;
        }
      },

      {
        data: 'average_health'
      },

      {
        render: function(data, type, full, meta) {
          var content = '';

          if (full.minimum_power == full.maximum_power) {
            content += full.minimum_power;
          } else {
            content += full.minimum_power;
            content += ' - ';
            content += full.maximum_power;
          }

          return content;
        }
      },

      {
        data: 'average_power'
      }
    ]
  });
});
