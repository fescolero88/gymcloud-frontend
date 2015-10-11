define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'a'

    className: 'gc-clients-list-avatar-wrapper'

    attributes:
      href: '#'

    events:
      'click': '_preventNavigate'

    behaviors:

      stickit:
        bindings:
          ':el':
            attributes: [
                observe: 'avatar_background_color'
                name: 'style'
                onGet: (val) ->
                  if val
                    "background-color: #{val}"
                  else
                    ''
            ]
          'img.gc-avatar':
            attributes: [
                observe: 'avatar_url'
                name: 'src'
              ,
                observe: 'avatar_url'
                name: 'class'
                onGet: (val) ->
                  if val
                    'gc-clients-list-avatar-exist'
                  else
                    ''
            ]

    _preventNavigate: (ev) ->
      ev.preventDefault()
