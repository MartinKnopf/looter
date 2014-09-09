// Generated by CoffeeScript 1.8.0
(function() {
  var reab, root;

  reab = {
    ctrl: function(ctrlName, sequences) {
      return $('[lt-ctrl=' + ctrlName + ']').each(function() {
        var $scope, ltAttr, scopeName;
        scopeName = $(this).attr('lt-ctrl');
        $scope = $(this);
        ltAttr = function(ltAttr, handler) {
          return $scope.find('[' + ltAttr + ']').each(function() {
            var attrVal, bind;
            attrVal = $(this).attr(ltAttr);
            bind = function(seqName) {
              if (!sequences[seqName]) {
                throw new Error('no sequence named ' + seqName + ' for binding ' + ltAttr + ' in controller ' + ctrlName);
              }
              return sequences[seqName].subscribe(function(value) {
                return $scope.find('[' + ltAttr + '="' + attrVal + '"]').each(_.partial(handler, value));
              });
            };
            if (_.contains(attrVal, ',')) {
              return _.forEach(attrVal.split(','), bind);
            } else {
              return bind(attrVal);
            }
          });
        };
        ltAttr('lt-text', function(value) {
          return $(this).text(value);
        });
        ltAttr('lt-enabled', function(value) {
          return $(this).prop('disabled', false);
        });
        ltAttr('lt-disabled', function(value) {
          return $(this).prop('disabled', true);
        });
        ltAttr('lt-show', function(value) {
          return $(this).show();
        });
        return ltAttr('lt-hide', function(value) {
          return $(this).hide();
        });
      });
    }
  };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  if (!root.reab) {
    root.reab = reab;
  }

}).call(this);