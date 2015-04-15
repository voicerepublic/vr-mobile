describe 'FactoryGirl', ->
  beforeEach ->
    id = 1

    FactoryGirl.define 'testcar',
      id:   -> id++
      name: 'bmw'
      type: 'car'

  afterEach ->
    FactoryGirl.undefine 'testcar'

  describe '#create', ->
    it "creates a object, assigning default attributes and evaluating lazy functions", ->
      car = FactoryGirl.create 'testcar'

      expect( car.id ).to.equal 1
      expect( car.name ).to.equal 'bmw'

      car = FactoryGirl.create 'testcar'

      expect( car.id ).to.equal 2
      expect( car.name ).to.equal 'bmw'

    it "replaces/adds attributes from passed arguments", ->
      car = FactoryGirl.create 'testcar', 
        id: -> 6
        name: 'mercedes'
        klass: 's'

      expect( car.id ).to.equal    6          # replaced evaluated function with also another evaluated function
      expect( car.name ).to.equal  'mercedes' # replaced static attribute
      expect( car.klass ).to.equal 's'        # added custom attribute
      expect( car.type ).to.equal  'car'      # default attribute

  describe '#createList', ->
    it "creates multiple objects with passed attributes", ->
      cars = FactoryGirl.createList 'testcar', 2, name: 'mercedes'

      expect( cars.length ).to.equal 2
      expect( cars[0].id ).to.equal 1
      expect( cars[1].id ).to.equal 2
      expect( car.name ).to.equal 'mercedes' for car in cars

