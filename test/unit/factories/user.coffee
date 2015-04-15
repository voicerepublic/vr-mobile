FactoryGirl.define 'user', 
  id:       -> ~~(Math.random() * 1000)
  username: 'testuser'
  email:    'testuser@test.com'
