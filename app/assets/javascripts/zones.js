$(document).ready(function() {
  $('#zones-index').dataTable({
    serverSide: true,
    ajax: $("#zones-index").attr('data-datatables-href'),
    pageLength: 25,

    columns: [
      {
        render: function(data, type, full, meta) {
          var content = '';

          content += '<div class="zone">';
          content += '<a href="' + full.url + '">';
          content += full.name;
          content += '</a>';
          content += '</div>';

          return content;
        }
      },

      {
        render: function(data, type, full, meta) {
          if (full.suggested_minimum_level == null) {
            return '';
          }

          var content = '';

          content += '<div class="levels">';

          if (full.suggested_minimum_level == full.suggested_maximum_level) {
            content += full.suggested_minimum_level;
          } else {
            content += full.suggested_minimum_level;
            content += ' - ';
            content += full.suggested_maximum_level;
          }

          content += '</div>';

          return content;
        },

        width: '10%'
      },

      {
        data: 'continent',
        width: '20%'
      },

      {
        data: 'territory_faction',
        width: '20%'
      }
    ]
  });

  $('#zone-creatures').dataTable({
    serverSide: true,
    ajax: $("#zone-creatures").attr('data-datatables-href'),
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
      },

      {
        render: function(data, type, full, meta) {
          var content = '';

          if (full.minimum_level == full.maximum_level) {
            content += full.minimum_level;
          } else {
            content += full.minimum_level;
            content += ' - ';
            content += full.maximum_level;
          }

          return content;
        },

        width: '15%'
      },

      {
        render: function(data, type, full, meta) {
          var content = '';

          content += full.areas.join(', ');

          return content;
        },

        width: '40%'
      }
    ]
  });
});
