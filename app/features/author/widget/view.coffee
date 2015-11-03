define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    className: 'gc-author-widget'

    behaviors:

      stickit:
        bindings:
          'a':
            attributes: [
                name: 'href'
                observe: 'author_id'
                onGet: (value) ->
                  "#users/#{value}"
            ]
          'img':
            attributes: [
                name: 'src'
                observe: 'author_id'
                onGet: (value) ->
                  @model.get('author')?.user_profile?.avatar?.thumb?.url
            ]
          'a:last': 'author_full_name'
