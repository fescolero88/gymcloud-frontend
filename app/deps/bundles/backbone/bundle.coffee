define [
  'deps/bundles/jquery/bundle'
  'backbone_original'
  'backbone.stickit'
  'imports?Backbone=deps/bundles/backbone/original&_=deps/bundles/underscore/original!backbone-validation'
], (
  b$
  oBackbone
)->

  oBackbone
  oBackbone.$ = b$
  oBackbone
