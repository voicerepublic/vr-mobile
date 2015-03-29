TestHelper = require './test_helper'

describe 'app init', ->

  it 'should land on the pets page', ->
    expect(browser.getLocationAbsUrl()).toMatch '/tab/pets'
