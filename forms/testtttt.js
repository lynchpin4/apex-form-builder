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

  module.exports = Forms.Default = (function(superClass) {
    extend(Default, superClass);

    Emitter.includeInto(Default);

    Default.title = "Untitled Form";

    Default.name = "Default";

    function Default(params) {
      if (params != null ? params.afterSetup : void 0) {
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
      Default.__super__.constructor.call(this, params);
    }

    Default.content = function() {
      return this.tag('atom-panel', {
        "class": 'form-widget apex-form-widget modal form-widget-floating form-Default'
      }, (function(_this) {
        return function() {
          _this.raw('<style>atom-panel.form-Default { width: 559px; height: 348px; }</style>');
          return _this.div({
            "class": 'inset-panel'
          }, function() {
            _this.div({
              "class": 'panel-heading',
              outlet: 'header'
            }, function() {
              _this.span("Untitled Form", {
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
              _this.subview("input1", new Apex.widgetResolver.widgets["input"]({
                "widgetType": "input",
                "x": 12,
                "y": 13,
                "w": 128,
                "h": 23,
                "value": "Textbox"
              }).get());
              _this.subview("button2", new Apex.widgetResolver.widgets["button"]({
                "widgetType": "button",
                "x": 144,
                "y": 11,
                "w": 52,
                "h": 25,
                "title": "Button"
              }).get());
              return _this.subview("label3", new Apex.widgetResolver.widgets["label"]({
                "widgetType": "label",
                "x": 15,
                "y": 45,
                "w": 77,
                "h": 22,
                "title": "Lets go"
              }).get());
            });
          });
        };
      })(this));
    };

    Default.prototype.setup = function() {
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

    Default.prototype.destroy = function() {
      return $(this.element).remove();
    };

    return Default;

  })(View);

}).call(this);
