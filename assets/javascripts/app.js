//= require ./libs/handlebars.runtime.js
//= require ./libs/handlebars.js
//= require ./libs/modernizr.min.js
//= require ./libs/jquery-1.9.1.min.js
//= require ./libs/jquery.imagesloaded.js
//= require ./libs/underscore.min.js
//= require ./libs/gumby.min.js
//= require ./libs/spinners.js

$(function() {
  var itemSource = $('#collection-item').html(),
      itemTemplate = Handlebars.compile(itemSource),
      itemContainer = $('#collection-items'),
      pageCount,
      perPage = 12,
      spinner,
      loadItems = function(count) {
        var searchInput = $('#search').find('.input').get(0),
            html;

        $(window).off('scroll', onScroll);
        showLoader();

        $.ajax('/search', {
          data: {'q': searchInput.value, 'p': count, 'pp': perPage},
          dataType:'json',
          success: function(data) {
            _.each(data, function(itemData) {
              html = itemTemplate(itemData);
              itemContainer.append(html);
            });
            itemContainer.imagesLoaded(function() {
              positionItems();
              if (data.length == perPage) {
                $(window).on('scroll', onScroll);
              }
              hideLoader();
            });
          },
          error: function(j, t, e) {
            console.log(e);
          }
        });
      },
      onScroll = function(e) {
        if (!pageCount) { return true; }

        var pageLength = $(document).height(),
            currentPosition = $(window).height() + $(document).scrollTop();

        console.log(pageLength);
        console.log(currentPosition);

        if (currentPosition >= pageLength) {
          pageCount++;
          loadItems(pageCount);
        }
      },
      positionItems = function() {
        var numColumns = 4;
        var lastItems = [];

        _(numColumns).times(function(colNum) {
          var selector = 'li:nth-child(4n+'+(colNum+1)+')';

          itemContainer.find(selector).each(function(i, v) {
            var top,
                left,
                item = $(v),
                lastItem = lastItems[colNum];
                lastItems[colNum] = item;

            top = lastItem ? (lastItem.position().top + lastItem.outerHeight()) : 0;
            left = lastItems[0].width() * colNum;
            item.css('top', top);
            item.css('left', left);
          });
        });
      },
      showLoader = function() {
        spinner.play();
        $('#loader').show();
      },
      hideLoader = function() {
        spinner.pause();
        $('#loader').hide();
      }

  $('#search').submit(function() {
    itemContainer.empty();
    pageCount = 1;
    loadItems(pageCount);

    return false;
  });

  spinner = Spinners.create('#loader div');
  $('#loader').hide();

  Gumby.initialize('fixed');
});