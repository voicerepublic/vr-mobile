TestHelper = require './test_helper'

describe 'app init', ->

  it 'should land on the login page', ->
    expect(browser.getLocationAbsUrl()).toMatch '/login'
