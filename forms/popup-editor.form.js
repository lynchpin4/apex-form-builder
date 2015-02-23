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

  module.exports = Forms.PopupScriptEditor = (function(superClass) {
    extend(PopupScriptEditor, superClass);

    Emitter.includeInto(PopupScriptEditor);

    PopupScriptEditor.title = "Untitled Form";

    PopupScriptEditor.name = "PopupScriptEditor";

    function PopupScriptEditor(params) {
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
      PopupScriptEditor.__super__.constructor.call(this, params);
    }

    PopupScriptEditor.content = function() {
      return this.tag('atom-panel', {
        "class": 'form-widget apex-form-widget modal form-widget-floating form-PopupScriptEditor'
      }, (function(_this) {
        return function() {
          _this.raw('<style>.form-PopupScriptEditor { width: 438px; height: 319px; }</style>');
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
              _this.subview("label1", new Apex.widgetResolver.widgets["label"]({
                "widgetType": "label",
                "x": 7,
                "y": 5,
                "w": 32,
                "h": 23,
                "title": "Script:"
              }).get());
              _this.subview("editor2", new Apex.widgetResolver.widgets["editor"]({
                "widgetType": "editor",
                "x": 7,
                "y": 24,
                "w": 400,
                "h": 194
              }).get());
              _this.subview("button3", new Apex.widgetResolver.widgets["button"]({
                "widgetType": "button",
                "x": 353,
                "y": 228,
                "w": 56,
                "h": 29,
                "title": "Save"
              }).get());
              return _this.subview("button4", new Apex.widgetResolver.widgets["button"]({
                "widgetType": "button",
                "x": 285,
                "y": 228,
                "w": 60,
                "h": 29,
                "title": "Cancel"
              }).get());
            });
          });
        };
      })(this));
    };

    PopupScriptEditor.prototype.setup = function() {
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

    PopupScriptEditor.prototype.destroy = function() {
      return $(this.element).remove();
    };

    return PopupScriptEditor;

  })(View);

}).call(this);
