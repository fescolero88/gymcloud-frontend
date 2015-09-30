define [
  'deps/bundles/jquery/bundle'
  'backbone_original'
  'backbone.stickit'
  'backbone-virtual-collection'
  'backbone-nested'
  'imports?Backbone=deps/bundles/backbone/original&_=deps/bundles/underscore/original!backbone-validation'
], (
  b$
  oBackbone
)->

  oBackbone
  oBackbone.$ = b$
  oBackbone
