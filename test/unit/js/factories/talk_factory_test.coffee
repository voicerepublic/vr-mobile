describe "TalkFactory", ->

	beforeEach module("ngCordovaMocks")

	describe 'relevant for recording', ->

	  it "should create the first talk", ->
	    inject ($window, $log, $cordovaFile, TalkFactory) ->

	    	talk = TalkFactory.createNew()

	    	expect(talk).to.not.be.undefined
	    	expect(talk).to.be.an "Object"
	    	expect(talk.id).to.equal 1
	    	expect(talk.src).not.to.equal ""
	    	expect(talk.isUploaded).not.to.be.ok

	  it "should create two talks", ->
	    inject ($window, $log, $cordovaFile, TalkFactory) ->

	    	talk1 = TalkFactory.createNew()
	    	talk2 = TalkFactory.createNew()

	    	expect(talk1.id).to.equal 1
	    	expect(talk2.id).to.equal 2

	  it "should retrieve all talks", ->
	    inject ($window, $log, $cordovaFile, TalkFactory) ->

	    	talk1 = TalkFactory.createNew()
	    	talk2 = TalkFactory.createNew()
	    	talks = TalkFactory.getAllTalks()

	    	expect(talks).to.be.instanceof Array
	    	expect(talks).not.to.be.empty
	    	expect(talks).to.have.length.of 2

	  it "should retrieve a talk by id", ->
	    inject ($window, $log, $cordovaFile, TalkFactory) ->

	    	talk = TalkFactory.createNew()
	    	
	    	talkById = TalkFactory.getTalkById talk.id

	    	expect(talkById).not.to.be.undefined
	    	expect(talkById.id).to.equal talk.id

	  xit "should delete a talk", ->
	    inject ($window, $log, $cordovaFile, TalkFactory) ->
	    	path = "documents://"
	    	talk = TalkFactory.createNew()

	    	expect(talk.filename).to.be.a "String"

	    	$cordovaFile.createFile(path, talk.filename)
	    	.then(() ->
	    		#success
	    	() ->
	    		#fail
	    	)

	    	success = TalkFactory.deleteTalkById talk.id

	    	expect(success).to.be.ok

	    	$cordovaFile.checkFile(path, talk.filename)
	    	.then((nok) ->
	    		success = nok
	    	(ok) ->
	    		success = ok
	    	)

	    	expect(success).to.be.ok
      