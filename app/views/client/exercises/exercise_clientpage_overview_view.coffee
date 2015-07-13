Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ExerciseGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/client/exercises/exercise_clientpage_overview')

  className: 'gc-exercises-exercise-view'

  templateHelpers: =>
    hasDescription: !!@model.get 'description'
    videoUrl = @model.get('video_url') || ''
    videoUrlSplitted = videoUrl.split 'v='
    if videoUrlSplitted.length > 1
      videoId = videoUrlSplitted[1]
      ampIndex = videoId.indexOf '&'
      if ampIndex != -1
        videoId = video_id.substring 0, ampIndex
      videoUrl = "https://youtube.com/v/#{videoId}"

    return {
      video_url: videoUrl
    }