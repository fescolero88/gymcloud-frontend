define [
  '../assigned/behavior'
  './view'
], (
  AssignedVideoBehavior
  View
) ->

  class Behavior extends AssignedVideoBehavior

    regionName: 'video_preview'

    behaviorViewClass: View
