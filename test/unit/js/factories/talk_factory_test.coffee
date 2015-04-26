describe "TalkFactory", ->

	beforeEach module("ngCordovaMocks")

	describe 'TalkFactory.createNew()', ->

	  it "should create a talk", ->
	    inject ($log, TalkFactory) ->
      