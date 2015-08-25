define [
  'config'
], (
  config
) ->

  describe 'config', ->

    it 'has api url', ->

      expect(config).to.be.an('object')
      expect(config).to.have.property('env')
      expect(config).to.have.property('api')
      expect(config.api).to.have.property('url')
