(function() {
  var $, CompositeDisposable, Emitter, View, path, ref,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Emitter = require('emissary').Emitter;

  ref = require('atom'), CompositeDisposable = ref.CompositeDisposable, $ = ref.$, View = ref.View;

  path = require('path');

  if (window.Apex == null) {
    window.Apex = {};
  }

  if (Apex.Form == null) {
    Apex.Form = {};
  }

  if (window.Forms == null) {
    window.Forms = {};
  }

  module.exports = Forms.pos = (function(superClass) {
    extend(pos, superClass);

    Emitter.includeInto(pos);

    pos.title = "Whateva 4um";

    pos.name = "pos";

    function pos(params) {
      if (params.afterSetup) {
        this.afterSetup = params.afterSetup;
      }
      this.attached = (function(_this) {
        return function() {
          return _this.setup();
        };
      })(this);
      this._appendTo = this.appendTo;
      this.appendTo = (function(_this) {
        return function(el) {
          _this._appendTo(el);
          return _this.attached();
        };
      })(this);
      pos.__super__.constructor.call(this, params);
    }

    pos.content = function() {
      return this.tag('atom-panel', {
        "class": 'form-widget apex-form-widget modal form-widget-floating form-pos'
      }, (function(_this) {
        return function() {
          _this.raw('<style>.form-pos { width: 558px; height: 250px; }</style>');
          return _this.div({
            "class": 'inset-panel'
          }, function() {
            _this.div({
              "class": 'panel-heading',
              outlet: 'header'
            }, function() {
              _this.span("Whateva 4um", {
                outlet: 'title'
              });
              return _this.div({
                "class": 'close-icon',
                outlet: 'close'
              });
            });
            return _this.div({
              "class": 'panel-body padded',
              outlet: 'contents'
            }, function() {
              _this.subview("button1", new Apex.widgetResolver.widgets["button"]({
                "widgetType": "button",
                "x": 7,
                "y": 9,
                "w": 54,
                "h": 24,
                "title": "STRING"
              }).get());
              _this.subview("input2", new Apex.widgetResolver.widgets["input"]({
                "widgetType": "input",
                "x": 63,
                "y": 9,
                "w": 126,
                "h": 23,
                "value": "Textbox"
              }).get());
              _this.subview("label3", new Apex.widgetResolver.widgets["label"]({
                "widgetType": "label",
                "x": 196,
                "y": 5,
                "w": 182,
                "h": 22,
                "title": "Science be damned.. It's good for the economy"
              }).get());
              return _this.subview("editor4", new Apex.widgetResolver.widgets["editor"]({
                "widgetType": "editor",
                "x": 9,
                "y": 42,
                "w": 521,
                "h": 141
              }).get());
            });
          });
        };
      })(this));
    };

    pos.prototype.setup = function() {
      if (this._setup) {
        return;
      }
      this._setup = true;
      console.log('setup ' + this.name);
      $(this.element).draggable({
        handle: '.panel-heading',
        grid: [15, 15]
      });
      this.css('position', 'fixed');
      this.css('z-index', '99999');
      this.css('left', '200px');
      this.css('top', '100px');
      this.close.click((function(_this) {
        return function() {
          return _this.destroy();
        };
      })(this));
      return typeof this.afterSetup === "function" ? this.afterSetup() : void 0;
    };

    pos.prototype.destroy = function() {
      return $(this.element).remove();
    };

    return pos;

  })(View);

}).call(this);
