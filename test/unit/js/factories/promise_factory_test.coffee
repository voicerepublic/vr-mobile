describe "PromiseFactory", ->

  it "given a promise, returns the promise", ->
    inject ($q, PromiseFactory) ->
      some_promise = $q.defer().promise
      expect(PromiseFactory(some_promise)).to.equal some_promise

  $it 'given a value, it returns resolved promise', (done) ->
    inject (PromiseFactory) ->
      promise = PromiseFactory('123')
      expect(promise).to.eventually.equal('123').notify(done)

  $it 'given a value and resolve=false, returns rejected promise', (done) ->
    inject (PromiseFactory) ->
      promise = PromiseFactory('123', false)
      expect(promise).to.be.rejectedWith('123').notify(done)
